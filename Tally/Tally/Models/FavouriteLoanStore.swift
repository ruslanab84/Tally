import Foundation
import SwiftUI

struct FavouriteLoan: Codable, Identifiable {
    var id = UUID()
    var name: String
    var kind: String   // "loan" | "mortgage"
    var savedAt = Date()

    // Loan
    var loanAmount: String = ""
    var loanRate: String = ""
    var loanTerm: String = ""
    var loanTermUnit: String = "years"
    var loanPaymentType: String = "annuity"

    // Mortgage
    var propPrice: String = ""
    var downPayment: String = ""
    var downPaymentMode: String = "amount"
    var mortRate: String = ""
    var mortTerm: String = ""
    var mortPaymentType: String = "annuity"
}

@Observable
class FavouriteLoanStore {
    var items: [FavouriteLoan] = []

    private let key = "tally_fav_loans_v1"

    init() { load() }

    func add(_ item: FavouriteLoan) {
        items.insert(item, at: 0)
        save()
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func remove(_ item: FavouriteLoan) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([FavouriteLoan].self, from: data) else { return }
        items = decoded
    }
}
