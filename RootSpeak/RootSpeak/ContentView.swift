import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            NavigationStack {
                DeckListView()
            }
            .tabItem {
                Label("Decks", systemImage: "square.stack.3d.up.fill")
            }
            .tag(1)

            NavigationStack {
                StatisticsView()
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.bar.fill")
            }
            .tag(2)

            SettingsView()
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
