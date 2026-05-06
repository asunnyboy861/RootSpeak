import SwiftData
import Foundation

@Model
final class Review {
    @Attribute(.unique) var id: UUID
    var rating: Int
    var reviewedAt: Date
    var nextReviewDate: Date
    var difficulty: Double
    var stability: Double
    var retrievability: Double
    var elapsedDays: Int
    var scheduledDays: Int

    var card: Card?

    init(rating: Int, nextReviewDate: Date) {
        self.id = UUID()
        self.rating = rating
        self.reviewedAt = Date()
        self.nextReviewDate = nextReviewDate
        self.difficulty = 0.0
        self.stability = 0.0
        self.retrievability = 1.0
        self.elapsedDays = 0
        self.scheduledDays = 0
    }
}
