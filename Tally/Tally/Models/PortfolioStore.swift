import Foundation
import Combine
import SwiftUI

// MARK: - Model

struct PortfolioHolding: Identifiable, Codable {
    var id: UUID = UUID()
    var cryptoId: String
    var amount: Double
    var purchasePrice: Double   // USD per coin
    var purchaseDate: Date

    func costBasis() -> Double { amount * purchasePrice }
    func currentValue(price: Double) -> Double { amount * price }
    func pnl(price: Double) -> Double { currentValue(price: price) - costBasis() }
    func pnlPct(price: Double) -> Double {
        guard purchasePrice > 0 else { return 0 }
        return ((price - purchasePrice) / purchasePrice) * 100
    }
}

// MARK: - Store

@MainActor
class PortfolioStore: ObservableObject {
    @Published var holdings: [PortfolioHolding] = []

    private let key = "tally_portfolio_v1"

    init() { load() }

    func add(_ holding: PortfolioHolding) {
        holdings.append(holding)
        save()
    }

    func remove(at offsets: IndexSet) {
        holdings.remove(atOffsets: offsets)
        save()
    }

    func totalInvested() -> Double {
        holdings.reduce(0) { $0 + $1.costBasis() }
    }

    func totalValue(prices: [String: CryptoPrice]) -> Double {
        holdings.reduce(0) { sum, h in
            let price = prices[h.cryptoId]?.price ?? h.purchasePrice
            return sum + h.currentValue(price: price)
        }
    }

    func totalPnL(prices: [String: CryptoPrice]) -> Double {
        totalValue(prices: prices) - totalInvested()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(holdings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([PortfolioHolding].self, from: data)
        else { return }
        holdings = decoded
    }
}
