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

private let favLoansKey = "tally_fav_loans_v1"

func loadFavouriteLoans() -> [FavouriteLoan] {
    guard let data = UserDefaults.standard.data(forKey: favLoansKey),
          let decoded = try? JSONDecoder().decode([FavouriteLoan].self, from: data) else { return [] }
    return decoded
}

func persistFavouriteLoans(_ items: [FavouriteLoan]) {
    guard let data = try? JSONEncoder().encode(items) else { return }
    UserDefaults.standard.set(data, forKey: favLoansKey)
}
