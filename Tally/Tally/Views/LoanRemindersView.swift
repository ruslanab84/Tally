import SwiftUI

struct LoanRemindersView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    let store: LoanReminderStore
    let suggestedPayment: Double
    var suggestedPaymentDay: Int = 15

    @State private var name = ""
    @State private var amountText = ""
    @State private var paymentDay = 15
    @State private var daysBefore = 3
    @FocusState private var focused: Field?

    enum Field { case name, amount }

    private let daysOptions = [1, 2, 3, 5, 7, 14]

    private var canAdd: Bool {
        !name.isEmpty && (Double(amountText) ?? 0) > 0 && store.authStatus != .denied
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if store.authStatus == .denied { deniedBanner }
                    addForm
                    if !store.reminders.isEmpty { remindersList }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 36)
            }
            .background(T.bg.ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(L.loanSetReminder)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(T.textMuted)
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    Button(L.done) { focused = nil }
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                        .foregroundStyle(T.accent)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .onAppear {
            name = "Loan"
            amountText = suggestedPayment > 0 ? String(format: "%.2f", suggestedPayment) : ""
            paymentDay = max(1, min(28, suggestedPaymentDay))
        }
    }

    // MARK: - Add Form

    private var addForm: some View {
        VStack(spacing: 12) {
            sectionHeader(L.loanReminderAdd)

            VStack(spacing: 0) {
                // Name
                formRow(label: L.loanReminderName) {
                    TextField("My Loan", text: $name)
                        .font(.custom("JetBrainsMono-Medium", size: 15))
                        .foregroundStyle(T.text)
                        .multilineTextAlignment(.trailing)
                        .focused($focused, equals: .name)
                }
                divider

                // Monthly payment
                formRow(label: L.loanReminderPayment) {
                    HStack(spacing: 3) {
                        Text("$")
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                        TextField("0.00", text: $amountText)
                            .font(.custom("JetBrainsMono-Medium", size: 15))
                            .foregroundStyle(T.text)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focused, equals: .amount)
                    }
                }
                divider

                // Payment day of month
                HStack {
                    Text(L.loanReminderPayDay)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .foregroundStyle(T.textMuted)
                    Spacer()
                    Stepper(value: $paymentDay, in: 1...28) {
                        Text("\(paymentDay)\(ordinalSuffix(paymentDay))")
                            .font(.custom("JetBrainsMono-SemiBold", size: 15))
                            .foregroundStyle(T.text)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                divider

                // Days before
                VStack(alignment: .leading, spacing: 8) {
                    Text(L.loanReminderDaysBefore)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .foregroundStyle(T.textMuted)
                        .padding(.horizontal, 16)
                        .padding(.top, 14)

                    HStack(spacing: 6) {
                        ForEach(daysOptions, id: \.self) { d in
                            Button { daysBefore = d } label: {
                                Text("\(d)d")
                                    .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                    .foregroundStyle(daysBefore == d ? T.accent : T.textMuted)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(daysBefore == d ? T.accentSoft : T.surfaceAlt)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            // Live preview card
            if let amt = Double(amountText), amt > 0 {
                notifPreview(amount: amt)
            }

            // Add button
            Button {
                Task {
                    if store.authStatus == .notDetermined {
                        _ = await store.requestPermission()
                    }
                    guard store.authStatus != .denied else { return }
                    let amt = Double(amountText) ?? 0
                    await store.add(LoanReminder(
                        name: name.isEmpty ? "Loan" : name,
                        amount: amt,
                        paymentDay: paymentDay,
                        daysBefore: daysBefore
                    ))
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bell.badge.fill")
                    Text(L.loanReminderAdd)
                        .font(.custom("JetBrainsMono-SemiBold", size: 16))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canAdd ? T.accent : T.textTertiary)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            }
            .buttonStyle(.plain)
            .disabled(!canAdd)
        }
    }

    // MARK: - Notification Preview

    private func notifPreview(amount: Double) -> some View {
        let raw = paymentDay - daysBefore
        let notifDay = raw <= 0 ? max(1, 28 + raw) : raw
        let crossMonth = raw <= 0

        return HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(T.accentSoft)
                    .frame(width: 44, height: 44)
                Image(systemName: "bell.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(T.accent)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text("PREVIEW")
                        .font(.custom("JetBrainsMono-SemiBold", size: 10))
                        .tracking(0.8)
                        .foregroundStyle(T.textMuted)
                    if crossMonth {
                        Text("(prev month)")
                            .font(.custom("JetBrainsMono-Regular", size: 10))
                            .foregroundStyle(T.yellow)
                    }
                }
                Text("💳 \(name.isEmpty ? "Loan" : name)")
                    .font(.custom("JetBrainsMono-SemiBold", size: 13))
                    .foregroundStyle(T.text)
                Text("$\(String(format: "%.2f", amount)) due in \(daysBefore) day\(daysBefore == 1 ? "" : "s")")
                    .font(.custom("JetBrainsMono-Regular", size: 12))
                    .foregroundStyle(T.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(notifDay)\(ordinalSuffix(notifDay))")
                    .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    .foregroundStyle(T.accent)
                Text("9:00 AM")
                    .font(.custom("JetBrainsMono-Regular", size: 12))
                    .foregroundStyle(T.textMuted)
                Text("monthly")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textTertiary)
            }
        }
        .padding(14)
        .background(T.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: TallyRadius.medium)
                .stroke(T.accent.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Reminders List

    private var remindersList: some View {
        VStack(spacing: 12) {
            sectionHeader(L.loanReminderActive)

            VStack(spacing: 0) {
                ForEach(Array(store.reminders.enumerated()), id: \.element.id) { i, r in
                    reminderRow(r)
                    if i < store.reminders.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    private func reminderRow(_ r: LoanReminder) -> some View {
        HStack(spacing: 12) {
            Image(systemName: r.isActive ? "bell.fill" : "bell.slash.fill")
                .font(.system(size: 16))
                .foregroundStyle(r.isActive ? T.accent : T.textMuted)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(r.name)
                    .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    .foregroundStyle(T.text)
                HStack(spacing: 6) {
                    Text("$\(String(format: "%.2f", r.amount))")
                        .font(.custom("JetBrainsMono-Regular", size: 12))
                        .foregroundStyle(T.textMuted)
                    Text("·")
                        .foregroundStyle(T.textTertiary)
                    Text("\(r.daysBefore)d before \(r.paymentDay)\(ordinalSuffix(r.paymentDay))")
                        .font(.custom("JetBrainsMono-Regular", size: 12))
                        .foregroundStyle(T.textMuted)
                }
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { r.isActive },
                set: { _ in Task { await store.toggleActive(id: r.id) } }
            ))
            .labelsHidden()
            .tint(T.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                if let idx = store.reminders.firstIndex(where: { $0.id == r.id }) {
                    store.remove(at: IndexSet(integer: idx))
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: - Denied Banner

    private var deniedBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "bell.slash.fill")
                .foregroundStyle(T.red)
            Text(L.loanReminderDenied)
                .font(.custom("JetBrainsMono-Regular", size: 13))
                .foregroundStyle(T.text)
            Spacer()
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Settings")
                    .font(.custom("JetBrainsMono-SemiBold", size: 12))
                    .foregroundStyle(T.accent)
            }
        }
        .padding(14)
        .background(T.red.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
    }

    // MARK: - Helpers

    private func sectionHeader(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.custom("JetBrainsMono-SemiBold", size: 11))
            .tracking(0.6)
            .foregroundStyle(T.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func formRow<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 13))
                .foregroundStyle(T.textMuted)
                .frame(minWidth: 90, alignment: .leading)
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var divider: some View {
        Divider().padding(.leading, 16)
    }

    private func ordinalSuffix(_ n: Int) -> String {
        switch n { case 1: "st"; case 2: "nd"; case 3: "rd"; default: "th" }
    }
}
