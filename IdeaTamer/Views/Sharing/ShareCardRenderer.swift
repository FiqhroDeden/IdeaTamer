import SwiftUI

// MARK: - Progress Share Card (Focus tab — in-progress quest)

struct ProgressShareCard: View {
    let title: String
    let progress: Double
    let milestones: [(title: String, done: Bool)]

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1B6EF2"), Color(hex: "0A4FBD")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                    Text("QUEST IN PROGRESS")
                        .font(.system(size: 11, weight: .heavy))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(height: 140)

            VStack(spacing: 16) {
                Text(title)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(Color(hex: "2E2F2F"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text("\(Int(progress * 100))% complete")
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(Color(hex: "1B6EF2"))

                // Milestone checklist
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(milestones.prefix(6).enumerated()), id: \.offset) { _, m in
                        HStack(spacing: 8) {
                            Image(systemName: m.done ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 14))
                                .foregroundStyle(m.done ? Color(hex: "12B76A") : Color(hex: "E3E2E0"))
                            Text(m.title)
                                .font(.system(size: 12, weight: m.done ? .regular : .semibold))
                                .foregroundStyle(m.done ? Color(hex: "8A8B8A") : Color(hex: "2E2F2F"))
                                .strikethrough(m.done)
                                .lineLimit(1)
                        }
                    }
                    if milestones.count > 6 {
                        Text("+\(milestones.count - 6) more...")
                            .font(.system(size: 11))
                            .foregroundStyle(Color(hex: "8A8B8A"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color(hex: "F1F0EF"), in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 6) {
                    Text("One quest at a time. No distractions.")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(hex: "5B5C5B"))
                    brandingRow
                }
            }
            .padding(20)
            .background(Color.white)
        }
        .frame(width: 390, height: CGFloat(380 + min(milestones.count, 6) * 24))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var brandingRow: some View {
        HStack(spacing: 6) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text("IdeaTamer")
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(Color(hex: "1B6EF2"))
        }
    }
}

// MARK: - Quest Shipped Card (Done tab — completed quest)

struct QuestShareCard: View {
    let title: String
    let score: Int?
    let completionDays: Int?
    let xpEarned: Int
    let milestoneCount: Int

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "12B76A"), Color(hex: "0D7A48")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                    Text("QUEST SHIPPED")
                        .font(.system(size: 11, weight: .heavy))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(height: 160)

            VStack(spacing: 18) {
                Text(title)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                    .foregroundStyle(Color(hex: "2E2F2F"))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                Text("Another idea shipped. Another level up.")
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color(hex: "8A8B8A"))
                    .italic()

                HStack(spacing: 10) {
                    if let score {
                        statPill(label: "SCORE", value: "\(score)", color: Color.scoreColor(score))
                    }
                    if let days = completionDays {
                        statPill(label: "SHIPPED IN", value: "\(days)d", color: Color(hex: "1B6EF2"))
                    }
                    statPill(label: "XP EARNED", value: "+\(xpEarned)", color: Color(hex: "12B76A"))
                    if milestoneCount > 0 {
                        statPill(label: "MILESTONES", value: "\(milestoneCount)", color: Color(hex: "F5A623"))
                    }
                }

                VStack(spacing: 6) {
                    Text("Stop collecting ideas. Start finishing them.")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(hex: "5B5C5B"))
                    brandingRow
                }
            }
            .padding(24)
            .background(Color.white)
        }
        .frame(width: 390, height: 480)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func statPill(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("PlusJakartaSans-Bold", size: 16))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 7, weight: .bold))
                .tracking(0.5)
                .foregroundStyle(Color(hex: "8A8B8A"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
    }

    private var brandingRow: some View {
        HStack(spacing: 6) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text("IdeaTamer")
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(Color(hex: "1B6EF2"))
        }
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
        if won >= 3 { return Color(hex: "12B76A") }
        if won == 2 { return Color(hex: "F5A623") }
        return Color(hex: "E5432A")
    }

    private var motivationalText: String {
        if won >= 3 { return "Beat my past self this week. The only rival that matters." }
        if won == 2 { return "Tied with my past self. Next week I go harder." }
        return "Lost to my past self. But I'll be back stronger."
    }

    private var headerColors: [Color] {
        if won >= 3 { return [Color(hex: "12B76A"), Color(hex: "0D7A48")] }
        if won == 2 { return [Color(hex: "F5A623"), Color(hex: "B87A0A")] }
        return [Color(hex: "E5432A"), Color(hex: "B22D18")]
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(colors: headerColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack(spacing: 8) {
                    Image(systemName: "figure.fencing")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                    Text("WEEKLY DUEL")
                        .font(.system(size: 11, weight: .heavy))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(height: 160)

            VStack(spacing: 16) {
                Text(resultText)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 32))
                    .foregroundStyle(resultColor)

                HStack(spacing: 6) {
                    Text("\(won)")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 48))
                        .foregroundStyle(Color(hex: "1B6EF2"))
                    Text(":")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 48))
                        .foregroundStyle(Color(hex: "8A8B8A"))
                    Text("\(lost)")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 48))
                        .foregroundStyle(Color(hex: "E5432A"))
                }

                MomentumBadge(value: momentum)

                Text(motivationalText)
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color(hex: "5B5C5B"))
                    .italic()
                    .multilineTextAlignment(.center)

                VStack(spacing: 6) {
                    Text("Compete with yourself. Ship ideas.")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(hex: "5B5C5B"))
                    HStack(spacing: 6) {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text("IdeaTamer")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(Color(hex: "1B6EF2"))
                    }
                }
            }
            .padding(24)
            .background(Color.white)
        }
        .frame(width: 390, height: 520)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
