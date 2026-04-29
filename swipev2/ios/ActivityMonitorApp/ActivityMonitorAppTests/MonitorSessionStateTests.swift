import XCTest
@testable import ActivityMonitorApp

final class ActionStreamStateTests: XCTestCase {
    func testRightSwipeExecutesFirstCardAndRemovesIt() {
        var state = ActionStreamState()
        let firstTitle = state.activeProposal?.title

        let action = state.choose(translation: CGSize(width: ActionStreamState.swipeThreshold + 4, height: 3))

        XCTAssertEqual(action, .execute)
        XCTAssertEqual(state.executedCount, 1)
        XCTAssertEqual(state.discardedCount, 0)
        XCTAssertNotEqual(state.activeProposal?.title, firstTitle)
        XCTAssertEqual(state.toast?.kind, .execute)
        XCTAssertTrue(state.toast?.text.contains("demo only") == true)
    }

    func testLeftSwipeDiscardsFirstCard() {
        var state = ActionStreamState()

        let action = state.choose(translation: CGSize(width: -ActionStreamState.swipeThreshold - 12, height: 0))

        XCTAssertEqual(action, .discard)
        XCTAssertEqual(state.executedCount, 0)
        XCTAssertEqual(state.discardedCount, 1)
        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count - 1)
        XCTAssertEqual(state.toast, ActionToast(text: "已丢掉：这张行动提案", kind: .discard))
    }

    func testDownSwipeMovesCardToBackWithoutDroppingIt() {
        var state = ActionStreamState()
        let firstTitle = state.activeProposal?.title

        let action = state.choose(translation: CGSize(width: 2, height: ActionStreamState.swipeThreshold + 8))

        XCTAssertEqual(action, .later)
        XCTAssertEqual(state.deferredCount, 1)
        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count)
        XCTAssertEqual(state.queue.last?.title, firstTitle)
    }

    func testUpSwipeOpensDetailWithoutRemovingCard() {
        var state = ActionStreamState()
        let firstTitle = state.activeProposal?.title

        let action = state.choose(translation: CGSize(width: 0, height: -ActionStreamState.swipeThreshold - 1))

        XCTAssertEqual(action, .detail)
        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count)
        XCTAssertEqual(state.detailProposal?.title, firstTitle)
        XCTAssertNil(state.toast)
    }

    func testShortDragDoesNothing() {
        var state = ActionStreamState()

        let action = state.choose(translation: CGSize(width: ActionStreamState.swipeThreshold - 1, height: 0))

        XCTAssertNil(action)
        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count)
        XCTAssertEqual(state.executedCount, 0)
        XCTAssertNil(state.toast)
    }

    func testSwipeFeedbackMapsDominantEdgeBeforeCommit() throws {
        let feedback = try XCTUnwrap(SwipeFeedback(translation: CGSize(width: 18, height: -42)))

        XCTAssertEqual(feedback.action, .detail)
        XCTAssertFalse(feedback.isCommitted)
        XCTAssertGreaterThan(feedback.progress, 0)
    }

    func testSwipeFeedbackMarksCommittedAtThreshold() throws {
        let feedback = try XCTUnwrap(SwipeFeedback(translation: CGSize(width: -ActionStreamState.swipeThreshold, height: 4)))

        XCTAssertEqual(feedback.action, .discard)
        XCTAssertTrue(feedback.isCommitted)
        XCTAssertEqual(feedback.progress, 1)
    }

    func testChipFeedbackIsDemoOnlyAndNonNavigating() throws {
        var state = ActionStreamState()
        let chip = try XCTUnwrap(state.activeProposal?.chips.first)

        state.tapChip(chip)

        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count)
        XCTAssertEqual(state.toast?.kind, .neutral)
        XCTAssertTrue(state.toast?.text.contains("demo only") == true)
        XCTAssertTrue(state.toast?.text.contains("未实际跳转") == true)
    }

    func testResetRestoresDeckAndCounters() {
        var state = ActionStreamState()
        _ = state.choose(translation: CGSize(width: ActionStreamState.swipeThreshold + 12, height: 0))
        _ = state.choose(translation: CGSize(width: -ActionStreamState.swipeThreshold - 12, height: 0))

        state.reset()

        XCTAssertEqual(state.queue.count, ActionProposal.demoDeck.count)
        XCTAssertEqual(state.executedCount, 0)
        XCTAssertEqual(state.discardedCount, 0)
        XCTAssertNil(state.toast)
        XCTAssertNil(state.detailProposal)
    }
}
