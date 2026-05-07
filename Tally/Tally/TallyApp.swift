import SwiftUI

@main
struct TallyApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView(isDarkMode: $isDarkMode)
                .environment(\.tokens, isDarkMode ? .dark : .light)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct ContentView: View {
    @Binding var isDarkMode: Bool
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
                Text("Home")
            }
            .tag(Tab.home)

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            .tag(Tab.history)

            NavigationStack {
                SettingsView(isDarkMode: $isDarkMode)
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            .tag(Tab.settings)
        }
        .tint(isDarkMode ? TallyTokens.dark.accent : TallyTokens.light.accent)
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
        }
    }
}

enum Screen: String, Hashable {
    case simple, scientific, currency, units, temp, date, sizes, tip
}
