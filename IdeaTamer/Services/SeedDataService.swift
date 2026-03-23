#if DEBUG
import Foundation
import SwiftData

@MainActor
enum SeedDataService {

    static func populate(context: ModelContext) {
        // Check if already seeded
        let profile = PlayerProfile.fetchOrCreate(context: context)
        guard profile.totalXP == 0 else { return }

        // MARK: - Player Profile

        profile.totalXP = 4850
        profile.currentLevel = XP.levelFor(xp: 4850)
        profile.captureStreakCount = 5
        profile.captureStreakLastDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        profile.focusStreakCount = 3
        profile.focusStreakLastDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        profile.questsCompletedCount = 3
        profile.unlockedBadges = [
            BadgeType.firstBlood.rawValue,
            BadgeType.streak7.rawValue,
            BadgeType.polisher.rawValue,
        ]
        profile.hasCompletedOnboarding = true

        // MARK: - Completed Ideas (Done tab)

        let completed1 = makeCompletedIdea(
            context: context,
            title: "Design System V1",
            description: "Component library with tokens, buttons, cards, and form elements",
            impact: 9, effort: 6, alignment: 8,
            daysAgoCompleted: 8, completionDays: 6, xpEarned: 850,
            milestones: ["Define design tokens", "Build Button component", "Build Card component", "Create form inputs", "Write documentation"]
        )
        context.insert(completed1)

        let completed2 = makeCompletedIdea(
            context: context,
            title: "Podcast Launch Plan",
            description: "Research, record pilot, set up hosting, and publish first 3 episodes",
            impact: 7, effort: 5, alignment: 8,
            daysAgoCompleted: 15, completionDays: 10, xpEarned: 725,
            milestones: ["Research hosting platforms", "Record pilot episode", "Design cover art", "Publish first episode"]
        )
        context.insert(completed2)

        let completed3 = makeCompletedIdea(
            context: context,
            title: "Portfolio Website Redesign",
            description: "Modern portfolio with case studies, blog, and contact form",
            impact: 9, effort: 7, alignment: 10,
            daysAgoCompleted: 22, completionDays: 14, xpEarned: 1050,
            milestones: ["Wireframe layouts", "Design in Figma", "Build with Next.js", "Write case studies", "Set up CMS", "Add contact form", "Deploy to Vercel"]
        )
        context.insert(completed3)

        // MARK: - Active Idea (Focus tab)

        let activeIdea = Idea(title: "Open Source Component Library", descriptionText: "React-based UI kit for developers with accessible, themeable components", status: .active)
        activeIdea.impactScore = 9
        activeIdea.effortScore = 5
        activeIdea.alignmentScore = 9
        activeIdea.computedScore = ScoringFormula.compute(impact: 9, effort: 5, alignment: 9)
        activeIdea.xpEarned = 150
        activeIdea.activatedAt = Calendar.current.date(byAdding: .day, value: -3, to: .now)
        activeIdea.createdAt = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        context.insert(activeIdea)

        let activeMilestones = [
            ("Define design tokens", true),
            ("Set up Tailwind config", true),
            ("Build core Button system", true),
            ("Write unit tests", false),
            ("Create npm pipeline", false),
            ("Write README", false),
            ("Launch on socials", false),
        ]
        for (i, (title, done)) in activeMilestones.enumerated() {
            let m = Milestone(title: title, sortOrder: i, idea: activeIdea)
            if done {
                m.isCompleted = true
                m.completedAt = Calendar.current.date(byAdding: .day, value: -(3 - i), to: .now)
            }
            context.insert(m)
            activeIdea.milestones.append(m)
        }

        // MARK: - Parked Ideas (Park tab)

        let parked = [
            ("AI-Driven Habit Stacking", "Neuro-adaptive habit formation using spaced repetition", 10, 4, 10),
            ("Vertical Garden OS", "Automated nutrient delivery and monitoring for vertical farms", 9, 5, 9),
            ("Credit Hub", "Community micro-lending platform for underserved markets", 8, 5, 8),
            ("Fitness Gamification App", "Turn workouts into RPG quests with XP and boss fights", 7, 6, 7),
        ]
        for (title, desc, impact, effort, alignment) in parked {
            let idea = Idea(title: title, descriptionText: desc, status: .parked)
            idea.impactScore = impact
            idea.effortScore = effort
            idea.alignmentScore = alignment
            idea.computedScore = ScoringFormula.compute(impact: impact, effort: effort, alignment: alignment)
            idea.createdAt = Calendar.current.date(byAdding: .day, value: -Int.random(in: 3...14), to: .now)!
            context.insert(idea)
        }

        // MARK: - Inbox Ideas (Inbox tab)

        let inbox1 = Idea(title: "Decentralized gardening protocol", descriptionText: nil)
        inbox1.createdAt = Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
        context.insert(inbox1)

        let inbox2 = Idea(title: "Coffee roast tracking SaaS", descriptionText: "IoT sensors for small batch roasters")
        inbox2.createdAt = Calendar.current.date(byAdding: .hour, value: -4, to: .now)!
        context.insert(inbox2)

        let inbox3 = Idea(title: "Pet rock AI marketplace")
        inbox3.impactScore = 4
        inbox3.effortScore = 3
        inbox3.alignmentScore = 5
        inbox3.computedScore = ScoringFormula.compute(impact: 4, effort: 3, alignment: 5)
        inbox3.createdAt = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        context.insert(inbox3)

        // MARK: - Weekly Snapshots (Duel tab)

        let threeWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date.now.startOfWeek)!
        let snap1 = WeeklySnapshot(weekStartDate: threeWeeksAgo, xpEarned: 980, milestonesCompleted: 4, ideasCaptured: 6, streakDays: 5)
        snap1.duelResult = .win
        context.insert(snap1)

        let twoWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now.startOfWeek)!
        let snap2 = WeeklySnapshot(weekStartDate: twoWeeksAgo, xpEarned: 1200, milestonesCompleted: 6, ideasCaptured: 8, streakDays: 7)
        snap2.duelResult = .win
        context.insert(snap2)

        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date.now.startOfWeek)!
        let snap3 = WeeklySnapshot(weekStartDate: lastWeek, xpEarned: 850, milestonesCompleted: 3, ideasCaptured: 5, streakDays: 4)
        snap3.duelResult = .loss
        context.insert(snap3)

        // MARK: - Current Week Tracker

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.weekStartDate = Date.now.startOfWeek
        tracker.xpEarned = 340
        tracker.milestonesCompleted = 3
        tracker.ideasCaptured = 3
        tracker.streakDays = 3
    }

    // MARK: - Helpers

    private static func makeCompletedIdea(
        context: ModelContext,
        title: String,
        description: String,
        impact: Int, effort: Int, alignment: Int,
        daysAgoCompleted: Int,
        completionDays: Int,
        xpEarned: Int,
        milestones: [String]
    ) -> Idea {
        let idea = Idea(title: title, descriptionText: description, status: .completed)
        idea.impactScore = impact
        idea.effortScore = effort
        idea.alignmentScore = alignment
        idea.computedScore = ScoringFormula.compute(impact: impact, effort: effort, alignment: alignment)
        idea.xpEarned = xpEarned
        idea.completedAt = Calendar.current.date(byAdding: .day, value: -daysAgoCompleted, to: .now)
        idea.activatedAt = Calendar.current.date(byAdding: .day, value: -(daysAgoCompleted + completionDays), to: .now)
        idea.completionDays = completionDays
        idea.createdAt = Calendar.current.date(byAdding: .day, value: -(daysAgoCompleted + completionDays + 2), to: .now)!

        for (i, milestoneTitle) in milestones.enumerated() {
            let m = Milestone(title: milestoneTitle, sortOrder: i, idea: idea)
            m.isCompleted = true
            m.completedAt = Calendar.current.date(byAdding: .day, value: -(daysAgoCompleted + completionDays - i), to: .now)
            context.insert(m)
            idea.milestones.append(m)
        }

        return idea
    }
}
#endif
