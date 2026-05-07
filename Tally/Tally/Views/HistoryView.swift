import SwiftUI

struct HistoryView: View {
    @Environment(\.tokens) private var T
    private let groups = HistoryGroup.sampleData

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(T.textMuted)
                    Text("Search history")
                        .font(.system(size: 14))
                        .foregroundStyle(T.textMuted)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(T.surfaceAlt)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                ForEach(groups) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.date.uppercased())
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(0.6)
                            .foregroundStyle(T.textMuted)
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            ForEach(Array(group.entries.enumerated()), id: \.element.id) { index, entry in
                                HStack(spacing: 12) {
                                    // Color bar
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

                                    Button(action: {}) {
                                        Image(systemName: "doc.on.doc")
                                            .font(.system(size: 13))
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
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(T.bg)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environment(\.tokens, .light)
}
