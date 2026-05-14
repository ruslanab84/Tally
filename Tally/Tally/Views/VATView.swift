import SwiftUI

struct VATView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @FocusState private var focused: FocusField?

    @State private var amountText = "1000"
    @State private var inputMode = "excl"   // "excl" or "incl"
    @State private var selectedRate: Double = 20
    @State private var isCustomRate = false
    @State private var customRateText = ""

    enum FocusField { case amount, customRate }

    private let commonRates: [Double] = [5, 7, 10, 13, 18, 19, 20, 21, 25]
    private let comparisonRates: [Double] = [5, 7, 10, 12, 15, 18, 19, 20, 21, 23, 25]

    private var amount: Double { Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0 }
    private var activeRate: Double { isCustomRate ? (Double(customRateText.replacingOccurrences(of: ",", with: ".")) ?? 0) : selectedRate }
    private var exclVAT: Double { inputMode == "excl" ? amount : amount / (1 + activeRate / 100) }
    private var vatAmount: Double { exclVAT * activeRate / 100 }
    private var inclVAT: Double { exclVAT + vatAmount }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                amountCard
                rateChips
                resultCard
                comparisonTable
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "percent", "building.columns", "dollarsign.circle",
            "chart.bar", "doc.text", "creditcard",
        ]) }
        .navigationTitle(L.navVAT)
        .navigationBarTitleDisplayMode(.large)
        .onTapGesture { focused = nil }
    }

    // MARK: - Amount Card

    private var amountCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                modeButton(L.vatExcl, mode: "excl")
                modeButton(L.vatIncl, mode: "incl")
            }
            .background(T.surfaceAlt)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            TextField("1000", text: $amountText)
                .font(.custom("JetBrainsMono-Medium", size: 36))
                .foregroundStyle(T.text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .focused($focused, equals: .amount)
                .padding(.vertical, 4)
        }
        .padding(18)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    private func modeButton(_ label: String, mode: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { inputMode = mode }
        } label: {
            Text(label)
                .font(.custom("JetBrainsMono-SemiBold", size: 14))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(inputMode == mode ? T.accent : Color.clear)
                .foregroundStyle(inputMode == mode ? .white : T.textMuted)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Rate Chips

    private var rateChips: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L.vatRate)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(commonRates, id: \.self) { rate in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedRate = rate
                                isCustomRate = false
                                customRateText = ""
                                focused = nil
                            }
                        } label: {
                            Text("\(Int(rate))%")
                                .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(!isCustomRate && selectedRate == rate ? T.accentSoft : T.surface)
                                .foregroundStyle(!isCustomRate && selectedRate == rate ? T.accent : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }

                    // Custom rate chip
                    HStack(spacing: 4) {
                        TextField("0", text: $customRateText)
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .foregroundStyle(isCustomRate ? T.accent : T.textMuted)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 36)
                            .focused($focused, equals: .customRate)
                            .onChange(of: focused) { _, newVal in
                                if newVal == .customRate {
                                    withAnimation(.easeInOut(duration: 0.15)) { isCustomRate = true }
                                } else if newVal == nil && customRateText.isEmpty {
                                    withAnimation(.easeInOut(duration: 0.15)) { isCustomRate = false }
                                }
                            }
                        Text("%")
                            .font(.custom("JetBrainsMono-SemiBold", size: 13))
                            .foregroundStyle(isCustomRate ? T.accent : T.textMuted)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(isCustomRate ? T.accentSoft : T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 0) {
            resultRow(L.vatBase, value: exclVAT, highlight: inputMode == "excl")
            Divider().padding(.leading, 16)
            resultRow("\(L.vatTax) \(fmtRate(activeRate))%", value: vatAmount, highlight: false, accent: true)
            Divider().padding(.leading, 16)
            resultRow(L.vatTotal, value: inclVAT, highlight: inputMode == "incl")
        }
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    private func resultRow(_ label: String, value: Double, highlight: Bool, accent: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.custom(highlight ? "JetBrainsMono-SemiBold" : "JetBrainsMono-Regular", size: highlight ? 15 : 14))
                .foregroundStyle(accent ? T.success : (highlight ? T.text : T.textMuted))
            Spacer()
            Text(fmtCurrency(value))
                .font(.custom(highlight ? "JetBrainsMono-SemiBold" : "JetBrainsMono-Regular", size: highlight ? 22 : 17))
                .foregroundStyle(accent ? T.success : (highlight ? T.accent : T.text))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(highlight ? T.accentSoft.opacity(0.5) : Color.clear)
    }

    // MARK: - Comparison Table

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L.vatComparison)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                Spacer()
                Text("BASE: \(fmtCurrency(exclVAT))")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(comparisonRates.enumerated()), id: \.element) { i, rate in
                    let vat = exclVAT * rate / 100
                    let total = exclVAT + vat
                    let isActive = isCustomRate ? (rate == (Double(customRateText) ?? -1)) : (rate == selectedRate)

                    HStack {
                        Text("\(Int(rate))%")
                            .font(.custom("JetBrainsMono-SemiBold", size: 14))
                            .foregroundStyle(isActive ? T.accent : T.textMuted)
                            .frame(width: 40, alignment: .leading)

                        Spacer()

                        Text("+ \(fmtCurrency(vat))")
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .foregroundStyle(isActive ? T.text : T.textMuted)

                        Text(fmtCurrency(total))
                            .font(.custom("JetBrainsMono-SemiBold", size: 15))
                            .foregroundStyle(isActive ? T.accent : T.text)
                            .frame(minWidth: 90, alignment: .trailing)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(isActive ? T.accentSoft.opacity(0.6) : Color.clear)

                    if i < comparisonRates.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Formatting

    private func fmtCurrency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.groupingSeparator = ","
        return (f.string(from: NSNumber(value: value)) ?? "0.00")
    }

    private func fmtRate(_ rate: Double) -> String {
        rate.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(rate)) : String(rate)
    }
}

#Preview {
    NavigationStack {
        VATView()
    }
    .environment(\.tokens, .light)
}
