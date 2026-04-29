import SwiftUI

enum ActivityMonitorSkin: String, CaseIterable, Identifiable {
    case bronze
    case coral
    case steel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .bronze:
            return "Bronze"
        case .coral:
            return "Coral"
        case .steel:
            return "Steel"
        }
    }

    var headline: String {
        switch self {
        case .bronze:
            return "Bronze Cinema"
        case .coral:
            return "Coral Receipt"
        case .steel:
            return "Steel Orchid"
        }
    }

    var note: String {
        switch self {
        case .bronze:
            return "夜间调度台，适合做默认主皮肤。"
        case .coral:
            return "亮面事务台，更像长期日用工具。"
        case .steel:
            return "冷金属未来版，保留一点实验感。"
        }
    }

    var theme: ActivityMonitorTheme {
        switch self {
        case .bronze:
            return .init(
                preferredScheme: .dark,
                backgroundTop: Color(hex: 0x100D0C),
                backgroundMid: Color(hex: 0x2A1D17),
                backgroundBottom: Color(hex: 0x0B0908),
                ambientGlow: Color(hex: 0xD29A62, opacity: 0.22),
                secondaryGlow: Color(hex: 0xFFE3BE, opacity: 0.08),
                primaryText: Color(hex: 0xFFF4EA),
                secondaryText: Color(hex: 0xFFF4EA, opacity: 0.72),
                tertiaryText: Color(hex: 0xFFF4EA, opacity: 0.46),
                cardFill: Color(hex: 0xFFE4CD, opacity: 0.21),
                line: Color(hex: 0xFFE4CD, opacity: 0.24),
                quoteFill: Color(hex: 0xFFF5E8, opacity: 0.16),
                quoteText: Color(hex: 0xFFF4EA),
                chipFill: Color(hex: 0xFFF5E8, opacity: 0.15),
                accent: Color(hex: 0xD29A62),
                accentInk: Color(hex: 0x1A0F05),
                danger: Color(hex: 0xED7B74),
                success: Color(hex: 0xD29A62),
                neutralFill: Color(hex: 0xFFF4EA, opacity: 0.16),
                shadowColor: Color.black.opacity(0.42),
                sheetBackground: Color(hex: 0x18100D)
            )
        case .coral:
            return .init(
                preferredScheme: .light,
                backgroundTop: Color(hex: 0xF5E9E2),
                backgroundMid: Color(hex: 0xECD7CB),
                backgroundBottom: Color(hex: 0xE3D0C4),
                ambientGlow: Color(hex: 0xE47F6B, opacity: 0.18),
                secondaryGlow: Color.white.opacity(0.34),
                primaryText: Color(hex: 0x241716),
                secondaryText: Color(hex: 0x241716, opacity: 0.68),
                tertiaryText: Color(hex: 0x241716, opacity: 0.46),
                cardFill: Color.white.opacity(0.68),
                line: Color(hex: 0x241716, opacity: 0.14),
                quoteFill: Color(hex: 0xFFF8F5, opacity: 0.74),
                quoteText: Color(hex: 0x241716),
                chipFill: Color(hex: 0x241716, opacity: 0.08),
                accent: Color(hex: 0xE47F6B),
                accentInk: Color(hex: 0x180706),
                danger: Color(hex: 0xC8534C),
                success: Color(hex: 0xD96E5B),
                neutralFill: Color(hex: 0x241716, opacity: 0.11),
                shadowColor: Color.black.opacity(0.18),
                sheetBackground: Color(hex: 0xF5EEE7)
            )
        case .steel:
            return .init(
                preferredScheme: .dark,
                backgroundTop: Color(hex: 0x111117),
                backgroundMid: Color(hex: 0x292C3B),
                backgroundBottom: Color(hex: 0x0D0D12),
                ambientGlow: Color(hex: 0xC8B5FF, opacity: 0.18),
                secondaryGlow: Color(hex: 0xDAD6FF, opacity: 0.08),
                primaryText: Color(hex: 0xF6F5FF),
                secondaryText: Color(hex: 0xF6F5FF, opacity: 0.72),
                tertiaryText: Color(hex: 0xF6F5FF, opacity: 0.46),
                cardFill: Color(hex: 0xECEBFF, opacity: 0.18),
                line: Color(hex: 0xECEBFF, opacity: 0.19),
                quoteFill: Color(hex: 0xF4F3FF, opacity: 0.14),
                quoteText: Color(hex: 0xF6F5FF),
                chipFill: Color(hex: 0xF4F3FF, opacity: 0.13),
                accent: Color(hex: 0xC8B5FF),
                accentInk: Color(hex: 0x110A20),
                danger: Color(hex: 0xF07A92),
                success: Color(hex: 0xC8B5FF),
                neutralFill: Color(hex: 0xF6F5FF, opacity: 0.16),
                shadowColor: Color.black.opacity(0.44),
                sheetBackground: Color(hex: 0x14151D)
            )
        }
    }
}

struct ActivityMonitorTheme {
    let preferredScheme: ColorScheme
    let backgroundTop: Color
    let backgroundMid: Color
    let backgroundBottom: Color
    let ambientGlow: Color
    let secondaryGlow: Color
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color
    let cardFill: Color
    let line: Color
    let quoteFill: Color
    let quoteText: Color
    let chipFill: Color
    let accent: Color
    let accentInk: Color
    let danger: Color
    let success: Color
    let neutralFill: Color
    let shadowColor: Color
    let sheetBackground: Color
}

extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
