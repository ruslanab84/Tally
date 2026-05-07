import SwiftUI

struct HubTileData: Identifiable {
    let id: String
    let screen: Screen
    let label: String
    let sub: String
    let icon: String       // SF Symbol name
    let accentKey: KeyPath<TallyTokens, Color>

    static let all: [HubTileData] = [
        HubTileData(id: "simple", screen: .simple, label: "Simple", sub: "Basic calc", icon: "plus.forwardslash.minus", accentKey: \.accent),
        HubTileData(id: "scientific", screen: .scientific, label: "Scientific", sub: "Advanced", icon: "function", accentKey: \.blue),
        HubTileData(id: "currency", screen: .currency, label: "Currency", sub: "32 currencies", icon: "dollarsign.circle", accentKey: \.success),
        HubTileData(id: "units", screen: .units, label: "Units", sub: "Length, mass…", icon: "ruler", accentKey: \.purple),
        HubTileData(id: "temp", screen: .temp, label: "Temperature", sub: "°C ↔ °F ↔ K", icon: "thermometer.medium", accentKey: \.pink),
        HubTileData(id: "date", screen: .date, label: "Date & Time", sub: "Timezones", icon: "calendar", accentKey: \.teal),
        HubTileData(id: "sizes", screen: .sizes, label: "Clothing", sub: "EU · US · UK", icon: "tshirt", accentKey: \.yellow),
        HubTileData(id: "tip", screen: .tip, label: "Tip & %", sub: "Split bill", icon: "percent", accentKey: \.red),
    ]
}

struct HubView: View {
    @Environment(\.tokens) private var T
    @Binding var navigationPath: NavigationPath

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Calculator & converters")
                    .font(.system(size: 14))
                    .foregroundStyle(T.textMuted)
                    .padding(.horizontal, 4)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(HubTileData.all) { tile in
                        HubTile(tile: tile) {
                            navigationPath.append(tile.screen)
                        }
                    }
                }

                // Recent card
                VStack(alignment: .leading, spacing: 8) {
                    Text("RECENT")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)

                    Text("127 × 4.5 = 571.5")
                        .font(.custom("JetBrainsMono-Medium", size: 17))
                        .foregroundStyle(T.text)

                    Text("100 USD → 92.00 EUR")
                        .font(.custom("JetBrainsMono-Medium", size: 14))
                        .foregroundStyle(T.textMuted)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(T.bg)
        .navigationTitle("Tally")
    }
}

struct HubTile: View {
    @Environment(\.tokens) private var T
    let tile: HubTileData
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(T[keyPath: tile.accentKey].opacity(0.12))
                        .frame(width: 38, height: 38)

                    Image(systemName: tile.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(T[keyPath: tile.accentKey])
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(tile.label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(T.text)
                        .tracking(-0.2)

                    Text(tile.sub)
                        .font(.system(size: 12))
                        .foregroundStyle(T.textMuted)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 124)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
            .shadow(color: .black.opacity(0.04), radius: 7, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        HubView(navigationPath: .constant(NavigationPath()))
    }
    .environment(\.tokens, .light)
}
