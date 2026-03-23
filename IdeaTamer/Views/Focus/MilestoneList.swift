import SwiftUI

struct MilestoneList: View {
    let idea: Idea
    let viewModel: FocusViewModel

    @State private var newMilestoneTitle = ""
    @State private var showAddSheet = false
    @FocusState private var isFieldFocused: Bool

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
            addButton
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 24))
        .sheet(isPresented: $showAddSheet) {
            addMilestoneSheet
                .presentationDetents([.height(140)])
        }
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
            }
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            showAddSheet = true
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
    }

    // MARK: - Add Sheet

    private var addMilestoneSheet: some View {
        VStack(spacing: 16) {
            Text("New Milestone")
                .font(.brand(.title))
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: 8) {
                TextField("What needs to be done?", text: $newMilestoneTitle)
                    .font(.brand(.body))
                    .focused($isFieldFocused)
                    .onSubmit(submitMilestone)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    submitMilestone()
                }
                .font(.brand(.title))
                .foregroundStyle(Color.hero)
                .disabled(newMilestoneTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(20)
        .onAppear { isFieldFocused = true }
    }

    private func submitMilestone() {
        let trimmed = newMilestoneTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation(.springFast) {
            viewModel.addMilestone(to: idea, title: trimmed)
        }
        newMilestoneTitle = ""
        showAddSheet = false
    }
}
