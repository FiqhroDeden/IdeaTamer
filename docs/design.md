# IdeaTamer — Technical Design Document

## 1. System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       SwiftUI Views                          │
│  InboxView · FocusView · DuelView · ParkView · DoneView     │
│  @Query for read-only lists │ Actions delegated to ViewModel │
└──────────────────────┬──────────────────────────────────────┘
                       │ @Observable binding
┌──────────────────────▼──────────────────────────────────────┐
│                       ViewModels                             │
│  Own ModelContext · Mutate SwiftData · Call Services          │
│  InboxVM · FocusVM · DuelVM · ParkVM · DoneVM · ScoringVM   │
└──────────┬───────────────────────┬──────────────────────────┘
           │                       │
┌──────────▼────────────┐   ┌──────▼──────────────────────────┐
│  SwiftData Layer       │   │  Stateless Services              │
│  ModelContainer        │   │  XPService · StreakService        │
│  @Model entities       │   │  DuelService · BadgeService       │
│  #Predicate queries    │   │  ShareCardService                 │
│                        │   │  NotificationService              │
└────────────────────────┘   └──────────────────────────────────┘
```

### Key Rules
- Views never access `ModelContext` directly — use `@Query` for reads, ViewModel for writes
- ViewModels receive `ModelContext` via initializer, not `@Environment`
- Services are stateless enums with static methods — no state, pure logic, trivially testable
- App entry point creates one `ModelContainer` shared via `.modelContainer()` modifier

---

## 2. Data Flow — Core Actions

### 2.1 Capture Idea
```
User types title → taps "+" or return
  → InboxViewModel.captureIdea(title:description:)
    → Create Idea(title:, status: .inbox, createdAt: .now)
    → modelContext.insert(idea)
    → XPService.awardCapture(profile:tracker:) → +10 XP
    → StreakService.recordCapture(profile:date:) → update captureStreak
    → BadgeService.evaluate(profile:) → check streak7, streakMaster
    → Return XPEvent for XPFloatView animation
```

### 2.2 Score Idea
```
User adjusts 3 sliders → taps "Score & Park"
  → ScoringViewModel.saveScore(idea:impact:effort:alignment:)
    → idea.impactScore = impact, effortScore = effort, alignmentScore = alignment
    → idea.computedScore = ScoringFormula.compute(impact:effort:alignment:)
    → idea.status = .parked
    → XPService.awardScore(profile:tracker:) → +25 XP
    → BadgeService.evaluate(profile:) → check polisher (score ≥ 90)
```

### 2.3 Activate Idea
```
User taps "Activate" on parked/inbox idea
  → ViewModel.activateIdea(_:)
    → Guard: fetch count where status == .active == 0
    → idea.status = .active
    → idea.activatedAt = .now
```

### 2.4 Complete Milestone
```
User taps checkbox on milestone
  → FocusViewModel.completeMilestone(_:)
    → milestone.isCompleted = true
    → milestone.completedAt = .now
    → XPService.awardMilestone(profile:tracker:) → +50 XP
    → tracker.milestonesCompleted += 1
    → BadgeService.evaluate(profile:)
    → If ALL milestones complete → trigger quest completion
```

### 2.5 Complete Quest
```
All milestones done OR manual "Complete Quest"
  → FocusViewModel.completeQuest(_:)
    → idea.status = .completed
    → idea.completedAt = .now
    → idea.completionDays = Calendar days from activatedAt
    → XPService.awardQuestComplete(profile:tracker:) → +500 XP
    → profile.questsCompletedCount += 1
    → BadgeService.evaluate(profile:) → check firstBlood, superFocus, moonshot
    → Trigger confetti + level-up check
```

### 2.6 Weekly Snapshot
```
App launch OR BGTaskScheduler fires (Monday)
  → DuelService.checkAndCreateSnapshot(context:)
    → Fetch CurrentWeekTracker
    → If tracker.weekStartDate < this Monday:
      → Create WeeklySnapshot from tracker values
      → Fetch previous snapshot for comparison
      → Compare 4 rounds: XP, milestones, captures, streaks
      → Set snapshot.duelResult = result
      → XPService.awardDuel(profile:result:) → +200/+50/+0
      → BadgeService.evaluate(profile:) → selfSurpassed badge
      → Reset tracker: weekStartDate = thisMonday, all counters = 0
```

---

## 3. SwiftData Schema

### Entity Relationship Diagram

```
┌───────────────────┐    cascade     ┌────────────────────┐
│      Idea         │ ──── 1:N ────► │    Milestone        │
│  (@Model)         │                │  (@Model)           │
│                   │                │                     │
│  id: UUID         │                │  id: UUID           │
│  title: String    │                │  title: String      │
│  descriptionText? │ ◄── .idea ──── │  isCompleted: Bool  │
│  impactScore?     │                │  completedAt: Date? │
│  effortScore?     │                │  sortOrder: Int     │
│  alignmentScore?  │                └────────────────────┘
│  computedScore?   │
│  status: IdeaStatus│
│  xpEarned: Int    │
│  createdAt: Date  │
│  activatedAt?     │
│  completedAt?     │
│  completionDays?  │
└───────────────────┘

┌──────────────────────┐   ┌──────────────────────────┐
│  PlayerProfile       │   │  CurrentWeekTracker       │
│  (@Model singleton)  │   │  (@Model singleton)       │
│                      │   │                           │
│  totalXP: Int        │   │  weekStartDate: Date      │
│  currentLevel: Int   │   │  xpEarned: Int            │
│  captureStreakCount   │   │  milestonesCompleted: Int │
│  captureStreakLastDate│   │  ideasCaptured: Int       │
│  focusStreakCount     │   │  streakDays: Int          │
│  focusStreakLastDate  │   └──────────────────────────┘
│  unlockedBadges: [String]│
│  questsCompletedCount │   ┌──────────────────────────┐
│  hasCompletedOnboarding│  │  WeeklySnapshot          │
└──────────────────────┘   │  (@Model)                 │
                           │                           │
                           │  id: UUID                 │
                           │  weekStartDate: Date      │
                           │  xpEarned: Int            │
                           │  milestonesCompleted: Int  │
                           │  ideasCaptured: Int        │
                           │  streakDays: Int           │
                           │  duelResult: DuelResult?   │
                           └──────────────────────────┘
```

### Constraints (enforced in code)
- **One active quest:** ViewModel guards `Idea.status == .active` count before activation
- **Singletons:** PlayerProfile and CurrentWeekTracker use `fetchOrCreate(context:)` pattern — `FetchDescriptor` with `fetchLimit = 1`, create if empty
- **Title limits:** Validated in ViewModel before save (120 chars for Idea, 200 for Milestone)
- **Enum storage:** All enums use `String` raw values for SwiftData JSON storage
- **Cascade delete:** Deleting an Idea cascades to its Milestones

---

## 4. IdeaStatus State Machine

```
                  ┌───────────┐
     capture      │   .inbox   │
   ──────────►    │ (unscored) │
                  └──┬─────┬──┘
                     │     │
             score   │     │ activate (guard: no active quest)
                     │     │
                ┌────▼─┐   │
                │      │   │
          ┌─────▼───┐  └───▼──────────┐
          │ .parked  │◄───┐│  .active   │
          │ (scored, │    ││  (quest)   │
          │  vault)  │    │└─────┬──────┘
          └────┬─────┘    │     │
               │       park     │ complete
               │          │     │
               │          │  ┌──▼──────────┐
               └─activate─┘  │ .completed   │
                             │ (hall of     │
                             │  fame)       │
                             └─────────────┘
```

### Valid Transitions
| From | To | Trigger | Guard |
|------|----|---------|-------|
| `.inbox` | `.parked` | Score idea (3 sliders) | — |
| `.inbox` | `.active` | Activate unscored | No other active quest |
| `.parked` | `.active` | Activate from vault | No other active quest |
| `.active` | `.parked` | Park/pause quest | — |
| `.active` | `.completed` | Complete quest | — |

### Invalid Transitions
- `.completed` → anything (terminal state)
- Any → `.active` when another `.active` exists (one-quest constraint)

---

## 5. Service Interaction Map

```
                      ┌──────────────┐
                      │   ViewModel   │
                      │   (any)       │
                      └──┬──┬──┬──┬──┘
                         │  │  │  │
           ┌─────────────┘  │  │  └──────────────┐
           ▼                ▼  ▼                  ▼
     ┌──────────┐    ┌────────┐ ┌──────────┐ ┌─────────┐
     │XPService │    │Streak  │ │Badge     │ │Duel     │
     │          │    │Service │ │Service   │ │Service  │
     │award*()  │    │record()│ │evaluate()│ │snapshot()│
     │levelUp() │    │reset() │ │          │ │compare() │
     └──────┬───┘    └───┬────┘ └────┬─────┘ └────┬────┘
            │            │           │              │
            ▼            ▼           ▼              ▼
     ┌──────────────────────────────────────────────────┐
     │             Model Objects (passed in)             │
     │  PlayerProfile · CurrentWeekTracker · Idea        │
     └──────────────────────────────────────────────────┘
```

### Call Order (per action)
1. **XPService** — awards XP, increments tracker, checks level-up
2. **StreakService** — updates streak counts on profile
3. **BadgeService** — evaluates all conditions against current state, returns newly unlocked badges

**DuelService** is called separately — on app launch and via BGTaskScheduler, not per-action.

### Service Method Signatures
```swift
// XPService
static func awardCapture(profile:tracker:) -> XPEvent
static func awardScore(profile:tracker:) -> XPEvent
static func awardMilestone(profile:tracker:) -> XPEvent
static func awardQuestComplete(profile:tracker:) -> XPEvent
static func awardDuel(profile:result:) -> XPEvent?

// StreakService
static func recordCapture(profile:date:)
static func recordFocusDay(profile:date:)
static func checkStreakReset(profile:date:)

// BadgeService
static func evaluate(profile:idea:) -> [BadgeType]

// DuelService
static func checkAndCreateSnapshot(context:)
static func compareRounds(current:previous:) -> (won:Int, lost:Int)
static func computeMomentum(currentXP:previousXP:) -> Double
```

---

## 6. Weekly Duel Lifecycle

```
Monday 00:00 (local time)
         │
         ▼
┌─────────────────────────┐
│ 1. Detect week boundary │  Compare tracker.weekStartDate
│    (app launch / BGTask)│  vs current Monday
└────────┬────────────────┘
         │ New week detected
         ▼
┌─────────────────────────┐
│ 2. Snapshot tracker      │  Create WeeklySnapshot with
│    data                  │  tracker's xpEarned, milestones,
│                          │  ideasCaptured, streakDays
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 3. Compare 4 rounds     │  Fetch previous WeeklySnapshot
│    • XP Earned           │  Compare each metric
│    • Milestones Hit      │  Tally: wins vs losses
│    • Ideas Captured      │
│    • Streak Days         │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 4. Determine result     │  3+ wins = .win → +200 XP
│    Award XP              │  2-2     = .draw → +50 XP
│    Check badges          │  0-1 win = .loss → +0 XP
│                          │  selfSurpassed badge on first win
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 5. Reset tracker        │  weekStartDate = this Monday
│                          │  All counters = 0
└─────────────────────────┘

During the week:
  • Every action increments CurrentWeekTracker fields
  • DuelView reads tracker + last snapshot for live comparison
  • Momentum = ((tracker.xpEarned - last.xpEarned) / last.xpEarned) × 100
  • Clamped to -99%...+999%
  • First week (no snapshot): "This week sets your baseline"
```

---

## 7. Screen-to-ViewModel Mapping

| Screen | ViewModel | ModelContext | Key Responsibilities |
|--------|-----------|:-----------:|---------------------|
| ContentView (TabView) | — | — | Root container, tab selection, creates VMs |
| InboxView | InboxViewModel | ✓ | Capture ideas, list inbox, delete, trigger scoring |
| ScoringSheet | ScoringViewModel | ✓ | 3 sliders, live score preview, save + transition to parked |
| FocusView | FocusViewModel | ✓ | Active quest display, milestone CRUD, completion flow |
| DuelView | DuelViewModel | ✓ | Load snapshot + tracker, compute rounds, display results |
| ParkView | ParkViewModel | ✓ | List parked ideas sorted by score, activate |
| DoneView | DoneViewModel | ✓ | Completed ideas, badge grid, legacy stats |
| OnboardingView | OnboardingViewModel | ✓ | Page navigation, mark onboarding complete |

---

## 8. Shared Component Inventory

| Component | File | Purpose | Used In |
|-----------|------|---------|---------|
| GlassCard | `Views/Components/GlassCard.swift` | Reusable `.glassEffect()` container with padding + corner radius | All screens |
| ScoreBadge | `Views/Components/ScoreBadge.swift` | Colored pill showing score (green ≥70, amber 40–69, blue <40) | Inbox, Park, Done |
| XPFloatView | `Views/Components/XPFloatView.swift` | Animated "+N XP" text that floats up and fades (1.2s) | All XP-awarding screens |
| ConfettiView | `Views/Components/ConfettiView.swift` | Particle confetti overlay (2s, brand colors) | Focus (quest complete), Done |
| StreakBadge | `Views/Components/StreakBadge.swift` | Fire icon + streak count, amber color, pulse animation | Inbox, Focus |
| LevelUpOverlay | `Views/Components/LevelUpOverlay.swift` | Full-screen backdrop blur, spring-animated level number | App-level overlay |
| EmptyStateView | `Views/Components/EmptyStateView.swift` | SF Symbol illustration + title + subtitle | All tabs (empty state) |
| DuelBannerMini | `Views/Inbox/DuelBannerMini.swift` | Compact duel status at top of Inbox | Inbox |
| ProgressRing | `Views/Focus/ProgressRing.swift` | Circular progress indicator for milestone completion | Focus |
| VSCard | `Views/Duel/VSCard.swift` | Hero vs Shadow split card | Duel |
| RoundCard | `Views/Duel/RoundCard.swift` | Single duel round with animated bars | Duel |
| MomentumBadge | `Views/Duel/MomentumBadge.swift` | Trend % with arrow icon | Duel, Inbox |
