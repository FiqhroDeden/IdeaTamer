import SwiftUI

struct RankedQuestCard: View {
    let idea: Idea
    let rank: Int
    let onActivate: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            rankLabel
            ideaContent
            Spacer()
            if let score = idea.computedScore {
                ScoreBadge(score: score)
            }
        }
        .padding(16)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.heroDeep.opacity(0.07), radius: 14, y: 4)
    }

    // MARK: - Rank

    private var rankLabel: some View {
        Text("#\(rank)")
            .font(.brand(.headline))
            .foregroundStyle(Color.textPrimary.opacity(0.15))
            .italic()
    }

    // MARK: - Content

    private var ideaContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(idea.title)
                .font(.brand(.title))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)

            if let desc = idea.descriptionText, !desc.isEmpty {
                Text(desc)
                    .font(.brand(.caption))
                    .foregroundStyle(Color.textMid)
                    .lineLimit(1)
            }

            activateButton
        }
    }

    // MARK: - Activate

    private var activateButton: some View {
        Button(action: onActivate) {
            HStack(spacing: 4) {
                Text("Activate")
                    .font(.brand(.label))
                    .fontWeight(.bold)
                Image(systemName: "bolt.fill")
                    .font(.caption2)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.hero, in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(.top, 4)
    }
}
