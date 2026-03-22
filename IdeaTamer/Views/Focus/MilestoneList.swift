import SwiftUI

struct MilestoneList: View {
    let idea: Idea
    let viewModel: FocusViewModel

    @State private var newMilestoneTitle = ""
    @FocusState private var isAddFocused: Bool

    private var sortedMilestones: [Milestone] {
        idea.milestones.sorted { $0.sortOrder < $1.sortOrder }
    }

    private var firstUncompletedID: UUID? {
        sortedMilestones.first(where: { !$0.isCompleted })?.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            milestoneItems
            addMilestoneField
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 24))
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Milestones")
                .font(.brand(.title))
                .foregroundStyle(Color.textPrimary)
            Spacer()
            Text("\(idea.completedMilestoneCount)/\(idea.milestones.count)")
                .font(.brand(.label))
                .textCase(.uppercase)
                .foregroundStyle(Color.victoryDim)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.victoryBG, in: Capsule())
        }
    }

    // MARK: - Items

    private var milestoneItems: some View {
        VStack(spacing: 4) {
            ForEach(sortedMilestones) { milestone in
                MilestoneRow(
                    milestone: milestone,
                    isFirstUncompleted: milestone.id == firstUncompletedID,
                    onToggle: {
                        withAnimation(.springFast) {
                            if milestone.isCompleted {
                                viewModel.uncompleteMilestone(milestone)
                            } else {
                                viewModel.completeMilestone(milestone)
                            }
                        }
                    }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        withAnimation(.springFast) {
                            viewModel.deleteMilestone(milestone)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    // MARK: - Add Milestone

    private var addMilestoneField: some View {
        Button {
            addMilestone()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle.fill")
                Text("Add Milestone")
                    .fontWeight(.bold)
            }
            .font(.brand(.body))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.hero, in: RoundedRectangle(cornerRadius: 16))
        }
        .sheet(isPresented: .init(
            get: { isAddFocused },
            set: { isAddFocused = $0 }
        )) {
            addMilestoneSheet
                .presentationDetents([.height(120)])
        }
    }

    private var addMilestoneSheet: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                TextField("Milestone title...", text: $newMilestoneTitle)
                    .font(.brand(.body))
                    .focused($isAddFocused)
                    .onSubmit(addMilestone)
                    .textFieldStyle(.plain)

                Button("Add") {
                    addMilestone()
                }
                .font(.brand(.title))
                .foregroundStyle(Color.hero)
                .disabled(newMilestoneTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
    }

    private func addMilestone() {
        let trimmed = newMilestoneTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            isAddFocused = true
            return
        }
        withAnimation(.springFast) {
            viewModel.addMilestone(to: idea, title: trimmed)
        }
        newMilestoneTitle = ""
    }
}
