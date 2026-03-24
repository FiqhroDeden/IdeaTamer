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
    @State private var searchText = ""
    @State private var filter: InboxFilter = .all
    @State private var showUndoToast = false
    @State private var deletedIdea: Idea?
    @State private var activationError: String?

    enum InboxFilter: String, CaseIterable {
        case all = "All"
        case unscored = "Unscored"
        case scored = "Scored"
    }

    private var filteredIdeas: [Idea] {
        var result = ideas
        // Apply filter
        switch filter {
        case .all: break
        case .unscored: result = result.filter { !$0.isScored }
        case .scored: result = result.filter { $0.isScored }
        }
        // Apply search
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    var body: some View {
        ZStack(alignment: .top) {
            mainContent
            XPFloatView(amount: XP.capture, isShowing: $showXPFloat)
                .padding(.top, 60)

            // Undo toast at bottom
            VStack {
                Spacer()
                UndoToast(
                    message: "Idea deleted",
                    onUndo: restoreDeletedIdea,
                    isShowing: $showUndoToast
                )
                .padding(.bottom, 8)
            }
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
        .alert("Cannot Activate", isPresented: .init(
            get: { activationError != nil },
            set: { if !$0 { activationError = nil } }
        )) {
            Button("OK") { activationError = nil }
        } message: {
            Text(activationError ?? "")
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

                QuickCaptureBar(showXPFloat: $showXPFloat, isAtCap: viewModel?.isInboxFull ?? false) { title in
                    _ = try? viewModel?.captureIdea(title: title)
                }

                CapturePaceIndicator()

                // Search + Filter
                searchAndFilter

                // Quests section
                questsSection

                MasteryCard()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Streak Row

    private var streakRow: some View {
        StreakRow()
    }

    // MARK: - Search & Filter

    private var searchAndFilter: some View {
        VStack(spacing: 10) {
            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.textLight)
                TextField("Search ideas...", text: $searchText)
                    .font(.brand(.body))
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.textLight)
                    }
                }
            }
            .padding(10)
            .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 10))

            // Filter pills
            HStack(spacing: 8) {
                ForEach(InboxFilter.allCases, id: \.self) { f in
                    Button {
                        withAnimation(.springFast) { filter = f }
                        Haptics.selection()
                    } label: {
                        Text(f.rawValue)
                            .font(.brand(.label))
                            .fontWeight(.bold)
                            .foregroundStyle(filter == f ? .white : Color.textMid)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                filter == f ? Color.hero : Color.surfaceLow,
                                in: Capsule()
                            )
                    }
                }
                Spacer()
            }
        }
    }

    // MARK: - Quests Section

    private var questsSection: some View {
        VStack(spacing: 8) {
            if filteredIdeas.isEmpty && !ideas.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(Color.textLight)
                    Text("No ideas match")
                        .font(.brand(.headline))
                        .foregroundStyle(Color.textMid)
                    Text("Try adjusting your search or filter")
                        .font(.brand(.body))
                        .foregroundStyle(Color.textLight)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(filteredIdeas) { idea in
                    Button {
                        selectedIdeaForScoring = idea
                    } label: {
                        IdeaCard(idea: idea)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            selectedIdeaForScoring = idea
                        } label: {
                            Label(idea.isScored ? "Re-score" : "Score Idea", systemImage: "slider.horizontal.3")
                        }
                        if idea.isScored {
                            Button {
                                do {
                                    try viewModel?.activateIdea(idea)
                                } catch {
                                    activationError = error.localizedDescription
                                }
                            } label: {
                                Label("Activate Quest", systemImage: "bolt.fill")
                            }
                            Button {
                                viewModel?.parkIdea(idea)
                            } label: {
                                Label("Park Idea", systemImage: "square.grid.2x2")
                            }
                        }
                        Button(role: .destructive) {
                            softDeleteIdea(idea)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Undo Delete

    private func softDeleteIdea(_ idea: Idea) {
        Haptics.warning()
        deletedIdea = idea
        idea.status = .completed // Temporarily hide from inbox query
        idea.statusRaw = "pendingDelete" // Custom state to hide
        withAnimation(.springFast) {
            showUndoToast = true
        }
        // Auto-delete after 3.5s if not undone
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if idea.statusRaw == "pendingDelete" {
                viewModel?.deleteIdea(idea)
                deletedIdea = nil
            }
        }
    }

    private func restoreDeletedIdea() {
        guard let idea = deletedIdea else { return }
        idea.statusRaw = IdeaStatus.inbox.rawValue
        deletedIdea = nil
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ZStack(alignment: .bottom) {
            EmptyStateView(
                systemImage: "lightbulb.max",
                title: "Your journey starts here",
                subtitle: "Capture your first idea below and begin your quest to ship something great",
                iconColor: Color.hero,
                gradientColors: [Color.heroBG, Color.surface]
            )

            QuickCaptureBar(showXPFloat: $showXPFloat, isAtCap: viewModel?.isInboxFull ?? false) { title in
                _ = try? viewModel?.captureIdea(title: title)
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
