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
            headerAndCapture
            List {
                ForEach(ideas) { idea in
                    Button {
                        selectedIdeaForScoring = idea
                    } label: {
                        IdeaCard(idea: idea)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation(.springFast) {
                                viewModel?.deleteIdea(idea)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            selectedIdeaForScoring = idea
                        } label: {
                            Label("Score", systemImage: "slider.horizontal.3")
                        }
                        .tint(Color.hero)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Header + Capture

    private var headerAndCapture: some View {
        VStack(spacing: 12) {
            PlayerHeader()
            DuelBannerMini()

            Text("Master your\nthoughts.")
                .font(.brand(.display))
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            QuickCaptureBar(showXPFloat: $showXPFloat) { title in
                viewModel?.captureIdea(title: title)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 8)
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
