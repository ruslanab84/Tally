import SwiftUI

struct SettingsView: View {
    @Environment(\.tokens) private var T
    @Binding var isDarkMode: Bool

    @State private var hapticEnabled = true
    @State private var soundEnabled = false
    @State private var livePreview = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Appearance
                SettingsSection(T: T, title: "Appearance") {
                    // Theme
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Theme")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(T.text)

                        HStack(spacing: 4) {
                            ForEach(["Light", "Dark", "System"], id: \.self) { theme in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if theme == "Dark" { isDarkMode = true }
                                        else if theme == "Light" { isDarkMode = false }
                                    }
                                } label: {
                                    Text(theme)
                                        .font(.system(size: 11, weight: .medium))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            (theme == "Dark" && isDarkMode) || (theme == "Light" && !isDarkMode)
                                            ? T.accent : T.surfaceAlt
                                        )
                                        .foregroundStyle(
                                            (theme == "Dark" && isDarkMode) || (theme == "Light" && !isDarkMode)
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
                        Text("Accent")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(T.text)
                        Spacer()
                        HStack(spacing: 6) {
                            ForEach([T.accent, T.blue, T.success, T.purple, T.pink], id: \.description) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        Circle()
                                            .stroke(color == T.accent ? T.text : .clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    Divider().padding(.leading, 16)

                    SettingsRow(T: T, label: "App icon", value: "Default", showChevron: true, isLast: true)
                }

                // Language
                SettingsSection(T: T, title: "Language") {
                    SettingsRow(T: T, label: "App language", value: "English", showChevron: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Number format", value: "1,234.56", showChevron: true, useMono: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Decimal precision", value: "4 digits", showChevron: true, isLast: true)
                }

                // Calculator
                SettingsSection(T: T, title: "Calculator") {
                    SettingsToggleRow(T: T, label: "Haptic feedback", isOn: $hapticEnabled)
                    Divider().padding(.leading, 16)
                    SettingsToggleRow(T: T, label: "Sound", isOn: $soundEnabled)
                    Divider().padding(.leading, 16)
                    SettingsToggleRow(T: T, label: "Live preview", isOn: $livePreview)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Angle units", value: "Degrees", showChevron: true, isLast: true)
                }

                // Conversions
                SettingsSection(T: T, title: "Conversions") {
                    SettingsRow(T: T, label: "Default currency", value: "USD", showChevron: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Favorite units", value: "6 selected", showChevron: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Update rates", value: "Daily", showChevron: true, isLast: true)
                }

                // About
                SettingsSection(T: T, title: "About") {
                    SettingsRow(T: T, label: "Version", value: "1.0 (beta)", showChevron: false, useMono: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Privacy", showChevron: true)
                    Divider().padding(.leading, 16)
                    SettingsRow(T: T, label: "Send feedback", showChevron: true, isLast: true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(T.bg)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
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
                .font(.system(size: 11, weight: .semibold))
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
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(T.text)
            Spacer()
            if let value {
                Text(value)
                    .font(useMono ? .custom("JetBrainsMono-Medium", size: 14) : .system(size: 14))
                    .foregroundStyle(T.textMuted)
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
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
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(T.text)
        }
        .tint(T.accent)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(minHeight: 50)
    }
}

#Preview {
    NavigationStack {
        SettingsView(isDarkMode: .constant(false))
    }
    .environment(\.tokens, .light)
}
