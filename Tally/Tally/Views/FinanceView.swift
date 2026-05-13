import SwiftUI

struct FinanceView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var mode = "loan"

    // Loan
    @State private var loanAmount = "250000"
    @State private var loanRate = "6.5"
    @State private var loanTerm = "30"
    @State private var loanTermUnit = "years"

    // Deposit
    @State private var depositAmount = "10000"
    @State private var depositRate = "4.5"
    @State private var depositTerm = "5"
    @State private var depositTermUnit = "years"
    @State private var monthlyContribution = "500"

    @State private var loanViewMode = "monthly"
    @State private var expandedYear: Int? = 1

    // Deposit options
    @State private var capitalization = "monthly"
    @State private var depositTaxRate = "0"

    // Mortgage
    @State private var propPrice = "500000"
    @State private var downPaymentAmt = "100000"
    @State private var downPaymentPct = "20"
    @State private var downPaymentMode = "amount"
    @State private var mortgageRate = "6.5"
    @State private var mortgageTerm = "30"
    @State private var mortgagePaymentType = "annuity"
    @State private var propTaxRate = "1.2"
    @State private var homeInsAmt = "150"
    @State private var hoaFeesAmt = "0"
    @State private var extraPayAmt = "0"
    @State private var showMortgageExtras = false
    @State private var mortgageExpandedYear: Int? = 1

    // Rent vs Buy
    @State private var rvbMonthlyRent = "2000"
    @State private var rvbRentIncrease = "3"
    @State private var rvbHomePrice = "500000"
    @State private var rvbDownPmt = "100000"
    @State private var rvbRate = "6.5"
    @State private var rvbTermYears = "30"
    @State private var rvbAppreciation = "3"
    @State private var rvbInvestReturn = "7"
    @State private var rvbYears = 10

    @FocusState private var focused: FocusField?

    enum FocusField: Hashable {
        case loanAmt, loanRate, loanTerm
        case depAmt, depRate, depTerm, depContrib, depTax
        case propPrice, downPayment, mortgageRate, mortgageTerm
        case propTax, homeIns, hoa, extraPay
        case rvbRent, rvbRentInc, rvbHomeP, rvbDownP, rvbRate2, rvbTerm2, rvbAppreciation, rvbReturn
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Picker("Mode", selection: $mode) {
                    Text(L.loan).tag("loan")
                    Text(L.deposit).tag("deposit")
                    Text(L.mortgage).tag("mortgage")
                    Text(L.rentVsBuy).tag("rentbuy")
                }
                .pickerStyle(.segmented)

                if mode == "loan" {
                    loanSection
                } else if mode == "deposit" {
                    depositSection
                } else if mode == "mortgage" {
                    mortgageSection
                } else {
                    rentVsBuySection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background { TallyBackground(T: T, icons: [
            "dollarsign.circle", "chart.line.uptrend.xyaxis", "percent",
            "building.columns", "creditcard", "banknote",
            "chart.bar", "chart.pie", "wallet.bifold",
        ]) }
        .navigationTitle(L.navFinance)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L.done) { focused = nil }
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
            financeField(L.loanAmount, prefix: "$", text: $loanAmount, focus: .loanAmt)

            HStack(spacing: 10) {
                financeField(L.annualRate, suffix: "%", text: $loanRate, focus: .loanRate)
                termField(text: $loanTerm, unit: $loanTermUnit, focus: .loanTerm)
            }

            if payment > 0 {
                VStack(spacing: 0) {
                    Text(L.monthlyPayment)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
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

                    summaryRow(L.principal, fmtCurrency(principal))
                        .padding(.bottom, 6)
                    summaryRow(L.totalInterest, fmtCurrency(totalInterest))
                        .padding(.bottom, 6)
                    summaryRow(L.totalPaid, fmtCurrency(totalPaid))

                    if totalPaid > 0 {
                        let principalFrac = CGFloat(principal / totalPaid)
                        VStack(spacing: 6) {
                            GeometryReader { geo in
                                HStack(spacing: 2) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white)
                                        .frame(width: geo.size.width * principalFrac)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white.opacity(0.35))
                                }
                            }
                            .frame(height: 8)

                            HStack {
                                HStack(spacing: 4) {
                                    Circle().fill(.white).frame(width: 6, height: 6)
                                    Text("\(L.principal) \(Int(principalFrac * 100))%")
                                        .font(.custom("JetBrainsMono-Regular", size: 10))
                                }
                                Spacer()
                                HStack(spacing: 4) {
                                    Circle().fill(.white.opacity(0.35)).frame(width: 6, height: 6)
                                    Text("\(L.interest) \(Int((1 - principalFrac) * 100))%")
                                        .font(.custom("JetBrainsMono-Regular", size: 10))
                                }
                            }
                            .opacity(0.85)
                        }
                        .padding(.top, 14)
                    }
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.accent)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Breakdown
                if months > 0 && months <= 600 {
                    loanSchedule(principal: principal, monthlyRate: mr, payment: payment, totalMonths: Int(months))
                }
            }
        }
    }

    // MARK: - Mortgage

    private var mortgageSection: some View {
        let price = Double(propPrice) ?? 0
        let dpAmt: Double = downPaymentMode == "amount"
            ? (Double(downPaymentAmt) ?? 0)
            : price * (Double(downPaymentPct) ?? 20) / 100
        let dpPct = price > 0 ? dpAmt / price * 100 : 0
        let loan = max(0, price - dpAmt)
        let mr = (Double(mortgageRate) ?? 0) / 12 / 100
        let termYears = Double(mortgageTerm) ?? 30
        let termMonths = Int(termYears * 12)

        let pAndIPayment: Double = {
            guard loan > 0, termMonths > 0 else { return 0 }
            if mortgagePaymentType == "annuity" && mr > 0 {
                let f = pow(1 + mr, Double(termMonths))
                return loan * (mr * f) / (f - 1)
            } else if mr == 0 {
                return loan / Double(termMonths)
            } else {
                return loan / Double(termMonths) + loan * mr
            }
        }()

        let pmiMonthly = dpPct < 20 ? loan * 0.005 / 12 : 0
        let taxMonthly = price * (Double(propTaxRate) ?? 1.2) / 100 / 12
        let insMonthly = Double(homeInsAmt) ?? 150
        let hoaMonthly = Double(hoaFeesAmt) ?? 0
        let total = pAndIPayment + pmiMonthly + taxMonthly + insMonthly + hoaMonthly

        let totalPaidAmt = pAndIPayment * Double(termMonths)
        let totalInterestAmt = max(0, totalPaidAmt - loan)

        let cal = Calendar.current
        let lastDate = cal.date(byAdding: .month, value: termMonths, to: Date()) ?? Date()
        let df = DateFormatter(); df.dateFormat = "MMM yyyy"
        let lastDateStr = df.string(from: lastDate)

        return VStack(spacing: 14) {
            // Property price
            financeField(L.propPrice, prefix: "$", text: $propPrice, focus: .propPrice)

            // Down payment
            VStack(alignment: .leading, spacing: 6) {
                Text(L.downPayment)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 8) {
                    Picker("", selection: $downPaymentMode) {
                        Text("$").tag("amount")
                        Text("%").tag("percent")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 80)

                    if downPaymentMode == "amount" {
                        HStack(spacing: 4) {
                            Text("$").font(.custom("JetBrainsMono-Medium", size: 18)).foregroundStyle(T.textMuted)
                            TextField("0", text: $downPaymentAmt)
                                .font(.custom("JetBrainsMono-Medium", size: 22))
                                .foregroundStyle(T.text)
                                .keyboardType(.decimalPad)
                                .focused($focused, equals: .downPayment)
                        }
                    } else {
                        HStack(spacing: 4) {
                            TextField("20", text: $downPaymentPct)
                                .font(.custom("JetBrainsMono-Medium", size: 22))
                                .foregroundStyle(T.text)
                                .keyboardType(.decimalPad)
                                .focused($focused, equals: .downPayment)
                            Text("%").font(.custom("JetBrainsMono-Medium", size: 18)).foregroundStyle(T.textMuted)
                        }
                    }

                    Spacer()

                    if price > 0 {
                        Text(fmtShort(dpAmt))
                            .font(.custom("JetBrainsMono-Medium", size: 14))
                            .foregroundStyle(T.textMuted)
                        Text("(\(Int(dpPct.rounded()))%)")
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                            .foregroundStyle(T.textMuted)
                    }
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            HStack(spacing: 10) {
                financeField(L.annualRate, suffix: "%", text: $mortgageRate, focus: .mortgageRate)
                financeField(L.term, suffix: L.yr, text: $mortgageTerm, focus: .mortgageTerm)
            }

            // Payment type
            VStack(alignment: .leading, spacing: 8) {
                Text(L.paymentType)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                HStack(spacing: 6) {
                    ForEach([("annuity", L.annuity), ("diff", L.diffPayment)], id: \.0) { key, label in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) { mortgagePaymentType = key }
                        } label: {
                            Text(label)
                                .font(.custom("JetBrainsMono-SemiBold", size: 12))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(mortgagePaymentType == key ? T.accent : .clear)
                                .foregroundStyle(mortgagePaymentType == key ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(mortgagePaymentType == key ? T.accent : T.border, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            // Optional extras toggle
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showMortgageExtras.toggle() }
            } label: {
                HStack {
                    Text("\(L.propTax) / \(L.homeIns) / \(L.hoa)")
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.3)
                        .foregroundStyle(T.textMuted)
                    Spacer()
                    Image(systemName: showMortgageExtras ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11))
                        .foregroundStyle(T.textMuted)
                }
                .padding(14)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            }
            .buttonStyle(.plain)

            if showMortgageExtras {
                VStack(spacing: 10) {
                    financeField(L.propTax, suffix: "%", text: $propTaxRate, focus: .propTax)
                    financeField(L.homeIns, prefix: "$", text: $homeInsAmt, focus: .homeIns)
                    financeField(L.hoa, prefix: "$", text: $hoaFeesAmt, focus: .hoa)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if total > 0 && termMonths > 0 {
                // Result card
                VStack(spacing: 0) {
                    Text(L.totalMonthly)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .opacity(0.85)

                    Text(fmtCurrency(total))
                        .font(.custom("JetBrainsMono-SemiBold", size: 40))
                        .tracking(-1)
                        .padding(.top, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1).padding(.vertical, 14)

                    // Breakdown rows
                    summaryRow(L.pAndI, fmtCurrency(pAndIPayment)).padding(.bottom, 6)
                    if taxMonthly > 0 {
                        summaryRow(L.propTax.replacingOccurrences(of: " %", with: ""), fmtCurrency(taxMonthly)).padding(.bottom, 6)
                    }
                    if insMonthly > 0 {
                        summaryRow(L.homeIns.components(separatedBy: " $/").first ?? "Ins.", fmtCurrency(insMonthly)).padding(.bottom, 6)
                    }
                    if pmiMonthly > 0 {
                        summaryRow(L.pmi, fmtCurrency(pmiMonthly)).padding(.bottom, 6)
                    }
                    if hoaMonthly > 0 {
                        summaryRow(L.hoa.components(separatedBy: " $/").first ?? "HOA", fmtCurrency(hoaMonthly)).padding(.bottom, 6)
                    }

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1).padding(.vertical, 10)

                    summaryRow(L.principal, fmtCurrency(loan)).padding(.bottom, 6)
                    summaryRow(L.totalInterest, fmtCurrency(totalInterestAmt)).padding(.bottom, 6)
                    summaryRow(L.totalPaid, fmtCurrency(totalPaidAmt)).padding(.bottom, 6)
                    summaryRow(L.lastPaymentDate, lastDateStr)

                    if dpPct < 20 {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 11))
                            Text("PMI \(L.pmi): \(String(format: "%.1f", dpPct))% < 20%")
                                .font(.custom("JetBrainsMono-Regular", size: 11))
                        }
                        .opacity(0.7)
                        .padding(.top, 10)
                    }
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.accent)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Balance chart
                if mr > 0 {
                    mortgageBalanceChart(loan: loan, mr: mr, pmt: pAndIPayment, termMonths: termMonths)
                }

                // Extra payment scenario
                mortgageScenario(loan: loan, mr: mr, basePmt: pAndIPayment, termMonths: termMonths, totalInterestAmt: totalInterestAmt)

                // Amortization schedule (reuse existing)
                if termMonths <= 600 {
                    loanSchedule(principal: loan, monthlyRate: mr, payment: pAndIPayment, totalMonths: termMonths)
                }
            }
        }
    }

    private func mortgageBalanceChart(loan: Double, mr: Double, pmt: Double, termMonths: Int) -> some View {
        let termYears = termMonths / 12
        let step = termYears > 20 ? 5 : (termYears > 10 ? 2 : 1)
        var points: [(year: Int, balance: Double)] = []
        let years = stride(from: 0, through: termYears, by: step)
        for y in years {
            let n = y * 12
            let bal: Double
            if n == 0 {
                bal = loan
            } else if n >= termMonths {
                bal = 0
            } else {
                let f = pow(1 + mr, Double(n))
                bal = max(0, loan * f - pmt * (f - 1) / mr)
            }
            points.append((y, bal))
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text(L.debtBalance)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                GeometryReader { geo in
                    let w = geo.size.width - 60
                    let h: CGFloat = 120
                    ZStack(alignment: .bottomLeading) {
                        ForEach(Array(points.enumerated()), id: \.offset) { i, point in
                            let x = w * CGFloat(i) / CGFloat(max(points.count - 1, 1)) + 50
                            let barH = loan > 0 ? h * CGFloat(point.balance / loan) : 0

                            VStack(spacing: 2) {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(colors: [T.accent.opacity(0.9), T.accent.opacity(0.3)],
                                                       startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 28, height: max(2, barH))

                                Text("\(point.year)")
                                    .font(.custom("JetBrainsMono-Regular", size: 9))
                                    .foregroundStyle(T.textMuted)
                                    .frame(width: 28)
                            }
                            .frame(height: h + 20)
                            .position(x: x, y: (h + 20) / 2)
                        }

                        // Y labels
                        VStack(alignment: .leading) {
                            Text(fmtShort(loan))
                                .font(.custom("JetBrainsMono-Regular", size: 9))
                                .foregroundStyle(T.textMuted)
                            Spacer()
                            Text("$0")
                                .font(.custom("JetBrainsMono-Regular", size: 9))
                                .foregroundStyle(T.textMuted)
                        }
                        .frame(width: 44, height: h)
                        .position(x: 22, y: h / 2)
                    }
                }
                .frame(height: 150)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    private func mortgageScenario(loan: Double, mr: Double, basePmt: Double, termMonths: Int, totalInterestAmt: Double) -> some View {
        let extra = Double(extraPayAmt) ?? 0
        let newPmt = basePmt + extra

        let monthsWithExtra: Int = {
            guard extra > 0, mr > 0, loan > 0 else { return termMonths }
            var bal = loan
            var m = 0
            while bal > 0 && m < termMonths * 2 {
                let intPart = bal * mr
                let prinPart = min(newPmt - intPart, bal)
                bal -= prinPart
                m += 1
            }
            return m
        }()

        let totalInterestExtra: Double = {
            guard extra > 0, mr > 0 else { return totalInterestAmt }
            var bal = loan; var totalInt = 0.0
            for _ in 0..<monthsWithExtra {
                let intPart = bal * mr
                let prinPart = min(newPmt - intPart, bal)
                totalInt += intPart
                bal = max(0, bal - prinPart)
            }
            return totalInt
        }()

        let yearsSaved = (termMonths - monthsWithExtra) / 12
        let monthsSaved = (termMonths - monthsWithExtra) % 12
        let interestSaved = totalInterestAmt - totalInterestExtra

        return VStack(alignment: .leading, spacing: 8) {
            Text(L.scenario)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                financeField(L.extraPaymentLabel, prefix: "$", text: $extraPayAmt, focus: .extraPay)
                    .padding(.horizontal, 14)
                    .padding(.top, 14)
                    .background(T.surface)

                if extra > 0 && interestSaved > 0 {
                    VStack(spacing: 10) {
                        Rectangle().fill(T.border).frame(height: 1).padding(.horizontal, 14)

                        HStack(spacing: 0) {
                            VStack(spacing: 4) {
                                Text(L.loan)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 10))
                                    .foregroundStyle(T.textMuted)
                                Text(fmtCurrency(totalInterestAmt))
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.red)
                                Text("\(termMonths / 12) \(L.yr)")
                                    .font(.custom("JetBrainsMono-Regular", size: 11))
                                    .foregroundStyle(T.textMuted)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 2) {
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(T.accent)
                                Text(fmtShort(interestSaved))
                                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                                    .foregroundStyle(T.success)
                                Text(L.saved)
                                    .font(.custom("JetBrainsMono-Regular", size: 9))
                                    .foregroundStyle(T.textMuted)
                            }

                            VStack(spacing: 4) {
                                Text("+\(fmtCurrency(extra))/\(L.mo)")
                                    .font(.custom("JetBrainsMono-SemiBold", size: 10))
                                    .foregroundStyle(T.textMuted)
                                Text(fmtCurrency(totalInterestExtra))
                                    .font(.custom("JetBrainsMono-Medium", size: 14))
                                    .foregroundStyle(T.success)
                                Text("\(monthsWithExtra / 12) \(L.yr) \(monthsWithExtra % 12) \(L.mo)")
                                    .font(.custom("JetBrainsMono-Regular", size: 11))
                                    .foregroundStyle(T.textMuted)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 14)
                        .padding(.bottom, 14)

                        if yearsSaved > 0 || monthsSaved > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundStyle(T.success)
                                Text("\(yearsSaved > 0 ? "\(yearsSaved) \(L.yr) " : "")\(monthsSaved > 0 ? "\(monthsSaved) \(L.mo)" : "") · \(fmtShort(interestSaved)) \(L.saved)")
                                    .font(.custom("JetBrainsMono-Medium", size: 12))
                                    .foregroundStyle(T.success)
                            }
                            .padding(.horizontal, 14)
                            .padding(.bottom, 14)
                        }
                    }
                    .background(T.accentSoft)
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Rent vs Buy

    private var rentVsBuySection: some View {
        // --- Inputs ---
        let rent0 = Double(rvbMonthlyRent) ?? 2000
        let rentIncRate = (Double(rvbRentIncrease) ?? 3) / 100
        let homePrice = Double(rvbHomePrice) ?? 500000
        let dp = Double(rvbDownPmt) ?? 100000
        let loan = max(0, homePrice - dp)
        let mr = (Double(rvbRate) ?? 6.5) / 12 / 100
        let termMo = (Int(rvbTermYears) ?? 30) * 12
        let appRate = (Double(rvbAppreciation) ?? 3) / 100
        let invRate = (Double(rvbInvestReturn) ?? 7) / 100
        let years = rvbYears
        let compareMo = min(years * 12, termMo)

        // Mortgage payment
        let pmt: Double = {
            guard loan > 0, termMo > 0 else { return 0 }
            if mr > 0 {
                let f = pow(1 + mr, Double(termMo))
                return loan * (mr * f) / (f - 1)
            }
            return loan / Double(termMo)
        }()

        // Renting: total rent paid with annual increases
        let totalRentPaid: Double = {
            var total = 0.0; var m = rent0
            for _ in 0..<years { total += m * 12; m *= (1 + rentIncRate) }
            return total
        }()

        // Buying: total mortgage paid
        let totalMortgagePaid = pmt * Double(compareMo)

        // Home value after N years
        let homeValueFuture = homePrice * pow(1 + appRate, Double(years))

        // Remaining loan balance after N years
        let remainingLoanBal: Double = {
            guard loan > 0, mr > 0 else { return max(0, loan - pmt * Double(compareMo)) }
            if compareMo >= termMo { return 0 }
            let f = pow(1 + mr, Double(compareMo))
            return max(0, loan * f - pmt * (f - 1) / mr)
        }()

        let equity = max(0, homeValueFuture - remainingLoanBal)

        // Down payment invested (opportunity cost for renter)
        let investedDP = dp * pow(1 + invRate, Double(years))

        // Net positions (from cash-flow perspective)
        // Buying: you have equity, you paid mortgage from income
        let buyNetWealth = equity - totalMortgagePaid
        // Renting: you invested DP, you paid rent from income
        let rentNetWealth = investedDP - totalRentPaid

        let buyingAdvantage = buyNetWealth - rentNetWealth
        let buyingWins = buyingAdvantage >= 0

        return VStack(spacing: 14) {
            // --- Renting inputs ---
            sectionLabel(L.renting)

            HStack(spacing: 10) {
                financeField(L.monthlyRent, prefix: "$", text: $rvbMonthlyRent, focus: .rvbRent)
                financeField(L.rentIncrease, suffix: "%", text: $rvbRentIncrease, focus: .rvbRentInc)
            }

            // --- Buying inputs ---
            sectionLabel(L.buying)

            financeField(L.propPrice, prefix: "$", text: $rvbHomePrice, focus: .rvbHomeP)

            HStack(spacing: 10) {
                financeField(L.downPayment, prefix: "$", text: $rvbDownPmt, focus: .rvbDownP)
                financeField(L.annualRate, suffix: "%", text: $rvbRate, focus: .rvbRate2)
            }

            HStack(spacing: 10) {
                financeField(L.term, suffix: L.yr, text: $rvbTermYears, focus: .rvbTerm2)
                financeField(L.homeAppreciation, suffix: "%", text: $rvbAppreciation, focus: .rvbAppreciation)
            }

            financeField(L.investReturn, suffix: "%", text: $rvbInvestReturn, focus: .rvbReturn)

            // --- Year selector ---
            VStack(alignment: .leading, spacing: 8) {
                Text(L.yearsCompare)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 6) {
                    ForEach([5, 10, 15, 20, 25, 30], id: \.self) { y in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) { rvbYears = y }
                        } label: {
                            Text("\(y)")
                                .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(rvbYears == y ? T.accent : T.surface)
                                .foregroundStyle(rvbYears == y ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            if pmt > 0 {
                // --- Main comparison card ---
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("\(L.renting)")
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .frame(maxWidth: .infinity)
                        Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 20)
                        Text("\(L.buying)")
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 14)

                    // Monthly cost row
                    HStack(alignment: .top) {
                        VStack(spacing: 2) {
                            Text(fmtCurrency(rent0))
                                .font(.custom("JetBrainsMono-SemiBold", size: 22))
                            Text(L.monthly.lowercased())
                                .font(.custom("JetBrainsMono-Regular", size: 10))
                                .opacity(0.75)
                        }
                        .frame(maxWidth: .infinity)

                        Text("vs")
                            .font(.custom("JetBrainsMono-Regular", size: 11))
                            .opacity(0.6)
                            .frame(width: 24)

                        VStack(spacing: 2) {
                            Text(fmtCurrency(pmt))
                                .font(.custom("JetBrainsMono-SemiBold", size: 22))
                            Text(L.monthly.lowercased())
                                .font(.custom("JetBrainsMono-Regular", size: 10))
                                .opacity(0.75)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.white)

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1).padding(.vertical, 14)

                    HStack(alignment: .top, spacing: 8) {
                        // Renting column
                        VStack(alignment: .leading, spacing: 6) {
                            rvbRow(label: L.totalPaid, value: fmtCurrency(totalRentPaid), highlight: false)
                            rvbRow(label: L.invested, value: fmtCurrency(investedDP), highlight: true)
                            Divider().background(.white.opacity(0.3))
                            rvbRow(label: L.netPosition, value: fmtCurrency(rentNetWealth), highlight: rentNetWealth >= 0)
                        }
                        .frame(maxWidth: .infinity)

                        Rectangle().fill(.white.opacity(0.3)).frame(width: 1)

                        // Buying column
                        VStack(alignment: .leading, spacing: 6) {
                            rvbRow(label: L.totalPaid, value: fmtCurrency(totalMortgagePaid), highlight: false)
                            rvbRow(label: L.homeEquity, value: fmtCurrency(equity), highlight: true)
                            Divider().background(.white.opacity(0.3))
                            rvbRow(label: L.netPosition, value: fmtCurrency(buyNetWealth), highlight: buyNetWealth >= 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.white)

                    // Sub-detail: home value + remaining loan
                    if remainingLoanBal > 0 {
                        HStack(spacing: 4) {
                            Text("\(L.homeEquity): \(fmtShort(homeValueFuture)) − \(fmtShort(remainingLoanBal))")
                                .font(.custom("JetBrainsMono-Regular", size: 10))
                                .opacity(0.6)
                        }
                        .padding(.top, 6)
                    }
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(buyingWins ? T.accent : T.success)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // --- Verdict banner ---
                HStack(spacing: 8) {
                    Image(systemName: buyingWins ? "house.fill" : "person.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(buyingWins ? T.accent : T.success)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(buyingWins ? L.buyingBetter : L.rentingBetter)
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .foregroundStyle(buyingWins ? T.accent : T.success)
                        Text(fmtCurrency(abs(buyingAdvantage)))
                            .font(.custom("JetBrainsMono-SemiBold", size: 22))
                            .tracking(-0.5)
                            .foregroundStyle(T.text)
                    }

                    Spacer()

                    Text(buyingWins ? "✅" : "🔑")
                        .font(.system(size: 28))
                }
                .padding(16)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

                // --- Timeline chart ---
                rvbTimelineChart(
                    rent0: rent0, rentIncRate: rentIncRate,
                    dp: dp, loan: loan, mr: mr, termMo: termMo,
                    pmt: pmt, appRate: appRate, invRate: invRate
                )
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.custom("JetBrainsMono-SemiBold", size: 11))
            .tracking(0.6)
            .foregroundStyle(T.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
    }

    private func rvbRow(label: String, value: String, highlight: Bool) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 10))
                .opacity(0.7)
            Text(value)
                .font(.custom("JetBrainsMono-Medium", size: 13))
                .opacity(highlight ? 1.0 : 0.85)
        }
    }

    private func rvbTimelineChart(
        rent0: Double, rentIncRate: Double,
        dp: Double, loan: Double, mr: Double, termMo: Int,
        pmt: Double, appRate: Double, invRate: Double
    ) -> some View {
        let checkpoints = [5, 10, 15, 20, 25, 30].filter { $0 <= (termMo / 12) }

        var points: [(year: Int, rentNet: Double, buyNet: Double)] = []
        for y in checkpoints {
            let cMo = min(y * 12, termMo)
            var totalRent = 0.0; var m = rent0
            for _ in 0..<y { totalRent += m * 12; m *= (1 + rentIncRate) }
            let totalMort = pmt * Double(cMo)
            let homeVal = (loan + dp) * pow(1 + appRate, Double(y))
            let remLoan: Double = {
                guard mr > 0, cMo < termMo else { return 0 }
                let f = pow(1 + mr, Double(cMo))
                return max(0, loan * f - pmt * (f - 1) / mr)
            }()
            let eq = max(0, homeVal - remLoan)
            let invDP = dp * pow(1 + invRate, Double(y))
            points.append((y, invDP - totalRent, eq - totalMort))
        }

        guard !points.isEmpty else { return AnyView(EmptyView()) }

        let allVals = points.flatMap { [$0.rentNet, $0.buyNet] }
        let minVal = allVals.min() ?? 0
        let maxVal = allVals.max() ?? 1
        let range = max(maxVal - minVal, 1)

        return AnyView(VStack(alignment: .leading, spacing: 8) {
            Text(L.netPosition.uppercased())
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                GeometryReader { geo in
                    let w = geo.size.width
                    let h: CGFloat = 110
                    let chartH: CGFloat = 80
                    let n = points.count
                    let colW = w / CGFloat(n)

                    ZStack(alignment: .bottom) {
                        // Zero line
                        let zeroY: CGFloat = minVal >= 0 ? chartH : chartH * CGFloat(maxVal / range)
                        let _ = zeroY
                        Rectangle()
                            .fill(T.border)
                            .frame(height: 1)
                            .offset(y: -(zeroY) + chartH - 1)

                        ForEach(Array(points.enumerated()), id: \.offset) { i, pt in
                            let x = CGFloat(i) * colW + colW / 2

                            // Rent bar
                            let rentH = chartH * CGFloat(abs(pt.rentNet) / range)
                            let rentUp = pt.rentNet >= 0
                            RoundedRectangle(cornerRadius: 3)
                                .fill(T.blue.opacity(0.7))
                                .frame(width: colW * 0.28, height: max(2, rentH))
                                .offset(x: x - colW * 0.17)
                                .frame(maxHeight: .infinity, alignment: rentUp ? .bottom : .top)

                            // Buy bar
                            let buyH = chartH * CGFloat(abs(pt.buyNet) / range)
                            let buyUp = pt.buyNet >= 0
                            RoundedRectangle(cornerRadius: 3)
                                .fill(T.accent.opacity(0.85))
                                .frame(width: colW * 0.28, height: max(2, buyH))
                                .offset(x: x + colW * 0.17)
                                .frame(maxHeight: .infinity, alignment: buyUp ? .bottom : .top)

                            // Year label
                            Text("\(pt.year)")
                                .font(.custom("JetBrainsMono-Regular", size: 9))
                                .foregroundStyle(T.textMuted)
                                .frame(width: colW)
                                .offset(x: x - colW / 2, y: chartH)
                        }
                    }
                    .frame(height: h)
                }
                .frame(height: 130)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)

                // Legend
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2).fill(T.blue.opacity(0.7)).frame(width: 12, height: 8)
                        Text(L.renting).font(.custom("JetBrainsMono-Regular", size: 10)).foregroundStyle(T.textMuted)
                    }
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2).fill(T.accent.opacity(0.85)).frame(width: 12, height: 8)
                        Text(L.buying).font(.custom("JetBrainsMono-Regular", size: 10)).foregroundStyle(T.textMuted)
                    }
                }
                .padding(.bottom, 12)
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        })
    }

    // MARK: - Deposit

    private var capPeriodsPerYear: Int {
        switch capitalization {
        case "quarterly": return 4
        case "semiannual": return 2
        case "annual": return 1
        default: return 12
        }
    }

    private var capLabel: String {
        switch capitalization {
        case "quarterly": return L.quarterly
        case "semiannual": return L.semiAnnual
        case "annual": return L.annual
        default: return L.monthly
        }
    }

    private func simulateDeposit(initial: Double, annualRate: Double, totalMonths: Int, monthly: Double, taxRate: Double = 0) -> (final: Double, totalDep: Double, grossInterest: Double, taxPaid: Double) {
        guard totalMonths > 0 else { return (initial, initial, 0, 0) }
        let capFreq = capPeriodsPerYear
        let monthsPerCap = 12 / capFreq
        let taxFactor = 1.0 - taxRate / 100

        var balance = initial
        var accruedInterest = 0.0
        var totalGrossInterest = 0.0

        for m in 1...totalMonths {
            balance += monthly
            accruedInterest += balance * (annualRate / 100 / 12)

            if m % monthsPerCap == 0 || m == totalMonths {
                totalGrossInterest += accruedInterest
                balance += accruedInterest * taxFactor
                accruedInterest = 0
            }
        }

        let totalDep = initial + monthly * Double(totalMonths)
        let taxPaid = totalGrossInterest * (taxRate / 100)
        return (balance, totalDep, totalGrossInterest, taxPaid)
    }

    private var depositSection: some View {
        let initial = Double(depositAmount) ?? 0
        let annual = Double(depositRate) ?? 0
        let termVal = Double(depositTerm) ?? 0
        let months = depositTermUnit == "years" ? termVal * 12 : termVal
        let monthly = Double(monthlyContribution) ?? 0
        let totalMonths = Int(months)

        let result = simulateDeposit(initial: initial, annualRate: annual, totalMonths: totalMonths, monthly: monthly)
        let finalAmt = result.final
        let totalDep = result.totalDep
        let interest = result.interest

        return VStack(spacing: 14) {
            financeField(L.initialDeposit, prefix: "$", text: $depositAmount, focus: .depAmt)

            HStack(spacing: 10) {
                financeField(L.annualRate, suffix: "%", text: $depositRate, focus: .depRate)
                termField(text: $depositTerm, unit: $depositTermUnit, focus: .depTerm)
            }

            financeField(L.monthlyContribution, prefix: "$", text: $monthlyContribution, focus: .depContrib)

            // Capitalization frequency
            VStack(alignment: .leading, spacing: 8) {
                Text(L.capitalization)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 6) {
                    ForEach(["monthly", "quarterly", "semiannual", "annual"], id: \.self) { cap in
                        let labels = ["monthly": L.monthly, "quarterly": L.quarter, "semiannual": L.semiAnnual, "annual": L.annual]
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) { capitalization = cap }
                        } label: {
                            Text(labels[cap] ?? cap)
                                .font(.custom("JetBrainsMono-SemiBold", size: 12))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(capitalization == cap ? T.accent : .clear)
                                .foregroundStyle(capitalization == cap ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(capitalization == cap ? T.accent : T.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            if finalAmt > 0 && termVal > 0 {
                VStack(spacing: 0) {
                    Text(L.finalAmount)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .opacity(0.85)

                    Text(fmtCurrency(finalAmt))
                        .font(.custom("JetBrainsMono-SemiBold", size: 40))
                        .tracking(-1)
                        .padding(.top, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Text("\(capLabel) \(L.capitaliz)")
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .opacity(0.7)
                        .padding(.top, 2)

                    Rectangle().fill(.white.opacity(0.3)).frame(height: 1)
                        .padding(.vertical, 14)

                    summaryRow(L.totalDeposited, fmtCurrency(totalDep))
                        .padding(.bottom, 6)
                    summaryRow(L.interestEarned, fmtCurrency(interest))
                    if annual > 0 {
                        summaryRow(L.effectiveRate, String(format: "%.2f%%", (finalAmt / totalDep - 1) * 100 / max(1, Double(totalMonths) / 12)))
                            .padding(.top, 6)
                    }

                    if finalAmt > 0 {
                        let depFrac = CGFloat(totalDep / finalAmt)
                        let interestPct = Int((1 - depFrac) * 100)
                        VStack(spacing: 6) {
                            GeometryReader { geo in
                                HStack(spacing: 2) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white.opacity(0.4))
                                        .frame(width: geo.size.width * depFrac)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white)
                                }
                            }
                            .frame(height: 8)

                            HStack {
                                HStack(spacing: 4) {
                                    Circle().fill(.white.opacity(0.4)).frame(width: 6, height: 6)
                                    Text("\(L.deposited) \(100 - interestPct)%")
                                        .font(.custom("JetBrainsMono-Regular", size: 10))
                                }
                                Spacer()
                                HStack(spacing: 4) {
                                    Circle().fill(.white).frame(width: 6, height: 6)
                                    Text("\(L.interest) \(interestPct)%")
                                        .font(.custom("JetBrainsMono-Regular", size: 10))
                                }
                            }
                            .opacity(0.85)
                        }
                        .padding(.top, 14)
                    }
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.success)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Growth breakdown
                if totalMonths > 0 && totalMonths <= 600 {
                    depositBreakdown(initial: initial, annualRate: annual, contribution: monthly, totalMonths: totalMonths)
                }
            }
        }
    }

    // MARK: - Loan Schedule

    private struct MonthRow: Identifiable {
        let id: Int
        let month: Int
        let interest: Double
        let principal: Double
        let remaining: Double
    }

    private struct YearGroup: Identifiable {
        let id: Int
        let year: Int
        let totalInterest: Double
        let totalPrincipal: Double
        let remaining: Double
        let months: [MonthRow]
    }

    private func buildSchedule(principal: Double, monthlyRate: Double, payment: Double, totalMonths: Int) -> [YearGroup] {
        var balance = principal
        var allMonths: [MonthRow] = []

        for m in 1...totalMonths {
            let intPart = balance * monthlyRate
            let prinPart = min(payment - intPart, balance)
            balance = max(0, balance - prinPart)
            allMonths.append(MonthRow(id: m, month: m, interest: intPart, principal: prinPart, remaining: balance))
        }

        let years = min(totalMonths / 12 + (totalMonths % 12 > 0 ? 1 : 0), 50)
        var groups: [YearGroup] = []
        for y in 1...years {
            let start = (y - 1) * 12
            let end = min(y * 12, totalMonths)
            guard start < end else { break }
            let slice = Array(allMonths[start..<end])
            let tInt = slice.reduce(0) { $0 + $1.interest }
            let tPrin = slice.reduce(0) { $0 + $1.principal }
            groups.append(YearGroup(id: y, year: y, totalInterest: tInt, totalPrincipal: tPrin, remaining: slice.last?.remaining ?? 0, months: slice))
        }
        return groups
    }

    private func loanSchedule(principal: Double, monthlyRate: Double, payment: Double, totalMonths: Int) -> some View {
        let groups = buildSchedule(principal: principal, monthlyRate: monthlyRate, payment: payment, totalMonths: totalMonths)

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(L.paymentSchedule)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                Spacer()

                Picker("", selection: $loanViewMode) {
                    Text(L.monthly).tag("monthly")
                    Text(L.yearly).tag("yearly")
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
            }
            .padding(.horizontal, 4)

            if loanViewMode == "yearly" {
                VStack(spacing: 0) {
                    ForEach(Array(groups.enumerated()), id: \.element.id) { i, group in
                        yearRow(group)
                        if i < groups.count - 1 {
                            Divider().padding(.leading, 14)
                        }
                    }
                }
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            } else {
                VStack(spacing: 6) {
                    ForEach(groups) { group in
                        monthlyGroup(group)
                    }
                }
            }
        }
    }

    private func yearRow(_ group: YearGroup) -> some View {
        HStack {
            Text("\(L.year) \(group.year)")
                .font(.custom("JetBrainsMono-SemiBold", size: 13))
                .foregroundStyle(T.text)
                .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 1) {
                Text("\(L.interest): \(fmtShort(group.totalInterest))")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.red)
                Text("\(L.principal): \(fmtShort(group.totalPrincipal))")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.success)
            }

            Spacer()

            Text(fmtShort(group.remaining))
                .font(.custom("JetBrainsMono-Medium", size: 13))
                .foregroundStyle(T.textMuted)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func monthlyGroup(_ group: YearGroup) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandedYear = expandedYear == group.year ? nil : group.year
                }
            } label: {
                HStack {
                    Text("\(L.year) \(group.year)")
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                        .foregroundStyle(T.text)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(L.interest): \(fmtShort(group.totalInterest))  \(L.principal): \(fmtShort(group.totalPrincipal))")
                            .font(.custom("JetBrainsMono-Regular", size: 11))
                            .foregroundStyle(T.textMuted)
                    }

                    Image(systemName: expandedYear == group.year ? "chevron.up" : "chevron.down")
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(T.textMuted)
                        .padding(.leading, 4)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(T.surfaceAlt)
            }
            .buttonStyle(.plain)

            if expandedYear == group.year {
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 0) {
                        Text("#")
                            .frame(width: 32, alignment: .leading)
                        Text(L.interest)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(L.principal)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(L.balance)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.custom("JetBrainsMono-SemiBold", size: 10))
                    .foregroundStyle(T.textMuted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)

                    ForEach(group.months) { row in
                        HStack(spacing: 0) {
                            Text("\(row.month)")
                                .frame(width: 32, alignment: .leading)
                                .foregroundStyle(T.textMuted)
                            Text(fmtShort(row.interest))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(T.red)
                            Text(fmtShort(row.principal))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(T.success)
                            Text(fmtShort(row.remaining))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(T.text)
                        }
                        .font(.custom("JetBrainsMono-Medium", size: 11))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)

                        if row.month != group.months.last?.month {
                            Divider().padding(.leading, 14)
                        }
                    }
                }
                .background(T.surface)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
    }

    // MARK: - Deposit Year Breakdown

    private func depositBreakdown(initial: Double, annualRate: Double, contribution: Double, totalMonths: Int) -> some View {
        let years = min(totalMonths / 12 + (totalMonths % 12 > 0 ? 1 : 0), 50)
        let capFreq = capPeriodsPerYear
        let monthsPerCap = 12 / capFreq
        var balance = initial
        var rows: [(year: Int, deposited: Double, interest: Double, capitalized: Double, total: Double)] = []

        for y in 1...years {
            let monthsInYear = min(12, totalMonths - (y - 1) * 12)
            guard monthsInYear > 0 else { break }
            var yInterest = 0.0
            var yCap = 0.0
            var accrued = 0.0
            let startMonth = (y - 1) * 12

            for mi in 0..<monthsInYear {
                let globalMonth = startMonth + mi + 1
                balance += contribution
                accrued += balance * (annualRate / 100 / 12)

                if globalMonth % monthsPerCap == 0 || globalMonth == totalMonths {
                    balance += accrued
                    yCap += accrued
                    yInterest += accrued
                    accrued = 0
                }
            }
            if accrued > 0 {
                yInterest += accrued
            }
            rows.append((y, contribution * Double(monthsInYear), yInterest, yCap, balance))
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text(L.yearlyGrowth)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { i, row in
                    HStack {
                        Text("\(L.year) \(row.year)")
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .foregroundStyle(T.text)
                            .frame(width: 56, alignment: .leading)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(L.interest): +\(fmtShort(row.interest))")
                                .font(.custom("JetBrainsMono-Regular", size: 11))
                                .foregroundStyle(T.success)
                            if row.deposited > 0 {
                                Text("\(L.added): +\(fmtShort(row.deposited))")
                                    .font(.custom("JetBrainsMono-Regular", size: 11))
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
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
            Text(L.term)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
                    Text(L.mo).tag("months")
                    Text(L.yr).tag("years")
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
            Text(label).font(.custom("JetBrainsMono-Regular", size: 13)).opacity(0.85)
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
