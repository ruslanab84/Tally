import SwiftUI

// MARK: - Favourites List

struct FavouritesView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    @Binding var loans: [FavouriteLoan]
    let onLoad: (FavouriteLoan) -> Void

    @State private var openItem: FavouriteLoan? = nil

    private let dateFmt: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .medium; return f
    }()

    var body: some View {
        NavigationStack {
            Group {
                if loans.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 44))
                            .foregroundStyle(T.textMuted)
                        Text(L.favEmpty)
                            .font(.custom("JetBrainsMono-Regular", size: 15))
                            .foregroundStyle(T.textMuted)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(T.bg)
                } else {
                    List {
                        ForEach(loans) { item in
                            Button { openItem = item } label: {
                                favRow(item)
                            }
                            .listRowBackground(T.surface)
                        }
                        .onDelete { offsets in
                            loans.remove(atOffsets: offsets)
                            persistFavouriteLoans(loans)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(T.bg)
                }
            }
            .navigationTitle(L.favFavourites)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L.done) { dismiss() }
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                        .foregroundStyle(T.accent)
                }
            }
        }
        .sheet(item: $openItem) { item in
            FavouriteDetailView(item: item, onLoad: {
                onLoad(item)
                dismiss()
            })
            .environment(\.tokens, T)
            .environment(\.loc, L)
        }
    }

    private func favRow(_ item: FavouriteLoan) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.kind == "loan" ? T.accentSoft : T.blue.opacity(0.12))
                    .frame(width: 38, height: 38)
                Image(systemName: item.kind == "loan" ? "banknote" : "house.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(item.kind == "loan" ? T.accent : T.blue)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    .foregroundStyle(T.text)
                Text(subtitle(item))
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(dateFmt.string(from: item.savedAt))
                    .font(.custom("JetBrainsMono-Regular", size: 10))
                    .foregroundStyle(T.textTertiary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(T.textTertiary)
            }
        }
        .padding(.vertical, 4)
    }

    private func subtitle(_ item: FavouriteLoan) -> String {
        item.kind == "loan"
            ? "$\(item.loanAmount) · \(item.loanRate)% · \(item.loanTerm) \(item.loanTermUnit)"
            : "$\(item.propPrice) · \(item.mortRate)% · \(item.mortTerm)yr"
    }
}

// MARK: - Favourite Detail (opens in new sheet)

struct FavouriteDetailView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    let item: FavouriteLoan
    let onLoad: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if item.kind == "loan" {
                        loanCard
                    } else {
                        mortgageCard
                    }

                    Button(action: onLoad) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 16))
                            Text(L.favLoad)
                                .font(.custom("JetBrainsMono-SemiBold", size: 16))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(T.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
            .background(T.bg)
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.cancel) { dismiss() }
                        .foregroundStyle(T.accent)
                }
            }
        }
    }

    // MARK: - Loan card

    private var loanCard: some View {
        let principal = Double(item.loanAmount) ?? 0
        let annual = Double(item.loanRate) ?? 0
        let termVal = Double(item.loanTerm) ?? 0
        let months = item.loanTermUnit == "years" ? termVal * 12 : termVal
        let mr = annual / 12 / 100

        let payment: Double
        let totalPaid: Double
        let totalInterest: Double

        if principal > 0 && mr > 0 && months > 0 {
            let f = pow(1 + mr, months)
            payment = principal * (mr * f) / (f - 1)
            totalPaid = payment * months
            totalInterest = totalPaid - principal
        } else {
            payment = 0; totalPaid = 0; totalInterest = 0
        }

        return detailCard(
            kind: "loan",
            bigValue: fmt(payment),
            bigLabel: L.monthlyPayment,
            rows: [
                (L.principal, fmt(principal)),
                (L.totalInterest, fmt(totalInterest)),
                (L.totalPaid, fmt(totalPaid)),
                (L.annualRate, "\(item.loanRate)%"),
                (L.term, "\(item.loanTerm) \(item.loanTermUnit)"),
                (L.paymentType, item.loanPaymentType == "annuity" ? L.annuity : L.diffPayment),
            ]
        )
    }

    // MARK: - Mortgage card

    private var mortgageCard: some View {
        let price = Double(item.propPrice) ?? 0
        let dp = Double(item.downPayment) ?? 0
        let loan = max(0, price - dp)
        let mr = (Double(item.mortRate) ?? 0) / 12 / 100
        let termMonths = (Double(item.mortTerm) ?? 30) * 12

        let payment: Double
        let totalPaid: Double
        let totalInterest: Double

        if loan > 0 && mr > 0 && termMonths > 0 {
            let f = pow(1 + mr, termMonths)
            payment = loan * (mr * f) / (f - 1)
            totalPaid = payment * termMonths
            totalInterest = max(0, totalPaid - loan)
        } else {
            payment = 0; totalPaid = 0; totalInterest = 0
        }

        return detailCard(
            kind: "mortgage",
            bigValue: fmt(payment),
            bigLabel: L.pAndI,
            rows: [
                (L.propPrice, fmt(price)),
                (L.downPayment, fmt(dp)),
                (L.principal, fmt(loan)),
                (L.totalInterest, fmt(totalInterest)),
                (L.totalPaid, fmt(totalPaid)),
                (L.annualRate, "\(item.mortRate)%"),
                (L.term, "\(item.mortTerm) \(L.yr)"),
                (L.paymentType, item.mortPaymentType == "annuity" ? L.annuity : L.diffPayment),
            ]
        )
    }

    @ViewBuilder
    private func detailCard(kind: String, bigValue: String, bigLabel: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: kind == "loan" ? "banknote" : "house.fill")
                    .font(.system(size: 13))
                    .opacity(0.75)
                Text(kind == "loan" ? L.loan : L.mortgage)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .opacity(0.85)
                Spacer()
            }

            Text(bigValue)
                .font(.custom("JetBrainsMono-SemiBold", size: 40))
                .tracking(-1)
                .padding(.top, 4)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(bigLabel)
                .font(.custom("JetBrainsMono-Regular", size: 12))
                .opacity(0.7)

            Rectangle().fill(.white.opacity(0.3)).frame(height: 1).padding(.vertical, 14)

            ForEach(Array(rows.enumerated()), id: \.offset) { i, row in
                HStack {
                    Text(row.0)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .opacity(0.85)
                    Spacer()
                    Text(row.1)
                        .font(.custom("JetBrainsMono-Medium", size: 14))
                }
                if i < rows.count - 1 {
                    Spacer().frame(height: 6)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(18)
        .background(T.accent)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    private func fmt(_ v: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: v)) ?? "$0.00"
    }
}
