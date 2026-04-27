import UIKit

enum HapticsClient {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func forAction(_ action: ProposalAction) {
        switch action {
        case .execute:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .discard:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .later, .detail:
            light()
        }
    }
}

