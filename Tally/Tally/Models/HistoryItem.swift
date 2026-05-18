import SwiftUI

enum HistoryType: String, Codable {
    case sci, cur, unit, temp, tip, finance, bmi, engineering, vat, inflation

    func color(_ T: TallyTokens) -> Color {
        switch self {
        case .sci, .engineering: return T.accent
        case .cur:               return T.success
        case .unit:              return T.purple
        case .temp:              return T.pink
        case .tip, .finance:     return T.red
        case .bmi:               return T.success
        case .vat:               return T.blue
        case .inflation:         return T.yellow
        }
    }
}

struct HistoryEntry: Identifiable, Codable {
    var id: UUID = UUID()
    let expression: String
    let result: String
    let type: HistoryType
    let date: Date
}

struct HistoryGroup: Identifiable {
    let id = UUID()
    let date: String
    let entries: [HistoryEntry]
}
