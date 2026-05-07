import SwiftUI

struct DateTimeView: View {
    @Environment(\.tokens) private var T
    @State private var fromDate = Date()
    @State private var toDate: Date

    private let worldClocks: [(city: String, tzId: String)] = [
        ("San Francisco", "America/Los_Angeles"),
        ("New York", "America/New_York"),
        ("London", "Europe/London"),
        ("Paris", "Europe/Paris"),
        ("Moscow", "Europe/Moscow"),
        ("Dubai", "Asia/Dubai"),
        ("Tokyo", "Asia/Tokyo"),
        ("Sydney", "Australia/Sydney"),
    ]

    init() {
        let cal = Calendar.current
        let endOfYear = cal.date(from: DateComponents(
            year: cal.component(.year, from: Date()), month: 12, day: 31
        )) ?? Date()
        _toDate = State(initialValue: endOfYear)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                differenceCard

                Text("WORLD CLOCK")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                TimelineView(.everyMinute) { timeline in
                    VStack(spacing: 6) {
                        ForEach(worldClocks, id: \.city) { clock in
                            clockRow(city: clock.city, tzId: clock.tzId, now: timeline.date)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(T.bg)
        .navigationTitle("Date & Time")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Date Difference

    private var differenceCard: some View {
        let calendar = Calendar.current
        let start = min(fromDate, toDate)
        let end = max(fromDate, toDate)
        let totalDays = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        let mc = calendar.dateComponents([.month, .day], from: start, to: end)
        let months = mc.month ?? 0
        let days = mc.day ?? 0
        let weeks = totalDays / 7
        let rem = totalDays % 7

        return VStack(spacing: 10) {
            Text("DIFFERENCE")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(T.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                VStack(spacing: 6) {
                    Text("From")
                        .font(.system(size: 11))
                        .foregroundStyle(T.textMuted)
                    DatePicker("", selection: $fromDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .tint(T.accent)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(T.surfaceAlt)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(T.accent)

                VStack(spacing: 6) {
                    Text("To")
                        .font(.system(size: 11))
                        .foregroundStyle(T.textMuted)
                    DatePicker("", selection: $toDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .tint(T.accent)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(T.surfaceAlt)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            VStack(spacing: 2) {
                Text("\(totalDays) days")
                    .font(.custom("JetBrainsMono-Medium", size: 36))
                    .fontWeight(.medium)
                    .tracking(-1)
                    .foregroundStyle(T.accent)

                Text("\(months) months \(days) days · \(weeks) weeks \(rem) day\(rem == 1 ? "" : "s")")
                    .font(.system(size: 12))
                    .foregroundStyle(T.textMuted)
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    // MARK: - World Clock

    private func clockRow(city: String, tzId: String, now: Date) -> some View {
        let tz = TimeZone(identifier: tzId) ?? .current

        let fmt = DateFormatter()
        fmt.timeZone = tz
        fmt.dateFormat = "HH:mm"
        let time = fmt.string(from: now)

        let abbr = tz.abbreviation(for: now) ?? ""
        let sec = tz.secondsFromGMT(for: now)
        let h = sec / 3600
        let m = abs(sec % 3600) / 60
        let offset = m > 0
            ? String(format: "%@ · UTC%+d:%02d", abbr, h, m)
            : String(format: "%@ · UTC%+d", abbr, h)

        let label = dayLabel(now: now, tz: tz)

        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(city)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(T.text)
                Text(offset)
                    .font(.custom("JetBrainsMono-Medium", size: 11))
                    .foregroundStyle(T.textMuted)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(time)
                    .font(.custom("JetBrainsMono-Medium", size: 22))
                    .foregroundStyle(T.text)
                Text(label)
                    .font(.system(size: 11))
                    .foregroundStyle(T.textMuted)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
    }

    private func dayLabel(now: Date, tz: TimeZone) -> String {
        let localCal = Calendar.current
        var tzCal = Calendar.current
        tzCal.timeZone = tz
        let localDay = localCal.ordinality(of: .day, in: .era, for: now) ?? 0
        let tzDay = tzCal.ordinality(of: .day, in: .era, for: now) ?? 0
        switch tzDay - localDay {
        case 1:  return "Tomorrow"
        case -1: return "Yesterday"
        default: return "Today"
        }
    }
}

#Preview {
    NavigationStack {
        DateTimeView()
    }
    .environment(\.tokens, .light)
}
