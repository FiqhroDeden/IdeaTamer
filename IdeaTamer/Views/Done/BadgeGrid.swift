import SwiftUI

struct BadgeGrid: View {
    let unlockedBadges: [String]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Badges")
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(BadgeType.allCases) { badge in
                    badgeCell(badge: badge, isUnlocked: unlockedBadges.contains(badge.rawValue))
                }
            }
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 24))
    }

    private func badgeCell(badge: BadgeType, isUnlocked: Bool) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? badgeColor(badge).opacity(0.15) : Color.surfaceHigh)
                    .frame(width: 36, height: 36)
                Image(systemName: badge.sfSymbol)
                    .font(.system(size: 16))
                    .foregroundStyle(isUnlocked ? badgeColor(badge) : Color.textLight)
            }
            Text(badge.displayName)
                .font(.brand(.label))
                .fontWeight(.bold)
                .foregroundStyle(isUnlocked ? Color.textPrimary : Color.textLight)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.cardShadow, radius: 4, y: 1)
        .opacity(isUnlocked ? 1 : 0.4)
    }

    private func badgeColor(_ badge: BadgeType) -> Color {
        switch badge {
        case .firstBlood, .polisher, .moonshot: return Color.victory
        case .streak7, .streakMaster: return Color.streak
        case .superFocus: return Color.hero
        case .selfSurpassed: return Color.rival
        }
    }
}
