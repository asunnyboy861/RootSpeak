import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deck.updatedAt, order: .reverse) private var decks: [Deck]
    @State private var dataManager = DataManager()
    @State private var showingStudySession = false
    @State private var selectedDeck: Deck?

    private var dueCardsCount: Int {
        dataManager.totalCardsDue(in: decks)
    }

    private var totalStreak: Int {
        decks.reduce(0) { max($0, dataManager.currentStreak(for: $1)) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    dailyReviewCard
                    recentDecksSection
                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle("RootSpeak")
            .onAppear {
                dataManager.createStarterData(context: modelContext)
            }
            .sheet(item: $selectedDeck) { deck in
                StudySessionView(cards: dueCards(in: deck))
            }
        }
    }

    private var dailyReviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.title2)
                Text("\(totalStreak) Day Streak")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }

            HStack {
                Text("\(dueCardsCount) cards due today")
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Button {
                if let firstDeckWithDue = decks.first(where: { dataManager.cardsDueToday(in: $0) > 0 }) {
                    selectedDeck = firstDeckWithDue
                }
            } label: {
                HStack {
                    Text("Start Daily Review")
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(dueCardsCount == 0)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var recentDecksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Decks")
                .font(.headline)

            if decks.isEmpty {
                ContentUnavailableView(
                    "No Decks Yet",
                    systemImage: "square.stack.3d.up.slash",
                    description: Text("Create your first deck to start learning")
                )
                .frame(height: 120)
            } else {
                ForEach(decks.prefix(5)) { deck in
                    NavigationLink(destination: DeckDetailView(deck: deck)) {
                        DeckRowView(deck: deck, dueCount: dataManager.cardsDueToday(in: deck))
                    }
                }
            }
        }
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)

            HStack(spacing: 12) {
                NavigationLink(destination: DeckCreationView()) {
                    Label("New Deck", systemImage: "plus.square")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink(destination: DeckListView()) {
                    Label("All Decks", systemImage: "square.stack.3d.up")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func dueCards(in deck: Deck) -> [Card] {
        let now = Date()
        return deck.cards.filter { card in
            guard let lastReview = card.reviews.last else { return true }
            return lastReview.nextReviewDate <= now
        }
    }
}

struct DeckRowView: View {
    let deck: Deck
    let dueCount: Int

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "square.stack.3d.up")
                        .foregroundStyle(Color.accentColor)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(deck.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(deck.cardCount) cards")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if dueCount > 0 {
                Text("\(dueCount)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor, in: Capsule())
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
