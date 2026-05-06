import SwiftData
import Foundation

@Model
final class Language {
    @Attribute(.unique) var id: UUID
    var name: String
    var nativeName: String
    var isoCode: String?
    var region: String?
    var family: String?
    var deckCount: Int
    var speakerCount: String?
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Deck.language)
    var decks: [Deck] = []

    init(name: String, nativeName: String) {
        self.id = UUID()
        self.name = name
        self.nativeName = nativeName
        self.deckCount = 0
        self.createdAt = Date()
    }
}
