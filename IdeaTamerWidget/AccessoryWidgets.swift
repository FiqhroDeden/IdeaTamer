import WidgetKit
import SwiftUI

// MARK: - Shared Accessory Provider

struct AccessoryProvider: TimelineProvider {
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

// MARK: - Quest Progress (Circular)

struct QuestProgressAccessory: Widget {
    let kind = "QuestProgressAccessory"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AccessoryProvider()) { entry in
            QuestProgressAccessoryView(data: entry.data)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Quest Progress")
        .description("Milestone progress for your active quest.")
        .supportedFamilies([.accessoryCircular])
    }
}

struct QuestProgressAccessoryView: View {
    let data: WidgetData

    var body: some View {
        if data.activeQuestTitle != nil {
            Gauge(value: progress) {
                Image(systemName: "bolt.fill")
            }
            .gaugeStyle(.accessoryCircularCapacity)
        } else {
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 20))
            }
        }
    }

    private var progress: Double {
        guard data.activeQuestMilestoneTotal > 0 else { return 0 }
        return Double(data.activeQuestMilestoneCompleted) / Double(data.activeQuestMilestoneTotal)
    }
}

// MARK: - Streak (Inline)

struct StreakAccessory: Widget {
    let kind = "StreakAccessory"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AccessoryProvider()) { entry in
            StreakAccessoryView(data: entry.data)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Capture Streak")
        .description("Your current capture streak.")
        .supportedFamilies([.accessoryInline])
    }
}

struct StreakAccessoryView: View {
    let data: WidgetData

    var body: some View {
        Label("\(data.captureStreakCount) day streak", systemImage: "flame.fill")
    }
}

// MARK: - Level (Rectangular)

struct LevelAccessory: Widget {
    let kind = "LevelAccessory"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AccessoryProvider()) { entry in
            LevelAccessoryView(data: entry.data)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Player Level")
        .description("Your current level and XP progress.")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct LevelAccessoryView: View {
    let data: WidgetData

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Level \(data.currentLevel)")
                .font(.headline)
                .widgetAccentable()
            Text(data.levelTitle)
                .font(.caption)
            Gauge(value: xpProgress) {
                EmptyView()
            }
            .gaugeStyle(.accessoryLinearCapacity)
        }
    }

    private var xpProgress: Double {
        // Approximate XP progress within current level
        let level = data.currentLevel
        let cumulativeForLevel = (1...max(1, level)).reduce(0) { $0 + $1 * 100 }
        let xpIntoCurrentLevel = data.totalXP - cumulativeForLevel
        let xpNeededForNext = (level + 1) * 100
        return max(0, min(1, Double(xpIntoCurrentLevel) / Double(xpNeededForNext)))
    }
}
