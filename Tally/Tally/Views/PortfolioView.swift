import SwiftUI

// MARK: - Portfolio Tab

struct PortfolioView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    let store: PortfolioStore
    let service: CryptoService
    @State private var showAdd = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if store.holdings.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 14) {
                        summaryCard
                        holdingsList
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 90)
                    .padding(.top, 4)
                }
            }

            // Floating add button
            Button { showAdd = true } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                    Text(L.portfolioAdd)
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 13)
                .background(T.accent)
                .clipShape(Capsule())
                .shadow(color: T.accent.opacity(0.35), radius: 10, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showAdd) {
            AddHoldingSheet(store: store, service: service)
                .environment(\.tokens, T)
                .environment(\.loc, L)
        }
    }

    // MARK: - Summary Card

    private var summaryCard: some View {
        let invested = store.totalInvested()
        let value    = store.totalValue(prices: service.prices)
        let pnl      = store.totalPnL(prices: service.prices)
        let pnlPct   = invested > 0 ? (pnl / invested) * 100 : 0
        let isUp     = pnl >= 0

        return VStack(spacing: 0) {
            // Header
            HStack {
                Text(L.cryptoPortfolio.uppercased())
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                Spacer()
                Text("\(store.holdings.count) coins")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
            }
            .padding(.bottom, 12)

            // Total value
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(formatUSD(value))
                    .font(.custom("JetBrainsMono-Medium", size: 30))
                    .foregroundStyle(T.text)
                Spacer()
            }

            // P&L row
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 11, weight: .semibold))
                    Text((isUp ? "+" : "") + formatUSD(pnl))
                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    Text(String(format: "(%+.2f%%)", pnlPct))
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                }
                .foregroundStyle(isUp ? T.success : T.red)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background((isUp ? T.success : T.red).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Spacer()

                VStack(alignment: .trailing, spacing: 1) {
                    Text(L.portfolioInvested)
                        .font(.custom("JetBrainsMono-Regular", size: 10))
                        .foregroundStyle(T.textMuted)
                    Text(formatUSD(invested))
                        .font(.custom("JetBrainsMono-Medium", size: 13))
                        .foregroundStyle(T.textMuted)
                }
            }
            .padding(.top, 8)
        }
        .padding(18)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    // MARK: - Holdings List

    private var holdingsList: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L.portfolioHoldings.uppercased())
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(store.holdings.enumerated()), id: \.element.id) { i, holding in
                    holdingRow(holding)
                    if i < store.holdings.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    private func holdingRow(_ holding: PortfolioHolding) -> some View {
        let crypto       = Crypto.all.first { $0.id == holding.cryptoId } ?? Crypto.all[0]
        let currentPrice = service.priceFor(holding.cryptoId).price
        let effectivePrice = currentPrice > 0 ? currentPrice : holding.purchasePrice
        let pnl          = holding.pnl(price: effectivePrice)
        let pnlPct       = holding.pnlPct(price: effectivePrice)
        let value        = holding.currentValue(price: effectivePrice)
        let isUp         = pnl >= 0

        return HStack(spacing: 12) {
            // Coin icon
            Text(crypto.icon)
                .font(.system(size: 26))
                .frame(width: 40)

            // Left: name + details
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(crypto.name)
                        .font(.custom("JetBrainsMono-SemiBold", size: 15))
                        .foregroundStyle(T.text)
                    Text(formatAmount(holding.amount) + " " + crypto.symbol)
                        .font(.custom("JetBrainsMono-Regular", size: 12))
                        .foregroundStyle(T.textMuted)
                }
                Text(formatUSD(holding.purchasePrice) + "/" + crypto.symbol)
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textTertiary)
                Text(formatDate(holding.purchaseDate))
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textTertiary)
            }

            Spacer()

            // Right: value + P&L
            VStack(alignment: .trailing, spacing: 3) {
                Text(formatUSD(value))
                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                    .foregroundStyle(T.text)

                HStack(spacing: 3) {
                    Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .semibold))
                    Text((isUp ? "+" : "") + formatUSD(pnl))
                        .font(.custom("JetBrainsMono-Medium", size: 12))
                }
                .foregroundStyle(isUp ? T.success : T.red)

                Text(String(format: "%+.2f%%", pnlPct))
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(isUp ? T.success : T.red)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                if let idx = store.holdings.firstIndex(where: { $0.id == holding.id }) {
                    store.remove(at: IndexSet(integer: idx))
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "chart.pie.fill")
                .font(.system(size: 52))
                .foregroundStyle(T.accent.opacity(0.4))
            Text(L.portfolioEmpty)
                .font(.custom("JetBrainsMono-Medium", size: 15))
                .foregroundStyle(T.textMuted)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    // MARK: - Formatting

    private func formatUSD(_ v: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency; f.currencyCode = "USD"; f.currencySymbol = "$"
        f.locale = Locale(identifier: "en_US")
        if abs(v) >= 1    { f.maximumFractionDigits = 2; f.minimumFractionDigits = 2 }
        else if abs(v) > 0 { f.maximumFractionDigits = 6; f.minimumFractionDigits = 4 }
        return f.string(from: NSNumber(value: v)) ?? "$0.00"
    }

    private func formatAmount(_ v: Double) -> String {
        if v >= 1    { return String(format: v.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.4g", v) }
        return String(format: "%.8g", v)
    }

    private func formatDate(_ d: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium; f.timeStyle = .none
        return f.string(from: d)
    }
}

// MARK: - Add Holding Sheet

struct AddHoldingSheet: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    let store: PortfolioStore
    let service: CryptoService

    @State private var selectedCrypto: Crypto = Crypto.all[0]
    @State private var amountText: String = ""
    @State private var priceText: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var showCoinPicker = false
    @FocusState private var focused: AddField?

    enum AddField { case amount, price }

    private var canAdd: Bool {
        (Double(amountText) ?? 0) > 0 && (Double(priceText) ?? 0) > 0
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Coin selector
                    fieldLabel(L.portfolioCoin)
                    Button { showCoinPicker = true } label: {
                        HStack(spacing: 10) {
                            Text(selectedCrypto.icon).font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(selectedCrypto.name)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                                    .foregroundStyle(T.text)
                                Text(selectedCrypto.symbol)
                                    .font(.custom("JetBrainsMono-Regular", size: 12))
                                    .foregroundStyle(T.textMuted)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(T.textMuted)
                        }
                        .padding(14)
                        .background(T.surface)
                        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
                    }
                    .buttonStyle(.plain)

                    // Amount
                    fieldLabel(L.portfolioAmount + " (\(selectedCrypto.symbol))")
                    HStack {
                        TextField("0.5", text: $amountText)
                            .font(.custom("JetBrainsMono-Medium", size: 22))
                            .foregroundStyle(T.text)
                            .keyboardType(.decimalPad)
                            .focused($focused, equals: .amount)
                        Spacer()
                        Text(selectedCrypto.symbol)
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                    }
                    .padding(14)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))

                    // Buy price
                    fieldLabel(L.portfolioBuyPrice + " (USD)")
                    HStack {
                        Text("$")
                            .font(.custom("JetBrainsMono-Regular", size: 18))
                            .foregroundStyle(T.textMuted)
                        TextField(currentPricePlaceholder, text: $priceText)
                            .font(.custom("JetBrainsMono-Medium", size: 22))
                            .foregroundStyle(T.text)
                            .keyboardType(.decimalPad)
                            .focused($focused, equals: .price)
                    }
                    .padding(14)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))

                    // Date
                    fieldLabel(L.portfolioDate)
                    DatePicker("", selection: $purchaseDate, in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(T.surface)
                        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))

                    // Live preview
                    if let amount = Double(amountText), let price = Double(priceText), amount > 0, price > 0 {
                        previewCard(amount: amount, price: price)
                    }

                    // Submit
                    Button {
                        guard let amount = Double(amountText), let price = Double(priceText) else { return }
                        store.add(PortfolioHolding(
                            cryptoId: selectedCrypto.id,
                            amount: amount,
                            purchasePrice: price,
                            purchaseDate: purchaseDate
                        ))
                        dismiss()
                    } label: {
                        Text(L.portfolioAdd)
                            .font(.custom("JetBrainsMono-SemiBold", size: 16))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(canAdd ? T.accent : T.textTertiary)
                            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                    }
                    .buttonStyle(.plain)
                    .disabled(!canAdd)
                    .padding(.top, 6)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
            .background(T.bg.ignoresSafeArea())
            .navigationTitle(L.portfolioAddTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
            .sheet(isPresented: $showCoinPicker) {
                PortfolioCoinPicker(selected: $selectedCrypto)
                    .environment(\.tokens, T)
                    .environment(\.loc, L)
            }
        }
        .onAppear {
            // Pre-fill with current price if available
            let price = service.priceFor(selectedCrypto.id).price
            if price > 0, priceText.isEmpty {
                priceText = formatPriceInput(price)
            }
        }
        .onChange(of: selectedCrypto) { _, crypto in
            let price = service.priceFor(crypto.id).price
            if price > 0 { priceText = formatPriceInput(price) }
        }
    }

    private var currentPricePlaceholder: String {
        let p = service.priceFor(selectedCrypto.id).price
        return p > 0 ? formatPriceInput(p) : "0"
    }

    private func previewCard(amount: Double, price: Double) -> some View {
        let currentPrice = service.priceFor(selectedCrypto.id).price
        let effectivePrice = currentPrice > 0 ? currentPrice : price
        let cost    = amount * price
        let value   = amount * effectivePrice
        let pnl     = value - cost
        let pnlPct  = ((effectivePrice - price) / price) * 100
        let isUp    = pnl >= 0

        return VStack(spacing: 10) {
            HStack {
                Text("PREVIEW")
                    .font(.custom("JetBrainsMono-SemiBold", size: 10))
                    .tracking(0.8)
                    .foregroundStyle(T.textMuted)
                Spacer()
            }

            HStack {
                statItem(title: L.portfolioCost, value: fmtUSD(cost), color: T.textMuted)
                Spacer()
                statItem(title: L.portfolioValue, value: fmtUSD(value), color: T.text)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("P&L")
                        .font(.custom("JetBrainsMono-Regular", size: 10))
                        .foregroundStyle(T.textMuted)
                    Text((isUp ? "+" : "") + fmtUSD(pnl))
                        .font(.custom("JetBrainsMono-SemiBold", size: 13))
                        .foregroundStyle(isUp ? T.success : T.red)
                    Text(String(format: "%+.2f%%", pnlPct))
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(isUp ? T.success : T.red)
                }
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

    private func statItem(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.custom("JetBrainsMono-Regular", size: 10))
                .foregroundStyle(T.textMuted)
            Text(value)
                .font(.custom("JetBrainsMono-SemiBold", size: 13))
                .foregroundStyle(color)
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.custom("JetBrainsMono-SemiBold", size: 11))
            .tracking(0.4)
            .foregroundStyle(T.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, -6)
    }

    private func formatPriceInput(_ v: Double) -> String {
        if v >= 1 { return String(format: "%.2f", v) }
        return String(format: "%.8g", v)
    }

    private func fmtUSD(_ v: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency; f.currencyCode = "USD"; f.currencySymbol = "$"
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 2; f.minimumFractionDigits = 2
        return f.string(from: NSNumber(value: v)) ?? "$0.00"
    }
}

// MARK: - Coin Picker

private struct PortfolioCoinPicker: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: Crypto
    @State private var query = ""

    private var filtered: [Crypto] {
        guard !query.isEmpty else { return Crypto.all }
        let q = query.lowercased()
        return Crypto.all.filter {
            $0.name.lowercased().contains(q) || $0.symbol.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationView {
            List(filtered) { crypto in
                Button {
                    selected = crypto
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Text(crypto.icon).font(.system(size: 22)).frame(width: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(crypto.name)
                                .font(.custom("JetBrainsMono-SemiBold", size: 15))
                                .foregroundStyle(T.text)
                            Text(crypto.symbol)
                                .font(.custom("JetBrainsMono-Regular", size: 12))
                                .foregroundStyle(T.textMuted)
                        }
                        Spacer()
                        if selected.id == crypto.id {
                            Image(systemName: "checkmark")
                                .foregroundStyle(T.accent)
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                }
                .buttonStyle(.plain)
                .listRowBackground(T.surface)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(T.bg)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(L.portfolioSelectCoin)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(T.textMuted)
                    }
                }
            }
        }
    }
}
