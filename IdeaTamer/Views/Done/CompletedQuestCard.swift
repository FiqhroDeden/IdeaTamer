import SwiftUI

struct CompletedQuestCard: View {
    let idea: Idea
    let isLatest: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                dateLabel
                titleLabel
                xpChips
            }
            Spacer()
            medalIcon
        }
        .padding(16)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.heroDeep.opacity(0.07), radius: 14, y: 4)
        .overlay {
            if isLatest {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.hero.opacity(0.15), lineWidth: 1)
            }
        }
    }

    // MARK: - Subviews

    private var dateLabel: some View {
        Group {
            if let date = idea.completedAt {
                Text(date, format: .dateTime.month().day().year())
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.textLight)
            }
        }
    }

    private var titleLabel: some View {
        Text(idea.title)
            .font(.brand(.headline))
            .foregroundStyle(Color.textPrimary)
            .lineLimit(2)
    }

    private var xpChips: some View {
        HStack(spacing: 6) {
            Text("+\(idea.xpEarned) XP")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.victoryDim)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.victoryBG, in: Capsule())

            if let days = idea.completionDays {
                Text("\(days)d to ship")
                    .font(.brand(.label))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.hero)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.heroBG, in: Capsule())
            }
        }
    }

    private var medalIcon: some View {
        ZStack {
            Circle()
                .fill(Color.victory)
                .frame(width: 32, height: 32)
            Image(systemName: "medal.fill")
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
    }
}
