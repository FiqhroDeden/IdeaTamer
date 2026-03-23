import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var profile: PlayerProfile?
    @State private var streakReminders = false
    @State private var questNudge = false
    @State private var reminderTime = Calendar.current.date(from: DateComponents(hour: 21, minute: 0)) ?? .now
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var showResetConfirm = false

    var body: some View {
        NavigationStack {
            List {
                notificationsSection
                aboutSection
                statsSection
                dangerSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .task { await loadData() }
    }

    // MARK: - Notifications

    private var notificationsSection: some View {
        Section {
            Toggle(isOn: $streakReminders) {
                HStack(spacing: 12) {
                    settingIcon("flame.fill", color: Color.streak)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Streak Reminders")
                            .font(.brand(.body))
                            .fontWeight(.semibold)
                        Text("Daily reminder to make progress")
                            .font(.brand(.caption))
                            .foregroundStyle(Color.textLight)
                    }
                }
            }
            .tint(Color.streak)
            .onChange(of: streakReminders) { _, newValue in
                Task { await toggleStreakReminder(newValue) }
            }

            if streakReminders {
                DatePicker(
                    "Reminder Time",
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .font(.brand(.body))
                .onChange(of: reminderTime) { _, newTime in
                    let components = Calendar.current.dateComponents([.hour, .minute], from: newTime)
                    profile?.streakReminderHour = components.hour ?? 21
                    profile?.streakReminderMinute = components.minute ?? 0
                    if streakReminders {
                        NotificationService.scheduleStreakReminder(
                            hour: components.hour ?? 21,
                            minute: components.minute ?? 0
                        )
                    }
                }
            }

            Toggle(isOn: $questNudge) {
                HStack(spacing: 12) {
                    settingIcon("bolt.fill", color: Color.hero)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Quest Nudge")
                            .font(.brand(.body))
                            .fontWeight(.semibold)
                        Text("After 2 days of no progress")
                            .font(.brand(.caption))
                            .foregroundStyle(Color.textLight)
                    }
                }
            }
            .tint(Color.hero)
            .onChange(of: questNudge) { _, newValue in
                Task { await toggleQuestNudge(newValue) }
            }

            if notificationStatus == .denied {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.rival)
                    Text("Notifications are disabled in Settings. Tap to open.")
                        .font(.brand(.caption))
                        .foregroundStyle(Color.textMid)
                }
                .onTapGesture {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } header: {
            Text("Notifications")
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                    .font(.brand(.body))
                Spacer()
                Text("1.0.0")
                    .font(.brand(.body))
                    .foregroundStyle(Color.textMid)
            }
            HStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text("IdeaTamer")
                        .font(.brand(.headline))
                        .foregroundStyle(Color.hero)
                    Text("Stop collecting ideas. Start finishing them.")
                        .font(.brand(.caption))
                        .foregroundStyle(Color.textMid)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("About")
        }
    }

    // MARK: - Stats

    private var statsSection: some View {
        Section {
            statRow("Level", value: "\(profile?.currentLevel ?? 1) — \(XP.title(for: profile?.currentLevel ?? 1))")
            statRow("Total XP", value: "\(profile?.totalXP ?? 0)")
            statRow("Quests Shipped", value: "\(profile?.questsCompletedCount ?? 0)")
            statRow("Capture Streak", value: "\(profile?.captureStreakCount ?? 0) days")
            statRow("Badges Earned", value: "\(profile?.unlockedBadges.count ?? 0) / 7")
        } header: {
            Text("Your Stats")
        }
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.brand(.body))
            Spacer()
            Text(value)
                .font(.brand(.body))
                .fontWeight(.semibold)
                .foregroundStyle(Color.hero)
        }
    }

    // MARK: - Danger Zone

    private var dangerSection: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirm = true
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Reset All Data")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.rival)
            }
            .confirmationDialog("Reset All Data?", isPresented: $showResetConfirm, titleVisibility: .visible) {
                Button("Reset Everything", role: .destructive) {
                    resetAllData()
                    dismiss()
                }
            } message: {
                Text("This will permanently delete all your ideas, milestones, XP, badges, and duel history. This cannot be undone.")
            }
        } header: {
            Text("Danger Zone")
        }
    }

    // MARK: - Helpers

    private func settingIcon(_ name: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 28, height: 28)
            Image(systemName: name)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
    }

    private func loadData() async {
        profile = PlayerProfile.fetchOrCreate(context: modelContext)
        streakReminders = profile?.streakRemindersEnabled ?? false
        questNudge = profile?.questNudgeEnabled ?? false
        notificationStatus = await NotificationService.checkPermissionStatus()

        // Load saved reminder time
        let hour = profile?.streakReminderHour ?? 21
        let minute = profile?.streakReminderMinute ?? 0
        reminderTime = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
    }

    private func toggleStreakReminder(_ enabled: Bool) async {
        if enabled {
            let granted = await NotificationService.requestPermission()
            if granted {
                let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                NotificationService.scheduleStreakReminder(
                    hour: components.hour ?? 21,
                    minute: components.minute ?? 0
                )
                profile?.streakRemindersEnabled = true
            } else {
                streakReminders = false
                notificationStatus = await NotificationService.checkPermissionStatus()
            }
        } else {
            NotificationService.cancelStreakReminder()
            profile?.streakRemindersEnabled = false
        }
    }

    private func toggleQuestNudge(_ enabled: Bool) async {
        if enabled {
            let granted = await NotificationService.requestPermission()
            if granted {
                NotificationService.scheduleQuestNudge()
                profile?.questNudgeEnabled = true
            } else {
                questNudge = false
                notificationStatus = await NotificationService.checkPermissionStatus()
            }
        } else {
            NotificationService.cancelQuestNudge()
            profile?.questNudgeEnabled = false
        }
    }

    private func resetAllData() {
        NotificationService.cancelAll()
        try? modelContext.delete(model: Idea.self)
        try? modelContext.delete(model: Milestone.self)
        try? modelContext.delete(model: PlayerProfile.self)
        try? modelContext.delete(model: WeeklySnapshot.self)
        try? modelContext.delete(model: CurrentWeekTracker.self)
    }
}
