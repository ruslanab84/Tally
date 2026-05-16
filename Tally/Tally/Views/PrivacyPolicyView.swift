import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    policySection(
                        icon: "hand.raised.fill",
                        title: "Overview",
                        body: "Tally is a calculator and converter app. We are committed to protecting your privacy. This policy explains what data we collect, why, and how it is used."
                    )

                    policySection(
                        icon: "iphone",
                        title: "Data We Collect",
                        body: "Tally does not require an account and does not collect personal data automatically.\n\nWhen you voluntarily submit feedback via Settings → Send Feedback, we collect:\n• Your feedback message\n• Device model (e.g. iPhone 15)\n• App version\n• Date of submission\n\nNo name, email, or location is collected unless you choose to include it in your message."
                    )

                    policySection(
                        icon: "internaldrive",
                        title: "Local Storage",
                        body: "All app settings, calculation history, favourites, and preferences are stored locally on your device using Apple's UserDefaults and never transmitted to our servers."
                    )

                    policySection(
                        icon: "network",
                        title: "Network Requests",
                        body: "Tally makes network requests only for:\n• Live currency exchange rates (OpenExchangeRates / Fixer API)\n• Cryptocurrency prices (CoinGecko API)\n• Sending feedback (Firebase Firestore)\n\nThese requests are made over HTTPS. No personal data is included in rate or price requests."
                    )

                    policySection(
                        icon: "flame",
                        title: "Firebase",
                        body: "We use Firebase (Google) to receive user feedback. Submitted feedback is stored in Firebase Firestore and is only accessible to the app developers. Firebase may collect anonymous usage diagnostics per Google's privacy policy."
                    )

                    policySection(
                        icon: "person.slash",
                        title: "Third Parties",
                        body: "We do not sell, share, or rent your data to any third parties. We do not display advertisements. We do not use tracking or analytics SDKs."
                    )

                    policySection(
                        icon: "lock.shield",
                        title: "Data Security",
                        body: "All data in transit is encrypted using HTTPS/TLS. Feedback data stored in Firebase is protected by Firebase security rules and is accessible only to authorized developers."
                    )

                    policySection(
                        icon: "person.badge.minus",
                        title: "Your Rights",
                        body: "You may request deletion of any feedback you submitted by contacting us at the email below. Since we do not link feedback to identifiable accounts, please include the content of your message and approximate date."
                    )

                    policySection(
                        icon: "envelope",
                        title: "Contact",
                        body: "If you have questions about this Privacy Policy, contact us at:\nrusikabdulov@gmail.com"
                    )

                    Text("Last updated: May 2026")
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(T.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                }
                .padding(16)
                .padding(.bottom, 20)
            }
            .background(T.bg)
            .navigationTitle(L.privacy)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L.done) { dismiss() }
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                        .foregroundStyle(T.accent)
                }
            }
        }
    }

    @ViewBuilder
    private func policySection(icon: String, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(T.accent.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(T.accent)
                }
                Text(title)
                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                    .foregroundStyle(T.text)
            }

            Text(body)
                .font(.custom("JetBrainsMono-Regular", size: 13))
                .foregroundStyle(T.textMuted)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
    }
}
