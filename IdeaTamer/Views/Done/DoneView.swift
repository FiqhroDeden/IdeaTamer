import SwiftUI
import SwiftData

struct DoneView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        filter: #Predicate<Idea> { $0.statusRaw == "completed" },
        sort: \Idea.completedAt,
        order: .reverse
    )
    private var completedIdeas: [Idea]

    @State private var profile: PlayerProfile?
    @State private var duelWins = 0
    @State private var duelLosses = 0
    @State private var showConfetti = false
    @State private var showXPFloat = false
    @State private var selectedQuest: Idea?
    @State private var sortMode: DoneSort = .recent

    enum DoneSort: String, CaseIterable {
        case recent = "Recent"
        case fastest = "Fastest"
        case mostXP = "Most XP"
    }

    private var sortedIdeas: [Idea] {
        switch sortMode {
        case .recent:
            return completedIdeas.sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
        case .fastest:
            return completedIdeas.sorted { ($0.completionDays ?? Int.max) < ($1.completionDays ?? Int.max) }
        case .mostXP:
            return completedIdeas.sorted { $0.xpEarned > $1.xpEarned }
        }
    }

    var body: some View {
        ZStack {
            Group {
                if completedIdeas.isEmpty && profile != nil {
                    emptyState
                } else {
                    doneContent
                }
            }
            ConfettiView(isShowing: $showConfetti)
            XPFloatView(amount: XP.questComplete, isShowing: $showXPFloat)
                .padding(.top, 100)
        }
        .task { loadStats() }
        .onReceive(NotificationCenter.default.publisher(for: .questCompleted)) { _ in
            showConfetti = true
            showXPFloat = true
        }
        .sheet(item: $selectedQuest) { quest in
            CompletedQuestDetailSheet(idea: quest)
        }
    }

    // MARK: - Content

    private var doneContent: some View {
        VStack(spacing: 0) {
            PlayerHeader()
            ScrollView {
                VStack(spacing: 16) {
                    header
                    legacyStats
                    sortPicker
                    questCards
                    badgeSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("HALL OF FAME")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(Color.victory)
            Text("Your Legacy.")
                .font(.brand(.display))
                .foregroundStyle(Color.textPrimary)
            Text("Proof you beat yourself, again and again.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Legacy Stats

    private var legacyStats: some View {
        LegacyStats(
            questsShipped: profile?.questsCompletedCount ?? 0,
            totalXP: profile?.totalXP ?? 0,
            duelWins: duelWins,
            duelLosses: duelLosses
        )
    }

    // MARK: - Sort Picker

    private var sortPicker: some View {
        HStack(spacing: 8) {
            ForEach(DoneSort.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.springFast) { sortMode = mode }
                    Haptics.selection()
                } label: {
                    Text(mode.rawValue)
                        .font(.brand(.label))
                        .fontWeight(.bold)
                        .foregroundStyle(sortMode == mode ? .white : Color.textMid)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            sortMode == mode ? Color.victory : Color.surfaceLow,
                            in: Capsule()
                        )
                }
            }
            Spacer()
        }
    }

    // MARK: - Quest Cards

    private var questCards: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(sortedIdeas.enumerated()), id: \.element.id) { index, idea in
                Button {
                    selectedQuest = idea
                } label: {
                    CompletedQuestCard(idea: idea, isLatest: sortMode == .recent && index == 0)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Badges

    private var badgeSection: some View {
        BadgeGrid(unlockedBadges: profile?.unlockedBadges ?? [])
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "trophy.circle",
            title: "Your hall of fame is empty",
            subtitle: "Ship your first quest and it'll live here forever. Every finished idea is proof you're getting better.",
            iconColor: Color.victory,
            gradientColors: [Color.victoryBG, Color.surface]
        )
    }

    // MARK: - Data Loading

    private func loadStats() {
        profile = PlayerProfile.fetchOrCreate(context: modelContext)

        let descriptor = FetchDescriptor<WeeklySnapshot>()
        let snapshots = (try? modelContext.fetch(descriptor)) ?? []
        duelWins = snapshots.filter { $0.duelResult == .win }.count
        duelLosses = snapshots.filter { $0.duelResult == .loss }.count
    }
}

#Preview {
    NavigationStack {
        DoneView()
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
