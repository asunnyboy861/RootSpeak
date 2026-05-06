import SwiftUI
import SwiftData

struct StudySessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var isShowingAnswer = false
    @State private var scheduler = FSRSScheduler()
    @State private var showResults = false
    @State private var sessionReviews: [(card: Card, rating: FSRSScheduler.Rating)] = []
    @State private var audioEngine = AudioEngine()

    let cards: [Card]

    private var currentCard: Card? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    private var progress: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(currentIndex) / Double(cards.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                progressBar
                Spacer()
                if showResults {
                    resultsView
                } else if let card = currentCard {
                    cardView(card)
                } else {
                    completionView
                }
                Spacer()
            }
            .navigationTitle("Study Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End") { dismiss() }
                }
            }
        }
    }

    private var progressBar: some View {
        ProgressView(value: progress)
            .progressViewStyle(.linear)
            .padding(.horizontal)
            .padding(.top, 4)
    }

    private func cardView(_ card: Card) -> some View {
        VStack(spacing: 32) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 8)

                VStack(spacing: 20) {
                    Text(card.frontText)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .multilineTextAlignment(.center)

                    if let phonetic = card.phoneticText {
                        Text(phonetic)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    if let audioFile = card.audioFileName {
                        Button {
                            try? audioEngine.play(fileName: audioFile)
                        } label: {
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .padding(32)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            if isShowingAnswer {
                answerSection(card)
            } else {
                Button("Show Answer") {
                    withAnimation(.spring(duration: 0.4)) {
                        isShowingAnswer = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
    }

    private func answerSection(_ card: Card) -> some View {
        VStack(spacing: 16) {
            Text(card.backText)
                .font(.title2)
                .foregroundStyle(.secondary)

            if let backAudio = card.backAudioFileName {
                Button {
                    try? audioEngine.play(fileName: backAudio)
                } label: {
                    Label("Hear English", systemImage: "speaker.wave.2")
                }
                .buttonStyle(.bordered)
            }

            Divider()

            Text("How well did you know this?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ratingButton("Again", color: .red, tag: .again)
                ratingButton("Hard", color: .orange, tag: .hard)
                ratingButton("Good", color: .green, tag: .good)
                ratingButton("Easy", color: .blue, tag: .easy)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func ratingButton(_ title: String, color: Color, tag: FSRSScheduler.Rating) -> some View {
        Button {
            handleRating(tag)
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(color)
        }
    }

    private func handleRating(_ rating: FSRSScheduler.Rating) {
        guard let card = currentCard else { return }
        sessionReviews.append((card: card, rating: rating))

        let result: FSRSScheduler.SchedulingResult
        if card.reviews.isEmpty {
            result = scheduler.initialSchedule(rating: rating)
        } else {
            let lastReview = card.reviews.last!
            result = scheduler.schedule(
                currentDifficulty: lastReview.difficulty,
                currentStability: lastReview.stability,
                rating: rating,
                elapsedDays: lastReview.elapsedDays
            )
        }

        let review = Review(rating: rating.rawValue, nextReviewDate: result.nextReview)
        review.difficulty = result.difficulty
        review.stability = result.stability
        review.retrievability = result.retrievability
        review.scheduledDays = result.interval
        review.card = card
        card.reviews.append(review)

        withAnimation {
            isShowingAnswer = false
            currentIndex += 1
            if currentIndex >= cards.count {
                showResults = true
            }
        }
    }

    private var resultsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            Text("Session Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)

            let againCount = sessionReviews.filter { $0.rating == .again }.count
            let hardCount = sessionReviews.filter { $0.rating == .hard }.count
            let goodCount = sessionReviews.filter { $0.rating == .good }.count
            let easyCount = sessionReviews.filter { $0.rating == .easy }.count

            HStack(spacing: 20) {
                statBadge(count: againCount, label: "Again", color: .red)
                statBadge(count: hardCount, label: "Hard", color: .orange)
                statBadge(count: goodCount, label: "Good", color: .green)
                statBadge(count: easyCount, label: "Easy", color: .blue)
            }

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
    }

    private func statBadge(count: Int, label: String, color: Color) -> some View {
        VStack {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var completionView: some View {
        ContentUnavailableView(
            "No Cards Due",
            systemImage: "checkmark.circle",
            description: Text("All cards have been reviewed for today!")
        )
    }
}

#Preview {
    StudySessionView(cards: [])
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
