import SwiftUI

// MARK: - Quest Completion Card

struct QuestShareCard: View {
    let title: String
    let score: Int?
    let completionDays: Int?
    let xpEarned: Int

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                Text("QUEST COMPLETE")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                LinearGradient(
                    colors: [Color.hero, Color.heroDim],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            // Content
            VStack(spacing: 16) {
                Text(title)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                HStack(spacing: 16) {
                    if let score {
                        statPill(label: "SCORE", value: "\(score)", color: Color.scoreColor(score))
                    }
                    if let days = completionDays {
                        statPill(label: "DAYS", value: "\(days)", color: Color.hero)
                    }
                    statPill(label: "XP", value: "+\(xpEarned)", color: Color.victory)
                }

                branding
            }
            .padding(24)
            .background(Color.card)
        }
        .frame(width: 390, height: 420)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func statPill(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.brand(.headline))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    private var branding: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.circle.fill")
                .foregroundStyle(Color.hero)
            Text("IdeaTamer")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.textMid)
        }
        .padding(.top, 8)
    }
}

// MARK: - Duel Result Card

struct DuelShareCard: View {
    let won: Int
    let lost: Int
    let momentum: Double

    private var resultText: String {
        if won >= 3 { return "VICTORY" }
        if won == 2 { return "DRAW" }
        return "DEFEATED"
    }

    private var resultColor: Color {
        if won >= 3 { return Color.victory }
        if won == 2 { return Color.streak }
        return Color.rival
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "figure.fencing")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                Text("WEEKLY DUEL")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                LinearGradient(
                    colors: [Color.rival, Color.rivalDim],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            // Content
            VStack(spacing: 16) {
                Text(resultText)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
                    .foregroundStyle(resultColor)

                HStack(spacing: 4) {
                    Text("\(won)")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 40))
                        .foregroundStyle(Color.hero)
                    Text(":")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 40))
                        .foregroundStyle(Color.textLight)
                    Text("\(lost)")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 40))
                        .foregroundStyle(Color.rival)
                }

                MomentumBadge(value: momentum)

                branding
            }
            .padding(24)
            .background(Color.card)
        }
        .frame(width: 390, height: 420)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var branding: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.circle.fill")
                .foregroundStyle(Color.hero)
            Text("IdeaTamer")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.textMid)
        }
        .padding(.top, 8)
    }
}
