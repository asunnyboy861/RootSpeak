import SwiftUI
import SwiftData

struct DeckCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var subtitle = ""
    @State private var selectedLanguage = "Navajo"
    @State private var category = ""

    private let languages = DataManager.starterLanguages.map(\.name)

    var body: some View {
        NavigationStack {
            Form {
                Section("Deck Info") {
                    TextField("Title", text: $title)
                    TextField("Subtitle (optional)", text: $subtitle)
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang).tag(lang)
                        }
                    }
                    TextField("Category (optional)", text: $category)
                }
            }
            .navigationTitle("New Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createDeck()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func createDeck() {
        let deck = Deck(title: title, languageName: selectedLanguage)
        deck.subtitle = subtitle.isEmpty ? nil : subtitle
        deck.category = category.isEmpty ? nil : category
        let progress = Progress()
        progress.deck = deck
        deck.progressList.append(progress)
        modelContext.insert(deck)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    DeckCreationView()
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
