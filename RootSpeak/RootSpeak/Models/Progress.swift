import SwiftData
import Foundation

@Model
final class Progress {
    @Attribute(.unique) var id: UUID
    var totalReviews: Int
    var correctCount: Int
    var streakDays: Int
    var longestStreak: Int
    var lastReviewDate: Date?
    var retentionRate: Double

    var deck: Deck?

    init() {
        self.id = UUID()
        self.totalReviews = 0
        self.correctCount = 0
        self.streakDays = 0
        self.longestStreak = 0
        self.retentionRate = 0.0
    }
}
