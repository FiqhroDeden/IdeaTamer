import SwiftUI
import SwiftData

struct ScoringSheet: View {
    let idea: Idea
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ScoringViewModel?

    var body: some View {
        NavigationStack {
            if let vm = viewModel {
                ScoringContent(idea: idea, viewModel: vm, dismiss: dismiss)
            }
        }
        .task {
            let vm = ScoringViewModel(modelContext: modelContext)
            vm.loadExistingScores(from: idea)
            viewModel = vm
        }
    }
}

// MARK: - Content

private struct ScoringContent: View {
    let idea: Idea
    @Bindable var viewModel: ScoringViewModel
    let dismiss: DismissAction

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                scorePreview
                slidersSection
                scoreButton
            }
            .padding(20)
        }
        .navigationTitle("Score Idea")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }

    // MARK: - Score Preview

    private var scorePreview: some View {
        VStack(spacing: 8) {
            Text(idea.title)
                .font(.brand(.title))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            ZStack {
                Circle()
                    .fill(Color.scoreColor(viewModel.previewScore).opacity(0.15))
                    .frame(width: 100, height: 100)
                Circle()
                    .strokeBorder(Color.scoreColor(viewModel.previewScore), lineWidth: 3)
                    .frame(width: 100, height: 100)
                Text("\(viewModel.previewScore)")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 36))
                    .foregroundStyle(Color.scoreColor(viewModel.previewScore))
            }
            .animation(.springMedium, value: viewModel.previewScore)
        }
    }

    // MARK: - Sliders

    private var slidersSection: some View {
        VStack(spacing: 20) {
            sliderRow(
                title: "Impact",
                subtitle: "How big is the potential?",
                value: $viewModel.impactScore,
                color: Color.hero
            )
            sliderRow(
                title: "Effort",
                subtitle: "How hard to execute?",
                value: $viewModel.effortScore,
                color: Color.rival
            )
            sliderRow(
                title: "Alignment",
                subtitle: "How aligned with your goals?",
                value: $viewModel.alignmentScore,
                color: Color.victory
            )
        }
    }

    private func sliderRow(
        title: String,
        subtitle: String,
        value: Binding<Int>,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.brand(.title))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text("\(value.wrappedValue)")
                    .font(.brand(.headline))
                    .foregroundStyle(color)
                    .frame(width: 30, alignment: .trailing)
            }
            Text(subtitle)
                .font(.brand(.caption))
                .foregroundStyle(Color.textMid)
            Slider(
                value: Binding<Double>(
                    get: { Double(value.wrappedValue) },
                    set: { value.wrappedValue = Int($0.rounded()) }
                ),
                in: 1...10,
                step: 1
            )
            .tint(color)
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Score Button

    private var scoreButton: some View {
        Button {
            viewModel.saveScore(for: idea)
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                Text("Score & Park")
                    .fontWeight(.bold)
                Text("+25 XP")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .opacity(0.8)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.hero, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
