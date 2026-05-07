import SwiftUI

// MARK: - Tally Design Tokens
// Warm neutral surfaces + orange accent. Friendly iOS feel.

struct TallyTokens {
    let bg: Color
    let surface: Color
    let surfaceAlt: Color
    let border: Color
    let text: Color
    let textMuted: Color
    let textTertiary: Color
    let accent: Color
    let accentSoft: Color
    let success: Color
    let blue: Color
    let purple: Color
    let pink: Color
    let teal: Color
    let red: Color
    let yellow: Color
    let keyNum: Color
    let keyOp: Color
    let keyFn: Color
    let tabBg: Color

    static let light = TallyTokens(
        bg: Color(hex: "F2EFEA"),
        surface: .white,
        surfaceAlt: Color(hex: "F7F4EF"),
        border: Color.black.opacity(0.08),
        text: Color(hex: "1A1A1A"),
        textMuted: Color(hex: "3C3C43").opacity(0.6),
        textTertiary: Color(hex: "3C3C43").opacity(0.35),
        accent: Color(hex: "FF8A00"),
        accentSoft: Color(hex: "FFE9D6"),
        success: Color(hex: "1FAE74"),
        blue: Color(hex: "3A6FF7"),
        purple: Color(hex: "9A4BF0"),
        pink: Color(hex: "EC4899"),
        teal: Color(hex: "0EA5E9"),
        red: Color(hex: "D14545"),
        yellow: Color(hex: "F5B945"),
        keyNum: .white,
        keyOp: Color(hex: "FFE0BD"),
        keyFn: Color(hex: "EDE8E0"),
        tabBg: Color(hex: "F2EFEA").opacity(0.85)
    )

    static let dark = TallyTokens(
        bg: Color(hex: "0F0E0C"),
        surface: Color(hex: "1C1B19"),
        surfaceAlt: Color(hex: "262421"),
        border: Color.white.opacity(0.08),
        text: .white,
        textMuted: Color(hex: "EBEBF5").opacity(0.6),
        textTertiary: Color(hex: "EBEBF5").opacity(0.3),
        accent: Color(hex: "FF8A00"),
        accentSoft: Color(hex: "3A2410"),
        success: Color(hex: "1FAE74"),
        blue: Color(hex: "5A8AFF"),
        purple: Color(hex: "B57BFF"),
        pink: Color(hex: "F472B6"),
        teal: Color(hex: "38BDF8"),
        red: Color(hex: "EF6A6A"),
        yellow: Color(hex: "F5B945"),
        keyNum: Color(hex: "2A2825"),
        keyOp: Color(hex: "3A2410"),
        keyFn: Color(hex: "1F1D1B"),
        tabBg: Color(hex: "0F0E0C").opacity(0.85)
    )
}

// MARK: - Fonts

struct TallyFonts {
    static func mono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .custom("JetBrainsMono-Medium", size: size)
            .weight(weight)
    }

    static func monoFixed(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .custom("JetBrainsMono-Medium", size: size)
            .weight(weight)
    }

    static func ui(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

// MARK: - Spacing & Radius

enum TallyRadius {
    static let small: CGFloat = 10
    static let medium: CGFloat = 16
    static let large: CGFloat = 18
    static let xl: CGFloat = 22
    static let xxl: CGFloat = 28
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Environment Key

private struct TokensKey: EnvironmentKey {
    static let defaultValue: TallyTokens = .light
}

extension EnvironmentValues {
    var tokens: TallyTokens {
        get { self[TokensKey.self] }
        set { self[TokensKey.self] = newValue }
    }
}
