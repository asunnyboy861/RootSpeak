import SwiftData
import Foundation

@Model
final class Card {
    @Attribute(.unique) var id: UUID
    var frontText: String
    var backText: String
    var phoneticText: String?
    var audioFileName: String?
    var backAudioFileName: String?
    var imageFileName: String?
    var category: String?
    var notes: String?
    var sortOrder: Int
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Review.card)
    var reviews: [Review] = []

    var deck: Deck?

    init(frontText: String, backText: String) {
        self.id = UUID()
        self.frontText = frontText
        self.backText = backText
        self.sortOrder = 0
        self.createdAt = Date()
    }
}
