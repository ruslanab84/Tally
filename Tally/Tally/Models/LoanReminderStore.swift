import Foundation
import UserNotifications
import SwiftUI

// MARK: - Model

struct LoanReminder: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
    var paymentDay: Int    // 1–28
    var daysBefore: Int    // fire notification this many days before paymentDay
    var isActive: Bool = true
    var createdAt: Date = Date()
}

// MARK: - Store + Notification Scheduling

@MainActor
@Observable
class LoanReminderStore {
    var reminders: [LoanReminder] = []
    var authStatus: UNAuthorizationStatus = .notDetermined

    private let key = "tally_loan_reminders_v1"

    init() {
        load()
        Task { await refreshAuth() }
    }

    // MARK: Public API

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            await refreshAuth()
            return granted
        } catch { return false }
    }

    func refreshAuth() async {
        let s = await UNUserNotificationCenter.current().notificationSettings()
        authStatus = s.authorizationStatus
    }

    func add(_ reminder: LoanReminder) async {
        reminders.append(reminder)
        save()
        if reminder.isActive { await schedule(reminder) }
    }

    func toggleActive(id: UUID) async {
        guard let idx = reminders.firstIndex(where: { $0.id == id }) else { return }
        reminders[idx].isActive.toggle()
        let r = reminders[idx]
        save()
        if r.isActive { await schedule(r) } else { cancel(id) }
    }

    func remove(at offsets: IndexSet) {
        let ids = offsets.map { reminders[$0].id }
        reminders.remove(atOffsets: offsets)
        save()
        ids.forEach { cancel($0) }
    }

    // MARK: Notification

    private func schedule(_ r: LoanReminder) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [r.id.uuidString])

        let content = UNMutableNotificationContent()
        let dLabel = r.daysBefore == 1 ? "1 day" : "\(r.daysBefore) days"
        content.title = "💳 \(r.name)"
        content.body = "Payment of $\(String(format: "%.2f", r.amount)) is due in \(dLabel)"
        content.sound = .default
        content.badge = 1

        // Notification fires on (paymentDay - daysBefore); wraps to previous month if needed
        let raw = r.paymentDay - r.daysBefore
        let notifDay = raw <= 0 ? max(1, 28 + raw) : raw

        var comps = DateComponents()
        comps.day    = notifDay
        comps.hour   = 9
        comps.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: r.id.uuidString, content: content, trigger: trigger)
        try? await center.add(request)
    }

    private func cancel(_ id: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    // MARK: Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([LoanReminder].self, from: data)
        else { return }
        reminders = decoded
    }
}
