import SwiftUI

struct HubTileData: Identifiable {
    let id: String
    let screen: Screen
    let labelKey: KeyPath<Loc, String>
    let subKey: KeyPath<Loc, String>
    let icon: String       // SF Symbol name
    let accentKey: KeyPath<TallyTokens, Color>

    static let all: [HubTileData] = [
        HubTileData(id: "finance", screen: .finance, labelKey: \.tileFinance, subKey: \.tileFinanceSub, icon: "building.columns", accentKey: \.blue),
        HubTileData(id: "crypto", screen: .crypto, labelKey: \.tileCrypto, subKey: \.tileCryptoSub, icon: "bitcoinsign.circle", accentKey: \.yellow),
        HubTileData(id: "currency", screen: .currency, labelKey: \.tileCurrency, subKey: \.tileCurrencySub, icon: "dollarsign.circle", accentKey: \.success),
        HubTileData(id: "units", screen: .units, labelKey: \.tileUnits, subKey: \.tileUnitsSub, icon: "ruler", accentKey: \.purple),
        HubTileData(id: "temp", screen: .temp, labelKey: \.tileTemp, subKey: \.tileTempSub, icon: "thermometer.medium", accentKey: \.pink),
        HubTileData(id: "date", screen: .date, labelKey: \.tileDateTime, subKey: \.tileDateTimeSub, icon: "calendar", accentKey: \.teal),
        HubTileData(id: "sizes", screen: .sizes, labelKey: \.tileClothing, subKey: \.tileClothingSub, icon: "tshirt", accentKey: \.yellow),
        HubTileData(id: "tip", screen: .tip, labelKey: \.tileTip, subKey: \.tileTipSub, icon: "percent", accentKey: \.red),
        HubTileData(id: "simple", screen: .simple, labelKey: \.tileSimple, subKey: \.tileSimpleSub, icon: "plus.forwardslash.minus", accentKey: \.accent),
        HubTileData(id: "bmi", screen: .bmi, labelKey: \.tileBMI, subKey: \.tileBMISub, icon: "figure.stand", accentKey: \.success),
        HubTileData(id: "engineering", screen: .engineering, labelKey: \.tileEngineering, subKey: \.tileEngineeringSub, icon: "gearshape.2", accentKey: \.teal),
        HubTileData(id: "scientific", screen: .scientific, labelKey: \.tileScientific, subKey: \.tileScientificSub, icon: "function", accentKey: \.blue),
    ]
}

struct HubView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Binding var navigationPath: NavigationPath

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(L.hubSubtitle)
                    .font(.custom("JetBrainsMono-Regular", size: 14))
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
                    Text(L.hubRecent)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
        .background { TallyBackground(T: T, icons: [
            "plus.forwardslash.minus", "function", "dollarsign.circle",
            "ruler", "thermometer.medium", "calendar",
            "tshirt", "percent", "building.columns", "figure.stand", "gearshape.2",
        ]) }
        .navigationTitle("Tally")
    }
}

struct HubTile: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
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
                        .font(.custom("JetBrainsMono-SemiBold", size: 16))
                        .foregroundStyle(T[keyPath: tile.accentKey])
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(L[keyPath: tile.labelKey])
                        .font(.custom("JetBrainsMono-SemiBold", size: 16))
                        .foregroundStyle(T.text)
                        .tracking(-0.2)

                    Text(L[keyPath: tile.subKey])
                        .font(.custom("JetBrainsMono-Regular", size: 12))
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
