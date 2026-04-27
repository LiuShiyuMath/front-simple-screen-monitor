import SwiftUI
import UIKit

@main
struct ActivityMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            NextMoveLockScreenView()
        }
    }
}

enum ProposalAction: Equatable {
    case execute
    case discard
    case later
    case detail
}

enum ToastKind: Equatable {
    case execute
    case discard
    case neutral
}

struct ActionChip: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    let title: String
    let isPrimary: Bool
}

struct EvidenceQuote: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let meta: String
}

struct ActionProposal: Identifiable, Equatable {
    let id = UUID()
    let source: String
    let sourceTime: String
    let confidence: String
    let label: String
    let title: String
    let because: String
    let quotes: [EvidenceQuote]
    let chips: [ActionChip]
    let sheetText: String
    let steps: [String]
    let executeToast: String
}

struct ActionToast: Equatable {
    let text: String
    let kind: ToastKind
}

struct ActionStreamState: Equatable {
    static let swipeThreshold: CGFloat = 88

    private(set) var queue: [ActionProposal]
    private(set) var detailProposal: ActionProposal?
    private(set) var toast: ActionToast?
    private(set) var executedCount = 0
    private(set) var discardedCount = 0
    private(set) var deferredCount = 0

    init(queue: [ActionProposal] = ActionProposal.demoDeck) {
        self.queue = queue
    }

    var activeProposal: ActionProposal? {
        queue.first
    }

    var isEmpty: Bool {
        queue.isEmpty
    }

    mutating func reset() {
        queue = ActionProposal.demoDeck
        detailProposal = nil
        toast = nil
        executedCount = 0
        discardedCount = 0
        deferredCount = 0
    }

    mutating func choose(_ action: ProposalAction) {
        guard let first = queue.first else { return }

        switch action {
        case .execute:
            queue.removeFirst()
            executedCount += 1
            toast = ActionToast(text: first.executeToast, kind: .execute)
        case .discard:
            queue.removeFirst()
            discardedCount += 1
            toast = ActionToast(text: "已丢掉：这张行动提案", kind: .discard)
        case .later:
            queue.removeFirst()
            queue.append(first)
            deferredCount += 1
            toast = ActionToast(text: "已放到卡堆末尾", kind: .neutral)
        case .detail:
            detailProposal = first
            toast = nil
        }
    }

    mutating func choose(translation: CGSize) -> ProposalAction? {
        let ax = abs(translation.width)
        let ay = abs(translation.height)
        guard max(ax, ay) >= Self.swipeThreshold else { return nil }

        let action: ProposalAction
        if ax > ay {
            action = translation.width > 0 ? .execute : .discard
        } else {
            action = translation.height < 0 ? .detail : .later
        }
        choose(action)
        return action
    }

    mutating func tapChip(_ chip: ActionChip) {
        toast = ActionToast(text: "demo only · \(chip.title) 未实际跳转", kind: .neutral)
    }

    mutating func closeDetail() {
        detailProposal = nil
    }
}

extension ActionProposal {
    static let demoDeck: [ActionProposal] = [
        ActionProposal(
            source: "微信 · 林林",
            sourceTime: "02 分钟前",
            confidence: "高置信",
            label: "当前最可能行动",
            title: "去北京北站网约车乘车点接人。",
            because: "位置、时间、通知三点叠合，这已经不是消息，是接人路径。",
            quotes: [
                EvidenceQuote(text: "我已经到北京北站了，你到哪了？", meta: "林林 · 02 分钟前"),
                EvidenceQuote(text: "上车点不好找，到了联系我。", meta: "林林 · 刚刚")
            ],
            chips: [
                ActionChip(symbol: "car.fill", title: "一键打车", isPrimary: true),
                ActionChip(symbol: "mappin.and.ellipse", title: "乘车点攻略", isPrimary: false),
                ActionChip(symbol: "tram.fill", title: "地铁换乘", isPrimary: false),
                ActionChip(symbol: "bubble.left.and.bubble.right.fill", title: "到达回复", isPrimary: false)
            ],
            sheetText: "微信通知、当前位置、时间窗口三个信号同时命中。系统判断你不是要继续读消息，而是要立刻处理接人路径。",
            steps: [
                "打开地图里的北京北站网约车上车点导航",
                "保留微信浮层，到达后一键发送实时位置草稿",
                "途中静默，避免再次解锁查看消息"
            ],
            executeToast: "demo only · 已展示北京北站路线草稿"
        ),
        ActionProposal(
            source: "飞书 · 周会 OKR 同步",
            sourceTime: "2 分钟后开始",
            confidence: "中高置信",
            label: "下一步行动提案",
            title: "静音入会，跳过等候室。",
            because: "通知与日程重合，下一步是入会，不是再读一遍提醒。",
            quotes: [
                EvidenceQuote(text: "周会 · OKR 同步即将开始（2 分钟后）", meta: "飞书提醒 · 刚刚"),
                EvidenceQuote(text: "与会 8 人 · 你的议题在第 3 项", meta: "日历 · 同步")
            ],
            chips: [
                ActionChip(symbol: "mic.slash.fill", title: "静音入会", isPrimary: true),
                ActionChip(symbol: "list.bullet.clipboard.fill", title: "查看议程", isPrimary: false),
                ActionChip(symbol: "note.text", title: "同步备忘", isPrimary: false),
                ActionChip(symbol: "person.2.fill", title: "通知联系人", isPrimary: false)
            ],
            sheetText: "飞书提醒和日历事件在 60 秒内重合。系统把它当成一个执行草稿：进入会议、默认静音、把日程标题贴在浮层顶部。",
            steps: [
                "准备会议链接，但不自动加入",
                "麦克风默认关闭，摄像头交给用户决定",
                "浮层顶部保留议程标题与第几项"
            ],
            executeToast: "demo only · 已准备静音入会草稿"
        ),
        ActionProposal(
            source: "美团 · 骑手即将到达",
            sourceTime: "约 300m",
            confidence: "高置信",
            label: "当前最可能行动",
            title: "准备下楼取餐。",
            because: "不是外卖摘要，是 3 分钟内要发生的执行动作。",
            quotes: [
                EvidenceQuote(text: "您的订单骑手已到达 1 公里内", meta: "美团 · 1 分钟前"),
                EvidenceQuote(text: "请准备取餐，预计 3 分钟到达", meta: "美团 · 刚刚")
            ],
            chips: [
                ActionChip(symbol: "location.fill", title: "骑手位置", isPrimary: true),
                ActionChip(symbol: "bell.fill", title: "提醒下楼", isPrimary: false),
                ActionChip(symbol: "phone.fill", title: "联系骑手", isPrimary: false),
                ActionChip(symbol: "house.fill", title: "修改地址", isPrimary: false)
            ],
            sheetText: "骑手定位与常用取餐地点重合，正在向你逼近。系统不打开外卖详情页，因为你现在更需要的是几点该下楼。",
            steps: [
                "展示骑手实时位置草稿",
                "提醒带门禁卡",
                "3 分钟后建议再次提醒"
            ],
            executeToast: "demo only · 已展示骑手位置草稿"
        ),
        ActionProposal(
            source: "短信 · 95588",
            sourceTime: "4 秒前",
            confidence: "高置信",
            label: "下一步行动提案",
            title: "把 824591 填进刚才的登录页。",
            because: "你刚在 Safari 输入过手机号，验证码不是消息，是登录的最后一步。",
            quotes: [
                EvidenceQuote(text: "【工商银行】您的验证码是 824591，60 秒内有效。", meta: "95588 · 4 秒前"),
                EvidenceQuote(text: "请勿向任何人提供此验证码。", meta: "95588 · 同条")
            ],
            chips: [
                ActionChip(symbol: "return", title: "一键填入", isPrimary: true),
                ActionChip(symbol: "doc.on.doc.fill", title: "复制", isPrimary: false),
                ActionChip(symbol: "checkmark.circle.fill", title: "标为已读", isPrimary: false),
                ActionChip(symbol: "exclamationmark.triangle.fill", title: "报告诈骗", isPrimary: false)
            ],
            sheetText: "短信验证码与 90 秒前 Safari 的登录行为高度相关。这里展示的是填入草稿，不会真实复制、切回或提交。",
            steps: [
                "识别 824591 作为一次性验证码",
                "定位到刚才的 Safari 登录页草稿",
                "等待用户确认，绝不自动提交"
            ],
            executeToast: "demo only · 已展示验证码填入草稿"
        )
    ]
}

struct NextMoveLockScreenView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var state = ActionStreamState()
    @State private var dragOffset: CGSize = .zero
    @State private var recordingDemoStarted = false

    private var shouldRunRecordingDemo: Bool {
        ProcessInfo.processInfo.arguments.contains("--recording-demo")
    }

    var body: some View {
        ZStack {
            LockWallpaperView()

            VStack(spacing: 0) {
                StatusBarView()
                HeaderView()
                Spacer(minLength: 18)
                CardStackView(
                    proposals: state.queue,
                    dragOffset: dragOffset,
                    onDragChanged: { dragOffset = $0 },
                    onDragEnded: handleDrag,
                    onChip: handleChip
                )
                .accessibilityIdentifier("action-card-stack")
                Spacer(minLength: 14)
                GestureHintBar(onAction: handleAction)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 18)

            if state.isEmpty {
                EmptyStateView {
                    withMotion {
                        state.reset()
                    }
                }
                .accessibilityIdentifier("empty-state")
            }

            if let toast = state.toast {
                ToastView(toast: toast)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .accessibilityIdentifier("action-toast")
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(true)
        .sheet(item: detailBinding) { proposal in
            DetailSheetView(proposal: proposal)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            await runRecordingDemoIfNeeded()
        }
    }

    private var detailBinding: Binding<ActionProposal?> {
        Binding(
            get: { state.detailProposal },
            set: { newValue in
                if newValue == nil {
                    state.closeDetail()
                }
            }
        )
    }

    private func handleChip(_ chip: ActionChip) {
        state.tapChip(chip)
        HapticsClient.light()
    }

    private func handleAction(_ action: ProposalAction) {
        withMotion {
            state.choose(action)
            dragOffset = .zero
        }
        HapticsClient.forAction(action)
    }

    private func handleDrag(_ translation: CGSize) {
        let action = state.choose(translation: translation)
        withMotion {
            dragOffset = .zero
        }
        if let action {
            HapticsClient.forAction(action)
        }
    }

    private func withMotion(_ changes: @escaping () -> Void) {
        if reduceMotion {
            changes()
        } else {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.82), changes)
        }
    }

    @MainActor
    private func runRecordingDemoIfNeeded() async {
        guard shouldRunRecordingDemo, !recordingDemoStarted else { return }
        recordingDemoStarted = true

        await pause(1.4)
        if let chip = state.activeProposal?.chips.first {
            handleChip(chip)
        }

        await pause(2.0)
        await demoSwipe(.detail)
        await pause(3.0)
        state.closeDetail()

        await pause(1.1)
        await demoSwipe(.later)

        await pause(2.0)
        await demoSwipe(.execute)

        await pause(2.0)
        await demoSwipe(.discard)

        await pause(2.0)
        await demoSwipe(.execute)

        await pause(2.0)
        await demoSwipe(.execute)

        await pause(3.0)
        withMotion {
            state.reset()
        }
    }

    @MainActor
    private func demoSwipe(_ action: ProposalAction) async {
        withMotion {
            dragOffset = demoOffset(for: action)
        }
        await pause(0.62)
        handleAction(action)
    }

    private func demoOffset(for action: ProposalAction) -> CGSize {
        switch action {
        case .execute:
            return CGSize(width: 132, height: 0)
        case .discard:
            return CGSize(width: -132, height: 0)
        case .later:
            return CGSize(width: 0, height: 132)
        case .detail:
            return CGSize(width: 0, height: -132)
        }
    }

    private func pause(_ seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

struct LockWallpaperView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.01, green: 0.02, blue: 0.07),
                Color(red: 0.03, green: 0.07, blue: 0.14),
                Color(red: 0.01, green: 0.02, blue: 0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Circle()
                .fill(Color.cyan.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 60)
                .offset(x: -90, y: -80)
        }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.green.opacity(0.11))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 110, y: 90)
        }
    }
}

struct StatusBarView: View {
    var body: some View {
        HStack {
            Text(Date.now, style: .time)
                .font(.callout.weight(.semibold))
                .monospacedDigit()
            Spacer()
            Label("5G", systemImage: "cellularbars")
                .labelStyle(.titleAndIcon)
                .font(.caption.weight(.semibold))
            Image(systemName: "battery.75")
                .font(.body.weight(.semibold))
        }
        .foregroundStyle(.white.opacity(0.9))
        .padding(.top, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("锁屏状态栏")
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("13:42")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.72)
                .accessibilityLabel("演示时间十三点四十二")

            HStack(spacing: 8) {
                Text("4月27日 周一")
                Circle().fill(.white.opacity(0.38)).frame(width: 3, height: 3)
                Text("朝阳区 · 锁屏")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.white.opacity(0.68))

            Label("正在把通知流转成行动提案", systemImage: "sparkles")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.84))
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(.white.opacity(0.08), in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.12)))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct CardStackView: View {
    let proposals: [ActionProposal]
    let dragOffset: CGSize
    let onDragChanged: (CGSize) -> Void
    let onDragEnded: (CGSize) -> Void
    let onChip: (ActionChip) -> Void

    var body: some View {
        ZStack {
            ForEach(Array(proposals.prefix(4).enumerated().reversed()), id: \.element.id) { index, proposal in
                ActionProposalCard(proposal: proposal, onChip: onChip)
                    .scaleEffect(index == 0 ? 1 : max(0.88, 1 - CGFloat(index) * 0.045))
                    .offset(y: index == 0 ? dragOffset.height : CGFloat(index) * -13)
                    .offset(x: index == 0 ? dragOffset.width : 0)
                    .rotationEffect(index == 0 ? .degrees(Double(dragOffset.width / 24)) : .zero)
                    .opacity(index == 0 ? 1 : max(0.28, 0.74 - Double(index) * 0.18))
                    .zIndex(Double(10 - index))
                    .allowsHitTesting(index == 0)
                    .gesture(
                        DragGesture(minimumDistance: 12)
                            .onChanged { value in onDragChanged(value.translation) }
                            .onEnded { value in onDragEnded(value.translation) }
                    )
            }
        }
        .frame(height: 430)
    }
}

struct ActionProposalCard: View {
    let proposal: ActionProposal
    let onChip: (ActionChip) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Circle().fill(Color.cyan).frame(width: 8, height: 8)
                Text(proposal.source)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                Text("· \(proposal.sourceTime)")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.48))
                Spacer()
                Text(proposal.confidence)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(.green.opacity(0.13), in: Capsule())
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(proposal.quotes) { quote in
                    VStack(alignment: .leading, spacing: 3) {
                        Text("“\(quote.text)”")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color(red: 0.95, green: 0.92, blue: 0.74))
                            .lineLimit(2)
                        Text(quote.meta)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.42))
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
                }
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(proposal.label)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.cyan)
                    .textCase(.uppercase)
                Text(proposal.title)
                    .font(.title2.weight(.bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                Text(proposal.because)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.64))
                    .lineLimit(3)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(proposal.chips) { chip in
                    Button {
                        onChip(chip)
                    } label: {
                        Label(chip.title, systemImage: chip.symbol)
                            .font(.caption.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(chip.isPrimary ? .black : .white.opacity(0.86))
                    .background(chip.isPrimary ? Color.green : Color.white.opacity(0.08), in: Capsule())
                    .overlay(Capsule().stroke(chip.isPrimary ? Color.clear : Color.white.opacity(0.12)))
                    .accessibilityLabel("\(chip.title)，演示按钮，不会实际跳转")
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 390, alignment: .top)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.16)))
        .shadow(color: .black.opacity(0.42), radius: 26, y: 18)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("行动提案，\(proposal.title)")
    }
}

struct GestureHintBar: View {
    let onAction: (ProposalAction) -> Void

    var body: some View {
        HStack(spacing: 8) {
            HintButton(title: "丢掉", systemImage: "arrow.left", action: { onAction(.discard) })
            HintButton(title: "执行", systemImage: "arrow.right", action: { onAction(.execute) })
            HintButton(title: "依据", systemImage: "arrow.up", action: { onAction(.detail) })
            HintButton(title: "稍后", systemImage: "arrow.down", action: { onAction(.later) })
        }
        .accessibilityElement(children: .contain)
    }
}

struct HintButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.bold))
                Text(title)
                    .font(.caption2.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12)))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white.opacity(0.78))
    }
}

struct DetailSheetView: View {
    let proposal: ActionProposal

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("判断依据")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.cyan)
                        .textCase(.uppercase)
                    Text(proposal.title)
                        .font(.title2.weight(.bold))
                    Text(proposal.sheetText)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(proposal.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .frame(width: 24, height: 24)
                                    .background(Color.cyan.opacity(0.16), in: Circle())
                                Text(step)
                                    .font(.subheadline)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("NextMove")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EmptyStateView: View {
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 58, weight: .semibold))
                .foregroundStyle(.green)
            Text("行动流已清空")
                .font(.title2.weight(.bold))
            Text("通知都已经变成演示结果。没有更多需要你现在判断的主卡片。")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.66))
            Button("重置 demo", action: onReset)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(.white.opacity(0.16)))
    }
}

struct ToastView: View {
    let toast: ActionToast

    var body: some View {
        Text(toast.text)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(foreground)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: 330)
            .background(background, in: Capsule())
            .overlay(Capsule().stroke(border))
            .shadow(color: .black.opacity(0.28), radius: 18, y: 10)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 30)
    }

    private var background: Color {
        switch toast.kind {
        case .execute: return Color.green.opacity(0.28)
        case .discard: return Color.red.opacity(0.28)
        case .neutral: return Color.white.opacity(0.12)
        }
    }

    private var border: Color {
        switch toast.kind {
        case .execute: return Color.green.opacity(0.46)
        case .discard: return Color.red.opacity(0.46)
        case .neutral: return Color.white.opacity(0.16)
        }
    }

    private var foreground: Color {
        toast.kind == .execute ? Color(red: 0.88, green: 1, blue: 0.78) : .white
    }
}
