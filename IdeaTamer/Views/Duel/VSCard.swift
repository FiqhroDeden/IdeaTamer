import SwiftUI

struct VSCard: View {
    let won: Int
    let lost: Int
    let momentum: Double
    let isFirstWeek: Bool

    private var statusText: String {
        if won > lost { return "You lead" }
        if lost > won { return "Shadow leads" }
        return "Tied"
    }

    private var statusColor: Color {
        if won > lost { return Color.victory }
        if lost > won { return Color.rival }
        return Color.textMid
    }

    var body: some View {
        VStack(spacing: 16) {
            avatarRow
            if !isFirstWeek {
                momentumSection
            }
        }
        .padding(20)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.cardShadow, radius: 14, y: 4)
    }

    // MARK: - Avatars

    private var avatarRow: some View {
        HStack {
            avatarColumn(label: "This week", color: Color.hero, icon: nil, letter: "Y", isHero: true)
            Spacer()
            scoreDisplay
            Spacer()
            avatarColumn(label: "Past you", color: Color.rival, icon: "person.fill", letter: nil, isHero: false)
        }
    }

    private func avatarColumn(label: String, color: Color, icon: String?, letter: String?, isHero: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                    .shadow(color: color.opacity(0.2), radius: 4)
                if let letter {
                    Text(letter)
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(.white)
                } else if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
            }
            Text(label)
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(color)
        }
    }

    private var scoreDisplay: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("\(won)")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(Color.textPrimary)
                Text(":")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(Color.textLight)
                Text("\(lost)")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(Color.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))

            Text(statusText)
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(statusColor)
        }
    }

    // MARK: - Momentum

    private var momentumSection: some View {
        HStack(spacing: 6) {
            Text("MOMENTUM")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textMid)
            Spacer()
            MomentumBadge(value: momentum)
        }
        .padding(12)
        .background(
            momentum >= 0
                ? Color.victoryBG.opacity(0.5)
                : Color.rivalBG.opacity(0.5),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}
