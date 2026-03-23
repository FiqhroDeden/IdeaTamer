import SwiftUI
import SwiftData
import UIKit

struct FocusView: View {
    @Binding var selectedTab: String
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: FocusViewModel?
    @State private var showXPFloat = false
    @State private var xpAmount = 0
    @State private var showCompleteConfirm = false
    @State private var showTargetDatePicker = false

    var body: some View {
        ZStack {
            if let vm = viewModel {
                if let quest = vm.activeQuest {
                    questContent(quest: quest, vm: vm)
                } else {
                    emptyState
                }
            }

            // Overlays
            XPFloatView(amount: xpAmount, isShowing: $showXPFloat)
                .padding(.top, 100)
        }
        .task {
            viewModel = FocusViewModel(modelContext: modelContext)
        }
    }

    // MARK: - Quest Content

    private func questContent(quest: Idea, vm: FocusViewModel) -> some View {
        VStack(spacing: 0) {
            PlayerHeader()
            ScrollView {
                VStack(spacing: 16) {
                    questHeader
                questCard(quest: quest)
                ShadowCheckCard(quest: quest)
                milestoneSection(quest: quest, vm: vm)
                actionButtons(quest: quest, vm: vm)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Header

    private var questHeader: some View {
        Text("CURRENT FOCUS")
            .font(.brand(.label))
            .textCase(.uppercase)
            .tracking(1.5)
            .foregroundStyle(Color.textLight)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Quest Card

    private func questCard(quest: Idea) -> some View {
        VStack(spacing: 16) {
            ProgressRing(progress: quest.milestoneProgress)

            Text(quest.title)
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            if let desc = quest.descriptionText, !desc.isEmpty {
                Text(desc)
                    .font(.brand(.body))
                    .foregroundStyle(Color.textMid)
                    .multilineTextAlignment(.center)
            }

            questStats(quest: quest)
            targetDateRow(quest: quest)
        }
        .padding(20)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.cardShadow, radius: 14, y: 4)
        .sheet(isPresented: $showTargetDatePicker) {
            targetDatePicker(quest: quest)
        }
    }

    // MARK: - Stats

    private func questStats(quest: Idea) -> some View {
        HStack(spacing: 12) {
            statCard(
                icon: "clock",
                iconColor: Color.hero,
                label: "STARTED",
                value: quest.activatedAt.map {
                    RelativeDateTimeFormatter().localizedString(for: $0, relativeTo: .now)
                } ?? "—"
            )
            statCard(
                icon: "star.fill",
                iconColor: Color.streak,
                label: "REWARD",
                value: "+500 XP"
            )
        }
    }

    private func statCard(icon: String, iconColor: Color, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.subheadline)
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.textLight)
                Text(value)
                    .font(.brand(.body))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Target Date

    private func targetDateRow(quest: Idea) -> some View {
        Button { showTargetDatePicker = true } label: {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(quest.targetDate != nil ? Color.streak : Color.textLight)
                    .font(.subheadline)

                if let target = quest.targetDate, let activated = quest.activatedAt {
                    let totalDays = max(1, Date.daysBetween(activated, and: target))
                    let elapsed = Date.daysBetween(activated, and: .now)
                    let remaining = max(0, totalDays - elapsed)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("TARGET")
                            .font(.brand(.label))
                            .textCase(.uppercase)
                            .tracking(1)
                            .foregroundStyle(Color.textLight)
                        Text("Day \(min(elapsed, totalDays)) of \(totalDays) — \(remaining) left")
                            .font(.brand(.body))
                            .fontWeight(.bold)
                            .foregroundStyle(remaining <= 2 ? Color.rival : Color.textPrimary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("TARGET")
                            .font(.brand(.label))
                            .textCase(.uppercase)
                            .tracking(1)
                            .foregroundStyle(Color.textLight)
                        Text("Set a deadline")
                            .font(.brand(.body))
                            .foregroundStyle(Color.textMid)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.textLight)
            }
            .padding(12)
            .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func targetDatePicker(quest: Idea) -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    "Target Date",
                    selection: Binding(
                        get: { quest.targetDate ?? Calendar.current.date(byAdding: .day, value: 14, to: .now)! },
                        set: { viewModel?.setTargetDate($0, for: quest) }
                    ),
                    in: Date.now...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color.hero)

                if quest.targetDate != nil {
                    Button("Remove Deadline") {
                        viewModel?.setTargetDate(nil, for: quest)
                        showTargetDatePicker = false
                    }
                    .foregroundStyle(Color.rival)
                    .font(.brand(.body))
                    .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding(20)
            .navigationTitle("Set Target Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showTargetDatePicker = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Milestones

    private func milestoneSection(quest: Idea, vm: FocusViewModel) -> some View {
        MilestoneList(idea: quest, viewModel: vm)
    }

    // MARK: - Actions

    private func actionButtons(quest: Idea, vm: FocusViewModel) -> some View {
        VStack(spacing: 10) {
            // Complete Quest — requires at least 1 milestone and ALL completed
            if !quest.milestones.isEmpty && quest.milestoneProgress == 1.0 {
                Button {
                    showCompleteConfirm = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill")
                        Text("Complete Quest")
                            .fontWeight(.bold)
                        Text("+500 XP")
                            .font(.brand(.label))
                            .opacity(0.8)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.victory, in: RoundedRectangle(cornerRadius: 16))
                }
                .confirmationDialog(
                    "Complete Quest?",
                    isPresented: $showCompleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("Complete & Earn 500 XP") {
                        vm.completeQuest(quest)
                        selectedTab = "done"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            NotificationCenter.default.post(name: .questCompleted, object: nil)
                        }
                    }
                } message: {
                    Text("This will mark \"\(quest.title)\" as completed and move it to the Hall of Fame.")
                }
            }

            // Share Progress
            Button {
                if let image = ShareCardService.renderProgressCard(idea: quest) {
                    ShareHelper.share(image)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Progress")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.hero)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.heroBG, in: RoundedRectangle(cornerRadius: 16))
            }

            // Park Quest
            Button {
                withAnimation(.springMedium) {
                    vm.parkQuest(quest)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "pause.circle")
                    Text("Park Quest")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.textMid)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "bolt.circle",
            title: "Ready to focus?",
            subtitle: "Pick your best idea from Inbox or Park and activate it as your quest. One at a time — that's the superpower.",
            iconColor: Color.hero,
            gradientColors: [Color.heroBG, Color.surface]
        )
    }
}

#Preview {
    NavigationStack {
        FocusView(selectedTab: .constant("focus"))
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
