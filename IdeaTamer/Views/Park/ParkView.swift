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

    // MARK: - Cards

    private var ideaCards: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(ideas.enumerated()), id: \.element.id) { index, idea in
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
