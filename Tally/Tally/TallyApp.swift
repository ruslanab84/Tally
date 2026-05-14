import SwiftUI

@main
struct TallyApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("appLanguage") private var appLanguage = "en"
    @AppStorage("accentColor") private var accentColor = "orange"

    private var lang: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .en
    }

    private var accentTheme: AccentTheme {
        AccentTheme(rawValue: accentColor) ?? .orange
    }

    private var tokens: TallyTokens {
        let base: TallyTokens = isDarkMode ? .dark : .light
        return base.withAccent(accentTheme, isDark: isDarkMode)
    }

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(isDarkMode: $isDarkMode, appLanguage: $appLanguage, accentColor: $accentColor)
                    .environment(\.tokens, tokens)
                    .environment(\.loc, Loc.forLanguage(lang))
                    .preferredColorScheme(isDarkMode ? .dark : .light)

                if showSplash {
                    SplashView(T: tokens)
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                showSplash = false
                            }
                        }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct ContentView: View {
    @Environment(\.loc) private var L
    @Environment(\.tokens) private var T
    @Binding var isDarkMode: Bool
    @Binding var appLanguage: String
    @Binding var accentColor: String
    @State private var selectedTab: Tab = .home
    @State private var navigationPath = NavigationPath()

    enum Tab {
        case home, history, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $navigationPath) {
                HubView(navigationPath: $navigationPath)
                    .navigationDestination(for: Screen.self) { screen in
                        screenView(for: screen)
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text(L.tabHome)
            }
            .tag(Tab.home)

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text(L.tabHistory)
            }
            .tag(Tab.history)

            NavigationStack {
                SettingsView(isDarkMode: $isDarkMode, appLanguage: $appLanguage, accentColor: $accentColor)
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text(L.tabSettings)
            }
            .tag(Tab.settings)
        }
        .tint(T.accent)
    }

    @ViewBuilder
    private func screenView(for screen: Screen) -> some View {
        switch screen {
        case .simple:     SimpleCalcView()
        case .scientific: SciCalcView()
        case .currency:   CurrencyView()
        case .units:      UnitsView()
        case .temp:       TempView()
        case .date:       DateTimeView()
        case .sizes:      SizesView()
        case .tip:        TipView()
        case .finance:    FinanceView()
        case .bmi:        BMIView()
        case .engineering: EngineeringView()
        case .crypto:      CryptoView()
        case .inflation:   InflationView()
        case .vat:         VATView()
        }
    }
}

enum Screen: String, Hashable {
    case simple, scientific, currency, units, temp, date, sizes, tip, finance, bmi, engineering, crypto, inflation, vat
}
