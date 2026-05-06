import SwiftData
import Foundation

@Model
final class Deck {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String?
    var category: String?
    var cardCount: Int
    var createdBy: String?
    var isCommunityDeck: Bool
    var languageName: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Card.deck)
    var cards: [Card] = []

    @Relationship(deleteRule: .cascade, inverse: \Progress.deck)
    var progressList: [Progress] = []

    var language: Language?

    init(title: String, languageName: String) {
        self.id = UUID()
        self.title = title
        self.languageName = languageName
        self.cardCount = 0
        self.isCommunityDeck = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
