import SwiftUI
import SwiftData
import UIKit

struct FocusView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: FocusViewModel?
    @State private var showConfetti = false
    @State private var showXPFloat = false
    @State private var xpAmount = 0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        ZStack {
            if let vm = viewModel {
                if let quest = vm.activeQuest {
                    questContent(quest: quest, vm: vm)
                } else {
                    emptyState
                }
            }

            // Overlays
            ConfettiView(isShowing: $showConfetti)
            XPFloatView(amount: xpAmount, isShowing: $showXPFloat)
                .padding(.top, 100)
        }
        .task {
            viewModel = FocusViewModel(modelContext: modelContext)
        }
    }

    // MARK: - Quest Content

    private func questContent(quest: Idea, vm: FocusViewModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                questHeader
                questCard(quest: quest)
                milestoneSection(quest: quest, vm: vm)
                actionButtons(quest: quest, vm: vm)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Header

    private var questHeader: some View {
        Text("CURRENT FOCUS")
            .font(.brand(.label))
            .textCase(.uppercase)
            .tracking(1.5)
            .foregroundStyle(Color.textLight)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Quest Card

    private func questCard(quest: Idea) -> some View {
        VStack(spacing: 16) {
            ProgressRing(progress: quest.milestoneProgress)

            Text(quest.title)
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            if let desc = quest.descriptionText, !desc.isEmpty {
                Text(desc)
                    .font(.brand(.body))
                    .foregroundStyle(Color.textMid)
                    .multilineTextAlignment(.center)
            }

            questStats(quest: quest)
        }
        .padding(20)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.heroDeep.opacity(0.07), radius: 14, y: 4)
    }

    // MARK: - Stats

    private func questStats(quest: Idea) -> some View {
        HStack(spacing: 12) {
            statCard(
                icon: "clock",
                iconColor: Color.hero,
                label: "STARTED",
                value: quest.activatedAt.map {
                    RelativeDateTimeFormatter().localizedString(for: $0, relativeTo: .now)
                } ?? "—"
            )
            statCard(
                icon: "star.fill",
                iconColor: Color.streak,
                label: "REWARD",
                value: "+500 XP"
            )
        }
    }

    private func statCard(icon: String, iconColor: Color, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.subheadline)
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.textLight)
                Text(value)
                    .font(.brand(.body))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Milestones

    private func milestoneSection(quest: Idea, vm: FocusViewModel) -> some View {
        MilestoneList(idea: quest, viewModel: vm)
    }

    // MARK: - Actions

    private func actionButtons(quest: Idea, vm: FocusViewModel) -> some View {
        VStack(spacing: 10) {
            // Complete Quest
            if quest.milestones.isEmpty || quest.milestoneProgress > 0 {
                Button {
                    withAnimation(.springMedium) {
                        vm.completeQuest(quest)
                        xpAmount = 500
                        showXPFloat = true
                        showConfetti = true
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill")
                        Text("Complete Quest")
                            .fontWeight(.bold)
                        Text("+500 XP")
                            .font(.brand(.label))
                            .opacity(0.8)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.victory, in: RoundedRectangle(cornerRadius: 16))
                }
            }

            // Share Progress
            Button {
                if let image = ShareCardService.renderQuestCard(idea: quest) {
                    shareImage = image
                    showShareSheet = true
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Progress")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.hero)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.heroBG, in: RoundedRectangle(cornerRadius: 16))
            }

            // Park Quest
            Button {
                withAnimation(.springMedium) {
                    vm.parkQuest(quest)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "pause.circle")
                    Text("Park Quest")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.textMid)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(activityItems: [image])
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "bolt.slash",
            title: "No active quest",
            subtitle: "Activate a quest from Inbox or Park to start focusing"
        )
    }
}

#Preview {
    NavigationStack {
        FocusView()
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
