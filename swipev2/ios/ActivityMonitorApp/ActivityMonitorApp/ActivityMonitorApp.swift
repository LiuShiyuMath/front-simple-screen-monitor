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

struct SwipeFeedback: Equatable {
    let action: ProposalAction
    let progress: CGFloat
    let isCommitted: Bool

    init?(translation: CGSize, threshold: CGFloat = ActionStreamState.swipeThreshold) {
        let ax = abs(translation.width)
        let ay = abs(translation.height)
        guard max(ax, ay) >= 6 else { return nil }

        if ax > ay {
            action = translation.width > 0 ? .execute : .discard
        } else {
            action = translation.height < 0 ? .detail : .later
        }
        let dominantDistance = max(ax, ay)
        progress = min(dominantDistance / threshold, 1.18)
        isCommitted = dominantDistance >= threshold
    }
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
    @AppStorage("selectedSkinID") private var selectedSkinID = ActivityMonitorSkin.bronze.rawValue
    @State private var state = ActionStreamState()
    @State private var dragOffset: CGSize = .zero
    @State private var recordingDemoStarted = false

    private var shouldRunRecordingDemo: Bool {
        ProcessInfo.processInfo.arguments.contains("--recording-demo")
    }

    private var launchSkinOverride: ActivityMonitorSkin? {
        ProcessInfo.processInfo.arguments
            .first(where: { $0.hasPrefix("--skin=") })
            .flatMap { argument in
                ActivityMonitorSkin(rawValue: String(argument.dropFirst("--skin=".count)))
            }
    }

    private var selectedSkin: ActivityMonitorSkin {
        ActivityMonitorSkin(rawValue: selectedSkinID) ?? .bronze
    }

    private var theme: ActivityMonitorTheme {
        selectedSkin.theme
    }

    private var skinBinding: Binding<ActivityMonitorSkin> {
        Binding(
            get: { selectedSkin },
            set: { selectedSkinID = $0.rawValue }
        )
    }

    var body: some View {
        ZStack {
            LockWallpaperView(theme: theme)

            VStack(spacing: 0) {
                StatusBarView(theme: theme)
                HeaderView(selectedSkin: skinBinding, theme: theme)
                Spacer(minLength: 18)
                CardStackView(
                    proposals: state.queue,
                    dragOffset: dragOffset,
                    onDragChanged: { dragOffset = $0 },
                    onDragEnded: handleDrag,
                    onChip: handleChip,
                    onAccessibilityAction: handleAction,
                    theme: theme
                )
                .accessibilityIdentifier("action-card-stack")
                Spacer(minLength: 28)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 18)

            if state.isEmpty {
                EmptyStateView(theme: theme) {
                    withMotion {
                        state.reset()
                    }
                }
                .accessibilityIdentifier("empty-state")
            }

            if let toast = state.toast {
                ToastView(toast: toast, theme: theme)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .accessibilityIdentifier("action-toast")
            }
        }
        .preferredColorScheme(theme.preferredScheme)
        .statusBarHidden(true)
        .sheet(item: detailBinding) { proposal in
            DetailSheetView(proposal: proposal, theme: theme)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            applyLaunchSkinOverrideIfNeeded()
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

    private func applyLaunchSkinOverrideIfNeeded() {
        guard let launchSkinOverride else { return }
        selectedSkinID = launchSkinOverride.rawValue
    }

    @MainActor
    private func runRecordingDemoIfNeeded() async {
        guard shouldRunRecordingDemo, !recordingDemoStarted else { return }
        recordingDemoStarted = true

        selectedSkinID = ActivityMonitorSkin.bronze.rawValue

        await pause(1.0)
        selectedSkinID = ActivityMonitorSkin.coral.rawValue
        await pause(1.1)
        selectedSkinID = ActivityMonitorSkin.steel.rawValue
        await pause(1.1)
        selectedSkinID = ActivityMonitorSkin.bronze.rawValue

        await pause(1.2)
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
        selectedSkinID = ActivityMonitorSkin.bronze.rawValue
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
    let theme: ActivityMonitorTheme

    var body: some View {
        LinearGradient(
            colors: [theme.backgroundTop, theme.backgroundMid, theme.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Circle()
                .fill(theme.secondaryGlow)
                .frame(width: 260, height: 260)
                .blur(radius: 60)
                .offset(x: -90, y: -80)
        }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(theme.ambientGlow)
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 110, y: 90)
        }
    }
}

struct StatusBarView: View {
    let theme: ActivityMonitorTheme

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
        .foregroundStyle(theme.primaryText.opacity(0.92))
        .padding(.top, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("锁屏状态栏")
    }
}

struct HeaderView: View {
    @Binding var selectedSkin: ActivityMonitorSkin
    let theme: ActivityMonitorTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("13:42")
                .font(.system(size: 70, weight: .bold, design: .serif))
                .monospacedDigit()
                .minimumScaleFactor(0.72)
                .accessibilityLabel("演示时间十三点四十二")

            HStack(spacing: 8) {
                Text("4月27日 周一")
                Circle().fill(theme.tertiaryText).frame(width: 3, height: 3)
                Text("朝阳区 · 锁屏")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(theme.secondaryText)

            VStack(alignment: .leading, spacing: 10) {
                Label(selectedSkin.note, systemImage: "swatchpalette.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.primaryText.opacity(0.86))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(GlassCapsuleSurface(theme: theme, fill: theme.cardFill, border: theme.line))

                SkinPickerView(selectedSkin: $selectedSkin, theme: theme)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CardStackView: View {
    let proposals: [ActionProposal]
    let dragOffset: CGSize
    let onDragChanged: (CGSize) -> Void
    let onDragEnded: (CGSize) -> Void
    let onChip: (ActionChip) -> Void
    let onAccessibilityAction: (ProposalAction) -> Void
    let theme: ActivityMonitorTheme

    var body: some View {
        ZStack {
            MagneticEdgesFeedbackView(feedback: feedback, theme: theme)

            ForEach(Array(proposals.prefix(4).enumerated().reversed()), id: \.element.id) { index, proposal in
                Group {
                    if index == 0 {
                        ActionProposalCard(
                            proposal: proposal,
                            feedback: feedback,
                            onChip: onChip,
                            theme: theme
                        )
                    } else {
                        ActionProposalPreviewCard(
                            proposal: proposal,
                            theme: theme,
                            depth: index
                        )
                    }
                }
                    .scaleEffect(index == 0 ? 1 : max(0.9, 1 - CGFloat(index) * 0.038))
                    .offset(y: index == 0 ? dragOffset.height : CGFloat(index) * -16)
                    .offset(x: index == 0 ? dragOffset.width : 0)
                    .rotationEffect(index == 0 ? .degrees(Double(dragOffset.width / 24)) : .zero)
                    .opacity(index == 0 ? 1 : max(0.2, 0.58 - Double(index) * 0.14))
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel("行动卡堆")
        .accessibilityHint("可通过滑动处理当前卡片，也可使用无障碍动作执行、丢掉、查看依据或稍后")
        .accessibilityAction(named: Text("执行")) { onAccessibilityAction(.execute) }
        .accessibilityAction(named: Text("丢掉")) { onAccessibilityAction(.discard) }
        .accessibilityAction(named: Text("依据")) { onAccessibilityAction(.detail) }
        .accessibilityAction(named: Text("稍后")) { onAccessibilityAction(.later) }
    }

    private var feedback: SwipeFeedback? {
        SwipeFeedback(translation: dragOffset)
    }
}

struct ActionProposalCard: View {
    let proposal: ActionProposal
    let feedback: SwipeFeedback?
    let onChip: (ActionChip) -> Void
    let theme: ActivityMonitorTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Circle().fill(theme.accent).frame(width: 8, height: 8)
                Text(proposal.source)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                Text("· \(proposal.sourceTime)")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(theme.tertiaryText)
                Spacer()
                Text(proposal.confidence)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(theme.accent)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(theme.accent.opacity(0.14), in: Capsule())
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(proposal.quotes) { quote in
                    VStack(alignment: .leading, spacing: 3) {
                        Text("“\(quote.text)”")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(theme.quoteText)
                            .lineLimit(2)
                        Text(quote.meta)
                            .font(.caption2)
                            .foregroundStyle(theme.tertiaryText)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.regularMaterial)
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(theme.quoteFill)
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(theme.line.opacity(0.56))
                    )
                }
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(proposal.label)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(theme.accent)
                    .textCase(.uppercase)
                Text(proposal.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                Text(proposal.because)
                    .font(.footnote)
                    .foregroundStyle(theme.secondaryText)
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
                    .foregroundStyle(chip.isPrimary ? theme.accentInk : theme.primaryText.opacity(0.9))
                    .background(
                        chip.isPrimary
                        ? AnyView(Capsule().fill(theme.accent))
                        : AnyView(GlassCapsuleSurface(theme: theme, fill: theme.chipFill, border: theme.line))
                    )
                    .accessibilityLabel("\(chip.title)，演示按钮，不会实际跳转")
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 390, alignment: .top)
        .background(GlassCardSurface(theme: theme, isPreview: false))
        .overlay(MagneticCardEdgeOverlay(feedback: feedback, theme: theme))
        .shadow(color: theme.shadowColor, radius: 26, y: 18)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityLabel: String {
        "行动提案，\(proposal.title)"
    }

    private var accessibilityValue: String {
        guard let feedback else { return "" }
        return "\(feedback.action.accessibilityName)，\(Int(feedback.progress * 100))%"
    }
}

struct MagneticEdgesFeedbackView: View {
    let feedback: SwipeFeedback?
    let theme: ActivityMonitorTheme

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                edgeRail(.discard, size: proxy.size)
                edgeRail(.execute, size: proxy.size)
                edgeRail(.detail, size: proxy.size)
                edgeRail(.later, size: proxy.size)

                if let feedback {
                    Image(systemName: feedback.action.symbolName)
                        .font(.system(size: 17 + feedback.progress * 8, weight: .bold))
                        .foregroundStyle(feedback.action.inkColor(theme: theme))
                        .frame(width: 42 + feedback.progress * 10, height: 42 + feedback.progress * 10)
                        .background(
                            Circle()
                                .fill(feedback.action.tintColor(theme: theme).opacity(0.88))
                        )
                        .overlay(
                            Circle()
                                .stroke(theme.primaryText.opacity(feedback.isCommitted ? 0.42 : 0.2), lineWidth: 1)
                        )
                        .shadow(
                            color: feedback.action.tintColor(theme: theme).opacity(0.34),
                            radius: 12 + feedback.progress * 10,
                            y: 4
                        )
                        .position(symbolPosition(for: feedback.action, size: proxy.size, progress: feedback.progress))
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityHidden(true)
                }
            }
        }
        .padding(.horizontal, -8)
        .padding(.vertical, -6)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func edgeRail(_ action: ProposalAction, size: CGSize) -> some View {
        let isActive = feedback?.action == action
        let progress = isActive ? feedback?.progress ?? 0 : 0
        let color = action.tintColor(theme: theme)
        let opacity = isActive ? 0.2 + progress * 0.44 : 0.09
        let thickness = isActive ? 7 + progress * 9 : 5
        let length = isActive ? 104 + progress * 92 : 78

        return Capsule()
            .fill(color.opacity(opacity))
            .overlay(Capsule().stroke(color.opacity(isActive ? 0.46 : 0.16), lineWidth: 1))
            .frame(
                width: action.isHorizontalEdge ? length : thickness,
                height: action.isHorizontalEdge ? thickness : length
            )
            .position(railPosition(for: action, size: size))
    }

    private func railPosition(for action: ProposalAction, size: CGSize) -> CGPoint {
        switch action {
        case .discard:
            return CGPoint(x: 10, y: size.height / 2)
        case .execute:
            return CGPoint(x: size.width - 10, y: size.height / 2)
        case .detail:
            return CGPoint(x: size.width / 2, y: 10)
        case .later:
            return CGPoint(x: size.width / 2, y: size.height - 10)
        }
    }

    private func symbolPosition(for action: ProposalAction, size: CGSize, progress: CGFloat) -> CGPoint {
        let inset = 28 - min(progress, 1) * 8
        switch action {
        case .discard:
            return CGPoint(x: inset, y: size.height / 2)
        case .execute:
            return CGPoint(x: size.width - inset, y: size.height / 2)
        case .detail:
            return CGPoint(x: size.width / 2, y: inset)
        case .later:
            return CGPoint(x: size.width / 2, y: size.height - inset)
        }
    }
}

struct MagneticCardEdgeOverlay: View {
    let feedback: SwipeFeedback?
    let theme: ActivityMonitorTheme

    var body: some View {
        GeometryReader { proxy in
            if let feedback {
                let color = feedback.action.tintColor(theme: theme)
                let progress = feedback.progress

                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(color.opacity(0.18 + progress * 0.34), lineWidth: 1 + progress * 1.4)

                    Capsule()
                        .fill(color.opacity(0.38 + progress * 0.28))
                        .frame(
                            width: feedback.action.isHorizontalEdge ? 92 + progress * 94 : 7 + progress * 9,
                            height: feedback.action.isHorizontalEdge ? 7 + progress * 9 : 92 + progress * 94
                        )
                        .position(edgePosition(for: feedback.action, size: proxy.size))
                        .shadow(color: color.opacity(0.34), radius: 12 + progress * 12)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func edgePosition(for action: ProposalAction, size: CGSize) -> CGPoint {
        switch action {
        case .discard:
            return CGPoint(x: 4, y: size.height / 2)
        case .execute:
            return CGPoint(x: size.width - 4, y: size.height / 2)
        case .detail:
            return CGPoint(x: size.width / 2, y: 4)
        case .later:
            return CGPoint(x: size.width / 2, y: size.height - 4)
        }
    }
}

private extension ProposalAction {
    var symbolName: String {
        switch self {
        case .execute:
            return "bolt.fill"
        case .discard:
            return "xmark"
        case .later:
            return "clock.arrow.circlepath"
        case .detail:
            return "doc.text.magnifyingglass"
        }
    }

    var accessibilityName: String {
        switch self {
        case .execute:
            return "执行"
        case .discard:
            return "丢掉"
        case .later:
            return "稍后"
        case .detail:
            return "依据"
        }
    }

    var isHorizontalEdge: Bool {
        self == .detail || self == .later
    }

    func tintColor(theme: ActivityMonitorTheme) -> Color {
        switch self {
        case .execute:
            return theme.success
        case .discard:
            return theme.danger
        case .later:
            return theme.accent
        case .detail:
            return theme.primaryText
        }
    }

    func inkColor(theme: ActivityMonitorTheme) -> Color {
        switch self {
        case .execute, .later:
            return theme.accentInk
        case .discard, .detail:
            return theme.backgroundBottom
        }
    }
}

struct ActionProposalPreviewCard: View {
    let proposal: ActionProposal
    let theme: ActivityMonitorTheme
    let depth: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Circle().fill(theme.accent.opacity(0.88)).frame(width: 8, height: 8)
                Text(proposal.source)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                Spacer()
                Text(proposal.confidence)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(theme.accent)
            }

            Text(proposal.title)
                .font(.system(.headline, design: .serif, weight: .bold))
                .lineLimit(depth == 1 ? 2 : 1)
                .foregroundStyle(theme.primaryText.opacity(0.92))

            HStack(spacing: 8) {
                Capsule()
                    .fill(theme.quoteFill)
                    .frame(width: depth == 1 ? 112 : 90, height: 12)
                Capsule()
                    .fill(theme.chipFill)
                    .frame(width: depth == 1 ? 84 : 62, height: 12)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 390, alignment: .top)
        .background(GlassCardSurface(theme: theme, isPreview: true))
        .shadow(color: theme.shadowColor.opacity(0.72), radius: 20, y: 14)
        .accessibilityHidden(true)
    }
}

struct GlassCardSurface: View {
    let theme: ActivityMonitorTheme
    let isPreview: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 28, style: .continuous)

        ZStack {
            shape.fill(.thinMaterial)
            shape.fill(theme.cardFill.opacity(isPreview ? 0.92 : 1))
            shape.fill(
                LinearGradient(
                    colors: [highlightColor, Color.clear, shadowColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .overlay(shape.stroke(theme.line.opacity(isPreview ? 0.78 : 1)))
        .overlay(shape.inset(by: 1).stroke(highlightColor.opacity(isPreview ? 0.2 : 0.28)))
    }

    private var highlightColor: Color {
        theme.preferredScheme == .dark
            ? theme.primaryText.opacity(isPreview ? 0.06 : 0.1)
            : Color.white.opacity(isPreview ? 0.2 : 0.34)
    }

    private var shadowColor: Color {
        theme.preferredScheme == .dark
            ? Color.black.opacity(isPreview ? 0.12 : 0.18)
            : theme.backgroundBottom.opacity(isPreview ? 0.1 : 0.18)
    }
}

struct GlassCapsuleSurface: View {
    let theme: ActivityMonitorTheme
    let fill: Color
    let border: Color

    var body: some View {
        let shape = Capsule()

        ZStack {
            shape.fill(.regularMaterial)
            shape.fill(fill)
            shape.fill(
                LinearGradient(
                    colors: [highlightColor, Color.clear, shadowColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .overlay(shape.stroke(border))
    }

    private var highlightColor: Color {
        theme.preferredScheme == .dark
            ? theme.primaryText.opacity(0.07)
            : Color.white.opacity(0.3)
    }

    private var shadowColor: Color {
        theme.preferredScheme == .dark
            ? Color.black.opacity(0.12)
            : theme.backgroundBottom.opacity(0.12)
    }
}

struct SkinPickerView: View {
    @Binding var selectedSkin: ActivityMonitorSkin
    let theme: ActivityMonitorTheme

    var body: some View {
        HStack(spacing: 10) {
            ForEach(ActivityMonitorSkin.allCases) { skin in
                Button {
                    selectedSkin = skin
                } label: {
                    Text(skin.title)
                        .font(.caption.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            selectedSkin == skin
                            ? AnyView(Capsule().fill(theme.accent))
                            : AnyView(GlassCapsuleSurface(theme: theme, fill: theme.cardFill, border: theme.line))
                        )
                }
                .buttonStyle(.plain)
                .foregroundStyle(selectedSkin == skin ? theme.accentInk : theme.primaryText.opacity(0.9))
                .accessibilityLabel("切换到\(skin.headline)皮肤")
            }
        }
        .accessibilityElement(children: .contain)
    }
}

struct DetailSheetView: View {
    let proposal: ActionProposal
    let theme: ActivityMonitorTheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("判断依据")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(theme.accent)
                        .textCase(.uppercase)
                    Text(proposal.title)
                        .font(.system(.title2, design: .serif, weight: .bold))
                    Text(proposal.sheetText)
                        .font(.body)
                        .foregroundStyle(theme.secondaryText)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(proposal.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .frame(width: 24, height: 24)
                                    .background(theme.accent.opacity(0.16), in: Circle())
                                Text(step)
                                    .font(.subheadline)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(theme.cardFill, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(theme.line))
                        }
                    }
                }
                .padding(20)
            }
            .scrollContentBackground(.hidden)
            .background(theme.sheetBackground)
            .navigationTitle("NextMove")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(theme.sheetBackground)
    }
}

struct EmptyStateView: View {
    let theme: ActivityMonitorTheme
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 58, weight: .semibold))
                .foregroundStyle(theme.accent)
            Text("行动流已清空")
                .font(.title2.weight(.bold))
            Text("通知都已经变成演示结果。没有更多需要你现在判断的主卡片。")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(theme.secondaryText)
            Button("重置 demo", action: onReset)
                .font(.headline.weight(.semibold))
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(theme.accent, in: Capsule())
                .foregroundStyle(theme.accentInk)
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(theme.cardFill, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(theme.line))
    }
}

struct ToastView: View {
    let toast: ActionToast
    let theme: ActivityMonitorTheme

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
        case .execute: return theme.success.opacity(0.24)
        case .discard: return theme.danger.opacity(0.26)
        case .neutral: return theme.neutralFill
        }
    }

    private var border: Color {
        switch toast.kind {
        case .execute: return theme.success.opacity(0.46)
        case .discard: return theme.danger.opacity(0.5)
        case .neutral: return theme.line
        }
    }

    private var foreground: Color {
        toast.kind == .execute ? theme.accentInk : theme.primaryText
    }
}
