import SwiftUI
import UIKit

struct CompletedQuestDetailSheet: View {
    let idea: Idea
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    questHeader
                    statsSection
                    if !idea.milestones.isEmpty {
                        milestoneHistory
                    }
                    if let desc = idea.descriptionText, !desc.isEmpty {
                        descriptionSection(desc)
                    }
                    shareButton
                }
                .padding(20)
            }
            .navigationTitle("Quest Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: - Header

    private var questHeader: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.victory)
                    .frame(width: 48, height: 48)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            Text(idea.title)
                .font(.brand(.display))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
            if let date = idea.completedAt {
                Text("Shipped \(date, format: .dateTime.month().day().year())")
                    .font(.brand(.caption))
                    .foregroundStyle(Color.textMid)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: 8) {
            if let score = idea.computedScore {
                statCard(label: "Score", value: "\(score)", color: Color.scoreColor(score))
            }
            if let days = idea.completionDays {
                statCard(label: "Days to Ship", value: "\(days)", color: Color.hero)
            }
            statCard(label: "XP Earned", value: "+\(xpValue)", color: Color.victory)
            statCard(label: "Milestones", value: "\(idea.milestones.count)", color: Color.streak)
        }
    }

    private var xpValue: Int {
        if idea.xpEarned > 0 { return idea.xpEarned }
        var xp = XP.capture
        if idea.isScored { xp += XP.score }
        xp += idea.completedMilestoneCount * XP.milestone
        xp += XP.questComplete
        return xp
    }

    private func statCard(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.brand(.title))
                .fontWeight(.heavy)
                .foregroundStyle(color)
            Text(label)
                .font(.brand(.label))
                .textCase(.uppercase)
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Score Breakdown

    private func descriptionSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DESCRIPTION")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
            Text(text)
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Milestone History

    private var milestoneHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MILESTONES COMPLETED")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)

            ForEach(idea.milestones.sorted(by: { $0.sortOrder < $1.sortOrder })) { milestone in
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.victory)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(milestone.title)
                            .font(.brand(.body))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textPrimary)
                        if let date = milestone.completedAt {
                            Text(date, format: .dateTime.month().day())
                                .font(.brand(.caption))
                                .foregroundStyle(Color.textLight)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Share

    private var shareButton: some View {
        Button {
            if let image = ShareCardService.renderQuestCard(idea: idea) {
                ShareHelper.share(image)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Achievement")
                    .fontWeight(.bold)
            }
            .foregroundStyle(Color.hero)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.heroBG, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
