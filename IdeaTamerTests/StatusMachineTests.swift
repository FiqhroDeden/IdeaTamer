import Testing
import SwiftData
@testable import IdeaTamer

@MainActor
struct StatusMachineTests {

    /// Creates an in-memory ModelContainer for testing.
    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Idea.self, Milestone.self, PlayerProfile.self,
            WeeklySnapshot.self, CurrentWeekTracker.self,
            configurations: config
        )
    }

    // MARK: - Activation

    @Test func activateIdea_whenNoneActive_succeeds() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Test Idea", status: .parked)
        context.insert(idea)

        try vm.activateIdea(idea)
        #expect(idea.status == .active)
        #expect(idea.activatedAt != nil)
    }

    @Test func activateSecondIdea_whenOneActive_throws() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea1 = Idea(title: "First Quest", status: .parked)
        let idea2 = Idea(title: "Second Quest", status: .parked)
        context.insert(idea1)
        context.insert(idea2)

        try vm.activateIdea(idea1)

        #expect(throws: IdeaTamerError.self) {
            try vm.activateIdea(idea2)
        }
        #expect(idea2.status == .parked)
    }

    // MARK: - Status Transitions

    @Test func scoring_movesInboxToParked() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = ScoringViewModel(modelContext: context)

        let idea = Idea(title: "Unscored Idea")
        context.insert(idea)
        #expect(idea.status == .inbox)

        vm.saveScore(for: idea)
        #expect(idea.status == .parked)
        #expect(idea.computedScore != nil)
        #expect(idea.impactScore == 5) // default slider
    }

    @Test func parked_toActive_toCompleted() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Full Lifecycle", status: .parked)
        context.insert(idea)

        // Activate
        try vm.activateIdea(idea)
        #expect(idea.status == .active)

        // Complete
        vm.completeQuest(idea)
        #expect(idea.status == .completed)
        #expect(idea.completedAt != nil)
    }

    @Test func active_toPark_returnsToParked() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Parkable Quest", status: .parked)
        context.insert(idea)

        try vm.activateIdea(idea)
        #expect(idea.status == .active)

        vm.parkQuest(idea)
        #expect(idea.status == .parked)
        #expect(vm.activeQuest == nil)
    }

    // MARK: - Milestones

    @Test func addMilestone_incrementsSortOrder() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Milestone Test", status: .active)
        context.insert(idea)

        vm.addMilestone(to: idea, title: "First")
        vm.addMilestone(to: idea, title: "Second")
        vm.addMilestone(to: idea, title: "Third")

        #expect(idea.milestones.count == 3)
        let sorted = idea.milestones.sorted { $0.sortOrder < $1.sortOrder }
        #expect(sorted[0].title == "First")
        #expect(sorted[1].title == "Second")
        #expect(sorted[2].title == "Third")
    }

    @Test func completeMilestone_setsCompletedFields() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Milestone Complete Test", status: .active)
        context.insert(idea)

        vm.addMilestone(to: idea, title: "Do the thing")
        let milestone = idea.milestones.first!

        #expect(milestone.isCompleted == false)
        #expect(milestone.completedAt == nil)

        vm.completeMilestone(milestone)

        #expect(milestone.isCompleted == true)
        #expect(milestone.completedAt != nil)
    }

    // MARK: - Completion Days

    @Test func completeQuest_calculatesCompletionDays() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = FocusViewModel(modelContext: context)

        let idea = Idea(title: "Days Test", status: .parked)
        context.insert(idea)

        try vm.activateIdea(idea)
        // activatedAt is set to .now, completedAt will also be .now
        // so completionDays should be 0
        vm.completeQuest(idea)
        #expect(idea.completionDays == 0)
    }
}
