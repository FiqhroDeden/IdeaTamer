import Testing
@testable import IdeaTamer

struct ScoringFormulaTests {

    @Test func allSlidersAtFive_returnsFifty() {
        let score = ScoringFormula.compute(impact: 5, effort: 5, alignment: 5)
        #expect(score == 50)
    }

    @Test func allSlidersAtTen_clampedToHundred() {
        // (10 + 10 - 10 + 10) × 3.33 = 66.6 → 67
        let score = ScoringFormula.compute(impact: 10, effort: 10, alignment: 10)
        #expect(score == 67)
    }

    @Test func allSlidersAtOne() {
        // (1 + 1 - 1 + 10) × 3.33 = 36.63 → 37
        let score = ScoringFormula.compute(impact: 1, effort: 1, alignment: 1)
        #expect(score == 37)
    }

    @Test func maxScore_highImpactLowEffortHighAlignment() {
        // (10 + 10 - 1 + 10) × 3.33 = 96.57 → 97
        let score = ScoringFormula.compute(impact: 10, effort: 1, alignment: 10)
        #expect(score == 97)
    }

    @Test func minScore_lowImpactHighEffortLowAlignment() {
        // (1 + 1 - 10 + 10) × 3.33 = 6.66 → 7
        let score = ScoringFormula.compute(impact: 1, effort: 10, alignment: 1)
        #expect(score == 7)
    }

    @Test func scoreNeverBelowOne() {
        // Even with extreme values, should be at least 1
        let score = ScoringFormula.compute(impact: 1, effort: 10, alignment: 1)
        #expect(score >= 1)
    }

    @Test func scoreNeverAboveHundred() {
        let score = ScoringFormula.compute(impact: 10, effort: 1, alignment: 10)
        #expect(score <= 100)
    }

    @Test func defaultSliders_produceMiddleScore() {
        // Default slider values are 5. Score should be moderate.
        let score = ScoringFormula.compute(impact: 5, effort: 5, alignment: 5)
        #expect(score >= 40 && score <= 60)
    }
}
