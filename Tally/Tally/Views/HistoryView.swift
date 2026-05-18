import SwiftUI

struct HistoryView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @EnvironmentObject var historyStore: HistoryStore

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                if historyStore.entries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 36))
                            .foregroundStyle(T.textMuted)
                        Text(L.searchHistory)
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    ForEach(historyStore.groups()) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.date.uppercased())
                                .font(.custom("JetBrainsMono-SemiBold", size: 11))
                                .tracking(0.6)
                                .foregroundStyle(T.textMuted)
                                .padding(.horizontal, 4)

                            VStack(spacing: 0) {
                                ForEach(Array(group.entries.enumerated()), id: \.element.id) { index, entry in
                                    HStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(entry.type.color(T))
                                            .frame(width: 4)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(entry.expression)
                                                .font(.custom("JetBrainsMono-Medium", size: 14))
                                                .foregroundStyle(T.textMuted)
                                                .lineLimit(1)

                                            Text("= \(entry.result)")
                                                .font(.custom("JetBrainsMono-Medium", size: 18))
                                                .foregroundStyle(T.text)
                                        }

                                        Spacer()

                                        Button {
                                            UIPasteboard.general.string = entry.result
                                        } label: {
                                            Image(systemName: "doc.on.doc")
                                                .font(.custom("JetBrainsMono-Regular", size: 13))
                                                .foregroundStyle(T.textMuted)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)

                                    if index < group.entries.count - 1 {
                                        Divider().padding(.leading, 32)
                                    }
                                }
                            }
                            .background(T.surface)
                            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "clock.arrow.circlepath", "list.bullet", "doc.text",
            "tray.full", "archivebox", "bookmark",
            "text.alignleft", "clock",
        ]) }
        .navigationTitle(L.navHistory)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
    .environmentObject(HistoryStore())
    .environment(\.tokens, .light)
}
