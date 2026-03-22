import SwiftUI

struct LegacyStats: View {
    let questsShipped: Int
    let totalXP: Int
    let duelWins: Int
    let duelLosses: Int

    var body: some View {
        HStack(spacing: 8) {
            statCell(
                value: String(format: "%02d", questsShipped),
                label: "Shipped",
                color: Color.hero
            )
            statCell(
                value: formatXP(totalXP),
                label: "XP",
                color: Color.victory
            )
            duelCell
        }
    }

    private func statCell(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.brand(.display))
                .foregroundStyle(color)
            Text(label)
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.heroDeep.opacity(0.05), radius: 8, y: 2)
    }

    private var duelCell: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Text("\(duelWins)")
                    .font(.brand(.display))
                    .foregroundStyle(Color.hero)
                Text("-")
                    .font(.brand(.display))
                    .foregroundStyle(Color.textLight)
                Text("\(duelLosses)")
                    .font(.brand(.display))
                    .foregroundStyle(Color.rival)
            }
            Text("Duel W-L")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            LinearGradient(colors: [Color.heroBG, Color.rivalBG], startPoint: .leading, endPoint: .trailing),
            in: RoundedRectangle(cornerRadius: 16)
        )
    }

    private func formatXP(_ xp: Int) -> String {
        if xp >= 1000 {
            return String(format: "%.1fk", Double(xp) / 1000.0)
        }
        return "\(xp)"
    }
}
