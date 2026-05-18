import SwiftUI

struct InflationView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @FocusState private var amountFocused: Bool
    @EnvironmentObject var historyStore: HistoryStore

    @State private var amountText = "1000"
    @State private var fromYear = 2000
    @State private var toYear = min(Calendar.current.component(.year, from: Date()), 2024)
    @State private var showFromPicker = false
    @State private var showToPicker = false

    private let presets = [1950, 1960, 1970, 1980, 1990, 2000, 2005, 2010, 2015, 2020]

    private var amount: Double { Double(amountText) ?? 0 }
    private var fromCPI: Double? { Self.cpiData[fromYear] }
    private var toCPI:   Double? { Self.cpiData[toYear]   }

    private var result: Double? {
        guard amount > 0, let f = fromCPI, let t = toCPI, f > 0 else { return nil }
        return amount * t / f
    }

    private var totalInflation: Double? {
        guard let f = fromCPI, let t = toCPI, f > 0 else { return nil }
        return (t / f - 1) * 100
    }

    private var annualRate: Double? {
        guard let f = fromCPI, let t = toCPI, f > 0 else { return nil }
        let n = Double(toYear - fromYear)
        guard n != 0 else { return 0 }
        return (pow(t / f, 1.0 / n) - 1) * 100
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                amountCard
                yearSelectors
                if let res = result {
                    resultCard(res)
                    powerCard
                }
                presetSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background {
            TallyBackground(T: T, icons: [
                "dollarsign.circle", "percent", "chart.line.uptrend.xyaxis",
                "calendar", "arrow.up.forward.circle", "banknote",
                "cart", "house", "fuelpump",
            ])
        }
        .navigationTitle(L.navInflation)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L.done) { amountFocused = false }
            }
        }
        .onDisappear {
            guard let res = result else { return }
            historyStore.add(
                expression: "$\(amountText) (\(fromYear) → \(toYear))",
                result: fmtCurrency(res),
                type: .inflation
            )
        }
        .sheet(isPresented: $showFromPicker) {
            yearSheet(
                selection: $fromYear,
                title: L.inflationFromYear,
                years: Self.cpiData.keys.sorted().filter { $0 < toYear }
            )
        }
        .sheet(isPresented: $showToPicker) {
            yearSheet(
                selection: $toYear,
                title: L.inflationToYear,
                years: Self.cpiData.keys.sorted().filter { $0 > fromYear }
            )
        }
    }

    // MARK: - Amount Card

    private var amountCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L.inflationAmount)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
            HStack(spacing: 6) {
                Text("$")
                    .font(.custom("JetBrainsMono-Medium", size: 26))
                    .foregroundStyle(T.textMuted)
                TextField("1000", text: $amountText)
                    .font(.custom("JetBrainsMono-Medium", size: 34))
                    .foregroundStyle(T.text)
                    .keyboardType(.decimalPad)
                    .focused($amountFocused)
            }
        }
        .padding(18)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    // MARK: - Year Selectors

    private var yearSelectors: some View {
        HStack(spacing: 12) {
            yearButton(year: fromYear, label: L.inflationFromYear) { showFromPicker = true }

            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(T.accent)

            yearButton(year: toYear, label: L.inflationToYear) { showToPicker = true }
        }
    }

    private func yearButton(year: Int, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.custom("JetBrainsMono-Regular", size: 10))
                    .foregroundStyle(T.textMuted)
                    .tracking(0.5)
                Text(String(year))
                    .font(.custom("JetBrainsMono-SemiBold", size: 30))
                    .foregroundStyle(T.text)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.15), value: year)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Result Card

    private func resultCard(_ res: Double) -> some View {
        let infl = totalInflation ?? 0
        let ann  = annualRate ?? 0
        let diff = abs(toYear - fromYear)

        return VStack(spacing: 0) {
            Text(L.inflationResult)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .opacity(0.85)

            Text(fmtCurrency(res))
                .font(.custom("JetBrainsMono-SemiBold", size: 42))
                .tracking(-1)
                .padding(.top, 4)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.2), value: res)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Rectangle().fill(.white.opacity(0.3)).frame(height: 1).padding(.vertical, 14)

            HStack(spacing: 0) {
                statPill(value: String(format: "%+.1f%%", infl),  label: L.inflationTotal)
                Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 40)
                statPill(value: String(format: "%+.2f%%", ann),   label: L.inflationAnnual)
                Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 40)
                statPill(value: "\(diff) \(L.yr)",                label: L.inflationPeriod)
            }
        }
        .foregroundStyle(.white)
        .padding(18)
        .background(T.accent)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    private func statPill(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.custom("JetBrainsMono-SemiBold", size: 15))
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 10))
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Purchasing Power Card

    @ViewBuilder
    private var powerCard: some View {
        if let f = fromCPI, let t = toCPI, f > 0, t > 0, fromYear != toYear {
            let ratio       = f / t          // fraction of purchasing power retained
            let dollarWorth = t / f          // $1 in fromYear = this many toYear dollars

            VStack(alignment: .leading, spacing: 12) {
                Text(L.inflationPower)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                GeometryReader { geo in
                    let barFrac = CGFloat(min(1.0, max(0.02, ratio)))
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(T.surfaceAlt)
                            .frame(height: 10)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ratio < 1 ? T.red : T.success)
                            .frame(width: geo.size.width * barFrac, height: 10)
                    }
                }
                .frame(height: 10)

                HStack {
                    Text("$1  (\(fromYear)) = \(fmtCurrency(dollarWorth))  (\(toYear))")
                        .font(.custom("JetBrainsMono-Medium", size: 13))
                        .foregroundStyle(T.text)
                    Spacer()
                    Text(String(format: "%.1f%%", ratio * 100))
                        .font(.custom("JetBrainsMono-SemiBold", size: 13))
                        .foregroundStyle(ratio < 1 ? T.red : T.success)
                }

                Text(L.inflationSource)
                    .font(.custom("JetBrainsMono-Regular", size: 10))
                    .foregroundStyle(T.textMuted)
            }
            .padding(16)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Quick Presets

    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L.inflationPresets)
                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets.filter { $0 < toYear }, id: \.self) { year in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) { fromYear = year }
                        } label: {
                            Text(String(year))
                                .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(fromYear == year ? T.accentSoft : T.surface)
                                .foregroundStyle(fromYear == year ? T.accent : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Year Picker Sheet

    private func yearSheet(selection: Binding<Int>, title: String, years: [Int]) -> some View {
        NavigationView {
            Picker("", selection: selection) {
                ForEach(years, id: \.self) { y in
                    Text(String(y)).tag(y)
                }
            }
            .pickerStyle(.wheel)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L.done) {
                        showFromPicker = false
                        showToPicker  = false
                    }
                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                }
            }
        }
    }

    // MARK: - Formatting

    private func fmtCurrency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.currencySymbol = "$"
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = value >= 100 ? 0 : 2
        f.minimumFractionDigits = value >= 100 ? 0 : 2
        return f.string(from: NSNumber(value: value)) ?? "$0"
    }

    // MARK: - US CPI-U Annual Average (BLS, base 1982-84 = 100)

    static let cpiData: [Int: Double] = [
        1913: 9.9,   1914: 10.0,  1915: 10.1,  1916: 10.9,  1917: 12.8,  1918: 15.1,
        1919: 17.3,  1920: 20.0,  1921: 17.9,  1922: 16.8,  1923: 17.1,  1924: 17.1,
        1925: 17.5,  1926: 17.7,  1927: 17.4,  1928: 17.1,  1929: 17.1,  1930: 16.7,
        1931: 15.2,  1932: 13.7,  1933: 13.0,  1934: 13.4,  1935: 13.7,  1936: 13.9,
        1937: 14.4,  1938: 14.1,  1939: 13.9,  1940: 14.0,  1941: 14.7,  1942: 16.3,
        1943: 17.3,  1944: 17.6,  1945: 18.0,  1946: 19.5,  1947: 22.3,  1948: 24.1,
        1949: 23.8,  1950: 24.1,  1951: 26.0,  1952: 26.5,  1953: 26.7,  1954: 26.9,
        1955: 26.8,  1956: 27.2,  1957: 28.1,  1958: 28.9,  1959: 29.1,  1960: 29.6,
        1961: 29.9,  1962: 30.2,  1963: 30.6,  1964: 31.0,  1965: 31.5,  1966: 32.4,
        1967: 33.4,  1968: 34.8,  1969: 36.7,  1970: 38.8,  1971: 40.5,  1972: 41.8,
        1973: 44.4,  1974: 49.3,  1975: 53.8,  1976: 56.9,  1977: 60.6,  1978: 65.2,
        1979: 72.6,  1980: 82.4,  1981: 90.9,  1982: 96.5,  1983: 99.6,  1984: 103.9,
        1985: 107.6, 1986: 109.6, 1987: 113.6, 1988: 118.3, 1989: 124.0, 1990: 130.7,
        1991: 136.2, 1992: 140.3, 1993: 144.5, 1994: 148.2, 1995: 152.4, 1996: 156.9,
        1997: 160.5, 1998: 163.0, 1999: 166.6, 2000: 172.2, 2001: 177.1, 2002: 179.9,
        2003: 184.0, 2004: 188.9, 2005: 195.3, 2006: 201.6, 2007: 207.3, 2008: 215.3,
        2009: 214.5, 2010: 218.1, 2011: 224.9, 2012: 229.6, 2013: 233.0, 2014: 236.7,
        2015: 237.0, 2016: 240.0, 2017: 245.1, 2018: 251.1, 2019: 255.7, 2020: 258.8,
        2021: 270.9, 2022: 292.7, 2023: 304.7, 2024: 314.2,
    ]
}

#Preview {
    NavigationView {
        InflationView()
    }
    .environment(\.tokens, .light)
    .environmentObject(HistoryStore())
}
