import Foundation

enum ScoringFormula {
    /// Computes idea score from 3 sliders (each 1–10). Returns 1–100.
    ///
    /// Formula: `round((impact + alignment - effort + 10) × 3.33)`
    /// - All at 5: (5 + 5 - 5 + 10) × 3.33 = 49.95 → 50
    /// - All at 10: (10 + 10 - 10 + 10) × 3.33 = 66.6 → 67... clamped to max 100
    /// - Max score: impact=10, effort=1, alignment=10 → (10 + 10 - 1 + 10) × 3.33 = 96.57 → 97
    static func compute(impact: Int, effort: Int, alignment: Int) -> Int {
        let raw = Double(impact + alignment - effort + 10) * 3.33
        return max(1, min(100, Int(raw.rounded())))
    }
}
