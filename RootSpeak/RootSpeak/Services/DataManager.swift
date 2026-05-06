import Foundation
import SwiftData

@Observable
final class DataManager {
    var useCloudKit: Bool = false {
        didSet {
            UserDefaults.standard.set(useCloudKit, forKey: "useCloudKit")
        }
    }

    init() {
        self.useCloudKit = UserDefaults.standard.bool(forKey: "useCloudKit")
    }

    static let starterLanguages: [(name: String, nativeName: String)] = [
        ("Navajo", "Dine bizaad"),
        ("Lakota", "Lakotiya"),
        ("Cherokee", "Tsalagi"),
        ("Ojibwe", "Anishinaabemowin"),
        ("Hawaiian", "Olelo Hawaii"),
        ("Maori", "Te Reo Maori"),
        ("Cree", "Nehiyawewin"),
        ("Inuktitut", "Inuktitut"),
        ("Choctaw", "Chahta Anumpa"),
        ("Mohawk", "Kanienkeha")
    ]

    func createStarterData(context: ModelContext) {
        let languageDescriptor = FetchDescriptor<Language>()
        let existingLanguages = (try? context.fetch(languageDescriptor)) ?? []
        guard existingLanguages.isEmpty else { return }

        for lang in Self.starterLanguages {
            let language = Language(name: lang.name, nativeName: lang.nativeName)
            context.insert(language)
        }
        try? context.save()
    }

    func cardsDueToday(in deck: Deck) -> Int {
        let now = Date()
        return deck.cards.filter { card in
            guard let lastReview = card.reviews.last else { return true }
            return lastReview.nextReviewDate <= now
        }.count
    }

    func totalCardsDue(in decks: [Deck]) -> Int {
        decks.reduce(0) { $0 + cardsDueToday(in: $1) }
    }

    func currentStreak(for deck: Deck) -> Int {
        guard let progress = deck.progressList.first else { return 0 }
        return progress.streakDays
    }

    func updateStreak(progress: Progress) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastReview = progress.lastReviewDate {
            let lastDay = calendar.startOfDay(for: lastReview)
            let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if daysBetween == 1 {
                progress.streakDays += 1
            } else if daysBetween > 1 {
                progress.streakDays = 1
            }
        } else {
            progress.streakDays = 1
        }

        if progress.streakDays > progress.longestStreak {
            progress.longestStreak = progress.streakDays
        }
        progress.lastReviewDate = Date()
    }
}
