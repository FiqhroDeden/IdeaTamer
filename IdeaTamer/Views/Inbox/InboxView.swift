import SwiftUI
import SwiftData
import UIKit

struct InboxView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        filter: #Predicate<Idea> { $0.statusRaw == "inbox" },
        sort: \Idea.createdAt,
        order: .reverse
    )
    private var ideas: [Idea]

    @State private var viewModel: InboxViewModel?
    @State private var selectedIdeaForScoring: Idea?
    @State private var showXPFloat = false

    var body: some View {
        ZStack(alignment: .top) {
            mainContent
            XPFloatView(amount: 10, isShowing: $showXPFloat)
                .padding(.top, 60)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        .task {
            viewModel = InboxViewModel(modelContext: modelContext)
        }
        .sheet(item: $selectedIdeaForScoring) { idea in
            ScoringSheet(idea: idea)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var mainContent: some View {
        if ideas.isEmpty && viewModel != nil {
            emptyState
        } else {
            ideaList
        }
    }

    // MARK: - Idea List

    private var ideaList: some View {
        VStack(spacing: 0) {
            PlayerHeader()
            ScrollView {
                VStack(spacing: 12) {
                    DuelBannerMini()

                // Streak
                streakRow

                Text("Master your\nthoughts.")
                    .font(.brand(.display))
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                QuickCaptureBar(showXPFloat: $showXPFloat) { title in
                    viewModel?.captureIdea(title: title)
                }

                CapturePaceIndicator()

                // Quests section
                questsSection

                MasteryCard()
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Streak Row

    private var streakRow: some View {
        StreakRow()
    }

    // MARK: - Quests Section

    private var questsSection: some View {
        VStack(spacing: 8) {
            ForEach(ideas) { idea in
                Button {
                    selectedIdeaForScoring = idea
                } label: {
                    IdeaCard(idea: idea)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            EmptyStateView(
                systemImage: "lightbulb.slash",
                title: "No ideas yet",
                subtitle: "Capture your first idea to start your quest"
            )
            Spacer()
            QuickCaptureBar(showXPFloat: $showXPFloat) { title in
                viewModel?.captureIdea(title: title)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Streak Row

private struct StreakRow: View {
    @Environment(\.modelContext) private var modelContext
    @State private var streakCount = 0
    @State private var pastStreakDays = 0

    var body: some View {
        HStack(spacing: 8) {
            StreakBadge(count: streakCount, label: "Days")
            Text("Past week: \(pastStreakDays) days")
                .font(.brand(.caption))
                .foregroundStyle(Color.textLight)
            Spacer()
        }
        .task { loadData() }
    }

    private func loadData() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        streakCount = profile.captureStreakCount

        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        pastStreakDays = (try? modelContext.fetch(descriptor).first)?.streakDays ?? 0
    }
}

// MARK: - Player Header Trailing (for toolbar)

struct PlayerHeaderTrailing: View {
    @Environment(\.modelContext) private var modelContext
    @State private var level = 1
    @State private var momentum: Double = 0
    @State private var hasMomentum = false

    var body: some View {
        HStack(spacing: 6) {
            if hasMomentum {
                MomentumBadge(value: momentum)
            }
            Text("LVL \(level)")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.hero)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.heroBG, in: Capsule())
        }
        .task { loadData() }
    }

    private func loadData() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        level = profile.currentLevel

        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        if let last = try? modelContext.fetch(descriptor).first {
            momentum = DuelService.computeMomentum(currentXP: tracker.xpEarned, previousXP: last.xpEarned)
            hasMomentum = true
        }
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
