import SwiftUI

// MARK: - Chart Period

enum ChartPeriod: String, CaseIterable {
    case day         = "1D"
    case week        = "1W"
    case month       = "1M"
    case threeMonths = "3M"
    case sixMonths   = "6M"
    case year        = "1Y"
    case fiveYears   = "5Y"
    case tenYears    = "10Y"

    var days: Int {
        switch self {
        case .day:         return 1
        case .week:        return 7
        case .month:       return 30
        case .threeMonths: return 90
        case .sixMonths:   return 180
        case .year:        return 365
        case .fiveYears:   return 1825
        case .tenYears:    return 3650
        }
    }
}

// MARK: - Chart Point

private struct ChartPoint {
    let date: Date
    let price: Double
}

// MARK: - Detail View

struct CryptoDetailView: View {
    let crypto: Crypto
    let priceData: CryptoPrice

    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPeriod: ChartPeriod = .day
    @State private var chartData: [ChartPoint] = []
    @State private var isLoading = false
    @State private var loadError = false
    @State private var isFallback = false
    @State private var dragX: CGFloat? = nil
    @State private var dragIndex: Int? = nil

    private var displayPrice: Double {
        if let idx = dragIndex, idx < chartData.count { return chartData[idx].price }
        return priceData.price
    }

    private var displayDate: Date? {
        guard let idx = dragIndex, idx < chartData.count else { return nil }
        return chartData[idx].date
    }

    private var isPositive: Bool {
        guard let first = chartData.first else { return priceData.change24h >= 0 }
        return priceData.price >= first.price
    }

    private var chartColor: Color { isPositive ? T.success : T.red }

    private var periodChange: Double {
        guard let first = chartData.first, first.price > 0 else { return priceData.change24h }
        return ((priceData.price - first.price) / first.price) * 100
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    priceHeader
                        .padding(.horizontal, 20)

                    chartArea

                    if isFallback {
                        fallbackBanner
                    }

                    periodSelector
                        .padding(.horizontal, 20)

                    if !chartData.isEmpty {
                        statsGrid
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 36)
            }
            .background(T.bg.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Text(crypto.icon)
                            .font(.system(size: 18))
                        Text(crypto.name)
                            .font(.custom("JetBrainsMono-SemiBold", size: 15))
                            .foregroundStyle(T.text)
                        Text(crypto.symbol)
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                            .foregroundStyle(T.textMuted)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(T.textMuted)
                    }
                }
            }
            .task(id: selectedPeriod) {
                await loadChart()
            }
        }
    }

    // MARK: - Price Header

    private var priceHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                if let date = displayDate {
                    Text(formatDate(date))
                        .font(.custom("JetBrainsMono-Regular", size: 12))
                        .foregroundStyle(T.textMuted)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.15), value: dragIndex != nil)
                }
                Text(formatPrice(displayPrice))
                    .font(.custom("JetBrainsMono-Medium", size: 34))
                    .foregroundStyle(T.text)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.1), value: displayPrice)
            }

            Spacer()

            if dragIndex == nil {
                changeBadge(periodChange)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: dragIndex != nil)
    }

    private func changeBadge(_ change: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                .font(.system(size: 11, weight: .semibold))
            Text(String(format: "%.2f%%", abs(change)))
                .font(.custom("JetBrainsMono-SemiBold", size: 14))
        }
        .foregroundStyle(change >= 0 ? T.success : T.red)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background((change >= 0 ? T.success : T.red).opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Chart Area

    private var chartArea: some View {
        Group {
            if isLoading {
                loadingPlaceholder
            } else if chartData.isEmpty {
                emptyPlaceholder
            } else {
                interactiveChart
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isLoading)
        .animation(.easeInOut(duration: 0.25), value: chartData.isEmpty)
    }

    private var loadingPlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(T.surfaceAlt)
            .frame(height: 200)
            .overlay(ProgressView().tint(T.accent))
            .padding(.horizontal, 20)
    }

    private var emptyPlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(T.surfaceAlt)
            .frame(height: 200)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 28))
                        .foregroundStyle(T.textMuted)
                    Text(L.cryptoOffline)
                        .font(.custom("JetBrainsMono-Regular", size: 12))
                        .foregroundStyle(T.textMuted)
                    Button {
                        Task { await loadChart() }
                    } label: {
                        Text("Retry")
                            .font(.custom("JetBrainsMono-SemiBold", size: 12))
                            .foregroundStyle(T.accent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(T.accentSoft)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            )
            .padding(.horizontal, 20)
    }

    private var fallbackBanner: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 10))
            Text("Demo data · API rate limited")
                .font(.custom("JetBrainsMono-Regular", size: 11))
        }
        .foregroundStyle(T.yellow)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(T.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 20)
    }

    private var interactiveChart: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h: CGFloat = 200

            ZStack {
                // Gradient fill under the line
                fillPath(width: w, height: h)
                    .fill(
                        LinearGradient(
                            colors: [chartColor.opacity(0.28), chartColor.opacity(0)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )

                // Price line
                linePath(width: w, height: h)
                    .stroke(chartColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                // Crosshair
                if let dx = dragX, let idx = dragIndex {
                    let pt = pointAt(index: idx, width: w, height: h)

                    // Vertical dashed line
                    Path { p in
                        p.move(to: CGPoint(x: dx, y: 0))
                        p.addLine(to: CGPoint(x: dx, y: h))
                    }
                    .stroke(T.textMuted.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [5, 4]))

                    // Dot at data point
                    Circle()
                        .fill(chartColor)
                        .frame(width: 10, height: 10)
                        .shadow(color: chartColor.opacity(0.45), radius: 5)
                        .position(pt)
                }
            }
            .frame(height: h)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        let x = max(0, min(w, val.location.x))
                        let fraction = x / w
                        let count = chartData.count
                        let idx = max(0, min(count - 1, Int(fraction * Double(count - 1))))
                        dragX = x
                        dragIndex = idx
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.25)) {
                            dragX = nil
                            dragIndex = nil
                        }
                    }
            )
        }
        .frame(height: 200)
    }

    // MARK: - Chart Math

    private func yRange() -> (min: Double, max: Double) {
        let prices = chartData.map(\.price)
        let lo = prices.min() ?? 0
        let hi = prices.max() ?? 1
        return (lo, max(hi, lo + 1))
    }

    private func yFor(_ price: Double, height: CGFloat) -> CGFloat {
        let (lo, hi) = yRange()
        let pad: CGFloat = 16
        let norm = (price - lo) / (hi - lo)
        return height - pad - CGFloat(norm) * (height - 2 * pad)
    }

    private func linePath(width: CGFloat, height: CGFloat) -> Path {
        guard chartData.count > 1 else { return Path() }
        let step = width / CGFloat(chartData.count - 1)
        var path = Path()
        for (i, pt) in chartData.enumerated() {
            let x = CGFloat(i) * step
            let y = yFor(pt.price, height: height)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        return path
    }

    private func fillPath(width: CGFloat, height: CGFloat) -> Path {
        guard chartData.count > 1 else { return Path() }
        let step = width / CGFloat(chartData.count - 1)
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height))
        for (i, pt) in chartData.enumerated() {
            let x = CGFloat(i) * step
            let y = yFor(pt.price, height: height)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        return path
    }

    private func pointAt(index: Int, width: CGFloat, height: CGFloat) -> CGPoint {
        guard chartData.count > 1 else { return .zero }
        let x = CGFloat(index) * (width / CGFloat(chartData.count - 1))
        let y = yFor(chartData[index].price, height: height)
        return CGPoint(x: x, y: y)
    }

    // MARK: - Period Selector

    private var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(ChartPeriod.allCases, id: \.self) { period in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                        dragX = nil
                        dragIndex = nil
                        isFallback = false
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.custom("JetBrainsMono-SemiBold", size: 12))
                        .foregroundStyle(selectedPeriod == period ? T.accent : T.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? T.accentSoft : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(T.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        let prices = chartData.map(\.price)
        let periodHigh = prices.max() ?? priceData.price
        let periodLow  = prices.min() ?? priceData.price

        return VStack(spacing: 10) {
            HStack(spacing: 10) {
                statCard(label: L.cryptoHigh, value: formatPrice(periodHigh), accent: T.success)
                statCard(label: L.cryptoLow,  value: formatPrice(periodLow),  accent: T.red)
            }
            HStack(spacing: 10) {
                statCard(label: L.cryptoMarketCap, value: formatLarge(priceData.marketCap), accent: T.blue)
                statCard(label: L.cryptoVolume,    value: formatLarge(priceData.volume24h), accent: T.purple)
            }
        }
    }

    private func statCard(label: String, value: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 11))
                .foregroundStyle(T.textMuted)
            Text(value)
                .font(.custom("JetBrainsMono-SemiBold", size: 15))
                .foregroundStyle(T.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: TallyRadius.medium)
                .stroke(accent.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Data Loading

    private func loadChart() async {
        isLoading = true
        loadError = false
        isFallback = false
        chartData = []
        defer { isLoading = false }

        // Try Binance first (free, no key, 1200 req/min)
        if let symbol = crypto.binanceSymbol,
           let points = await fetchBinanceKlines(symbol: symbol) {
            chartData = points
            return
        }

        // Fallback: CoinGecko (rate-limited but covers all coins)
        if let points = await fetchCoinGeckoChart() {
            chartData = points
            return
        }

        // Last resort: demo curve from known price + 24h change
        useFallback()
    }

    private func fetchBinanceKlines(symbol: String) async -> [ChartPoint]? {
        let (interval, limit) = binanceParams(for: selectedPeriod)
        let urlStr = "https://api.binance.com/api/v3/klines?symbol=\(symbol)&interval=\(interval)&limit=\(limit)"
        guard let url = URL(string: urlStr) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            // Response: [[openTime, open, high, low, close, vol, closeTime, ...]]
            guard let json = try JSONSerialization.jsonObject(with: data) as? [[Any]], !json.isEmpty else { return nil }
            let points: [ChartPoint] = json.compactMap { candle in
                guard candle.count >= 7,
                      let closeTime = candle[6] as? Double,
                      let closeStr  = candle[4] as? String,
                      let close     = Double(closeStr)
                else { return nil }
                return ChartPoint(date: Date(timeIntervalSince1970: closeTime / 1000), price: close)
            }
            return points.isEmpty ? nil : points
        } catch { return nil }
    }

    private func fetchCoinGeckoChart() async -> [ChartPoint]? {
        let urlStr = "https://api.coingecko.com/api/v3/coins/\(crypto.id)/market_chart?vs_currency=usd&days=\(selectedPeriod.days)"
        guard let url = URL(string: urlStr) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            guard let json    = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let prices  = json["prices"] as? [[Double]], !prices.isEmpty
            else { return nil }
            let raw = prices.map { ChartPoint(date: Date(timeIntervalSince1970: $0[0] / 1000), price: $0[1]) }
            return subsample(raw, maxCount: 300)
        } catch { return nil }
    }

    // Binance kline interval + limit for each time period
    private func binanceParams(for period: ChartPeriod) -> (interval: String, limit: Int) {
        switch period {
        case .day:         return ("1h",  24)
        case .week:        return ("4h",  42)
        case .month:       return ("1d",  30)
        case .threeMonths: return ("1d",  90)
        case .sixMonths:   return ("1d", 180)
        case .year:        return ("1w",  52)
        case .fiveYears:   return ("1w", 260)
        case .tenYears:    return ("1M", 120)
        }
    }

    private func useFallback() {
        isFallback = true
        chartData = generateFallbackData()
    }

    // Generate a deterministic demo curve based on current price + 24h change
    private func generateFallbackData() -> [ChartPoint] {
        let price = priceData.price
        let change24h = priceData.change24h / 100
        let days = Double(selectedPeriod.days)
        let count = 120
        let now = Date()
        let intervalSecs = days * 86400 / Double(count)

        // Rough estimate of period return by scaling 24h change
        let periodReturn = change24h * sqrt(days)
        let startPrice = price / (1.0 + periodReturn)

        return (0..<count).map { i in
            let t = Double(i) / Double(count - 1)
            let trend = startPrice + (price - startPrice) * t
            // Add subtle sine waves to look like a real chart
            let amp = abs(price - startPrice) * 0.12
            let wave = sin(t * .pi * 5) * amp + sin(t * .pi * 13 + 0.8) * amp * 0.4
            let p = trend + wave
            return ChartPoint(
                date: now.addingTimeInterval(-intervalSecs * Double(count - i - 1)),
                price: max(p, price * 0.01)
            )
        }
    }

    private func subsample(_ points: [ChartPoint], maxCount: Int) -> [ChartPoint] {
        guard points.count > maxCount else { return points }
        let step = Double(points.count) / Double(maxCount)
        return (0..<maxCount).map { i in points[Int(Double(i) * step)] }
    }

    // MARK: - Formatting

    private func formatPrice(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.currencySymbol = "$"
        f.locale = Locale(identifier: "en_US")
        if value >= 1000      { f.maximumFractionDigits = 2; f.minimumFractionDigits = 2 }
        else if value >= 1    { f.maximumFractionDigits = 4; f.minimumFractionDigits = 2 }
        else if value > 0     { f.maximumFractionDigits = 6; f.minimumFractionDigits = 4 }
        return f.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func formatLarge(_ value: Double) -> String {
        if value == 0 { return "—" }
        if value >= 1_000_000_000_000 { return String(format: "$%.2fT", value / 1_000_000_000_000) }
        if value >= 1_000_000_000     { return String(format: "$%.2fB", value / 1_000_000_000) }
        if value >= 1_000_000         { return String(format: "$%.2fM", value / 1_000_000) }
        return String(format: "$%.0f", value)
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        switch selectedPeriod {
        case .day:          f.dateFormat = "HH:mm"
        case .week, .month: f.dateFormat = "MMM d, HH:mm"
        default:            f.dateFormat = "MMM d, yyyy"
        }
        return f.string(from: date)
    }
}
