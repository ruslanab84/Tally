import SwiftUI

struct CryptoView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var service = CryptoService()
    @State private var amount = "1"
    @State private var selectedCrypto = Crypto.all[0]
    @State private var showAll = false

    private var numericAmount: Double {
        Double(amount) ?? 1
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                converterCard
                statusBar
                priceList
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "bitcoinsign.circle", "chart.line.uptrend.xyaxis",
            "arrow.triangle.2.circlepath", "dollarsign",
            "chart.bar", "network", "bolt", "globe",
        ]) }
        .navigationTitle(L.navCrypto)
        .navigationBarTitleDisplayMode(.large)
        .task { await service.fetchPrices() }
    }

    // MARK: - Converter

    private var converterCard: some View {
        let price = service.priceFor(selectedCrypto.id)
        let usdValue = numericAmount * price.price

        return VStack(spacing: 14) {
            HStack {
                Text(L.cryptoConverter)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                Spacer()
            }

            HStack(spacing: 10) {
                VStack(spacing: 6) {
                    Text(L.cryptoAmount)
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(T.textMuted)
                    TextField("1", text: $amount)
                        .font(.custom("JetBrainsMono-Medium", size: 28))
                        .foregroundStyle(T.text)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(T.surfaceAlt)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Image(systemName: "arrow.right")
                    .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    .foregroundStyle(T.accent)

                VStack(spacing: 6) {
                    Text("USD")
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(T.textMuted)
                    Text(formatUSD(usdValue))
                        .font(.custom("JetBrainsMono-Medium", size: 22))
                        .foregroundStyle(T.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(T.surfaceAlt)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Crypto.popular) { crypto in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedCrypto = crypto
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(crypto.icon)
                                    .font(.custom("JetBrainsMono-Regular", size: 14))
                                Text(crypto.symbol)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 12))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selectedCrypto.id == crypto.id ? T.accentSoft : T.surfaceAlt)
                            .foregroundStyle(selectedCrypto.id == crypto.id ? T.accent : T.text)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(18)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    // MARK: - Status

    private var statusBar: some View {
        HStack {
            if service.isLoading {
                ProgressView()
                    .scaleEffect(0.7)
                Text(L.cryptoLoading)
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
            } else if service.isOffline {
                Image(systemName: "wifi.slash")
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.red)
                Text(L.cryptoOffline)
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
            }
            Spacer()
            Text("\(L.cryptoUpdated): \(service.lastUpdatedText)")
                .font(.custom("JetBrainsMono-Regular", size: 11))
                .foregroundStyle(T.textMuted)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Price List

    private var priceList: some View {
        let cryptos = showAll ? Crypto.all : Crypto.popular

        return VStack(spacing: 0) {
            HStack {
                Text(L.cryptoPrices)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { showAll.toggle() }
                } label: {
                    Text(showAll ? L.cryptoShowLess : L.cryptoShowAll)
                        .font(.custom("JetBrainsMono-Medium", size: 11))
                        .foregroundStyle(T.accent)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(cryptos.enumerated()), id: \.element.id) { i, crypto in
                    let price = service.priceFor(crypto.id)
                    let isUp = price.change24h >= 0

                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedCrypto = crypto
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Text(crypto.icon)
                                .font(.custom("JetBrainsMono-Regular", size: 24))
                                .frame(width: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(crypto.name)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                                    .foregroundStyle(T.text)
                                Text(crypto.symbol)
                                    .font(.custom("JetBrainsMono-Regular", size: 11))
                                    .foregroundStyle(T.textMuted)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(formatUSD(price.price))
                                    .font(.custom("JetBrainsMono-Medium", size: 15))
                                    .foregroundStyle(T.text)

                                HStack(spacing: 3) {
                                    Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                                        .font(.custom("JetBrainsMono-Medium", size: 10))
                                    Text(String(format: "%.2f%%", abs(price.change24h)))
                                        .font(.custom("JetBrainsMono-Medium", size: 12))
                                }
                                .foregroundStyle(isUp ? T.success : T.red)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(selectedCrypto.id == crypto.id ? T.accentSoft : .clear)
                    }
                    .buttonStyle(.plain)

                    if i < cryptos.count - 1 {
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Formatting

    private func formatUSD(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "$%,.2f", value)
        } else if value >= 1 {
            return String(format: "$%.2f", value)
        } else if value > 0 {
            return String(format: "$%.4f", value)
        }
        return "$0.00"
    }
}

#Preview {
    NavigationStack {
        CryptoView()
    }
    .environment(\.tokens, .light)
}
