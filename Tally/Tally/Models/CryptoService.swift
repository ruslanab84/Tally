import Foundation

struct Crypto: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let icon: String

    // Binance USDT pair — nil means coin is not listed on Binance
    var binanceSymbol: String? { Crypto.binanceMap[id] }

    private static let binanceMap: [String: String] = [
        "bitcoin":            "BTCUSDT",
        "ethereum":           "ETHUSDT",
        "binancecoin":        "BNBUSDT",
        "solana":             "SOLUSDT",
        "ripple":             "XRPUSDT",
        "cardano":            "ADAUSDT",
        "dogecoin":           "DOGEUSDT",
        "tron":               "TRXUSDT",
        "avalanche-2":        "AVAXUSDT",
        "wrapped-bitcoin":    "WBTCUSDT",
        "chainlink":          "LINKUSDT",
        "the-open-network":   "TONUSDT",
        "sui":                "SUIUSDT",
        "polkadot":           "DOTUSDT",
        "stellar":            "XLMUSDT",
        "hedera-hashgraph":   "HBARUSDT",
        "bitcoin-cash":       "BCHUSDT",
        "hyperliquid":        "HYPEUSDT",
        "uniswap":            "UNIUSDT",
        "litecoin":           "LTCUSDT",
        "near":               "NEARUSDT",
        "matic-network":      "POLUSDT",
        "aptos":              "APTUSDT",
        "pepe":               "PEPEUSDT",
        "internet-computer":  "ICPUSDT",
        "ethereum-classic":   "ETCUSDT",
        "crypto-com-chain":   "CROUSDT",
        "render-token":       "RENDERUSDT",
        "cosmos":             "ATOMUSDT",
        "aave":               "AAVEUSDT",
        "monero":             "XMRUSDT",
        "filecoin":           "FILUSDT",
        "arbitrum":           "ARBUSDT",
        "vechain":            "VETUSDT",
        "mantle":             "MNTUSDT",
        "immutable-x":        "IMXUSDT",
        "optimism":           "OPUSDT",
        "injective-protocol": "INJUSDT",
        "algorand":           "ALGOUSDT",
        "theta-token":        "THETAUSDT",
        "fantom":             "FTMUSDT",
        "the-graph":          "GRTUSDT",
        "sei-network":        "SEIUSDT",
    ]

    static let all: [Crypto] = [
        Crypto(id: "bitcoin",            symbol: "BTC",    name: "Bitcoin",             icon: "₿"),
        Crypto(id: "ethereum",           symbol: "ETH",    name: "Ethereum",            icon: "Ξ"),
        Crypto(id: "tether",             symbol: "USDT",   name: "Tether",              icon: "₮"),
        Crypto(id: "binancecoin",        symbol: "BNB",    name: "BNB",                 icon: "⬡"),
        Crypto(id: "solana",             symbol: "SOL",    name: "Solana",              icon: "◎"),
        Crypto(id: "ripple",             symbol: "XRP",    name: "XRP",                 icon: "✕"),
        Crypto(id: "usd-coin",           symbol: "USDC",   name: "USD Coin",            icon: "$"),
        Crypto(id: "staked-ether",       symbol: "stETH",  name: "Lido Staked Ether",   icon: "◈"),
        Crypto(id: "cardano",            symbol: "ADA",    name: "Cardano",             icon: "♦"),
        Crypto(id: "dogecoin",           symbol: "DOGE",   name: "Dogecoin",            icon: "Ð"),
        Crypto(id: "tron",               symbol: "TRX",    name: "TRON",                icon: "⬟"),
        Crypto(id: "avalanche-2",        symbol: "AVAX",   name: "Avalanche",           icon: "▲"),
        Crypto(id: "wrapped-bitcoin",    symbol: "WBTC",   name: "Wrapped Bitcoin",     icon: "₿"),
        Crypto(id: "chainlink",          symbol: "LINK",   name: "Chainlink",           icon: "⬡"),
        Crypto(id: "the-open-network",   symbol: "TON",    name: "Toncoin",             icon: "◆"),
        Crypto(id: "sui",                symbol: "SUI",    name: "Sui",                 icon: "〜"),
        Crypto(id: "polkadot",           symbol: "DOT",    name: "Polkadot",            icon: "●"),
        Crypto(id: "stellar",            symbol: "XLM",    name: "Stellar",             icon: "✦"),
        Crypto(id: "hedera-hashgraph",   symbol: "HBAR",   name: "Hedera",              icon: "ℏ"),
        Crypto(id: "bitcoin-cash",       symbol: "BCH",    name: "Bitcoin Cash",        icon: "Ƀ"),
        Crypto(id: "hyperliquid",        symbol: "HYPE",   name: "Hyperliquid",         icon: "⧫"),
        Crypto(id: "uniswap",            symbol: "UNI",    name: "Uniswap",             icon: "🦄"),
        Crypto(id: "litecoin",           symbol: "LTC",    name: "Litecoin",            icon: "Ł"),
        Crypto(id: "leo-token",          symbol: "LEO",    name: "LEO Token",           icon: "◉"),
        Crypto(id: "near",               symbol: "NEAR",   name: "NEAR",                icon: "Ⓝ"),
        Crypto(id: "matic-network",      symbol: "POL",    name: "Polygon",             icon: "⬠"),
        Crypto(id: "dai",                symbol: "DAI",    name: "Dai",                 icon: "◇"),
        Crypto(id: "aptos",              symbol: "APT",    name: "Aptos",               icon: "⬡"),
        Crypto(id: "pepe",               symbol: "PEPE",   name: "Pepe",                icon: "🐸"),
        Crypto(id: "internet-computer",  symbol: "ICP",    name: "Internet Computer",   icon: "∞"),
        Crypto(id: "ethereum-classic",   symbol: "ETC",    name: "Ethereum Classic",    icon: "Ξ"),
        Crypto(id: "crypto-com-chain",   symbol: "CRO",    name: "Cronos",              icon: "◈"),
        Crypto(id: "render-token",       symbol: "RENDER", name: "Render",              icon: "▣"),
        Crypto(id: "kaspa",              symbol: "KAS",    name: "Kaspa",               icon: "◆"),
        Crypto(id: "cosmos",             symbol: "ATOM",   name: "Cosmos",              icon: "⚛"),
        Crypto(id: "aave",               symbol: "AAVE",   name: "Aave",                icon: "◬"),
        Crypto(id: "monero",             symbol: "XMR",    name: "Monero",              icon: "ɱ"),
        Crypto(id: "filecoin",           symbol: "FIL",    name: "Filecoin",            icon: "⨍"),
        Crypto(id: "arbitrum",           symbol: "ARB",    name: "Arbitrum",            icon: "△"),
        Crypto(id: "vechain",            symbol: "VET",    name: "VeChain",             icon: "✓"),
        Crypto(id: "okb",                symbol: "OKB",    name: "OKB",                 icon: "◎"),
        Crypto(id: "mantle",             symbol: "MNT",    name: "Mantle",              icon: "▽"),
        Crypto(id: "immutable-x",        symbol: "IMX",    name: "Immutable",           icon: "✦"),
        Crypto(id: "optimism",           symbol: "OP",     name: "Optimism",            icon: "⊕"),
        Crypto(id: "injective-protocol", symbol: "INJ",    name: "Injective",           icon: "⟐"),
        Crypto(id: "algorand",           symbol: "ALGO",   name: "Algorand",            icon: "△"),
        Crypto(id: "theta-token",        symbol: "THETA",  name: "Theta",               icon: "θ"),
        Crypto(id: "fantom",             symbol: "FTM",    name: "Fantom",              icon: "◎"),
        Crypto(id: "the-graph",          symbol: "GRT",    name: "The Graph",           icon: "◈"),
        Crypto(id: "sei-network",        symbol: "SEI",    name: "Sei",                 icon: "⧫"),
    ]

    static let popular: [Crypto] = Array(all.prefix(10))

    // Stablecoins always priced at $1
    static let stablecoins: Set<String> = ["tether", "usd-coin", "staked-ether", "dai"]
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

    init() { loadCachedPrices() }

    func fetchPrices() async {
        isLoading = true
        defer { isLoading = false }

        var newPrices: [String: CryptoPrice] = [:]

        // Stablecoins — always $1, no network needed
        for id in Crypto.stablecoins {
            newPrices[id] = CryptoPrice(price: 1.0, change24h: 0.0, marketCap: 0, volume24h: 0)
        }

        // Binance — batch fetch for all supported coins
        let binancePairs = Crypto.all.compactMap { c -> (id: String, symbol: String)? in
            guard let sym = c.binanceSymbol else { return nil }
            return (c.id, sym)
        }
        if let fetched = await fetchBinance(pairs: binancePairs) {
            for (id, price) in fetched { newPrices[id] = price }
            isOffline = false
        } else {
            isOffline = true
        }

        // CoinGecko — for coins not covered by Binance or stablecoins (LEO, OKB, KAS, etc.)
        let stillMissing = Crypto.all.filter { newPrices[$0.id] == nil }.map(\.id)
        if !stillMissing.isEmpty, let fetched = await fetchCoinGecko(ids: stillMissing) {
            for (id, price) in fetched { newPrices[id] = price }
        }

        if !newPrices.isEmpty {
            prices = newPrices
            lastUpdated = Date()
            saveCachedPrices()
        } else if prices.isEmpty {
            loadFallbackPrices()
        }
    }

    // MARK: - Binance REST

    private func fetchBinance(pairs: [(id: String, symbol: String)]) async -> [String: CryptoPrice]? {
        let syms = pairs.map { #""\#($0.symbol)""# }.joined(separator: ",")
        let symbolsParam = "[\(syms)]"
        guard let encoded = symbolsParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.binance.com/api/v3/ticker/24hr?symbols=\(encoded)")
        else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return nil }

            let symbolToId = Dictionary(uniqueKeysWithValues: pairs.map { ($0.symbol, $0.id) })
            var result: [String: CryptoPrice] = [:]
            for item in json {
                guard let sym      = item["symbol"]              as? String,
                      let id       = symbolToId[sym],
                      let priceStr = item["lastPrice"]           as? String,
                      let price    = Double(priceStr),
                      let chgStr   = item["priceChangePercent"]  as? String,
                      let change   = Double(chgStr),
                      let volStr   = item["quoteVolume"]         as? String,
                      let vol      = Double(volStr)
                else { continue }
                result[id] = CryptoPrice(price: price, change24h: change, marketCap: 0, volume24h: vol)
            }
            return result.isEmpty ? nil : result
        } catch { return nil }
    }

    // MARK: - CoinGecko REST (fallback for non-Binance coins)

    private func fetchCoinGecko(ids: [String]) async -> [String: CryptoPrice]? {
        let idsStr = ids.joined(separator: ",")
        let urlStr = "https://api.coingecko.com/api/v3/simple/price?ids=\(idsStr)&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true"
        guard let url = URL(string: urlStr) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: [String: Double]] else { return nil }
            var result: [String: CryptoPrice] = [:]
            for (id, v) in json {
                result[id] = CryptoPrice(price: v["usd"] ?? 0, change24h: v["usd_24h_change"] ?? 0,
                                         marketCap: v["usd_market_cap"] ?? 0, volume24h: v["usd_24h_vol"] ?? 0)
            }
            return result.isEmpty ? nil : result
        } catch { return nil }
    }

    // MARK: - Helpers

    func priceFor(_ id: String) -> CryptoPrice {
        prices[id] ?? CryptoPrice(price: 0, change24h: 0, marketCap: 0, volume24h: 0)
    }

    var lastUpdatedText: String {
        guard let date = lastUpdated else { return "—" }
        let s = Int(-date.timeIntervalSinceNow)
        if s < 60    { return "just now" }
        if s < 3600  { return "\(s / 60)m ago" }
        if s < 86400 { return "\(s / 3600)h ago" }
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
        else { loadFallbackPrices(); return }
        for (id, v) in dict {
            prices[id] = CryptoPrice(price: v["price"] ?? 0, change24h: v["change"] ?? 0,
                                     marketCap: v["cap"] ?? 0, volume24h: v["vol"] ?? 0)
        }
        lastUpdated = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date
        isOffline = true
    }

    private func loadFallbackPrices() {
        let fallback: [(String, Double, Double)] = [
            ("bitcoin", 103000, 1.2), ("ethereum", 2450, -0.8), ("tether", 1.0, 0.01),
            ("binancecoin", 650, 0.5), ("solana", 170, 2.1), ("ripple", 2.35, -1.3),
            ("usd-coin", 1.0, 0.0), ("staked-ether", 2440, -0.9), ("cardano", 0.78, 1.8),
            ("dogecoin", 0.22, 3.5), ("tron", 0.27, 0.4), ("avalanche-2", 24, -2.1),
            ("wrapped-bitcoin", 102900, 1.1), ("chainlink", 16, 1.1),
            ("the-open-network", 3.4, 0.6), ("sui", 3.6, 2.8), ("polkadot", 4.8, 0.9),
            ("stellar", 0.11, -0.2), ("hedera-hashgraph", 0.19, 1.5),
            ("bitcoin-cash", 420, 1.5), ("hyperliquid", 25, 3.2),
            ("uniswap", 7.5, -0.4), ("litecoin", 97, 0.3), ("leo-token", 9.2, 0.1),
            ("near", 3.2, 2.3), ("matic-network", 0.42, -0.6), ("dai", 1.0, 0.0),
            ("aptos", 9.1, 1.7), ("pepe", 0.000012, 5.1),
            ("internet-computer", 12, -1.8), ("ethereum-classic", 27, 0.8),
            ("crypto-com-chain", 0.12, -0.3), ("render-token", 7.8, 2.5),
            ("kaspa", 0.11, 1.9), ("cosmos", 5.6, -1.0), ("aave", 280, 1.3),
            ("monero", 195, 0.7), ("filecoin", 4.5, -0.5), ("arbitrum", 0.85, 1.2),
            ("vechain", 0.035, 0.9), ("okb", 48, 0.2), ("mantle", 0.75, -1.1),
            ("immutable-x", 1.4, 2.0), ("optimism", 1.1, -0.7),
            ("injective-protocol", 22, 1.6), ("algorand", 0.22, 0.5),
            ("theta-token", 1.3, -0.8), ("fantom", 0.65, 1.4),
            ("the-graph", 0.18, 0.3), ("sei-network", 0.38, 2.1),
        ]
        for (id, price, change) in fallback {
            prices[id] = CryptoPrice(price: price, change24h: change, marketCap: 0, volume24h: 0)
        }
        isOffline = true
    }
}
