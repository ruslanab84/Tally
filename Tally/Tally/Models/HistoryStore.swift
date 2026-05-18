import Foundation
import Combine

@MainActor
class HistoryStore: ObservableObject {
    @Published var entries: [HistoryEntry] = []

    private let key = "tally_history_v1"
    private let maxEntries = 100

    init() { load() }

    func add(expression: String, result: String, type: HistoryType) {
        let entry = HistoryEntry(expression: expression, result: result, type: type, date: Date())
        entries.insert(entry, at: 0)
        if entries.count > maxEntries {
            entries = Array(entries.prefix(maxEntries))
        }
        save()
    }

    func clear() {
        entries = []
        save()
    }

    var recent: [HistoryEntry] {
        Array(entries.prefix(2))
    }

    func groups() -> [HistoryGroup] {
        guard !entries.isEmpty else { return [] }
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.date) }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return grouped.keys.sorted(by: >).map { day in
            let label: String
            if calendar.isDateInToday(day) { label = "Today" }
            else if calendar.isDateInYesterday(day) { label = "Yesterday" }
            else { label = formatter.string(from: day) }
            return HistoryGroup(date: label, entries: grouped[day]!.sorted { $0.date > $1.date })
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data)
        else { return }
        entries = decoded
    }
}
