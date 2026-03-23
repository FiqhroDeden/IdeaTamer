import SwiftUI
import SwiftData
import UIKit

struct ParkView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        filter: #Predicate<Idea> { $0.statusRaw == "parked" },
        sort: \Idea.computedScore,
        order: .reverse
    )
    private var ideas: [Idea]

    @State private var viewModel: ParkViewModel?
    @State private var selectedIdea: Idea?
    @State private var activationError: String?
    @State private var sortMode: ParkSort = .score

    enum ParkSort: String, CaseIterable {
        case score = "Score ↓"
        case newest = "Newest"
        case oldest = "Oldest"
    }

    private var sortedIdeas: [Idea] {
        switch sortMode {
        case .score:
            return ideas.sorted { ($0.computedScore ?? 0) > ($1.computedScore ?? 0) }
        case .newest:
            return ideas.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            return ideas.sorted { $0.createdAt < $1.createdAt }
        }
    }

    var body: some View {
        Group {
            if ideas.isEmpty {
                emptyState
            } else {
                parkList
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        .task {
            viewModel = ParkViewModel(modelContext: modelContext)
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailSheet(idea: idea)
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

    // MARK: - Park List

    private var parkList: some View {
        VStack(spacing: 0) {
            PlayerHeader()
            ScrollView {
                VStack(spacing: 16) {
                    header
                    VaultStats(ideas: ideas)
                    sortPicker
                    ideaCards
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
            Text("THE VAULT")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(Color.hero)
            Text("The Park")
                .font(.brand(.display))
                .foregroundStyle(Color.textPrimary)
            Text("Ranked ideas waiting for activation.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sort Picker

    private var sortPicker: some View {
        HStack(spacing: 8) {
            ForEach(ParkSort.allCases, id: \.self) { mode in
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
                            sortMode == mode ? Color.hero : Color.surfaceLow,
                            in: Capsule()
                        )
                }
            }
            Spacer()
        }
    }

    // MARK: - Cards

    private var ideaCards: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(sortedIdeas.enumerated()), id: \.element.id) { index, idea in
                VStack(spacing: 0) {
                    if viewModel?.isStale(idea) == true {
                        staleBanner(for: idea)
                    }
                    Button {
                        selectedIdea = idea
                    } label: {
                        RankedQuestCard(idea: idea, rank: index + 1) {
                            activateIdea(idea)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Stale Banner

    private func staleBanner(for idea: Idea) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.caption2)
            Text("Parked 30+ days — still relevant?")
                .font(.brand(.label))
            Spacer()
            Button("Keep") {
                Haptics.light()
                // Touch createdAt to reset staleness clock
                idea.createdAt = .now
            }
            .font(.brand(.label))
            .fontWeight(.bold)
            .foregroundStyle(Color.streakDim)
            Button("Remove") {
                Haptics.light()
                viewModel?.deleteIdea(idea)
            }
            .font(.brand(.label))
            .fontWeight(.bold)
            .foregroundStyle(Color.rivalMid)
        }
        .foregroundStyle(Color.streakDim)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.streakBG, in: RoundedRectangle(cornerRadius: 8))
        .padding(.bottom, 4)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "archivebox",
            title: "Your vault awaits",
            subtitle: "Score ideas from your Inbox to rank them here. The highest-scored idea becomes your next quest.",
            iconColor: Color.streak,
            gradientColors: [Color.streakBG, Color.surface]
        )
    }

    // MARK: - Actions

    private func activateIdea(_ idea: Idea) {
        do {
            try viewModel?.activateIdea(idea)
        } catch {
            activationError = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        ParkView()
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
