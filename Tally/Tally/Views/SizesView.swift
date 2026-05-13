import SwiftUI

struct SizesView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var category = "shoes"
    @State private var gender = "men"
    @State private var regionIndex = 0
    @State private var sizeIndex = 0

    private var chart: SizeChart {
        SizeChart.get(category: category, gender: category == "kids" ? "kids" : gender)
    }

    private var safeRegion: Int { min(regionIndex, chart.regions.count - 1) }
    private var safeSize: Int { min(sizeIndex, chart.sizes.count - 1) }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Category
                Picker("Category", selection: $category) {
                    Text(L.shirts).tag("shirts")
                    Text(L.pants).tag("pants")
                    Text(L.shoes).tag("shoes")
                    Text(L.kids).tag("kids")
                }
                .pickerStyle(.segmented)
                .onChange(of: category) { _, _ in sizeIndex = 0 }

                // Gender (hidden for kids)
                if category != "kids" {
                    HStack(spacing: 8) {
                        ForEach(["men", "women"], id: \.self) { g in
                            Button {
                                gender = g
                                sizeIndex = 0
                            } label: {
                                Text(g == "men" ? L.mens : L.womens)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(gender == g ? T.accent : .clear)
                                    .foregroundStyle(gender == g ? .white : T.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(gender == g ? T.accent : T.border, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Size selector
                VStack(alignment: .leading, spacing: 12) {
                    Text(L.selectYourSize)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)

                    // Region chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(chart.regions.enumerated()), id: \.offset) { i, region in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.1)) { regionIndex = i }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(region.flag).font(.custom("JetBrainsMono-Regular", size: 14))
                                        Text(region.code)
                                            .font(.custom("JetBrainsMono-SemiBold", size: 12))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(safeRegion == i ? T.accentSoft : T.surfaceAlt)
                                    .foregroundStyle(safeRegion == i ? T.accent : T.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Size chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(chart.sizes.enumerated()), id: \.offset) { i, row in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.1)) { sizeIndex = i }
                                } label: {
                                    Text(row[safeRegion])
                                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(safeSize == i ? T.accent : T.surfaceAlt)
                                        .foregroundStyle(safeSize == i ? .white : T.text)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Conversions
                Text(L.conversions)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                VStack(spacing: 0) {
                    ForEach(Array(chart.regions.enumerated()), id: \.offset) { i, region in
                        HStack(spacing: 12) {
                            Text(region.flag).font(.custom("JetBrainsMono-Regular", size: 22))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(region.code)
                                    .font(.custom("JetBrainsMono-SemiBold", size: 15))
                                    .foregroundStyle(T.text)
                                Text(region.name)
                                    .font(.custom("JetBrainsMono-Regular", size: 11))
                                    .foregroundStyle(T.textMuted)
                            }

                            Spacer()

                            Text(chart.sizes[safeSize][i])
                                .font(.custom("JetBrainsMono-Medium", size: 22))
                                .foregroundStyle(i == safeRegion ? T.accent : T.text)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(i == safeRegion ? T.accentSoft : .clear)

                        if i < chart.regions.count - 1 {
                            Divider().padding(.leading, 50)
                        }
                    }
                }
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "tshirt", "shoe", "ruler",
            "tag", "hanger", "bag",
            "scissors", "crown",
        ]) }
        .navigationTitle(L.navClothing)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Size Data

struct SizeChart {
    struct Region {
        let code: String
        let name: String
        let flag: String
    }
    let regions: [Region]
    let sizes: [[String]]

    static func get(category: String, gender: String) -> SizeChart {
        switch (category, gender) {
        case ("shirts", "men"):   return menShirts
        case ("shirts", "women"): return womenShirts
        case ("pants", "men"):    return menPants
        case ("pants", "women"):  return womenPants
        case ("shoes", "men"):    return menShoes
        case ("shoes", "women"):  return womenShoes
        case ("kids", _):         return kidsClothing
        default:                  return menShoes
        }
    }

    // MARK: - Shoes

    private static let shoeRegions = [
        Region(code: "EU", name: "Europe", flag: "🇪🇺"),
        Region(code: "US", name: "United States", flag: "🇺🇸"),
        Region(code: "UK", name: "United Kingdom", flag: "🇬🇧"),
        Region(code: "JP", name: "Japan (cm)", flag: "🇯🇵"),
    ]

    static let menShoes = SizeChart(regions: shoeRegions, sizes: [
        ["39", "6.5", "5.5", "24.5"],
        ["40", "7", "6", "25"],
        ["41", "8", "7", "26"],
        ["42", "8.5", "7.5", "26.5"],
        ["43", "9.5", "8.5", "27.5"],
        ["44", "10", "9", "28"],
        ["45", "11", "10", "29"],
        ["46", "12", "11", "30"],
    ])

    static let womenShoes = SizeChart(regions: shoeRegions, sizes: [
        ["35", "5", "2.5", "22"],
        ["36", "5.5", "3.5", "23"],
        ["37", "6.5", "4", "23.5"],
        ["38", "7.5", "5", "24.5"],
        ["39", "8", "5.5", "25"],
        ["40", "9", "6.5", "25.5"],
        ["41", "9.5", "7", "26"],
        ["42", "10.5", "8", "27"],
    ])

    // MARK: - Shirts

    private static let clothingRegions = [
        Region(code: "INT", name: "International", flag: "🌐"),
        Region(code: "EU", name: "Europe", flag: "🇪🇺"),
        Region(code: "US", name: "United States", flag: "🇺🇸"),
        Region(code: "UK", name: "United Kingdom", flag: "🇬🇧"),
    ]

    static let menShirts = SizeChart(regions: clothingRegions, sizes: [
        ["XS", "44", "34", "34"],
        ["S", "46", "36", "36"],
        ["M", "48", "38", "38"],
        ["L", "50", "40", "40"],
        ["XL", "52", "42", "42"],
        ["XXL", "54", "44", "44"],
    ])

    static let womenShirts = SizeChart(regions: clothingRegions, sizes: [
        ["XS", "32", "0", "4"],
        ["S", "34", "2", "6"],
        ["M", "36", "4", "8"],
        ["L", "38", "6", "10"],
        ["XL", "40", "8", "12"],
        ["XXL", "42", "10", "14"],
    ])

    // MARK: - Pants

    private static let pantsRegions = [
        Region(code: "EU", name: "Europe", flag: "🇪🇺"),
        Region(code: "US", name: "United States", flag: "🇺🇸"),
        Region(code: "UK", name: "United Kingdom", flag: "🇬🇧"),
        Region(code: "INT", name: "International", flag: "🌐"),
    ]

    static let menPants = SizeChart(regions: pantsRegions, sizes: [
        ["42", "28", "28", "XS"],
        ["44", "30", "30", "S"],
        ["46", "32", "32", "M"],
        ["48", "34", "34", "L"],
        ["50", "36", "36", "XL"],
        ["52", "38", "38", "XXL"],
        ["54", "40", "40", "3XL"],
    ])

    static let womenPants = SizeChart(regions: pantsRegions, sizes: [
        ["32", "0", "4", "XS"],
        ["34", "2", "6", "S"],
        ["36", "4", "8", "M"],
        ["38", "6", "10", "L"],
        ["40", "8", "12", "XL"],
        ["42", "10", "14", "XXL"],
    ])

    // MARK: - Kids

    static let kidsClothing = SizeChart(regions: [
        Region(code: "Age", name: "Age (years)", flag: "👶"),
        Region(code: "EU", name: "Europe (cm)", flag: "🇪🇺"),
        Region(code: "US", name: "United States", flag: "🇺🇸"),
        Region(code: "UK", name: "United Kingdom", flag: "🇬🇧"),
    ], sizes: [
        ["2-3", "92-98", "2T-3T", "2-3"],
        ["3-4", "98-104", "4T", "3-4"],
        ["4-5", "104-110", "5", "4-5"],
        ["5-6", "110-116", "6", "5-6"],
        ["6-7", "116-122", "6X-7", "6-7"],
        ["7-8", "122-128", "8", "7-8"],
        ["8-10", "128-140", "10", "8-10"],
        ["10-12", "140-152", "12", "10-12"],
    ])
}

#Preview {
    NavigationStack {
        SizesView()
    }
    .environment(\.tokens, .light)
}
