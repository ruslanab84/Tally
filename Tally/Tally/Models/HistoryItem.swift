import SwiftUI

enum HistoryType: String {
    case sci, cur, unit, temp, tip

    func color(_ T: TallyTokens) -> Color {
        switch self {
        case .sci:  return T.accent
        case .cur:  return T.success
        case .unit: return T.purple
        case .temp: return T.pink
        case .tip:  return T.red
        }
    }
}

struct HistoryEntry: Identifiable {
    let id = UUID()
    let expression: String
    let result: String
    let type: HistoryType
}

struct HistoryGroup: Identifiable {
    let id = UUID()
    let date: String
    let entries: [HistoryEntry]
}

extension HistoryGroup {
    static let sampleData: [HistoryGroup] = [
        HistoryGroup(date: "Today", entries: [
            HistoryEntry(expression: "127 × 4.5", result: "571.5", type: .sci),
            HistoryEntry(expression: "100 USD → EUR", result: "92.00", type: .cur),
            HistoryEntry(expression: "sin(45°) + log(100)", result: "2.7071", type: .sci),
            HistoryEntry(expression: "5 km → mi", result: "3.107", type: .unit),
        ]),
        HistoryGroup(date: "Yesterday", entries: [
            HistoryEntry(expression: "$84.50 ÷ 2 + 18%", result: "$49.85 each", type: .tip),
            HistoryEntry(expression: "22°C → °F", result: "71.6°F", type: .temp),
            HistoryEntry(expression: "(2³ × 7) + 14", result: "70", type: .sci),
        ]),
        HistoryGroup(date: "May 4", entries: [
            HistoryEntry(expression: "1500 RUB → USD", result: "$16.39", type: .cur),
        ]),
    ]
}
