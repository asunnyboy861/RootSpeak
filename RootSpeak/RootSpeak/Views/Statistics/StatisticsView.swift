import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query private var decks: [Deck]
    @State private var dataManager = DataManager()

    private var totalReviews: Int {
        decks.reduce(0) { $0 + ($1.progressList.first?.totalReviews ?? 0) }
    }

    private var totalCards: Int {
        decks.reduce(0) { $0 + $1.cardCount }
    }

    private var bestStreak: Int {
        decks.reduce(0) { max($0, $1.progressList.first?.longestStreak ?? 0) }
    }

    private var averageRetention: Double {
        let decksReviewed = decks.filter { ($0.progressList.first?.totalReviews ?? 0) > 0 }
        guard !decksReviewed.isEmpty else { return 0 }
        let total = decksReviewed.reduce(0.0) { $0 + ($1.progressList.first?.retentionRate ?? 0) }
        return total / Double(decksReviewed.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                overviewStats
                deckBreakdown
            }
            .padding()
        }
        .navigationTitle("Statistics")
    }

    private var overviewStats: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(value: "\(totalReviews)", label: "Total Reviews", icon: "repeat", color: .blue)
                StatCard(value: "\(totalCards)", label: "Total Cards", icon: "square.on.square", color: .green)
                StatCard(value: "\(bestStreak)", label: "Best Streak", icon: "flame.fill", color: .orange)
                StatCard(value: "\(Int(averageRetention * 100))%", label: "Retention", icon: "chart.line.uptrend.xyaxis", color: .purple)
            }
        }
    }

    private var deckBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Deck Breakdown")
                .font(.headline)

            if decks.isEmpty {
                ContentUnavailableView(
                    "No Data Yet",
                    systemImage: "chart.bar",
                    description: Text("Start studying to see your statistics")
                )
                .frame(height: 120)
            } else {
                ForEach(decks) { deck in
                    DeckStatRow(deck: deck)
                }
            }
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct DeckStatRow: View {
    let deck: Deck

    private var progress: Progress? {
        deck.progressList.first
    }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(deck.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(deck.languageName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(deck.cardCount) cards")
                    .font(.caption)
                if let p = progress, p.totalReviews > 0 {
                    Text("\(Int(p.retentionRate * 100))% retention")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        StatisticsView()
            .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
    }
}
