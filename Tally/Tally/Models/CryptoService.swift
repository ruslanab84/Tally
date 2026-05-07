import Foundation

struct Crypto: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let icon: String

    static let all: [Crypto] = [
        Crypto(id: "bitcoin", symbol: "BTC", name: "Bitcoin", icon: "₿"),
        Crypto(id: "ethereum", symbol: "ETH", name: "Ethereum", icon: "Ξ"),
        Crypto(id: "tether", symbol: "USDT", name: "Tether", icon: "₮"),
        Crypto(id: "binancecoin", symbol: "BNB", name: "BNB", icon: "⬡"),
        Crypto(id: "solana", symbol: "SOL", name: "Solana", icon: "◎"),
        Crypto(id: "ripple", symbol: "XRP", name: "XRP", icon: "✕"),
        Crypto(id: "usd-coin", symbol: "USDC", name: "USD Coin", icon: "$"),
        Crypto(id: "cardano", symbol: "ADA", name: "Cardano", icon: "♦"),
        Crypto(id: "dogecoin", symbol: "DOGE", name: "Dogecoin", icon: "Ð"),
        Crypto(id: "avalanche-2", symbol: "AVAX", name: "Avalanche", icon: "▲"),
        Crypto(id: "polkadot", symbol: "DOT", name: "Polkadot", icon: "●"),
        Crypto(id: "tron", symbol: "TRX", name: "TRON", icon: "⬟"),
        Crypto(id: "chainlink", symbol: "LINK", name: "Chainlink", icon: "⬡"),
        Crypto(id: "matic-network", symbol: "MATIC", name: "Polygon", icon: "⬠"),
        Crypto(id: "litecoin", symbol: "LTC", name: "Litecoin", icon: "Ł"),
        Crypto(id: "bitcoin-cash", symbol: "BCH", name: "Bitcoin Cash", icon: "Ƀ"),
        Crypto(id: "stellar", symbol: "XLM", name: "Stellar", icon: "✦"),
        Crypto(id: "monero", symbol: "XMR", name: "Monero", icon: "ɱ"),
        Crypto(id: "cosmos", symbol: "ATOM", name: "Cosmos", icon: "⚛"),
        Crypto(id: "near", symbol: "NEAR", name: "NEAR", icon: "Ⓝ"),
    ]

    static let popular: [Crypto] = Array(all.prefix(10))
}

struct CryptoPrice {
    let price: Double
    let change24h: Double
    let marketCap: Double
    let volume24h: Double
}

@MainActor
@Observable
class CryptoService {
    var prices: [String: CryptoPrice] = [:]
    var lastUpdated: Date?
    var isLoading = false
    var isOffline = false

    private let cacheKey = "tally_crypto_prices"
    private let cacheTimestampKey = "tally_crypto_timestamp"

    init() {
        loadCachedPrices()
    }

    func fetchPrices() async {
        isLoading = true
        defer { isLoading = false }

        let ids = Crypto.all.map(\.id).joined(separator: ",")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(ids)&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true"

        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: [String: Double]] ?? [:]

            var newPrices: [String: CryptoPrice] = [:]
            for (id, values) in json {
                newPrices[id] = CryptoPrice(
                    price: values["usd"] ?? 0,
                    change24h: values["usd_24h_change"] ?? 0,
                    marketCap: values["usd_market_cap"] ?? 0,
                    volume24h: values["usd_24h_vol"] ?? 0
                )
            }
            prices = newPrices
            lastUpdated = Date()
            isOffline = false
            saveCachedPrices()
        } catch {
            isOffline = true
            if prices.isEmpty { loadFallbackPrices() }
        }
    }

    func priceFor(_ id: String) -> CryptoPrice {
        prices[id] ?? CryptoPrice(price: 0, change24h: 0, marketCap: 0, volume24h: 0)
    }

    var lastUpdatedText: String {
        guard let date = lastUpdated else { return "—" }
        let seconds = Int(-date.timeIntervalSinceNow)
        if seconds < 60 { return "just now" }
        if seconds < 3600 { return "\(seconds / 60)m ago" }
        if seconds < 86400 { return "\(seconds / 3600)h ago" }
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
    }

    // MARK: - Cache

    private func saveCachedPrices() {
        var dict: [String: [String: Double]] = [:]
        for (id, p) in prices {
            dict[id] = ["price": p.price, "change": p.change24h, "cap": p.marketCap, "vol": p.volume24h]
        }
        if let data = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(data, forKey: cacheKey)
            UserDefaults.standard.set(lastUpdated, forKey: cacheTimestampKey)
        }
    }

    private func loadCachedPrices() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let dict = try? JSONDecoder().decode([String: [String: Double]].self, from: data)
        else {
            loadFallbackPrices()
            return
        }
        for (id, v) in dict {
            prices[id] = CryptoPrice(price: v["price"] ?? 0, change24h: v["change"] ?? 0, marketCap: v["cap"] ?? 0, volume24h: v["vol"] ?? 0)
        }
        lastUpdated = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date
        isOffline = true
    }

    private func loadFallbackPrices() {
        let fallback: [(String, Double, Double)] = [
            ("bitcoin", 103000, 1.2), ("ethereum", 2450, -0.8), ("tether", 1.0, 0.01),
            ("binancecoin", 650, 0.5), ("solana", 170, 2.1), ("ripple", 2.35, -1.3),
            ("usd-coin", 1.0, 0.0), ("cardano", 0.78, 1.8), ("dogecoin", 0.22, 3.5),
            ("avalanche-2", 24, -2.1), ("polkadot", 4.8, 0.9), ("tron", 0.27, 0.4),
            ("chainlink", 16, 1.1), ("matic-network", 0.42, -0.6), ("litecoin", 97, 0.3),
            ("bitcoin-cash", 420, 1.5), ("stellar", 0.11, -0.2), ("monero", 195, 0.7),
            ("cosmos", 5.6, -1.0), ("near", 3.2, 2.3),
        ]
        for (id, price, change) in fallback {
            prices[id] = CryptoPrice(price: price, change24h: change, marketCap: 0, volume24h: 0)
        }
        isOffline = true
    }
}
