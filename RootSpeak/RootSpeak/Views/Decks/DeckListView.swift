import SwiftUI
import SwiftData

struct DeckListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deck.updatedAt, order: .reverse) private var decks: [Deck]
    @State private var searchText = ""
    @State private var dataManager = DataManager()

    private var filteredDecks: [Deck] {
        if searchText.isEmpty {
            return decks
        }
        return decks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.languageName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            ForEach(filteredDecks) { deck in
                NavigationLink(destination: DeckDetailView(deck: deck)) {
                    DeckRowView(deck: deck, dueCount: dataManager.cardsDueToday(in: deck))
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .onDelete(perform: deleteDecks)
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search decks...")
        .navigationTitle("All Decks")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: DeckCreationView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func deleteDecks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredDecks[index])
        }
    }
}

#Preview {
    NavigationStack {
        DeckListView()
            .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
    }
}
