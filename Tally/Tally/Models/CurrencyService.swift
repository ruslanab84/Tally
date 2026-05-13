import Foundation

@MainActor
@Observable
class CurrencyService {
    var rates: [String: Double] = [:]
    var previousRates: [String: Double] = [:]
    var lastUpdated: Date?
    var isLoading = false
    var isOffline = false

    private let cacheRatesKey = "tally_cached_rates"
    private let cachePreviousRatesKey = "tally_cached_previous_rates"
    private let cacheTimestampKey = "tally_cached_rates_timestamp"
    private let apiURL = "https://open.er-api.com/v6/latest/USD"

    init() {
        loadCachedRates()
    }

    func fetchRates() async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: apiURL) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
            guard response.result == "success" else {
                markOffline()
                return
            }
            previousRates = rates
            rates = response.rates
            applyPeggedRates()
            lastUpdated = Date()
            isOffline = false
            saveCachedRates()
        } catch {
            markOffline()
        }
    }

    func rateFor(_ code: String) -> Double {
        rates[code] ?? 1.0
    }

    func changeFor(_ code: String) -> Double {
        guard let current = rates[code], let previous = previousRates[code], previous > 0 else {
            return 0
        }
        return ((current - previous) / previous) * 100
    }

    var lastUpdatedText: String {
        guard let date = lastUpdated else { return "No data" }
        let seconds = Int(-date.timeIntervalSinceNow)
        if seconds < 60 { return "Updated just now" }
        if seconds < 3600 { return "Updated \(seconds / 60) min ago" }
        if seconds < 86400 { return "Updated \(seconds / 3600)h ago" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "Updated \(formatter.string(from: date))"
    }

    // MARK: - Cache

    private func loadCachedRates() {
        if let data = UserDefaults.standard.data(forKey: cacheRatesKey),
           let cached = try? JSONDecoder().decode([String: Double].self, from: data) {
            rates = cached
            lastUpdated = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date
            if let prevData = UserDefaults.standard.data(forKey: cachePreviousRatesKey),
               let prevCached = try? JSONDecoder().decode([String: Double].self, from: prevData) {
                previousRates = prevCached
            }
            isOffline = true
        } else {
            loadFallbackRates()
        }
    }

    private func saveCachedRates() {
        if let data = try? JSONEncoder().encode(rates) {
            UserDefaults.standard.set(data, forKey: cacheRatesKey)
            UserDefaults.standard.set(lastUpdated, forKey: cacheTimestampKey)
        }
        if let prevData = try? JSONEncoder().encode(previousRates) {
            UserDefaults.standard.set(prevData, forKey: cachePreviousRatesKey)
        }
    }

    private func loadFallbackRates() {
        for currency in Currency.all {
            rates[currency.code] = currency.rate
        }
        isOffline = true
    }

    private let peggedRates: [String: Double] = [
        "AZN": 1.7,
    ]

    private func applyPeggedRates() {
        for (code, rate) in peggedRates {
            rates[code] = rate
        }
    }

    private func markOffline() {
        isOffline = true
        if rates.isEmpty {
            loadFallbackRates()
        }
    }
}

// MARK: - API Response

private struct ExchangeRateResponse: Decodable {
    let result: String
    let rates: [String: Double]
}
