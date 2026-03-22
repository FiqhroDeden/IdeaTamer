import SwiftUI
import SwiftData

struct IdeaDetailSheet: View {
    let idea: Idea
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var editedTitle: String = ""
    @State private var editedDescription: String = ""
    @State private var showScoringSheet = false
    @State private var showDeleteConfirm = false
    @State private var activationError: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    editSection
                    scoreSection
                    actionsSection
                }
                .padding(20)
            }
            .navigationTitle("Idea Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        saveEdits()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            editedTitle = idea.title
            editedDescription = idea.descriptionText ?? ""
        }
        .sheet(isPresented: $showScoringSheet) {
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
        .confirmationDialog("Delete Idea?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                modelContext.delete(idea)
                dismiss()
            }
        } message: {
            Text("This idea and all its milestones will be permanently deleted.")
        }
    }

    // MARK: - Edit Section

    private var editSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TITLE")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
            TextField("Idea title", text: $editedTitle)
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)

            Text("DESCRIPTION")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textLight)
            TextEditor(text: $editedDescription)
                .font(.brand(.body))
                .foregroundStyle(Color.textPrimary)
                .frame(minHeight: 80)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Score Section

    private var scoreSection: some View {
        VStack(spacing: 12) {
            if let score = idea.computedScore {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Score")
                            .font(.brand(.label))
                            .textCase(.uppercase)
                            .tracking(1)
                            .foregroundStyle(Color.textLight)
                        ScoreBadge(score: score)
                    }
                    Spacer()
                    scoreBreakdown
                }
            }

            Button {
                showScoringSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                    Text(idea.isScored ? "Re-score" : "Score Idea")
                        .fontWeight(.semibold)
                }
                .font(.brand(.body))
                .foregroundStyle(Color.hero)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.heroBG, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var scoreBreakdown: some View {
        if let impact = idea.impactScore,
           let effort = idea.effortScore,
           let alignment = idea.alignmentScore {
            HStack(spacing: 12) {
                miniStat("IMP", value: impact, color: Color.hero)
                miniStat("EFF", value: effort, color: Color.rival)
                miniStat("ALN", value: alignment, color: Color.victory)
            }
        }
    }

    private func miniStat(_ label: String, value: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.brand(.title))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.textLight)
        }
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: 10) {
            if idea.status != .active && idea.status != .completed {
                Button {
                    activateIdea()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                        Text("Activate Quest")
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.hero, in: RoundedRectangle(cornerRadius: 16))
                }
            }

            Button {
                showDeleteConfirm = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "trash")
                    Text("Delete Idea")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.rival)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.rivalBG, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Helpers

    private func saveEdits() {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespaces)
        if !trimmedTitle.isEmpty {
            idea.title = String(trimmedTitle.prefix(120))
        }
        idea.descriptionText = editedDescription.isEmpty ? nil : editedDescription
    }

    private func activateIdea() {
        let vm = ParkViewModel(modelContext: modelContext)
        do {
            try vm.activateIdea(idea)
            dismiss()
        } catch {
            activationError = error.localizedDescription
        }
    }
}
