import SwiftUI

struct FinanceView: View {
    @Environment(\.tokens) private var T
    @State private var mode = "loan"

    // Loan
    @State private var loanAmount = ""
    @State private var loanRate = ""
    @State private var loanTerm = ""
    @State private var loanTermUnit = "months"

    // Deposit
    @State private var depositAmount = ""
    @State private var depositRate = ""
    @State private var depositTerm = ""
    @State private var depositTermUnit = "months"
    @State private var monthlyContribution = ""

    @FocusState private var focused: FocusField?

    enum FocusField: Hashable {
        case loanAmt, loanRate, loanTerm
        case depAmt, depRate, depTerm, depContrib
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Picker("Mode", selection: $mode) {
                    Text("Loan").tag("loan")
                    Text("Deposit").tag("deposit")
                }
                .pickerStyle(.segmented)

                if mode == "loan" {
                    loanSection
                } else {
                    depositSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(T.bg)
        .navigationTitle("Finance")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focused = nil }
            }
        }
    }

    // MARK: - Loan

    private var loanSection: some View {
        let principal = Double(loanAmount) ?? 0
        let annual = Double(loanRate) ?? 0
        let termVal = Double(loanTerm) ?? 0
        let months = loanTermUnit == "years" ? termVal * 12 : termVal
        let mr = annual / 12 / 100

        let payment: Double
        let totalPaid: Double
        let totalInterest: Double

        if principal > 0 && mr > 0 && months > 0 {
            let f = pow(1 + mr, months)
            payment = principal * (mr * f) / (f - 1)
            totalPaid = payment * months
            totalInterest = totalPaid - principal
        } else if principal > 0 && months > 0 {
            payment = principal / months
            totalPaid = principal
            totalInterest = 0
        } else {
            payment = 0; totalPaid = 0; totalInterest = 0
        }

        return VStack(spacing: 14) {
            financeField("LOAN AMOUNT", prefix: "$", text: $loanAmount, focus: .loanAmt)

            HStack(spacing: 10) {
                financeField("ANNUAL RATE", suffix: "%", text: $loanRate, focus: .loanRate)
                termField(text: $loanTerm, unit: $loanTermUnit, focus: .loanTerm)
            }

            if payment > 0 {
                VStack(spacing: 0) {
                    Text("MONTHLY PAYMENT")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.6)
                        .opacity(0.85)

                    Text(fmtCurrency(payment))
                        .font(.custom("JetBrainsMono-SemiBold", size: 40))
                        .tracking(-1)
                        .padding(.top, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1)
                        .padding(.vertical, 14)

                    summaryRow("Principal", fmtCurrency(principal))
                        .padding(.bottom, 6)
                    summaryRow("Total Interest", fmtCurrency(totalInterest))
                        .padding(.bottom, 6)
                    summaryRow("Total Paid", fmtCurrency(totalPaid))
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.accent)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Breakdown
                if months > 0 && months <= 600 {
                    yearBreakdown(principal: principal, monthlyRate: mr, payment: payment, totalMonths: Int(months))
                }
            }
        }
    }

    // MARK: - Deposit

    private var depositSection: some View {
        let initial = Double(depositAmount) ?? 0
        let annual = Double(depositRate) ?? 0
        let termVal = Double(depositTerm) ?? 0
        let months = depositTermUnit == "years" ? termVal * 12 : termVal
        let monthly = Double(monthlyContribution) ?? 0
        let mr = annual / 12 / 100

        let finalAmt: Double
        let totalDep: Double
        let interest: Double

        if months > 0 {
            if mr > 0 {
                let ci = initial * pow(1 + mr, months)
                let cc = monthly > 0 ? monthly * (pow(1 + mr, months) - 1) / mr : 0
                finalAmt = ci + cc
            } else {
                finalAmt = initial + monthly * months
            }
            totalDep = initial + monthly * months
            interest = finalAmt - totalDep
        } else {
            finalAmt = initial; totalDep = initial; interest = 0
        }

        return VStack(spacing: 14) {
            financeField("INITIAL DEPOSIT", prefix: "$", text: $depositAmount, focus: .depAmt)

            HStack(spacing: 10) {
                financeField("ANNUAL RATE", suffix: "%", text: $depositRate, focus: .depRate)
                termField(text: $depositTerm, unit: $depositTermUnit, focus: .depTerm)
            }

            financeField("MONTHLY CONTRIBUTION", prefix: "$", text: $monthlyContribution, focus: .depContrib)

            if finalAmt > 0 && termVal > 0 {
                VStack(spacing: 0) {
                    Text("FINAL AMOUNT")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.6)
                        .opacity(0.85)

                    Text(fmtCurrency(finalAmt))
                        .font(.custom("JetBrainsMono-SemiBold", size: 40))
                        .tracking(-1)
                        .padding(.top, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1)
                        .padding(.vertical, 14)

                    summaryRow("Total Deposited", fmtCurrency(totalDep))
                        .padding(.bottom, 6)
                    summaryRow("Interest Earned", fmtCurrency(interest))
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.success)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Growth breakdown
                if months > 0 && months <= 600 {
                    depositBreakdown(initial: initial, monthlyRate: mr, contribution: monthly, totalMonths: Int(months))
                }
            }
        }
    }

    // MARK: - Loan Year Breakdown

    private func yearBreakdown(principal: Double, monthlyRate: Double, payment: Double, totalMonths: Int) -> some View {
        let years = min(totalMonths / 12 + (totalMonths % 12 > 0 ? 1 : 0), 50)
        var balance = principal
        var rows: [(year: Int, principalPaid: Double, interestPaid: Double, remaining: Double)] = []

        for y in 1...years {
            let monthsInYear = min(12, totalMonths - (y - 1) * 12)
            guard monthsInYear > 0 else { break }
            var yPrincipal = 0.0
            var yInterest = 0.0
            for _ in 0..<monthsInYear {
                let intPart = balance * monthlyRate
                let prinPart = min(payment - intPart, balance)
                yInterest += intPart
                yPrincipal += prinPart
                balance = max(0, balance - prinPart)
            }
            rows.append((y, yPrincipal, yInterest, balance))
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text("YEARLY BREAKDOWN")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { i, row in
                    HStack {
                        Text("Year \(row.year)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(T.text)
                            .frame(width: 56, alignment: .leading)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Interest: \(fmtShort(row.interestPaid))")
                                .font(.system(size: 11))
                                .foregroundStyle(T.red)
                            Text("Principal: \(fmtShort(row.principalPaid))")
                                .font(.system(size: 11))
                                .foregroundStyle(T.success)
                        }

                        Spacer()

                        Text(fmtShort(row.remaining))
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                            .foregroundStyle(T.textMuted)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)

                    if i < rows.count - 1 {
                        Divider().padding(.leading, 14)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Deposit Year Breakdown

    private func depositBreakdown(initial: Double, monthlyRate: Double, contribution: Double, totalMonths: Int) -> some View {
        let years = min(totalMonths / 12 + (totalMonths % 12 > 0 ? 1 : 0), 50)
        var balance = initial
        var rows: [(year: Int, deposited: Double, interest: Double, total: Double)] = []

        for y in 1...years {
            let monthsInYear = min(12, totalMonths - (y - 1) * 12)
            guard monthsInYear > 0 else { break }
            var yInterest = 0.0
            for _ in 0..<monthsInYear {
                let intPart = balance * monthlyRate
                yInterest += intPart
                balance += intPart + contribution
            }
            rows.append((y, contribution * Double(monthsInYear), yInterest, balance))
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text("YEARLY GROWTH")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { i, row in
                    HStack {
                        Text("Year \(row.year)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(T.text)
                            .frame(width: 56, alignment: .leading)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Interest: +\(fmtShort(row.interest))")
                                .font(.system(size: 11))
                                .foregroundStyle(T.success)
                            if row.deposited > 0 {
                                Text("Added: +\(fmtShort(row.deposited))")
                                    .font(.system(size: 11))
                                    .foregroundStyle(T.blue)
                            }
                        }

                        Spacer()

                        Text(fmtShort(row.total))
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                            .foregroundStyle(T.accent)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)

                    if i < rows.count - 1 {
                        Divider().padding(.leading, 14)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Components

    private func financeField(_ title: String, prefix: String? = nil, suffix: String? = nil, text: Binding<String>, focus: FocusField) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)

            HStack(spacing: 4) {
                if let prefix {
                    Text(prefix)
                        .font(.custom("JetBrainsMono-Medium", size: 18))
                        .foregroundStyle(T.textMuted)
                }
                TextField("0", text: text)
                    .font(.custom("JetBrainsMono-Medium", size: 22))
                    .foregroundStyle(T.text)
                    .keyboardType(.decimalPad)
                    .focused($focused, equals: focus)
                if let suffix {
                    Text(suffix)
                        .font(.custom("JetBrainsMono-Medium", size: 18))
                        .foregroundStyle(T.textMuted)
                }
            }
        }
        .padding(14)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
    }

    private func termField(text: Binding<String>, unit: Binding<String>, focus: FocusField) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TERM")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)

            HStack(spacing: 6) {
                TextField("0", text: text)
                    .font(.custom("JetBrainsMono-Medium", size: 22))
                    .foregroundStyle(T.text)
                    .keyboardType(.numberPad)
                    .focused($focused, equals: focus)
                    .frame(maxWidth: 50)

                Picker("", selection: unit) {
                    Text("mo").tag("months")
                    Text("yr").tag("years")
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 100)
            }
        }
        .padding(14)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 13)).opacity(0.85)
            Spacer()
            Text(value).font(.custom("JetBrainsMono-Medium", size: 14))
        }
    }

    private func fmtCurrency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func fmtShort(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "$%.1fM", value / 1_000_000)
        }
        if value >= 10_000 {
            return String(format: "$%.1fK", value / 1_000)
        }
        return String(format: "$%.0f", value)
    }
}

#Preview {
    NavigationStack {
        FinanceView()
    }
    .environment(\.tokens, .light)
}
