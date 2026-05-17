import SwiftUI
import FirebaseCore

@main
struct TallyApp: App {
    init() {
        FirebaseApp.configure()
    }

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

    enum Tab {
        case home, history, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HubView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "house.fill")
                Text(L.tabHome)
            }
            .tag(Tab.home)

            NavigationView {
                HistoryView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "clock.fill")
                Text(L.tabHistory)
            }
            .tag(Tab.history)

            NavigationView {
                SettingsView(isDarkMode: $isDarkMode, appLanguage: $appLanguage, accentColor: $accentColor)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text(L.tabSettings)
            }
            .tag(Tab.settings)
        }
        .tint(T.accent)
    }
}

enum Screen: String, Hashable {
    case simple, scientific, currency, units, temp, date, sizes, tip, finance, bmi, engineering, crypto, inflation, vat
}
