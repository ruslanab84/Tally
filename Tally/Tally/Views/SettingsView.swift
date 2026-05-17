import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Binding var isDarkMode: Bool
    @Binding var appLanguage: String
    @Binding var accentColor: String

    @AppStorage("numberFormat") private var numberFormat = "comma_dot"
    @AppStorage("decimalPrecision") private var decimalPrecision = 4
    @AppStorage("defaultCurrency") private var defaultCurrency = "USD"

    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @State private var soundEnabled = false
    @State private var livePreview = true
    @State private var showFeedback = false
    @State private var showPrivacy = false

    private var appVersion: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Appearance
                SettingsSection(T: T, title: L.appearance) {
                    // Theme
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L.theme)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)

                        HStack(spacing: 4) {
                            let themeOptions: [(key: String, label: String)] = [
                                ("light", L.light),
                                ("dark", L.dark),
                                ("system", L.system),
                            ]
                            ForEach(themeOptions, id: \.key) { option in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if option.key == "dark" { isDarkMode = true }
                                        else if option.key == "light" { isDarkMode = false }
                                    }
                                } label: {
                                    Text(option.label)
                                        .font(.custom("JetBrainsMono-Medium", size: 11))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            (option.key == "dark" && isDarkMode) || (option.key == "light" && !isDarkMode)
                                            ? T.accent : T.surfaceAlt
                                        )
                                        .foregroundStyle(
                                            (option.key == "dark" && isDarkMode) || (option.key == "light" && !isDarkMode)
                                            ? .white : T.text
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    Divider().padding(.leading, 16)

                    // Accent colors
                    HStack {
                        Text(L.accent)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                        Spacer()
                        HStack(spacing: 6) {
                            ForEach(AccentTheme.allCases, id: \.rawValue) { theme in
                                let color = isDarkMode ? theme.darkColor : theme.lightColor
                                let isSelected = accentColor == theme.rawValue
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        accentColor = theme.rawValue
                                    }
                                } label: {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            Circle()
                                                .stroke(isSelected ? T.text : .clear, lineWidth: 2)
                                                .frame(width: 28, height: 28)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    Divider().padding(.leading, 16)

                    SettingsRow(T: T, label: L.appIcon, value: L.defaultVal, showChevron: true, isLast: true)
                }

                // Language
                SettingsSection(T: T, title: L.language) {
                    HStack {
                        Text(L.appLanguage)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                        Spacer()
                        Menu {
                            ForEach(AppLanguage.allCases) { lang in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        appLanguage = lang.rawValue
                                    }
                                } label: {
                                    HStack {
                                        Text("\(lang.flag) \(lang.displayName)")
                                        if appLanguage == lang.rawValue {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            let current = AppLanguage(rawValue: appLanguage) ?? .en
                            HStack(spacing: 6) {
                                Text(current.flag)
                                    .font(.custom("JetBrainsMono-Regular", size: 16))
                                Text(current.displayName)
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.textMuted)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.custom("JetBrainsMono-Regular", size: 10))
                                    .foregroundStyle(T.textTertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    Divider().padding(.leading, 16)

                    // Number format
                    HStack {
                        Text(L.numberFormat)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                        Spacer()
                        Menu {
                            ForEach(NumberFormatOption.allCases, id: \.rawValue) { opt in
                                Button {
                                    numberFormat = opt.rawValue
                                } label: {
                                    HStack {
                                        Text(opt.example)
                                        if numberFormat == opt.rawValue {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(NumberFormatOption(rawValue: numberFormat)?.example ?? "1,234.56")
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.textMuted)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.custom("JetBrainsMono-Regular", size: 10))
                                    .foregroundStyle(T.textTertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(minHeight: 50)

                    Divider().padding(.leading, 16)

                    // Decimal precision
                    HStack {
                        Text(L.decimalPrecision)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                        Spacer()
                        Menu {
                            ForEach([2, 4, 6, 8], id: \.self) { n in
                                Button {
                                    decimalPrecision = n
                                } label: {
                                    HStack {
                                        Text("\(n) \(L.digits)")
                                        if decimalPrecision == n {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("\(decimalPrecision) \(L.digits)")
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.textMuted)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.custom("JetBrainsMono-Regular", size: 10))
                                    .foregroundStyle(T.textTertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(minHeight: 50)
                }

                // Calculator
                SettingsSection(T: T, title: L.calculator) {
                    SettingsToggleRow(T: T, label: L.hapticFeedback, isOn: $hapticEnabled)
                    Divider().padding(.leading, 16)
                    SettingsToggleRow(T: T, label: L.sound, isOn: $soundEnabled)
                    Divider().padding(.leading, 16)
                    SettingsToggleRow(T: T, label: L.livePreview, isOn: $livePreview)
                }

                // Conversions
                SettingsSection(T: T, title: L.conversionsSection) {
                    HStack {
                        Text(L.defaultCurrency)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                        Spacer()
                        Menu {
                            ForEach(Currency.all.prefix(20)) { cur in
                                Button {
                                    defaultCurrency = cur.code
                                } label: {
                                    HStack {
                                        Text("\(cur.flag) \(cur.code) — \(cur.name)")
                                        if defaultCurrency == cur.code {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            let cur = Currency.all.first { $0.code == defaultCurrency }
                            HStack(spacing: 6) {
                                Text(cur?.flag ?? "🏳️")
                                    .font(.custom("JetBrainsMono-Regular", size: 16))
                                Text(defaultCurrency)
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.textMuted)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.custom("JetBrainsMono-Regular", size: 10))
                                    .foregroundStyle(T.textTertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(minHeight: 50)

                }

                // About
                SettingsSection(T: T, title: L.about) {
                    SettingsRow(T: T, label: L.version, value: appVersion, showChevron: false, useMono: true)
                    Divider().padding(.leading, 16)
                    Button { requestReview() } label: {
                        HStack {
                            Text(L.rateApp)
                                .font(.custom("JetBrainsMono-Medium", size: 15))
                                .foregroundStyle(T.text)
                            Spacer()
                            HStack(spacing: 2) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(T.yellow)
                                }
                            }
                            Image(systemName: "chevron.right")
                                .font(.custom("JetBrainsMono-SemiBold", size: 12))
                                .foregroundStyle(T.textTertiary)
                                .padding(.leading, 4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(minHeight: 50)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.leading, 16)
                    Button { showPrivacy = true } label: {
                        SettingsRow(T: T, label: L.privacy, showChevron: true)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.leading, 16)
                    Button { showFeedback = true } label: {
                        SettingsRow(T: T, label: L.sendFeedback, showChevron: true, isLast: true)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "gearshape", "paintbrush", "moon",
            "sun.max", "bell", "shield",
            "wrench", "slider.horizontal.3",
        ]) }
        .navigationTitle(L.navSettings)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showFeedback) {
            FeedbackView()
                .environment(\.tokens, T)
                .environment(\.loc, L)
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyPolicyView()
                .environment(\.tokens, T)
                .environment(\.loc, L)
        }
    }
}

// MARK: - Components

private struct SettingsSection<Content: View>: View {
    let T: TallyTokens
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }
}

private struct SettingsRow: View {
    let T: TallyTokens
    let label: String
    var value: String? = nil
    var showChevron: Bool = false
    var useMono: Bool = false
    var isLast: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.custom("JetBrainsMono-Medium", size: 15))
                .foregroundStyle(T.text)
            Spacer()
            if let value {
                Text(value)
                    .font(useMono ? .custom("JetBrainsMono-Medium", size: 14) : .system(size: 14))
                    .foregroundStyle(T.textMuted)
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.custom("JetBrainsMono-SemiBold", size: 12))
                    .foregroundStyle(T.textTertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(minHeight: 50)
    }
}

private struct SettingsToggleRow: View {
    let T: TallyTokens
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
                .font(.custom("JetBrainsMono-Medium", size: 15))
                .foregroundStyle(T.text)
        }
        .tint(T.accent)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(minHeight: 50)
    }
}

enum NumberFormatOption: String, CaseIterable {
    case comma_dot = "comma_dot"
    case dot_comma = "dot_comma"
    case space_comma = "space_comma"

    var example: String {
        switch self {
        case .comma_dot:  return "1,234.56"
        case .dot_comma:  return "1.234,56"
        case .space_comma: return "1 234,56"
        }
    }
}

#Preview {
    NavigationView {
        SettingsView(isDarkMode: .constant(false), appLanguage: .constant("en"), accentColor: .constant("orange"))
    }
    .environment(\.tokens, .light)
}
