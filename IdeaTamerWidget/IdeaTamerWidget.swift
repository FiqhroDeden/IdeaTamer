import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct ActiveQuestProvider: TimelineProvider {
    func placeholder(in context: Context) -> ActiveQuestEntry {
        ActiveQuestEntry(date: .now, data: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (ActiveQuestEntry) -> Void) {
        completion(ActiveQuestEntry(date: .now, data: WidgetData.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ActiveQuestEntry>) -> Void) {
        let entry = ActiveQuestEntry(date: .now, data: WidgetData.load())
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

// MARK: - Timeline Entry

struct ActiveQuestEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

// MARK: - Small Widget View

struct ActiveQuestSmallView: View {
    let data: WidgetData

    var body: some View {
        if let title = data.activeQuestTitle {
            VStack(spacing: 8) {
                questProgressRing
                Text(title)
                    .font(.custom("PlusJakartaSans-Bold", size: 13))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text(milestoneLabel)
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textMid)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            emptyState
        }
    }

    private var questProgressRing: some View {
        ZStack {
            Circle()
                .stroke(Color.surfaceHigh, lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.hero, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Image(systemName: "bolt.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.hero)
        }
        .frame(width: 44, height: 44)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.hero)
            Text("Start a quest")
                .font(.custom("PlusJakartaSans-Bold", size: 13))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var progress: CGFloat {
        guard data.activeQuestMilestoneTotal > 0 else { return 0 }
        return CGFloat(data.activeQuestMilestoneCompleted) / CGFloat(data.activeQuestMilestoneTotal)
    }

    private var milestoneLabel: String {
        "\(data.activeQuestMilestoneCompleted)/\(data.activeQuestMilestoneTotal) milestones"
    }
}

// MARK: - Medium Widget View

struct ActiveQuestMediumView: View {
    let data: WidgetData

    var body: some View {
        HStack(spacing: 12) {
            questSection
            Divider()
            statsSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var questSection: some View {
        if let title = data.activeQuestTitle {
            VStack(alignment: .leading, spacing: 6) {
                Label {
                    Text("Active Quest")
                        .font(.custom("PlusJakartaSans-Bold", size: 10))
                        .textCase(.uppercase)
                        .tracking(1)
                } icon: {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 9))
                }
                .foregroundStyle(Color.hero)

                Text(title)
                    .font(.custom("PlusJakartaSans-Bold", size: 15))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)

                Spacer()

                progressBar
                Text(milestoneLabel)
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textMid)
            }
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.hero)
                Text("No active quest")
                    .font(.custom("PlusJakartaSans-Bold", size: 15))
                    .foregroundStyle(Color.textMid)
                Spacer()
                Text("Tap to start one")
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textLight)
            }
        }
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            statRow(icon: "star.fill", label: "XP", value: "\(data.totalXP)", color: Color.victory)
            statRow(icon: "shield.fill", label: "Lv.\(data.currentLevel)", value: data.levelTitle, color: Color.hero)
            statRow(icon: "flame.fill", label: "Streak", value: "\(data.captureStreakCount)d", color: Color.streak)
            statRow(icon: "trophy.fill", label: "Done", value: "\(data.questsCompletedCount)", color: Color.victory)
        }
    }

    private func statRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 10))
                .foregroundStyle(Color.textMid)
            Spacer()
            Text(value)
                .font(.custom("PlusJakartaSans-Bold", size: 11))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.surfaceHigh)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.victory)
                    .frame(width: geo.size.width * progress)
            }
        }
        .frame(height: 6)
    }

    private var progress: CGFloat {
        guard data.activeQuestMilestoneTotal > 0 else { return 0 }
        return CGFloat(data.activeQuestMilestoneCompleted) / CGFloat(data.activeQuestMilestoneTotal)
    }

    private var milestoneLabel: String {
        "\(data.activeQuestMilestoneCompleted)/\(data.activeQuestMilestoneTotal) milestones"
    }
}

// MARK: - Widget Definition

struct ActiveQuestWidget: Widget {
    let kind = "ActiveQuestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ActiveQuestProvider()) { entry in
            ActiveQuestWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Active Quest")
        .description("Track your current quest progress and player stats.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ActiveQuestWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: ActiveQuestEntry

    var body: some View {
        switch family {
        case .systemSmall:
            ActiveQuestSmallView(data: entry.data)
                .widgetURL(URL(string: "ideatamer://focus"))
        case .systemMedium:
            ActiveQuestMediumView(data: entry.data)
                .widgetURL(URL(string: "ideatamer://focus"))
        default:
            ActiveQuestSmallView(data: entry.data)
        }
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    ActiveQuestWidget()
} timeline: {
    ActiveQuestEntry(date: .now, data: .empty)
    ActiveQuestEntry(date: .now, data: WidgetData(
        activeQuestTitle: "Build IdeaTamer Widget",
        activeQuestMilestoneTotal: 5,
        activeQuestMilestoneCompleted: 3,
        activeQuestActivatedAt: .now,
        totalXP: 1250,
        currentLevel: 4,
        levelTitle: "Spark",
        captureStreakCount: 7,
        focusStreakCount: 3,
        questsCompletedCount: 2,
        weeklyXP: 350,
        lastUpdated: .now
    ))
}

#Preview(as: .systemMedium) {
    ActiveQuestWidget()
} timeline: {
    ActiveQuestEntry(date: .now, data: WidgetData(
        activeQuestTitle: "Build IdeaTamer Widget",
        activeQuestMilestoneTotal: 5,
        activeQuestMilestoneCompleted: 3,
        activeQuestActivatedAt: .now,
        totalXP: 1250,
        currentLevel: 4,
        levelTitle: "Spark",
        captureStreakCount: 7,
        focusStreakCount: 3,
        questsCompletedCount: 2,
        weeklyXP: 350,
        lastUpdated: .now
    ))
}
