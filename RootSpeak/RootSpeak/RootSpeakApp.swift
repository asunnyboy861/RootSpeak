import SwiftUI
import SwiftData

@main
struct RootSpeakApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
    }
}
