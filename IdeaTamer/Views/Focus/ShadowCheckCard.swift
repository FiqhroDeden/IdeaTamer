import SwiftUI
import SwiftData

struct ShadowCheckCard: View {
    let quest: Idea
    @Environment(\.modelContext) private var modelContext
    @State private var lastQuestDays: Int?
    @State private var currentDay = 0

    private var progressPercent: Int {
        Int(quest.milestoneProgress * 100)
    }

    private var paceText: String? {
        guard let lastDays = lastQuestDays, lastDays > 0 else { return nil }
        let expectedDays = quest.milestoneProgress > 0
            ? Double(currentDay) / quest.milestoneProgress
            : Double(lastDays + 1)
        let diff = Double(lastDays) - expectedDays
        if diff > 0 {
            return "On pace to beat your shadow by \(Int(diff)) days"
        } else if diff < 0 {
            return "Behind shadow pace by \(Int(abs(diff))) days"
        }
        return "Matching your shadow's pace"
    }

    private var isAhead: Bool {
        guard let lastDays = lastQuestDays, lastDays > 0 else { return true }
        let expectedDays = quest.milestoneProgress > 0
            ? Double(currentDay) / quest.milestoneProgress
            : Double(lastDays + 1)
        return Double(lastDays) - expectedDays >= 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "person.fill")
                    .font(.caption)
                    .foregroundStyle(Color.rival)
                Text("SHADOW CHECK")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.rival)
            }

            if let lastDays = lastQuestDays {
                HStack(spacing: 0) {
                    Text("Last quest: ")
                        .foregroundStyle(Color.textPrimary)
                    Text("\(lastDays) days")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textPrimary)
                    Text(". You're on day ")
                        .foregroundStyle(Color.textPrimary)
                    Text("\(currentDay)")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.hero)
                    Text(" at ")
                        .foregroundStyle(Color.textPrimary)
                    Text("\(progressPercent)%")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.hero)
                    Text(".")
                        .foregroundStyle(Color.textPrimary)
                }
                .font(.brand(.body))
            } else {
                Text("This is your first quest. Set the pace!")
                    .font(.brand(.body))
                    .foregroundStyle(Color.textPrimary)
            }

            if let pace = paceText {
                HStack(spacing: 4) {
                    Image(systemName: isAhead ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2)
                        .fontWeight(.bold)
                    Text(pace)
                        .font(.brand(.caption))
                        .fontWeight(.bold)
                }
                .foregroundStyle(isAhead ? Color.victory : Color.rival)
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color.heroBG, Color.rivalBG],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .task { loadData() }
    }

    private func loadData() {
        if let activated = quest.activatedAt {
            currentDay = Date.daysBetween(activated, and: .now)
        }

        // Get average completion days from past quests
        let completedStatus = IdeaStatus.completed.rawValue
        let descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == completedStatus }
        )
        let completed = (try? modelContext.fetch(descriptor)) ?? []
        let days = completed.compactMap(\.completionDays)
        if !days.isEmpty {
            lastQuestDays = days.reduce(0, +) / days.count
        }
    }
}
