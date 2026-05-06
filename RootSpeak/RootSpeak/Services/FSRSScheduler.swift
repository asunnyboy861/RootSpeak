import Foundation

struct FSRSScheduler {
    struct FSRSParameters {
        var w: [Double] = [
            0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01,
            1.49, 0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61
        ]
        var requestRetention: Double = 0.9
        var maximumInterval: Int = 365
        var easyBonus: Double = 1.3
        var hardIntervalChange: Double = 1.2
    }

    let params: FSRSParameters

    init(params: FSRSParameters = FSRSParameters()) {
        self.params = params
    }

    enum Rating: Int {
        case again = 1
        case hard = 2
        case good = 3
        case easy = 4
    }

    struct SchedulingResult {
        var difficulty: Double
        var stability: Double
        var retrievability: Double
        var interval: Int
        var nextReview: Date
    }

    func schedule(
        currentDifficulty: Double,
        currentStability: Double,
        rating: Rating,
        elapsedDays: Int
    ) -> SchedulingResult {
        let d = nextDifficulty(current: currentDifficulty, rating: rating)
        let s = nextStability(
            current: currentStability,
            difficulty: d,
            rating: rating,
            elapsedDays: elapsedDays
        )
        let r = retrievability(stability: s, elapsedDays: elapsedDays)
        let interval = nextInterval(stability: s)

        return SchedulingResult(
            difficulty: d,
            stability: s,
            retrievability: r,
            interval: interval,
            nextReview: Calendar.current.date(
                byAdding: .day, value: interval, to: Date()
            )!
        )
    }

    func initialSchedule(rating: Rating) -> SchedulingResult {
        let d = initialDifficulty(rating: rating)
        let s = initialStability(rating: rating)
        let interval = nextInterval(stability: s)

        return SchedulingResult(
            difficulty: d,
            stability: s,
            retrievability: 1.0,
            interval: interval,
            nextReview: Calendar.current.date(
                byAdding: .day, value: interval, to: Date()
            )!
        )
    }

    private func initialDifficulty(rating: Rating) -> Double {
        return max(1.0, params.w[0] + params.w[1] * (Double(rating.rawValue) - 3))
    }

    private func initialStability(rating: Rating) -> Double {
        return max(params.w[2], params.w[2] + params.w[3] * (Double(rating.rawValue) - 1))
    }

    private func nextDifficulty(current: Double, rating: Rating) -> Double {
        let delta = params.w[4] * (initialDifficulty(rating: rating) - current)
        let meanRevert = params.w[5] * (params.w[0] - current)
        return clamp(current + delta + meanRevert, min: 1.0, max: 10.0)
    }

    private func nextStability(
        current: Double,
        difficulty: Double,
        rating: Rating,
        elapsedDays: Int
    ) -> Double {
        switch rating {
        case .again:
            return max(params.w[6], current * params.w[7] * pow(difficulty, -params.w[8]))
        case .hard:
            return current * (1 + params.w[9] * pow(difficulty, -params.w[10]))
        case .good:
            let r = retrievability(stability: current, elapsedDays: elapsedDays)
            return current * (1 + params.w[11] * pow(difficulty, -params.w[12]) * (exp(params.w[13] * (1 - r)) - 1))
        case .easy:
            let r = retrievability(stability: current, elapsedDays: elapsedDays)
            return current * (1 + params.w[14] * pow(difficulty, -params.w[15]) * (exp(params.w[16] * (1 - r)) - 1))
        }
    }

    private func retrievability(stability: Double, elapsedDays: Int) -> Double {
        guard elapsedDays > 0 else { return 1.0 }
        return pow(1 + Double(elapsedDays) / (9 * stability), -1)
    }

    private func nextInterval(stability: Double) -> Int {
        let interval = 9 * stability * (1 / params.requestRetention - 1)
        return min(max(1, Int(round(interval))), params.maximumInterval)
    }

    private func clamp(_ value: Double, min: Double, max: Double) -> Double {
        return Swift.min(Swift.max(value, min), max)
    }
}
