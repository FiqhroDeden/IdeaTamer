# IdeaTamer

Gamified idea focus app — capture ideas, score them, activate ONE as a quest, compete with your past self weekly. Free, offline-first, no accounts. iOS 26+ with Liquid Glass + Kinetic Quest design.

**Tagline:** "Stop collecting ideas. Start finishing them." / "Compete with yourself."

## Core principles

- **Simplicity first:** Make every change as simple as possible. Impact minimal code.
- **No laziness:** Find root causes. No temporary fixes. Senior developer standards.
- **Minimal impact:** Changes should only touch what's necessary. Avoid introducing bugs.
- **Demand elegance (balanced):** For non-trivial changes, pause and ask "is there a more elegant way?" Skip for simple obvious fixes — don't over-engineer.

## Workflow orchestration

1. **Plan mode default:** Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions). If something goes sideways, STOP and re-plan immediately — don't keep pushing.
2. **Subagent strategy:** Use subagents liberally to keep main context clean. Offload research, exploration, and parallel analysis. One task per subagent for focused execution.
3. **Self-improvement loop:** After ANY correction from the user, update `tasks/lessons.md` with the pattern. Write rules that prevent the same mistake. Review lessons at session start.
4. **Verification before done:** Never mark a task complete without proving it works. Ask yourself: "Would a staff iOS engineer approve this?" Run tests, check logs, demonstrate correctness.
5. **Autonomous bug fixing:** When given a bug report, just fix it. Don't ask for hand-holding. Point at logs, errors, failing tests — then resolve them.

## Task management

1. **Plan first:** Write plan to `tasks/todo.md` with checkable items.
2. **Verify plan:** Check in before starting implementation.
3. **Track progress:** Mark items complete as you go.
4. **Explain changes:** High-level summary at each step.
5. **Document results:** Add review section to `tasks/todo.md`.
6. **Capture lessons:** Update `tasks/lessons.md` after corrections.

## Tech stack

- Swift 6.2, SwiftUI, iOS 26+ minimum deployment
- SwiftData (`@Model` macro) for local persistence
- UserNotifications for streak reminders (optional, local-only)
- BGTaskScheduler for weekly snapshot creation at week boundary
- MVVM with `@Observable` ViewModels
- Zero third-party dependencies — pure Apple frameworks only (except Plus Jakarta Sans font bundle)
- Xcode 26, Swift Testing + XCTest UI Tests

## Build & run

```
# Open project (no CLI builds — use Xcode for SwiftUI previews)
open IdeaTamer.xcodeproj
# Scheme: IdeaTamer > iPhone 16 Pro simulator
# Run tests: Cmd+U in Xcode
```

## Project structure

```
IdeaTamer/
├── App/                  → IdeaTamerApp.swift, ContentView.swift (TabView)
├── Models/
│   ├── Idea.swift        → @Model — the core quest entity
│   ├── Milestone.swift   → @Model — checklist items within a quest
│   ├── PlayerProfile.swift → @Model singleton — XP, level, streaks, badges
│   ├── WeeklySnapshot.swift → @Model — past week stats for duel comparison
│   ├── CurrentWeekTracker.swift → @Model singleton — running weekly totals
│   └── Enums.swift       → IdeaStatus, DuelResult, BadgeType
├── ViewModels/           → @Observable VMs: Inbox, Focus, Duel, Park, Done, Scoring, Onboarding
├── Views/
│   ├── Inbox/            → InboxView, QuickCaptureBar, IdeaCard, DuelBannerMini
│   ├── Focus/            → FocusView, ProgressRing, MilestoneList, ShadowCheckCard
│   ├── Duel/             → DuelView, VSCard, RoundCard, MomentumBadge, DuelHistory
│   ├── Park/             → ParkView, RankedQuestCard, VaultStats
│   ├── Done/             → DoneView, CompletedQuestCard, BadgeGrid, LegacyStats
│   ├── Scoring/          → ScoringSheet (presented as .medium detent)
│   ├── Sharing/          → ShareSheet, ShareCardRenderer
│   ├── Onboarding/       → OnboardingView, OnboardingPage1/2/3
│   └── Components/       → GlassCard, ScoreBadge, XPFloatView, ConfettiView, StreakBadge
├── Services/
│   ├── XPService.swift   → XP awarding, level-up detection, float animation triggers
│   ├── StreakService.swift → Streak calculation, reset logic, comparison to past
│   ├── DuelService.swift → Weekly snapshot, round comparison, result calculation
│   ├── BadgeService.swift → Badge unlock evaluation after each action
│   ├── ShareCardService.swift → UIGraphicsImageRenderer card generation
│   └── NotificationService.swift → Local notification scheduling (streak reminders)
├── Extensions/           → Color+Brand, Date+Week, View+Glass, Animation+Spring
├── Resources/
│   ├── Assets.xcassets   → App icon, brand colors as named colors
│   ├── Fonts/            → PlusJakartaSans-*.ttf (400, 500, 600, 700, 800)
│   └── Preview Content/  → Sample data for SwiftUI previews
├── docs/                 → IdeaTamer_PRD_v1.md, IdeaTamer_Mockups.html
└── tasks/                → todo.md, lessons.md
```

## Architecture rules

- Every screen gets its own `@Observable` ViewModel. Views never access `ModelContext` directly.
- ViewModels own the `ModelContext`; pass via initializer, not environment.
- Business logic (XP awarding, scoring formula, streak resets, duel calculations, badge unlocks) lives in Services or ViewModel methods — NEVER in View bodies.
- Navigation uses `NavigationStack` with typed `NavigationPath`. No coordinator pattern.
- Use `@Query` in Views only for read-only lists. Mutations go through ViewModel.
- Services are stateless utility classes with static methods or lightweight `@Observable` singletons.

## SwiftUI rules — IMPORTANT

- NEVER put more than ~50 lines in a single `var body`. Extract subviews to avoid "compiler unable to type-check" errors.
- Prefer `LazyVStack` inside `ScrollView` over `List` for custom-styled item lists (Kinetic Quest cards need custom styling).
- Use `.task {}` for async work, never `onAppear` with `Task {}`.
- Always add `@MainActor` to ViewModels and any class that touches UI state.
- Use `private` on `@State` and `@Binding` properties.
- Use SF Symbols (`Material Symbols` equivalent mapped to SF Symbols) for all icons.
- Prefer `.font(.system(.body, design: .rounded))` for body text OR use Plus Jakarta Sans via custom font modifier.
- Tab bar icons: `tray.and.arrow.down` (Inbox), `bolt.fill` (Focus), `figure.fencing` (Duel), `square.grid.2x2` (Park), `trophy.fill` (Done).

## SwiftData rules — IMPORTANT

- `Milestone` is a separate `@Model` with a relationship to `Idea` — NOT embedded Codable.
- `PlayerProfile` and `CurrentWeekTracker` are singletons — fetch or create on first access.
- Always update `updatedAt = .now` on Idea before any save.
- Use `#Predicate` for filtering (e.g., `.inbox` status, `.parked` sorted by score), never raw string predicates.
- For previews, use in-memory container: `ModelContainer(for: Idea.self, Milestone.self, PlayerProfile.self, WeeklySnapshot.self, CurrentWeekTracker.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))`.
- Max 1 `Idea` with `.active` status enforced in ViewModel (check before activation).

## iOS 26 Liquid Glass — IMPORTANT

- Apply `.glassEffect()` to cards, sheets, and the tab bar for Liquid Glass look.
- NEVER apply `.background()` BEFORE `.glassEffect()` — it blocks the glass material. Glass modifier must come first.
- Use `.ultraThinMaterial` as base material for glass surfaces.
- Tab bar: use native `TabView` with `.tabViewStyle(.automatic)` — iOS 26 applies glass automatically.
- Duel tab active state uses red tint; all others use blue. Implement with custom tab bar styling.
- All animations use `spring(response:dampingFraction:)`, not `.default` or `.linear`.
- Scoring sheet presented as `.presentationDetents([.medium, .large])`.
- Share sheet presented as custom bottom sheet with `.ultraThinMaterial` background.

## Design tokens

```swift
// MARK: - Brand Colors (Hero Blue vs Rival Red)

// Hero Blue — "You, right now"
static let heroBG      = Color(hex: "EBF2FF")
static let heroLight   = Color(hex: "A8C8FF")
static let heroMid     = Color(hex: "4D8FFF")
static let hero        = Color(hex: "1B6EF2")  // Primary
static let heroDim     = Color(hex: "0A4FBD")
static let heroDeep    = Color(hex: "0A3578")

// Rival Red — "Past you, the enemy"
static let rivalBG     = Color(hex: "FFF0ED")
static let rivalLight  = Color(hex: "FFB8AA")
static let rivalMid    = Color(hex: "FF6B52")
static let rival       = Color(hex: "E5432A")  // Primary
static let rivalDim    = Color(hex: "B22D18")
static let rivalDeep   = Color(hex: "721C0F")

// Victory Emerald — completions, XP, success
static let victoryBG   = Color(hex: "E6F7EF")
static let victoryLight = Color(hex: "5CE0A0")
static let victory     = Color(hex: "12B76A")  // Primary
static let victoryDim  = Color(hex: "0D7A48")

// Streak Amber — streaks, urgency, rewards
static let streakBG    = Color(hex: "FFF6E5")
static let streakLight = Color(hex: "FFCB57")
static let streak      = Color(hex: "F5A623")  // Primary
static let streakDim   = Color(hex: "B87A0A")

// Surface Neutrals
static let surface     = Color(hex: "F8F7F6")
static let surfaceLow  = Color(hex: "F1F0EF")
static let surfaceHigh = Color(hex: "E3E2E0")
static let card        = Color.white
static let textPrimary = Color(hex: "2E2F2F")  // Never use pure black
static let textMid     = Color(hex: "5B5C5B")
static let textLight   = Color(hex: "8A8B8A")

// MARK: - Score Color Coding
static func scoreColor(_ score: Int) -> Color {
    if score >= 70 { return .victory }
    if score >= 40 { return .streak }
    return .hero
}

// MARK: - Animations
static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
static let xpFloatDuration: Double = 1.2
static let confettiDuration: Double = 2.0
static let duelBarDuration: Double = 0.7
```

## Scoring formula

```swift
/// Computes idea score from 3 sliders (each 1–10). Returns 1–100.
static func computeScore(impact: Int, effort: Int, alignment: Int) -> Int {
    let raw = Double(impact + alignment - effort + 10) * 3.33
    return max(1, min(100, Int(raw.rounded())))
}
```

## XP rules quick reference

| Action | XP | Constant name |
|--------|----|---------------|
| Capture idea | +10 | `XP.capture` |
| Score idea | +25 | `XP.score` |
| Complete milestone | +50 | `XP.milestone` |
| Complete quest | +500 | `XP.questComplete` |
| Win weekly duel (3+ rounds) | +200 | `XP.duelWin` |
| Draw weekly duel (2-2) | +50 | `XP.duelDraw` |
| Daily capture streak/day | +15 | `XP.captureStreak` |
| Focus streak/day | +20 | `XP.focusStreak` |

## Level formula

```swift
/// XP required for a specific level: 100 × level
/// Cumulative XP for level N = sum(100 × i for i in 1...N)
static func levelFor(xp: Int) -> Int {
    var level = 0
    var remaining = xp
    while remaining >= (level + 1) * 100 {
        level += 1
        remaining -= level * 100
    }
    return max(1, level)
}

static let levelTitles: [Int: String] = [
    1: "Spark", 5: "Flame", 10: "Creator",
    15: "Legendary Creator", 20: "Grandmaster", 25: "Legend"
]
```

## Weekly duel logic

```swift
/// Compare current week vs last week's snapshot across 4 rounds.
/// Returns (roundsWon: Int, roundsLost: Int) — win 3+ = duel win.
/// Rounds: XP earned, milestones completed, ideas captured, streak days.
///
/// Momentum = ((thisWeekXP - lastWeekXP) / lastWeekXP) × 100
/// Clamped to -99%...999%. Show green trending_up or red trending_down.
///
/// First week (no snapshot): show "This week sets your baseline"
```

## Data model quick reference

```
Idea (@Model): id, title (120 max), descriptionText?, impactScore?, effortScore?,
  alignmentScore?, computedScore?, status: IdeaStatus, xpEarned: Int,
  createdAt, activatedAt?, completedAt?, completionDays?: Int,
  milestones: [Milestone] (relationship)

Milestone (@Model): id, title (200 max), isCompleted: Bool, completedAt?,
  sortOrder: Int, idea: Idea (parent)

PlayerProfile (@Model singleton): totalXP, currentLevel, captureStreakCount,
  captureStreakLastDate?, focusStreakCount, focusStreakLastDate?,
  unlockedBadges: [String], questsCompletedCount, hasCompletedOnboarding

WeeklySnapshot (@Model): id, weekStartDate, xpEarned, milestonesCompleted,
  ideasCaptured, streakDays, duelResult?: DuelResult

CurrentWeekTracker (@Model singleton): weekStartDate, xpEarned,
  milestonesCompleted, ideasCaptured, streakDays

IdeaStatus: .inbox | .parked | .active | .completed
DuelResult: .win | .loss | .draw
```

## Badge unlock conditions

| Badge ID | Condition | Color |
|----------|-----------|-------|
| `firstBlood` | Complete first quest ever | Victory |
| `streak7` | 7-day capture streak | Amber |
| `superFocus` | Complete quest with 5+ milestones, no parking | Blue |
| `polisher` | Score an idea ≥90/100 | Victory |
| `selfSurpassed` | Win a weekly duel (3+ rounds) | Red |
| `moonshot` | Complete 10 quests total | Gray → Victory on unlock |
| `streakMaster` | 30-day capture streak | Amber |

## Typography

Plus Jakarta Sans is the primary font. Load via custom font bundle registered in Info.plist.

```swift
// Usage pattern
.font(.custom("PlusJakartaSans-ExtraBold", size: 28))  // Display
.font(.custom("PlusJakartaSans-Bold", size: 18))        // Headline
.font(.custom("PlusJakartaSans-Bold", size: 14))        // Title
.font(.custom("PlusJakartaSans-Regular", size: 13))     // Body
.font(.custom("PlusJakartaSans-Bold", size: 10))        // Label (use .textCase(.uppercase) + .tracking(1))
```

## Tab bar behavior

| Tab | SF Symbol | Active tint | Notes |
|-----|-----------|-------------|-------|
| Inbox | `tray.and.arrow.down.fill` | Hero Blue | Default landing tab |
| Focus | `bolt.fill` | Hero Blue | Filled when active |
| Duel | `figure.fencing` | **Rival Red** | Red tint = enemy territory |
| Park | `square.grid.2x2.fill` | Hero Blue | — |
| Done | `trophy.fill` | Hero Blue | Filled when active |

## Code style

- Modern concurrency: `async/await`, `@MainActor`, `Sendable`.
- Prefer `guard` for early returns. Max 3 levels of nesting.
- File names match primary type: `InboxView.swift`, `Idea.swift`.
- Group with `// MARK: -` comments. Max 400 lines per file.
- Use `Logger` (from `os`) for debug logging, never `print()`.
- All user-facing strings use `LocalizedStringKey` for future localization.
- XP constants defined in a single `XP` enum for consistency.

## Git workflow

- Conventional commits: `feat:`, `fix:`, `refactor:`, `style:`, `docs:`, `test:`.
- One feature per commit. Atomic and reviewable.
- NEVER modify `.pbxproj` directly — create files, add to Xcode manually.
- Branch naming: `sprint-N/feature-name` (e.g., `sprint-1/inbox-capture`).

## Testing

- Swift Testing (`@Test`, `#expect`) for unit tests, XCTest for UI tests.
- Test ViewModels thoroughly — they hold all business logic.
- In-memory `ModelContainer` for SwiftData tests.
- Priority test coverage: scoring formula, XP awarding, level calculation, streak reset logic, duel round comparison, badge unlock conditions, one-active-quest enforcement.

## Development roadmap (quick ref)

Full sprint breakdown in PRD Section 13. Summary:

| Sprint | Focus | Est. days |
|--------|-------|-----------|
| 0 | Foundation: structure, models, tokens, fonts, TabView | 1 |
| 1 | Core data: CRUD, scoring formula, status machine, tests | 2 |
| 2 | Inbox + Quick Capture + Scoring Modal | 2–3 |
| 3 | Focus + Milestones + Progress Ring | 2–3 |
| 4 | Park (Vault) + Idea Detail Sheet | 2 |
| 5 | Gamification services: XP, levels, streaks, badges | 2–3 |
| 6 | Weekly Duel: snapshot, comparison, DuelView, momentum | 3 |
| 7 | Done (Hall of Fame) + Confetti + Badge Grid | 2 |
| 8 | Social Sharing: card renderer, share sheet | 2 |
| 9 | Onboarding: 3 pages with animations | 1–2 |
| 10 | Polish: empty states, dark mode, a11y, performance | 2–3 |

**Total: 20–25 days**

## Reference docs

- Full requirements + roadmap: `docs/IdeaTamer_PRD_v1.md`
- Visual mockups: `docs/IdeaTamer_Mockups.html`

## Gotchas — add new ones as discovered

- `#Preview` with SwiftData requires wrapping in a container; use the preview helper.
- `@Query` does NOT work inside `@Observable` classes — only in SwiftUI Views.
- Enums with `Codable` must have `String` raw values for SwiftData JSON storage.
- `matchedGeometryEffect` requires source and destination in the view hierarchy simultaneously.
- iOS 26 `glassEffect` only renders in simulator on Xcode 26+ — invisible in canvas previews.
- Plus Jakarta Sans must be registered in Info.plist under "Fonts provided by application" — each weight as separate .ttf entry.
- `PlayerProfile` and `CurrentWeekTracker` singletons: always use fetch-or-create pattern, never assume they exist.
- Weekly snapshot must be created via BGTaskScheduler or on app launch (check if Monday has passed since last snapshot).
- Max 1 active quest enforced in ViewModel — always check `Idea.status == .active` count before allowing activation.
- Score formula edge case: all sliders at default (5,5,5) = score of 50. Ensure sliders default to 5 not 1.
- When a fix feels hacky, step back: "Knowing everything I know now, implement the elegant solution."