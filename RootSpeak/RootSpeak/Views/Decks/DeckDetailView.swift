import SwiftUI
import SwiftData

struct DeckDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let deck: Deck
    @State private var showingStudySession = false
    @State private var showingCardCreation = false
    @State private var dataManager = DataManager()
    @State private var audioEngine = AudioEngine()

    private var dueCards: [Card] {
        let now = Date()
        return deck.cards.filter { card in
            guard let lastReview = card.reviews.last else { return true }
            return lastReview.nextReviewDate <= now
        }
    }

    private var streak: Int {
        dataManager.currentStreak(for: deck)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                statsCard
                studyButton
                cardsList
            }
            .padding()
        }
        .navigationTitle(deck.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingCardCreation = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingStudySession) {
            StudySessionView(cards: dueCards)
        }
        .sheet(isPresented: $showingCardCreation) {
            CardCreationView(deck: deck)
        }
    }

    private var statsCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                StatItem(value: "\(deck.cardCount)", label: "Cards", icon: "square.on.square")
                StatItem(value: "\(dueCards.count)", label: "Due", icon: "clock")
                StatItem(value: "\(streak)", label: "Streak", icon: "flame")
            }

            if let progress = deck.progressList.first, progress.totalReviews > 0 {
                HStack {
                    Text("Retention: \(Int(progress.retentionRate * 100))%")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Reviews: \(progress.totalReviews)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var studyButton: some View {
        Button {
            showingStudySession = true
        } label: {
            HStack {
                Image(systemName: "book.fill")
                Text("Study Now")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(dueCards.isEmpty)
    }

    private var cardsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards")
                .font(.headline)

            if deck.cards.isEmpty {
                ContentUnavailableView(
                    "No Cards Yet",
                    systemImage: "rectangle.on.rectangle.angled",
                    description: Text("Add your first flashcard")
                )
                .frame(height: 120)
            } else {
                ForEach(deck.cards.sorted(by: { $0.sortOrder < $1.sortOrder })) { card in
                    CardRowView(card: card, audioEngine: audioEngine)
                }
            }
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.accent)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CardRowView: View {
    let card: Card
    @State var audioEngine: AudioEngine

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(card.frontText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(card.backText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if card.audioFileName != nil {
                Button {
                    try? audioEngine.play(fileName: card.audioFileName!)
                } label: {
                    Image(systemName: "speaker.wave.2")
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        DeckDetailView(deck: Deck(title: "Sample", languageName: "Navajo"))
            .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
    }
}
