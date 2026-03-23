import SwiftUI

struct VaultStats: View {
    let ideas: [Idea]

    private var highScoreCount: Int {
        ideas.filter { ($0.computedScore ?? 0) >= 70 }.count
    }

    private var avgScore: Int {
        guard !ideas.isEmpty else { return 0 }
        let total = ideas.compactMap(\.computedScore).reduce(0, +)
        let count = ideas.compactMap(\.computedScore).count
        guard count > 0 else { return 0 }
        return total / count
    }

    var body: some View {
        HStack(spacing: 8) {
            statCell(value: "\(ideas.count)", label: "Total")
            statCell(value: "\(highScoreCount)", label: "High", color: Color.victory)
            statCell(value: "\(avgScore)", label: "Avg", color: Color.streak)
        }
    }

    private func statCell(value: String, label: String, color: Color = Color.hero) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.brand(.headline))
                .foregroundStyle(color)
            Text(label)
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.cardShadow, radius: 8, y: 2)
    }
}
