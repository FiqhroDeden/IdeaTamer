# IdeaTamer — Product Requirements Document

**Gamified Idea Focus App — Compete With Yourself**

| Field | Value |
|---|---|
| Version | 1.0 |
| Date | March 2026 |
| Author | Fiqhro Dedhen Supatmo |
| Platform | iOS 26+ (SwiftUI + Liquid Glass) |
| Status | Pre-development |

---

## 1. Executive summary

IdeaTamer is a free, offline-first iOS app that solves "Too Many Ideas Syndrome" for content creators, indie developers, and creative professionals. Instead of helping users collect more ideas, it enforces radical focus through a gamified quest system — limiting active projects to one at a time while rewarding progress with XP, levels, streaks, and badges.

The signature feature is **"Compete with yourself"** — a weekly duel system where users race their own past week's performance across four rounds. Hero Blue represents you now; Rival Red represents your past self. Beat your shadow to level up.

The app targets iOS 26 as its minimum deployment, taking full advantage of Apple's Liquid Glass UI design language. Built entirely with SwiftUI, SwiftData, and native Apple frameworks, IdeaTamer requires zero third-party dependencies (except custom fonts) and zero user accounts.

The design philosophy blends RPG-inspired dopamine loops with editorial-grade visual design, following the "Kinetic Quest" design system — treating personal productivity as a prestigious journey rather than a chore.

---

## 2. Problem statement

Content creators and indie builders suffer from "Too Many Ideas Syndrome." They capture obsessively but rarely finish. The dopamine hit of a new idea far exceeds the discipline required to complete one.

But the real obstacle isn't the ideas. **It's you.** Laziness, procrastination, distraction — the enemy is the person you were yesterday. Not some external force, not a lack of tools. You.

Existing tools fail in two ways: they encourage infinite collection (Notion, Apple Notes), and they offer zero motivational feedback for finishing. There is no reward for completion, no consequence for quitting, and no framework for self-improvement over time.

IdeaTamer solves this with three interlocking systems:

1. **Radical focus** — one active quest at a time, no exceptions
2. **Gamification** — XP, levels, streaks, and badges that make finishing feel rewarding
3. **Self-rivalry** — a weekly duel against your own past performance, so the only person you need to beat is who you were last week

The philosophy: **finish less, finish better, and prove to yourself that you're improving.**

---

## 3. Target user

### Primary persona

**Mira, 29 — Freelance content creator**

- 50+ idea fragments across Notion, voice memos, screenshots
- Starts 3–4 projects per month, finishes ~1 per quarter
- Knows procrastination is her main enemy, not lack of creativity
- Responds strongly to streaks and visible progress metrics
- Shares achievements on Twitter/LinkedIn as personal branding
- iPhone-first; captures ideas on the go

### Secondary persona

**Rafi, 34 — Indie developer / side-project builder**

- Builds side projects but rarely ships them
- Self-aware about his own patterns of starting and abandoning
- Would be motivated by seeing concrete proof he's improving week over week
- Would share a "I beat my past self" card to Discord / indie communities
- Needs an objective scoring framework to choose what to build next

### User characteristics

- iPhone users running iOS 26 or later
- Comfortable with simple app interactions
- Privacy-conscious: prefer offline-first apps with no mandatory accounts
- Motivated by game-like feedback loops (XP, levels, streaks)
- Active on social media and enjoy sharing achievements

---

## 4. Product vision & principles

### Vision statement

> *IdeaTamer transforms idea hoarding into a focused quest — making finishing feel as rewarding as starting, and proving to users that they're getting better every week.*

### Design principles

1. **One quest, always:** The one-active-project constraint is the entire product thesis. No exceptions.
2. **Offline-first, always:** All data lives on-device. No accounts, no servers, no sync complexity.
3. **The enemy is you:** The rivalry framing (blue vs red, hero vs shadow) makes self-improvement tangible and visual.
4. **Reward finishing, not starting:** Every XP award, badge, and celebration is tied to completion, not creation.
5. **Zero friction:** Capturing an idea takes < 3 seconds. No mandatory fields beyond title.
6. **Share the win:** Social sharing turns private progress into public accountability.

---

## 5. Core workflow

**Capture → Score → Focus → Finish**

1. **Inbox** — Quick idea capture (< 3 seconds). Title + optional description. Ideas enter as "Unprocessed Quests."
2. **Score** — Rate each idea on 3 sliders: Impact (1–10), Effort (1–10), Alignment (1–10). Formula: `round((Impact + Alignment − Effort + 10) × 3.33)`, clamped to 1–100.
3. **Focus** — Activate ONE idea at a time (hard limit). Break it into milestones. Work on it until done. Race your shadow.
4. **Duel** — Weekly competition against your past self across 4 rounds: XP, milestones, captures, streaks. Win 3+ to claim the week.
5. **Park** — Scored ideas waiting their turn, ranked by score. The backlog vault.
6. **Done** — Finished quests with completion dates, XP earned, and badges. The Hall of Fame.

---

## 6. Color palette — Hero Blue vs Rival Red

The palette is built around a gaming rivalry narrative. Blue is the hero (you, now). Red is the enemy (your past self). Green is victory. Amber is urgency.

### Hero Blue — "You, right now"

| Stop | Hex | Usage |
|------|-----|-------|
| BG | `#EBF2FF` | Light fills, tab highlights, score backgrounds |
| Light | `#A8C8FF` | Borders, subtle accents |
| Mid | `#4D8FFF` | Secondary elements |
| Primary | `#1B6EF2` | CTAs, progress bars, active states, "You" bars |
| Dim | `#0A4FBD` | Gradients, pressed states |
| Deep | `#0A3578` | Text on blue backgrounds |

### Rival Red — "Past you, the enemy"

| Stop | Hex | Usage |
|------|-----|-------|
| BG | `#FFF0ED` | Light fills, shadow indicators |
| Light | `#FFB8AA` | Borders, subtle accents |
| Mid | `#FF6B52` | Secondary elements |
| Primary | `#E5432A` | Shadow avatar, "Past" bars, duel losses |
| Dim | `#B22D18` | Gradients, pressed states |
| Deep | `#721C0F` | Text on red backgrounds |

### Victory Emerald — "Wins and completions"

| Stop | Hex | Usage |
|------|-----|-------|
| BG | `#E6F7EF` | Light fills, success backgrounds |
| Light | `#5CE0A0` | Progress bar fills, glow effects |
| Primary | `#12B76A` | Checkmarks, win indicators, XP chips |
| Dim | `#0D7A48` | Text on green backgrounds |

### Streak Amber — "Fire and urgency"

| Stop | Hex | Usage |
|------|-----|-------|
| BG | `#FFF6E5` | Light fills, streak backgrounds |
| Light | `#FFCB57` | Accents, fire glow |
| Primary | `#F5A623` | Streak counters, reward previews, fire icon |
| Dim | `#B87A0A` | Text on amber backgrounds |

### Surface neutrals

| Name | Hex | Usage |
|------|-----|-------|
| Surface | `#F8F7F6` | App background, base canvas |
| Surface Low | `#F1F0EF` | Section backgrounds, input fields |
| Surface High | `#E3E2E0` | Dividers, tracks, disabled states |
| Card | `#FFFFFF` | Card backgrounds, floating elements |
| Text | `#2E2F2F` | Primary text (never use pure black) |
| Text Mid | `#5B5C5B` | Secondary text, labels |
| Text Light | `#8A8B8A` | Tertiary text, hints, placeholders |

---

## 7. Gamification system

### 7.1 Experience Points (XP)

| Action | XP | Notes |
|--------|----|-------|
| Capture a new idea | +10 | Per idea |
| Score an idea (all 3 sliders) | +25 | Per idea scored |
| Complete a milestone | +50 | Per milestone checked |
| Complete a quest (all milestones) | +500 | Base reward |
| Win a weekly duel (3+ rounds) | +200 | Bonus, weekly |
| Draw a weekly duel (2-2) | +50 | Consolation, weekly |
| Daily capture streak (per day) | +15 | Compounds daily |
| Focus streak (per day active) | +20 | While quest is active |

### 7.2 Leveling system

XP per level = 100 × level. Cumulative = sum of all prior thresholds.

| Level | XP required | Cumulative | Title |
|-------|------------|------------|-------|
| 1 | 0 | 0 | Spark |
| 5 | 500 | 1,500 | Flame |
| 10 | 1,000 | 6,000 | Creator |
| 15 | 1,500 | 13,500 | Legendary Creator |
| 20 | 2,000 | 24,000 | Grandmaster |
| 25+ | 2,500+ | 37,500+ | Legend |

**Level-up moment:** full-screen overlay with backdrop blur, spring-animated level number, title fade-in, success haptic, dismiss on tap.

### 7.3 Streaks

**Daily capture streak** — increments when user captures ≥1 idea per day. Resets after a missed day. +15 XP/day. Shows past-week comparison.

**Focus streak** — increments each day with an active quest. Resets if no quest active for a day. +20 XP/day.

### 7.4 Badges

| Badge ID | Unlock condition | Color |
|----------|-----------------|-------|
| `firstBlood` | Complete first quest ever | Emerald |
| `streak7` | 7-day capture streak | Amber |
| `superFocus` | Complete quest with 5+ milestones, no parking | Blue |
| `polisher` | Score an idea ≥90/100 | Emerald |
| `selfSurpassed` | Win a weekly duel (3+ rounds) | Red |
| `moonshot` | Complete 10 quests total | Gray → Emerald |
| `streakMaster` | 30-day capture streak | Amber |

---

## 8. Compete With Yourself — Weekly Duel

### 8.1 Concept

Every Monday at midnight (local), the app snapshots last week's stats → **Shadow Self** (Rival Red). You race to beat it in the current week (Hero Blue).

### 8.2 Duel structure

4 rounds. Win 3+ to win the week.

| Round | Metric |
|-------|--------|
| XP Earned | Total XP this week vs last |
| Milestones Hit | Milestones completed this week vs last |
| Ideas Captured | Ideas captured this week vs last |
| Streak Days | Streak days this week vs last |

### 8.3 Momentum Score

`((thisWeekXP − lastWeekXP) / lastWeekXP) × 100`, clamped −99% to +999%. Green = positive, red = negative. Persistent in app header.

### 8.4 Rewards

- **Win:** +200 XP + "Self-Surpassed" badge (first time)
- **Loss:** No penalty. Encouraging copy.
- **Draw:** +50 XP.

### 8.5 Shadow across screens

Inbox: duel banner + capture pace indicator. Focus: shadow check card + past comparisons. Done: W-L stat card + shadow-beat chips. Header: momentum chip.

---

## 9. Features & acceptance criteria

### 9.1 Quick capture (Inbox)

1. Capture in < 3 seconds, +10 XP float
2. Sorted newest first, optional description
3. Unscored = pulsing dot, scored = color badge (Emerald ≥70, Amber 40–69, Blue <40)
4. Swipe: left = delete, right = score
5. Duel mini-banner, capture pace indicator, streak banner
6. Empty state with illustration

### 9.2 Scoring system

Formula: `round((Impact + Alignment − Effort + 10) × 3.33)` → 1–100. Three sliders, real-time preview, +25 XP. Auto-moves to Park on score.

### 9.3 Focus mode

Progress ring, milestone checklist (completed/in-progress/future states), +50 XP per milestone, +500 XP quest complete. Shadow check card. Share progress. Park option. Empty state.

### 9.4 Weekly Duel

VS card, 4 animated round cards, momentum score, win bonus (+200 XP), duel history (W/L/D), share results. Red tab tint. First-week baseline message.

### 9.5 Park (The Vault)

Ranked by score. Stats header. Activate button (disabled if active exists). Detail sheet.

### 9.6 Done (Hall of Fame)

Legacy stats, completed cards with medals/XP, shadow-beat chips, confetti, badge grid.

### 9.7 Social sharing

Bottom sheet, card preview, 4 targets (Twitter, LinkedIn, Discord, Copy), UIGraphicsImageRenderer, UIActivityViewController.

### 9.8 Onboarding

3 pages: (1) "Too many ideas" — blue gradient, floating bubbles. (2) "Your rival is yesterday's you" — red gradient, VS illustration. (3) "Capture. Score. Focus. Ship." — green gradient, 4-step flow, CTA. Skip on 1–2, persisted.

---

## 10. Data model (SwiftData)

### Entity: Idea

| Property | Type | Required | Notes |
|----------|------|----------|-------|
| id | UUID | Yes | Auto-generated |
| title | String | Yes | Max 120 chars |
| descriptionText | String? | No | Optional |
| impactScore | Int? | No | 1–10 |
| effortScore | Int? | No | 1–10 |
| alignmentScore | Int? | No | 1–10 |
| computedScore | Int? | No | 1–100 |
| status | IdeaStatus | Yes | Enum |
| xpEarned | Int | Yes | Default 0 |
| createdAt | Date | Yes | Auto-set |
| activatedAt | Date? | No | Quest start |
| completedAt | Date? | No | Quest finish |
| completionDays | Int? | No | Activation → completion |
| milestones | [Milestone] | No | @Relationship(deleteRule: .cascade) |

### Entity: Milestone

| Property | Type | Required | Notes |
|----------|------|----------|-------|
| id | UUID | Yes | Auto-generated |
| title | String | Yes | Max 200 chars |
| isCompleted | Bool | Yes | Default false |
| completedAt | Date? | No | When checked |
| sortOrder | Int | Yes | Manual ordering |
| idea | Idea | Yes | Parent |

### Entity: PlayerProfile (Singleton)

| Property | Type | Default |
|----------|------|---------|
| totalXP | Int | 0 |
| currentLevel | Int | 1 |
| captureStreakCount | Int | 0 |
| captureStreakLastDate | Date? | nil |
| focusStreakCount | Int | 0 |
| focusStreakLastDate | Date? | nil |
| unlockedBadges | [String] | [] |
| questsCompletedCount | Int | 0 |
| hasCompletedOnboarding | Bool | false |

### Entity: WeeklySnapshot

| Property | Type | Required |
|----------|------|----------|
| id | UUID | Yes |
| weekStartDate | Date | Yes |
| xpEarned | Int | Yes |
| milestonesCompleted | Int | Yes |
| ideasCaptured | Int | Yes |
| streakDays | Int | Yes |
| duelResult | DuelResult? | No |

### Entity: CurrentWeekTracker (Singleton)

| Property | Type | Default |
|----------|------|---------|
| weekStartDate | Date | Current Monday |
| xpEarned | Int | 0 |
| milestonesCompleted | Int | 0 |
| ideasCaptured | Int | 0 |
| streakDays | Int | 0 |

### Enums

| Enum | Cases |
|------|-------|
| IdeaStatus | `.inbox`, `.parked`, `.active`, `.completed` |
| DuelResult | `.win`, `.loss`, `.draw` |

---

## 11. Technical architecture

### 11.1 Tech stack

| Layer | Technology |
|---|---|
| UI | SwiftUI (iOS 26+) + Liquid Glass |
| Persistence | SwiftData (`@Model`) |
| Notifications | UserNotifications (local) |
| Background | BGTaskScheduler (weekly snapshot) |
| Architecture | MVVM + `@Observable` |
| Navigation | `NavigationStack` with typed destinations |
| Typography | Plus Jakarta Sans (custom bundle) |
| Icons | SF Symbols |
| Dependencies | Zero third-party (except fonts) |
| Min deployment | iOS 26.0 |

### 11.2 Project structure

```
IdeaTamer/
├── App/                  → IdeaTamerApp.swift, ContentView.swift
├── Models/               → Idea, Milestone, PlayerProfile, WeeklySnapshot, CurrentWeekTracker, Enums
├── ViewModels/           → @Observable VMs per screen
├── Views/
│   ├── Inbox/            → InboxView, QuickCaptureBar, IdeaCard, DuelBannerMini
│   ├── Focus/            → FocusView, ProgressRing, MilestoneList, ShadowCheckCard
│   ├── Duel/             → DuelView, VSCard, RoundCard, MomentumBadge, DuelHistory
│   ├── Park/             → ParkView, RankedQuestCard, VaultStats
│   ├── Done/             → DoneView, CompletedQuestCard, BadgeGrid, LegacyStats
│   ├── Scoring/          → ScoringSheet
│   ├── Sharing/          → ShareSheet, ShareCardRenderer
│   ├── Onboarding/       → OnboardingView, Pages
│   └── Components/       → GlassCard, ScoreBadge, XPFloatView, ConfettiView, StreakBadge
├── Services/             → XPService, StreakService, DuelService, BadgeService, ShareCardService, NotificationService
├── Extensions/           → Color+Brand, Date+Week, View+Glass, Animation+Spring
├── Resources/            → Assets.xcassets, Fonts/, Preview Content
├── docs/                 → PRD, Mockups
└── tasks/                → todo.md, lessons.md
```

---

## 12. Design system

### 12.1 Typography (Plus Jakarta Sans)

| Style | Weight | Size | Usage |
|-------|--------|------|-------|
| Display | 800 | 28–32pt | Hero titles, level-up |
| Headline | 700 | 18–22pt | Screen titles |
| Title | 700 | 14–16pt | Card headers |
| Body | 400 | 13–14pt | Descriptions |
| Label | 700, CAPS | 9–10pt | XP, metadata, badges |
| Caption | 400 | 11pt | Timestamps |

### 12.2 Surface architecture

No-Line Rule: hierarchy through tonal shifting, not borders. Surface → Surface Low → Card with ambient shadow.

### 12.3 Glassmorphism

Nav bars: 80% opacity + blur 20px. Tab bar: 75% white + blur 20px. Modals: 40% + blur 20px.

### 12.4 Animations

| Animation | Duration | Easing |
|-----------|----------|--------|
| XP float | 1.2s | ease-out |
| Quest complete | 300ms | ease-out |
| Level-up | spring | scale 0→1.2→1.0 |
| Progress ring | 600ms | cubic-bezier |
| Streak fire | 500ms | ease-in-out ∞ |
| Confetti | 1.4–2.4s | ease-in |
| Duel bars | 700ms | cubic-bezier |
| Shadow pulse | 2s | ease-in-out ∞ |
| Hero glow | 2.5s | ease-in-out ∞ |
| Onboarding float | 3s | ease-in-out ∞ |

### 12.5 Tab bar

| Tab | SF Symbol | Active tint |
|-----|-----------|-------------|
| Inbox | `tray.and.arrow.down.fill` | Hero Blue |
| Focus | `bolt.fill` | Hero Blue |
| Duel | `figure.fencing` | **Rival Red** |
| Park | `square.grid.2x2.fill` | Hero Blue |
| Done | `trophy.fill` | Hero Blue |

---

## 13. Development roadmap

### Sprint 0: Foundation (1 day)

- [ ] Project structure per Section 11.2
- [ ] SwiftData schema: all models + enums
- [ ] Color+Brand extension with full palette
- [ ] Plus Jakarta Sans font registration
- [ ] Base TabView with 5 tabs
- [ ] ModelContainer setup in App entry point

### Sprint 1: Core data layer (2 days)

- [ ] Idea CRUD in ViewModel
- [ ] Milestone CRUD with relationship
- [ ] PlayerProfile + CurrentWeekTracker singletons
- [ ] Scoring formula + unit tests
- [ ] Status state machine + one-active enforcement + tests

### Sprint 2: Inbox + Capture + Scoring (2–3 days)

- [ ] InboxView with quest list
- [ ] QuickCaptureBar + XP float
- [ ] IdeaCard component
- [ ] ScoringSheet: 3 sliders, live preview, auto-save
- [ ] Swipe actions, sort toggle, streak banner, empty state

### Sprint 3: Focus + Milestones (2–3 days)

- [ ] FocusView with progress ring
- [ ] MilestoneList: add, check, reorder, delete
- [ ] Milestone +50 XP, quest completion flow + confetti
- [ ] Park action, empty state, time estimate + reward preview

### Sprint 4: Park + Detail (2 days)

- [ ] ParkView ranked list + stats header
- [ ] RankedQuestCard + activate button
- [ ] Idea Detail Sheet: edit, re-score, activate, delete

### Sprint 5: Gamification services (2–3 days)

- [ ] XPService + level-up overlay
- [ ] StreakService: capture + focus + reset + comparison
- [ ] BadgeService: evaluate after each action
- [ ] XP float component, level formula + tests

### Sprint 6: Weekly Duel (3 days)

- [ ] DuelService: snapshot, comparison, momentum
- [ ] CurrentWeekTracker increments
- [ ] DuelView: VS card, round cards, momentum, history
- [ ] Rewards + first-week messaging
- [ ] BGTaskScheduler for snapshots

### Sprint 7: Done + Badges (2 days)

- [ ] DoneView with legacy stats
- [ ] CompletedQuestCard + shadow-beat chips
- [ ] BadgeGrid + confetti + glow effects

### Sprint 8: Social sharing (2 days)

- [ ] ShareCardService: achievement + duel card rendering
- [ ] ShareSheet + UIActivityViewController
- [ ] Share buttons on Focus, Done, Duel

### Sprint 9: Onboarding (1–2 days)

- [ ] 3-page carousel with animations
- [ ] Gradient backgrounds, floating elements, CTA
- [ ] Persisted onboarding state

### Sprint 10: Polish & QA (2–3 days)

- [ ] All empty states
- [ ] Edge cases (0 milestones, max title length, default sliders)
- [ ] Dark Mode, Dynamic Type, VoiceOver, Reduce Motion
- [ ] Glassmorphism consistency, Duel tab red tint
- [ ] Performance profiling

**Total estimated: 20–25 days**

---

## 14. Non-functional requirements

### 14.1 Performance

| Metric | Target |
|---|---|
| Launch to interactive | < 1 second |
| List scroll (100+ items) | 60 fps |
| Idea capture to saved | < 200ms |
| Share card render | < 1 second |
| App binary size | < 15 MB |

### 14.2 Accessibility

- Dynamic Type on all text
- VoiceOver labels on all interactive elements
- WCAG AA color contrast
- Score badges use color AND text (not color-only)
- 44×44pt minimum touch targets
- Reduce Motion: spring → linear, confetti/fire disabled

### 14.3 Privacy

- Zero data collection, no analytics, no network requests
- All data local via SwiftData
- Works in Airplane Mode
- No ATT prompt needed
- Share cards contain only user-chosen content

### 14.4 Localization

- v1.0 English only
- `LocalizedStringKey` throughout
- Locale-aware date/number formatting
- Ready for `Localizable.strings`

---

## 15. Success metrics

| Metric | Target (6 months) |
|---|---|
| App Store rating | ≥ 4.5 stars |
| Reviews mentioning "compete with yourself" | ≥ 30% |
| Reviews mentioning ease of use | ≥ 50% |
| Organic downloads | ≥ 5,000 |
| App Store feature | 1 in first 3 months |
| Social shares (#IdeaTamer) | ≥ 200 organic posts |

---

## 16. Out of scope

| Feature | Rationale |
|---------|-----------|
| AI-powered scoring | Manual scoring IS the feature |
| Cloud sync / iCloud | Offline-first; no sync conflicts |
| User accounts / auth | No server = no accounts |
| Analytics / telemetry | Zero data collection |
| Leaderboards | Only compete with yourself |
| Widgets / Live Activities | v2 consideration |
| IAP / Premium | 100% free |
| Tags / categories | Contradicts focus philosophy |
| Multiple active quests | ONE-quest = product thesis |
| iPad / Mac / Watch | iPhone-only v1 |

---

## 17. Future considerations (v2.0+)

| Feature | Notes |
|---|---|
| iCloud Sync | CloudKit cross-device sync |
| Widgets | Active quest progress + duel status |
| Live Activities | Lock screen milestone progress |
| Apple Watch | Streak + duel complication |
| Siri Shortcuts | Voice capture + duel status |
| Historical analytics | XP/momentum charts over time |
| iPad support | Multi-column sidebar layout |
| Notification reminders | Streak-at-risk push alerts |
| Theme customization | Custom hero/rival colors |
| Export | CSV/JSON idea + history export |

---

## 18. Appendix

### 18.1 Glossary

| Term | Definition |
|---|---|
| Quest | Activated idea for focused work (max 1) |
| Milestone | Sub-task within an active quest |
| Inbox | Capture area for unscored ideas |
| Park / Vault | Ranked backlog of scored ideas |
| Hall of Fame | Archive of completed quests |
| Shadow Self | Past week's stats as the rival |
| Weekly Duel | 4-round weekly self-competition |
| Momentum Score | Week-over-week XP trend % |
| Hero Blue | You now (#1B6EF2) |
| Rival Red | Past you (#E5432A) |
| Victory Emerald | Wins/completions (#12B76A) |
| Streak Amber | Streaks/urgency (#F5A623) |
| XP | Experience Points |
| Level | Progression tier from cumulative XP |
| Badge | Achievement for specific conditions |
| Liquid Glass | iOS 26 translucent design language |
| SwiftData | Apple's persistence framework |
| Kinetic Quest | IdeaTamer's design system |

### 18.2 References

- Apple HIG — iOS 26 Liquid Glass
- SwiftData — developer.apple.com
- SwiftUI — developer.apple.com
- UserNotifications — developer.apple.com
- BGTaskScheduler — developer.apple.com
- WCAG 2.1 Level AA — w3.org/WAI/WCAG21
- Plus Jakarta Sans — fonts.google.com/specimen/Plus+Jakarta+Sans

### 18.3 Wireframe reference

Interactive HTML mockups: `docs/IdeaTamer_Mockups.html`

Covers all screens (Onboarding, Inbox, Focus, Duel, Park, Done) with working tab navigation, Hero Blue vs Rival Red palette, animated duel bars, confetti, and Kinetic Quest design tokens.

---

## 19. App Store metadata

**App Name:** IdeaTamer

**Subtitle:** Compete with yourself. Ship ideas.

**Keywords:** ideas,focus,productivity,gamify,xp,compete,quest,ship,duel,streak,level,finish

**Promotional Text:** The only enemy is who you were last week. Score your ideas, pick ONE, earn XP as you hit milestones, and duel your past self every week.

**Description:**

You don't have a creativity problem. You have a finishing problem. And the real obstacle? It's you.

IdeaTamer turns your scattered ideas into a focused quest system — with a twist. Every week, you duel your own past performance. Beat yourself in XP earned, milestones hit, ideas captured, and streak days. Win the week. Level up. Share your victory.

How it works: Capture ideas in seconds (+10 XP). Score them on Impact, Effort, and Alignment. Activate your best one as a Quest. Break it into milestones (+50 XP each). Ship it (+500 XP). Then pick the next one.

The constraint is the superpower: only ONE active quest at a time.

Compete with yourself: Every Monday, your last week becomes your rival. Four rounds. Blue vs red. Beat 3 to win the week and earn bonus XP.

Share your wins: Generate branded achievement cards and share to Twitter, LinkedIn, or Discord. Prove you're shipping.

100% offline. Your data stays on your device. No accounts, no cloud, no tracking.
100% free. No ads, no subscriptions, no in-app purchases. Ever.

**Category:** Primary: Productivity. Secondary: Lifestyle.

**Age Rating:** 4+

**Privacy:** Data not collected. Privacy nutrition label: empty.

---

*— End of Document —*