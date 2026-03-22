# IdeaTamer — Implementation Plan

## Sprint 0: Foundation (1 day)

**Goal:** Project structure, all models, design tokens, fonts verified, TabView shell.
**Dependencies:** None.

- [x] 0.1 Create directory structure (App/, Models/, ViewModels/, Views/*, Services/, Extensions/, tasks/)
- [x] 0.2 Delete `Item.swift` template scaffolding
- [x] 0.3 Create `Models/Enums.swift` — IdeaStatus, DuelResult, BadgeType (String raw values, Codable)
- [x] 0.4 Create `Models/Idea.swift` — @Model with all properties, @Relationship(cascade) to milestones
- [x] 0.5 Create `Models/Milestone.swift` — @Model with inverse relationship to Idea
- [x] 0.6 Create `Models/PlayerProfile.swift` — @Model singleton with fetchOrCreate(context:)
- [x] 0.7 Create `Models/WeeklySnapshot.swift` — @Model with all properties
- [x] 0.8 Create `Models/CurrentWeekTracker.swift` — @Model singleton with fetchOrCreate(context:)
- [x] 0.9 Create `Extensions/Color+Brand.swift` — Full palette + Color(hex:) + scoreColor()
- [x] 0.10 Create `Extensions/Animation+Spring.swift` — springFast/Medium/Gentle, duration constants
- [x] 0.11 Create `Extensions/Date+Week.swift` — startOfWeek, isToday, isSameDay, daysBetween
- [x] 0.12 Create `Extensions/View+Glass.swift` — .glassCard() modifier
- [x] 0.13 Create `Extensions/Font+Brand.swift` — Font.brand(.display/.headline/.title/.body/.label/.caption)
- [x] 0.14 Create `Extensions/XP.swift` — XP constants, levelFor(xp:), levelTitles
- [x] 0.15 Create `Extensions/ScoringFormula.swift` — ScoringFormula.compute(impact:effort:alignment:)
- [x] 0.16 Move + rewrite `App/IdeaTamerApp.swift` — ModelContainer with all 5 model types
- [x] 0.17 Move + rewrite `App/ContentView.swift` — 5-tab TabView with correct icons + Duel red tint

**Testing:** Build succeeds. App launches with 5 tabs. Font renders. Models compile.
**Done when:** App runs on simulator, TabView with correct icons/tints, all models compile.

---

## Sprint 1: Core Data Layer (2 days)

**Goal:** ViewModels with CRUD, scoring formula, status machine, one-active enforcement.
**Dependencies:** Sprint 0 complete.

- [x] 1.1 Create `ViewModels/InboxViewModel.swift` — captureIdea, deleteIdea, activateIdea
- [x] 1.2 Create `ViewModels/FocusViewModel.swift` — activateIdea (guard one-active), milestone CRUD, completeQuest, parkQuest
- [x] 1.3 Create `ViewModels/ParkViewModel.swift` — activateIdea with one-active guard, deleteIdea
- [x] 1.4 Create `ViewModels/ScoringViewModel.swift` — slider state, previewScore, saveScore, loadExistingScores
- [x] 1.5 Create `ViewModels/DoneViewModel.swift` — fetchCompletedIdeas, totalXP, avgCompletionDays
- [x] 1.6 PlayerProfile fetch-or-create (implemented in Sprint 0)
- [x] 1.7 CurrentWeekTracker fetch-or-create (implemented in Sprint 0)
- [x] 1.8 Create `IdeaTamerTests/ScoringFormulaTests.swift` — 8 tests covering all edge cases
- [x] 1.9 Create `IdeaTamerTests/XPLevelTests.swift` — 10 tests: levels, titles, progress, constants
- [x] 1.10 Create `IdeaTamerTests/StatusMachineTests.swift` — 8 tests: activation, transitions, milestones

**Testing:** All unit tests pass. In-memory ModelContainer for SwiftData tests.
**Done when:** CRUD operations work, scoring correct, one-active enforced, all tests green.

---

## Sprint 2: Inbox + Capture + Scoring (2–3 days)

**Goal:** Full capture-to-score flow with UI.
**Dependencies:** Sprint 1 complete.

- [x] 2.1 Create `Views/Inbox/InboxView.swift` — @Query .inbox, List with swipe actions, header + capture bar
- [x] 2.2 Create `Views/Inbox/QuickCaptureBar.swift` — TextField + "+10 XP" button, @FocusState
- [x] 2.3 Create `Views/Inbox/IdeaCard.swift` — title, relative date, pulsing dot or ScoreBadge
- [x] 2.4 Create `Views/Components/ScoreBadge.swift` — colored pill (green/amber/blue) via scoreColor()
- [x] 2.5 Create `Views/Scoring/ScoringSheet.swift` — .medium/.large detent, 3 sliders, live preview, "Score & Park"
- [x] 2.6 Create `Views/Components/XPFloatView.swift` — animated "+N XP" float with 1.2s easeOut
- [x] 2.7 Swipe actions: trailing=delete (destructive), leading=score (hero blue)
- [x] 2.8 Create `Views/Components/EmptyStateView.swift` — configurable SF Symbol + title + subtitle
- [x] 2.9 Wire InboxView into ContentView tab replacing placeholder

**Testing:** Capture idea → appears in list. Score → disappears from inbox. XP float animates.
**Done when:** Full capture-to-score flow, glass cards, XP float, empty state.

---

## Sprint 3: Focus + Milestones (2–3 days)

**Goal:** Active quest view with milestone management and completion.
**Dependencies:** Sprint 2 complete.

- [x] 3.1 Create `Views/Focus/FocusView.swift` — active quest display, empty state, XP floats
- [x] 3.2 Create `Views/Focus/ProgressRing.swift` — circular progress with animated trim, center %
- [x] 3.3 Create `Views/Focus/MilestoneList.swift` — sorted milestones, add via sheet, swipe delete
- [x] 3.4 Create `Views/Focus/MilestoneRow.swift` — checkbox states (done/in-progress/future), strikethrough
- [x] 3.5 Milestone completion XP (+50) float animation in FocusView
- [x] 3.6 Quest completion flow (+500 XP, confetti, status transition)
- [x] 3.7 Create `Views/Components/ConfettiView.swift` — 24 particles, brand colors, 2s duration
- [x] 3.8 Wire FocusView into ContentView tab replacing placeholder

**Testing:** Activate quest, add milestones, complete them, see progress ring update, complete quest → confetti.
**Done when:** Full milestone lifecycle, progress ring, confetti, park action works.

---

## Sprint 4: Park + Detail (2 days)

**Goal:** Ranked vault view with activation and detail sheet.
**Dependencies:** Sprint 2, 3 complete.

- [x] 4.1 Create `Views/Park/ParkView.swift` — @Query .parked sorted by score desc, VaultStats header
- [x] 4.2 Create `Views/Park/RankedQuestCard.swift` — rank #, title, ScoreBadge, activate button
- [x] 4.3 Create `Views/Park/VaultStats.swift` — 3-column grid: total, high (≥70), avg score
- [x] 4.4 Create `Views/Park/IdeaDetailSheet.swift` — edit title/desc, re-score, activate/delete with confirmations
- [x] 4.5 Wire ParkView into ContentView tab replacing placeholder
- [x] 4.6 Cross-tab activation: Park→Focus via ParkViewModel, one-active alert, detail sheet activate

**Testing:** Park shows ranked ideas. Activate → appears in Focus. Detail sheet edits work.
**Done when:** Full cross-tab flow, detail sheet, one-active alert.

---

## Sprint 5: Gamification Services (2–3 days)

**Goal:** XP/level/streak/badge engine fully wired.
**Dependencies:** Sprint 3 complete.

- [x] 5.1 Create `Services/XPService.swift` — XPEvent struct, awardXP core, convenience methods, level-up detection
- [x] 5.2 Create `Services/StreakService.swift` — recordCapture/Focus, checkStreakReset, consecutive/missed logic
- [x] 5.3 Create `Services/BadgeService.swift` — evaluate 7 conditions, no duplicates, returns newly unlocked
- [x] 5.4 Create `Views/Components/LevelUpOverlay.swift` — spring scale animation, haptic, tap to dismiss
- [x] 5.5 Integrate services into InboxVM (capture+streak+badge), ScoringVM (score+badge), FocusVM (milestone+quest+badge)
- [ ] 5.6 Add XP/level display to app header (deferred — needs ContentView header redesign)
- [x] 5.7 Create `IdeaTamerTests/StreakServiceTests.swift` — 7 tests: first, same-day, consecutive, missed, reset, preserve, focus
- [x] 5.8 Create `IdeaTamerTests/BadgeServiceTests.swift` — 7 tests: firstBlood, streak7, polisher, moonshot, noDupes, superFocus, streakMaster

**Testing:** All service tests pass. XP awards visible. Level-up triggers. Streaks track correctly.
**Done when:** Gamification loop complete end-to-end. All tests green.

---

## Sprint 6: Weekly Duel (3 days)

**Goal:** Full duel system with snapshot, comparison, UI, and background task.
**Dependencies:** Sprint 5 complete.

- [x] 6.1 Create `Services/DuelService.swift` — DuelRound struct, snapshot/compare/momentum/result, selfSurpassed badge
- [x] 6.2 Create `ViewModels/DuelViewModel.swift` — loads tracker+snapshot, rounds, momentum, history, score text
- [x] 6.3 Create `Views/Duel/DuelView.swift` — first week baseline, VS card, rounds, win bonus, history
- [x] 6.4 Create `Views/Duel/VSCard.swift` — Hero vs Shadow avatars, score display, momentum section
- [x] 6.5 Create `Views/Duel/RoundCard.swift` — animated bars (700ms), win/loss/tied badges, color-coded icons
- [x] 6.6 Create `Views/Duel/MomentumBadge.swift` — trend % with arrow, green/red pill
- [x] 6.7 Create `Views/Duel/DuelHistory.swift` — W/L/D squares, summary text
- [x] 6.8 Create `Views/Inbox/DuelBannerMini.swift` — compact "Winning 3—1" banner, added to InboxView header
- [x] 6.9 App-launch snapshot check in IdeaTamerApp.swift + streak reset (BGTask deferred — app-launch is primary)
- [x] 6.10 Create `IdeaTamerTests/DuelServiceTests.swift` — 9 tests: rounds, momentum, clamping, results

**Testing:** All duel tests pass. Snapshot creation works. 4 rounds compare. Momentum displays.
**Done when:** Full duel lifecycle, animated UI, BGTask registered.

---

## Sprint 7: Done + Badges (2 days)

**Goal:** Hall of Fame with legacy stats and badge grid.
**Dependencies:** Sprint 5, 6 complete.

- [ ] 7.1 Create `ViewModels/DoneViewModel.swift` — fetch completed, compute stats, badge list
- [ ] 7.2 Create `Views/Done/DoneView.swift` — LegacyStats + cards + BadgeGrid
- [ ] 7.3 Create `Views/Done/CompletedQuestCard.swift` — title, date, days, XP, medal
- [ ] 7.4 Create `Views/Done/BadgeGrid.swift` — locked (gray) / unlocked (colored) grid
- [ ] 7.5 Create `Views/Done/LegacyStats.swift` — total quests, XP, streak, duel record
- [ ] 7.6 Create `Views/Components/StreakBadge.swift` — fire icon + count, pulse animation

**Testing:** Done tab shows completed quests. Badge grid shows lock/unlock state.
**Done when:** Hall of Fame complete, badges display correctly.

---

## Sprint 8: Social Sharing (2 days)

**Goal:** Share cards for achievements and duel results.
**Dependencies:** Sprint 7 complete.

- [ ] 8.1 Create `Services/ShareCardService.swift` — ImageRenderer card generation
- [ ] 8.2 Create `Views/Sharing/ShareSheet.swift` — bottom sheet, card preview, UIActivityViewController
- [ ] 8.3 Create `Views/Sharing/ShareCardRenderer.swift` — SwiftUI view for card content
- [ ] 8.4 Add share buttons to Focus, Done, Duel views

**Testing:** Share cards render with brand styling. System share sheet presents correctly.
**Done when:** Cards render, share sheet works, branding consistent.

---

## Sprint 9: Onboarding (1–2 days)

**Goal:** 3-page animated onboarding flow.
**Dependencies:** Sprint 1 (PlayerProfile) complete.

- [ ] 9.1 Create `ViewModels/OnboardingViewModel.swift` — page tracking, completeOnboarding()
- [ ] 9.2 Create `Views/Onboarding/OnboardingView.swift` — 3-page TabView, skip, page indicator
- [ ] 9.3 Create `Views/Onboarding/OnboardingPage1.swift` — "Too many ideas" blue gradient
- [ ] 9.4 Create `Views/Onboarding/OnboardingPage2.swift` — "Your rival" red gradient, VS
- [ ] 9.5 Create `Views/Onboarding/OnboardingPage3.swift` — "Capture. Score. Focus. Ship." green
- [ ] 9.6 Wire into App entry point — .fullScreenCover if !hasCompletedOnboarding

**Testing:** Shows on first launch. Skip works. "Get Started" persists. Never shows again.
**Done when:** Onboarding flow complete, animations working, state persisted.

---

## Sprint 10: Polish & QA (2–3 days)

**Goal:** Edge cases, accessibility, dark mode, performance.
**Dependencies:** All sprints complete.

- [ ] 10.1 All empty states for 5 tabs
- [ ] 10.2 Edge cases: 0 milestones, max title length, default sliders=5, double-tap prevention
- [ ] 10.3 Dark Mode support and verification
- [ ] 10.4 Accessibility: Dynamic Type, VoiceOver labels, 44×44 touch targets, Reduce Motion
- [ ] 10.5 Glassmorphism consistency pass — no .background() before .glassEffect()
- [ ] 10.6 Performance profiling — scroll 100+ items, launch <1s, memory baseline
- [ ] 10.7 Create `Services/NotificationService.swift` — streak-at-risk local notifications (optional)

**Testing:** Full QA pass. Dark mode works. VoiceOver audit. Performance targets met.
**Done when:** Ship-ready quality. No crashes on edge cases.

---

## File Count Summary

| Sprint | New Files | Cumulative |
|--------|-----------|-----------|
| 0 | 15 | 15 |
| 1 | 8 | 23 |
| 2 | 8 | 31 |
| 3 | 6 | 37 |
| 4 | 5 | 42 |
| 5 | 6 | 48 |
| 6 | 9 | 57 |
| 7 | 6 | 63 |
| 8 | 3 | 66 |
| 9 | 5 | 71 |
| 10 | 1 | 72 |

**Total: ~72 files across 11 sprints**

---

## Review

*(To be filled after each sprint)*
