# IdeaTamer — Launch & Monetization Roadmap

**From Code Complete to Revenue: A Phased Launch Strategy**

| Field | Value |
|---|---|
| Version | 1.0 |
| Date | March 2026 |
| Author | Fiqhro Dedhen Supatmo |
| Current Status | Development ~95% complete, all 10 sprints done |
| Target Launch | iOS 26 public release (estimated September 2026) |

---

## Table of Contents

1. [Current State Assessment](#1-current-state-assessment)
2. [Launch Philosophy](#2-launch-philosophy)
3. [Phase Overview](#3-phase-overview)
4. [Phase 1: Polish & QA — v1.0 Free Launch](#4-phase-1-polish--qa--v10-free-launch)
5. [Phase 2: Community Building — Pre-Launch Marketing](#5-phase-2-community-building--pre-launch-marketing)
6. [Phase 3: App Store Submission & Launch](#6-phase-3-app-store-submission--launch)
7. [Phase 4: Post-Launch Observation & Data Collection](#7-phase-4-post-launch-observation--data-collection)
8. [Phase 5: Monetization — v1.1 Pro Update](#8-phase-5-monetization--v11-pro-update)
9. [Phase 6: Pro Value Expansion — v1.2](#9-phase-6-pro-value-expansion--v12)
10. [Phase 7: Growth & Retention — v1.3+](#10-phase-7-growth--retention--v13)
11. [Phase 8: Long-term Vision — v2.0](#11-phase-8-long-term-vision--v20)
12. [Risk Contingencies](#12-risk-contingencies)
13. [Budget & Resource Planning](#13-budget--resource-planning)
14. [Decision Checkpoints](#14-decision-checkpoints)

---

## 1. Current State Assessment

### 1.1 What's Already Built

IdeaTamer has completed all 10 development sprints. Here's the full inventory:

#### Core Features — DONE

| Feature | Status | Files | Notes |
|---------|--------|-------|-------|
| Data models (Idea, Milestone, PlayerProfile, WeeklySnapshot, CurrentWeekTracker) | ✅ Complete | 6 model files | SwiftData @Model, relationships, singletons |
| Inbox tab (capture, search, filter, swipe actions) | ✅ Complete | 6 view files | < 3 second capture, XP float |
| Scoring system (3 sliders, formula, auto-park) | ✅ Complete | ScoringSheet + ScoringViewModel | .medium/.large detents |
| Focus tab (progress ring, milestones, quest completion) | ✅ Complete | 5 view files | +75 XP/milestone, +500 XP/quest, confetti |
| Park tab (ranked vault, stats, activate) | ✅ Complete | 4 view files | One-active guard enforced |
| Done tab (hall of fame, badges, legacy stats) | ✅ Complete | 5 view files | CompletedQuestDetailSheet |
| Weekly Duel (4 rounds, VS card, momentum, history) | ✅ Complete | 5 view files + DuelService | Animated bars, W/L/D record |
| Onboarding (5 pages with gradients) | ✅ Complete | 6 view files | Extended beyond PRD's 3 pages |
| Settings | ✅ Complete | SettingsView | Notification toggles, stats, data reset |

#### Gamification Services — DONE

| Service | Status | Coverage |
|---------|--------|----------|
| XPService | ✅ Complete | Capture, score, milestone, quest, duel, streaks |
| StreakService | ✅ Complete | Capture + focus streaks, gap-reset logic |
| BadgeService | ✅ Complete | All 7 badges (firstBlood, streak7, superFocus, polisher, selfSurpassed, moonshot, streakMaster) |
| DuelService | ✅ Complete | Snapshot, 4-round comparison, momentum calculation |
| NotificationService | ✅ Complete | Streak reminders, quest nudges, target date reminders |
| ShareCardService | ✅ Complete | Quest + duel card rendering |
| WidgetService | ✅ Complete | Real-time widget data sync |

#### UI & Design — DONE

| Element | Status | Notes |
|---------|--------|-------|
| iOS 26 Liquid Glass | ✅ Complete | .glassEffect() on cards, sheets, tab bar |
| Kinetic Quest design system | ✅ Complete | Hero Blue, Rival Red, Victory Emerald, Streak Amber |
| Plus Jakarta Sans typography | ✅ Complete | All weights (400–800) registered |
| Dark mode | ✅ Complete | Adaptive colors with light/dark variants |
| Animations | ✅ Complete | Spring animations, confetti, XP float, duel bars |
| Haptic feedback | ✅ Complete | Milestone completion, quest park, errors |

#### Extensions & Extras — DONE

| Feature | Status |
|---------|--------|
| WidgetKit extension (active quest, stats, lock screen) | ✅ Complete |
| Social sharing (ShareSheet, UIActivityViewController) | ✅ Complete |
| Undo toast (idea deletion recovery) | ✅ Complete |
| Seed data service (DEBUG mode) | ✅ Complete |

#### Testing — DONE

| Test File | Tests | What's Covered |
|-----------|-------|---------------|
| ScoringFormulaTests | 8 | Formula edge cases, clamping |
| XPLevelTests | 10 | Level formula, titles, progress |
| StatusMachineTests | 8 | Status transitions, milestone guard |
| StreakServiceTests | 7 | Streak tracking, reset, gaps |
| BadgeServiceTests | 7 | All 7 badge unlock conditions |
| DuelServiceTests | 9 | Rounds, momentum, results |
| **Total** | **49+** | Core business logic |

### 1.2 What's NOT Done Yet

| Gap | Severity | When to Fix |
|-----|----------|-------------|
| Comprehensive VoiceOver labels | Medium | Phase 1 (before launch) |
| UI tests | Low | Phase 1 (basic flow tests) |
| Performance profiling (large lists) | Low | Phase 1 (verify 60fps) |
| Localization (English strings ready, no translations) | Low | v2.0 (English-only for v1) |
| App Store screenshots & metadata | Critical | Phase 2 (before submission) |
| Privacy Policy & Terms page | Critical | Phase 2 (required for App Store) |
| StoreKit 2 integration | N/A | Phase 5 (monetization update) |
| Analytics Dashboard | N/A | Phase 6 (Pro feature) |
| Streak Freeze | N/A | Phase 5 (Pro feature) |
| Quest Templates | N/A | Phase 6 (Pro feature) |

### 1.3 Codebase Health

| Metric | Value |
|--------|-------|
| Total Swift files | 70+ |
| Total lines of code | ~7,845 |
| Architecture | MVVM + @Observable (consistent) |
| Code style | Clean — no print(), MARK sections, proper naming |
| Third-party dependencies | Zero (except Plus Jakarta Sans fonts) |
| Git commits | 21 on main |
| Branch | Clean, all work merged to main |

---

## 2. Launch Philosophy

### 2.1 Core Principles

1. **Ship fast, monetize later.** A live app with users beats a perfect app with none.
2. **Free builds audience, Pro builds revenue.** Launch free to maximize downloads, reviews, and Apple featuring potential.
3. **Data before decisions.** Don't guess what to put behind the paywall — observe what users love most, then gate expansion of that.
4. **Apple featuring is the #1 growth lever.** Every decision should maximize featuring potential.
5. **One update per month.** Consistent updates signal "this app is alive" to both Apple and users.

### 2.2 Anti-Principles (What NOT to Do)

- **Don't delay launch** to add "one more feature" — the current feature set is already comprehensive
- **Don't launch with a paywall** — builds negative reviews before you have social proof
- **Don't add monetization before product-market fit is validated** — if nobody uses the free app, nobody will pay for Pro
- **Don't over-engineer the Pro tier** — start with minimal feature gating, expand based on data
- **Don't ignore user feedback** — the first 50 reviews will tell you more than any research

---

## 3. Phase Overview

```
                    WE ARE HERE
                         ↓
Phase 1 ─── Polish & QA ──────────────── 2 weeks
Phase 2 ─── Pre-Launch Marketing ──────── 4-8 weeks (parallel with Phase 1)
Phase 3 ─── App Store Submission ──────── 1-2 weeks
Phase 4 ─── Post-Launch Observation ───── 4-6 weeks
Phase 5 ─── v1.1 Monetization ─────────── 2-3 weeks
Phase 6 ─── v1.2 Pro Value ───────────── 2 weeks
Phase 7 ─── v1.3+ Growth & Retention ─── Ongoing
Phase 8 ─── v2.0 Vision ──────────────── 6-12 months out
```

**Timeline visual:**

```
Mar-Apr 2026     May-Jul 2026        Aug 2026         Sep 2026          Oct-Nov 2026
┌──────────┐    ┌──────────────┐   ┌──────────┐    ┌──────────────┐   ┌──────────────┐
│ Phase 1   │    │ Phase 2       │   │ Phase 3   │    │ Phase 4       │   │ Phase 5      │
│ Polish    │    │ Marketing     │   │ Submit    │    │ Observe       │   │ Monetize     │
│ & QA      │    │ & Community   │   │ & Launch  │    │ & Collect     │   │ v1.1 Pro     │
└──────────┘    └──────────────┘   └──────────┘    └──────────────┘   └──────────────┘
                                                    ↑
                                              iOS 26 Release
                                         (target launch day)
```

---

## 4. Phase 1: Polish & QA — v1.0 Free Launch

**Duration:** 2 weeks
**Goal:** Production-ready app, zero rough edges, confident submission

### 4.1 Accessibility Audit (3-4 days)

Every interactive element needs proper VoiceOver support. This is both ethically right and an App Store review factor.

| Task | Priority | Details |
|------|----------|---------|
| Audit all interactive elements for accessibilityLabel | P0 | Cards, buttons, swipe actions, sliders |
| Add accessibilityHint to non-obvious controls | P0 | "Double tap to score this idea", "Swipe left to delete" |
| Verify Dynamic Type works on all screens | P0 | Test with largest accessibility text size |
| Add accessibilityValue to progress indicators | P0 | Progress ring, streak counter, XP display |
| Verify minimum 44x44pt touch targets | P0 | All buttons, cards, tab bar items |
| Test Reduce Motion behavior | P1 | Confetti, XP float, duel bar animations should simplify |
| Add accessibilityAction for swipe gestures | P1 | Alternative to swipe for VoiceOver users |
| WCAG AA color contrast verification | P1 | Check all text/background combinations |
| Screen reader flow testing (full user journey) | P1 | Capture → Score → Activate → Complete |

**Acceptance criteria:** Complete user journey possible with VoiceOver only.

### 4.2 Empty States Audit (1 day)

Every screen must have a meaningful empty state — not a blank white screen.

| Screen | Empty State Required | Message Suggestion |
|--------|---------------------|-------------------|
| Inbox (no ideas) | ✅ Verify exists | "Your first quest starts with one idea. Capture it below." |
| Inbox (all scored) | ✅ Verify exists | "All scored! Head to Park to activate your best idea." |
| Focus (no active quest) | ✅ Verify exists | "No active quest. Pick one from your Park." |
| Focus (no milestones) | ✅ Verify exists | "Break your quest into milestones to track progress." |
| Park (empty) | ✅ Verify exists | "Score ideas from your Inbox to fill your vault." |
| Done (no completions) | ✅ Verify exists | "Your Hall of Fame awaits. Finish a quest to earn your place." |
| Duel (first week) | ✅ Verify exists | "This week sets your baseline. Your rival appears next Monday." |
| Duel (no snapshot) | ✅ Verify exists | "Start using the app to build your first weekly snapshot." |

### 4.3 Edge Cases & Defensive Testing (2 days)

| Test Case | Expected Behavior |
|-----------|------------------|
| Title at max length (120 chars) | Truncates gracefully, no layout break |
| Description with 1000+ chars | Scrollable, no performance issue |
| 100+ ideas in inbox | Smooth 60fps scroll (LazyVStack) |
| 50+ milestones on one quest | Smooth scroll, reorder works |
| All sliders at 1 (minimum score) | Score = 1, no crash |
| All sliders at 10 (maximum score) | Score = 100, no crash |
| Rapid capture (spam the + button) | Debounced, no duplicate entries |
| Activate quest while one is active | Blocked with clear message |
| Complete quest with 0 milestones | Allowed (quest complete = all milestones done, 0 = all done) |
| Delete idea that's referenced in widget | Widget gracefully shows empty state |
| App killed mid-transaction (SwiftData) | Data consistent on relaunch |
| Date change (cross midnight) | Streak logic handles correctly |
| Monday rollover during app use | Duel snapshot triggers correctly |
| Timezone change | Week boundaries adjust properly |
| Device storage full | SwiftData handles gracefully, no crash |
| Notification permission denied | App works fully, just no reminders |

### 4.4 Performance Profiling (1 day)

| Check | Target | Tool |
|-------|--------|------|
| App launch to interactive | < 1 second | Xcode Instruments (Time Profiler) |
| Inbox scroll (100+ items) | 60fps, no drops | Instruments (Core Animation) |
| Memory usage (normal use) | < 50MB | Instruments (Allocations) |
| Memory usage (100+ ideas) | < 100MB | Instruments (Allocations) |
| SwiftData query time | < 50ms for any query | Instruments (os_signpost) |
| Share card render | < 1 second | Manual timing |
| Widget refresh | < 2 seconds | Manual timing |
| No memory leaks | Zero leaks | Instruments (Leaks) |

### 4.5 Dark Mode Verification (0.5 day)

| Check | Details |
|-------|---------|
| All screens in dark mode | Walk through every tab, every modal |
| Contrast ratios | Text readable on all dark backgrounds |
| Glass effects | .glassEffect() renders correctly in dark mode |
| Share cards | Cards look good in both modes |
| Score badges | Color coding visible in dark mode |
| Onboarding | Gradient backgrounds work in dark mode |
| Widgets | Dark mode variants render correctly |

### 4.6 Final Bug Sweep (1 day)

| Task | Details |
|------|---------|
| Review all TODO/FIXME comments in code | Address or document each one |
| Remove all DEBUG-only code paths | SeedDataService gated behind #if DEBUG |
| Verify all animations use spring (not .default) | Per CLAUDE.md requirement |
| Verify no print() statements | Use Logger only |
| Check all @MainActor compliance | ViewModels, Services |
| Run full test suite (Cmd+U) | All 49+ tests pass |
| Test on multiple simulator sizes | iPhone SE, iPhone 15, iPhone 16 Pro Max |
| Test with slow network / airplane mode | App fully functional offline |

### 4.7 Phase 1 Deliverables

- [ ] All accessibility labels added
- [ ] All empty states verified
- [ ] All edge cases tested and passing
- [ ] Performance profiled, targets met
- [ ] Dark mode verified on all screens
- [ ] Full test suite passing
- [ ] Zero TODO/FIXME items remaining
- [ ] App tested on 3+ device sizes
- [ ] lessons.md updated with any findings

---

## 5. Phase 2: Community Building — Pre-Launch Marketing

**Duration:** 4–8 weeks (runs parallel with Phase 1 and continues through Phase 3)
**Goal:** Build an audience before launch day, maximize day-1 downloads

### 5.1 Brand Assets Preparation (1 week)

| Asset | Specification | Purpose |
|-------|--------------|---------|
| App icon (final) | 1024x1024, Hero Blue gradient with lightning bolt motif | App Store, marketing |
| App Store screenshots (iPhone) | 6.7" (1290x2796) — 6-10 screenshots | App Store listing |
| App Store screenshots (iPhone SE) | 5.5" (1242x2208) — 6-10 screenshots | Required for smaller devices |
| App preview video (optional) | 15-30 seconds, showing capture → score → duel flow | App Store listing |
| Social banner | 1500x500 (Twitter/X header) | Social media profiles |
| Open Graph image | 1200x630 | Link previews when shared |
| Press kit (zip) | Icon, screenshots, one-paragraph description, founder bio | Media outreach |
| Product Hunt assets | Thumbnail (240x240), gallery images (1270x760) | Product Hunt launch |

### 5.2 App Store Screenshots Strategy

Screenshots are the #1 conversion factor after the app icon. Each screenshot should communicate one benefit in under 2 seconds.

| Screenshot # | Screen | Headline Text | What It Shows |
|-------------|--------|---------------|---------------|
| 1 | Inbox with ideas | "Capture ideas in seconds" | Quick capture bar, XP float, idea cards |
| 2 | Scoring sheet | "Score what matters most" | 3 sliders, live preview, score badge |
| 3 | Focus with milestones | "One quest. Total focus." | Progress ring, milestone checklist, active quest |
| 4 | Duel VS card | "Compete with yourself" | Hero Blue vs Rival Red, round results |
| 5 | Done with badges | "Earn your legacy" | Completed quests, badge grid, XP stats |
| 6 | Widget on home screen | "Track progress everywhere" | Home screen widget showing active quest |

**Design guidelines:**
- Hero Blue (#1B6EF2) as primary background accent
- Device frames (iPhone 16 Pro)
- Large, bold headline text (Plus Jakarta Sans ExtraBold)
- Minimal UI chrome — focus on the content
- Show real (but sample) data, not empty states

### 5.3 App Store Metadata

Finalize before submission:

| Field | Content | Character Limit |
|-------|---------|----------------|
| App Name | IdeaTamer | 30 chars |
| Subtitle | Compete with yourself. Ship ideas. | 30 chars |
| Keywords | ideas,focus,productivity,gamify,xp,compete,quest,ship,duel,streak,level,finish | 100 chars |
| Promotional Text | The only enemy is who you were last week. Score your ideas, pick ONE, earn XP as you hit milestones, and duel your past self every week. | 170 chars |
| Description | (Full description from PRD Section 19) | 4000 chars |
| Category (Primary) | Productivity | — |
| Category (Secondary) | Lifestyle | — |
| Age Rating | 4+ | — |
| Privacy | Data not collected | — |
| Support URL | GitHub Pages or simple landing page | — |
| Privacy Policy URL | Required — simple page stating zero data collection | — |

### 5.4 #BuildInPublic Campaign (ongoing)

Start immediately. Share the development journey on Twitter/X.

**Weekly content calendar:**

| Week | Post Type | Content Idea |
|------|-----------|-------------|
| 1 | Dev log | "Building a gamified idea app — here's the duel mechanic in action" + screen recording |
| 2 | Design showcase | "Hero Blue vs Rival Red — the color psychology behind self-competition" + color palette |
| 3 | Behind the scenes | "How iOS 26 Liquid Glass transforms a productivity app" + before/after |
| 4 | Technical deep dive | "Implementing weekly self-duels with SwiftData" + code snippet |
| 5 | Philosophy | "Why I built an app that LIMITS you to one project at a time" + thread |
| 6 | Preview | "First look at IdeaTamer" + screenshots or video |
| 7 | Beta invite | "Looking for 100 TestFlight beta testers" + link |
| 8 | Launch countdown | "IdeaTamer launches with iOS 26. Here's what to expect" + feature list |

**Hashtags:** #BuildInPublic #IndieApp #iOSDev #SwiftUI #iOS26 #Productivity #IdeaTamer

**Platforms:**
- Twitter/X (primary — indie dev community is very active)
- Mastodon (iOS dev community migrated here)
- LinkedIn (content creator audience)
- Reddit: r/iOSProgramming, r/SwiftUI (when appropriate, follow self-promo rules)

### 5.5 TestFlight Beta Program (2-4 weeks before launch)

| Step | Details |
|------|---------|
| Recruit beta testers | Target: 100–200 testers. Source from Twitter followers, Reddit, indie dev Discords |
| Beta focus areas | Onboarding clarity, capture flow, duel understanding, crash reports |
| Feedback collection | Simple Google Form or TestFlight's built-in feedback |
| Beta duration | 2–4 weeks minimum |
| Iterate based on feedback | Fix critical bugs, clarify confusing UX, adjust onboarding |
| Ask engaged testers | "Would you leave a review on launch day?" (builds day-1 review volume) |

### 5.6 Apple Editorial Pitch (3-4 weeks before iOS 26 release)

Apple actively features apps that showcase new platform capabilities.

| Element | Details |
|---------|---------|
| Where to submit | App Store Connect → "Promote your app" or Apple Developer → "Tell us your story" |
| Key selling points | (1) Built for iOS 26 with Liquid Glass from day one (2) Unique "compete with yourself" mechanic (3) Zero data collection, fully offline (4) Beautiful Kinetic Quest design system |
| Assets to include | Screenshots, app preview video, brief description of Liquid Glass usage |
| Timing | Submit 3–4 weeks before iOS 26 public release |
| Follow up | If no response after 2 weeks, submit again with updated assets |

### 5.7 Landing Page (optional but recommended)

Simple one-page site at ideatamer.app (or similar domain):

| Section | Content |
|---------|---------|
| Hero | App icon + "Stop collecting ideas. Start finishing them." + App Store badge (coming soon) |
| Features | 3 pillars: Capture & Score, Focus & Ship, Compete with Yourself |
| Screenshots | 3–4 key screenshots |
| Social proof | "Built with iOS 26 Liquid Glass" + "100% offline, 100% free" |
| Footer | Privacy Policy, Terms of Use, contact email |

**Tech:** Can be a simple static HTML/CSS page hosted on GitHub Pages (free).

### 5.8 Phase 2 Deliverables

- [ ] Final app icon designed
- [ ] 6-10 App Store screenshots created
- [ ] App preview video (optional)
- [ ] All App Store metadata finalized
- [ ] Privacy Policy page live
- [ ] Terms of Use page live
- [ ] #BuildInPublic: 8+ posts published
- [ ] TestFlight beta with 50+ testers completed
- [ ] Apple editorial pitch submitted
- [ ] Press kit ready
- [ ] Product Hunt listing drafted
- [ ] Landing page live (optional)

---

## 6. Phase 3: App Store Submission & Launch

**Duration:** 1–2 weeks
**Goal:** Smooth submission, approval, and coordinated launch on iOS 26 release day

### 6.1 Pre-Submission Checklist

| Check | Status |
|-------|--------|
| App builds successfully in Release configuration | ☐ |
| No compiler warnings | ☐ |
| All tests pass (Cmd+U) | ☐ |
| App tested on real device (not just simulator) | ☐ |
| Provisioning profile and certificates valid | ☐ |
| App icon meets all size requirements | ☐ |
| Info.plist correct (fonts, permissions, etc.) | ☐ |
| Privacy nutrition label completed (empty — no data collected) | ☐ |
| Age rating questionnaire completed (4+) | ☐ |
| Screenshots uploaded for all required sizes | ☐ |
| App preview video uploaded (if created) | ☐ |
| Metadata (name, subtitle, description, keywords) finalized | ☐ |
| Support URL working | ☐ |
| Privacy Policy URL working | ☐ |
| Copyright field set | ☐ |
| Build number and version number set (1.0.0, build 1) | ☐ |
| Archive created and validated in Xcode | ☐ |
| No private API usage | ☐ |
| TestFlight build tested and stable | ☐ |

### 6.2 Submission Strategy

| Step | Timing | Details |
|------|--------|---------|
| Submit for review | 2–3 weeks before target launch | Apple review typically takes 1–3 days, but submit early for buffer |
| Set release mode | "Manually release this version" | Don't auto-release — you want to control launch day |
| Coordinate with iOS 26 | Target: iOS 26 public release day | Release the app the same day iOS 26 goes public |
| If approved early | Hold the release | Wait for iOS 26 launch |
| If rejected | Fix issues immediately | Common rejection reasons: missing privacy policy, broken links, crashes |

### 6.3 Launch Day Execution

| Time | Action |
|------|--------|
| Morning | Release app on App Store (tap "Release this version") |
| Morning | Post launch thread on Twitter/X with screenshots + App Store link |
| Morning | Submit to Product Hunt (Tuesday or Wednesday is optimal) |
| Morning | Post to Reddit: r/iOSProgramming ("I shipped my first iOS 26 app"), r/productivity, r/SwiftUI |
| Morning | Post to Hacker News: "Show HN: IdeaTamer — gamified idea focus with weekly self-competition" |
| Afternoon | Share to Discord communities (IndieHackers, iOS Dev, SwiftUI) |
| Afternoon | Send to beta testers: "We're live! Please leave a review if you enjoy the app" |
| Evening | Post LinkedIn article about the journey |
| Day 2–3 | Monitor reviews, respond to every single one |
| Day 2–3 | Monitor crash reports in Xcode Organizer |
| Week 1 | Daily check: downloads, crashes, reviews, feedback |

### 6.4 Common App Store Rejection Reasons & Prevention

| Rejection Reason | How We Prevent It |
|-----------------|-------------------|
| Crash on launch | Test on real device, multiple OS versions |
| Missing privacy policy | Create and host before submission |
| Broken links (support URL, privacy URL) | Verify all URLs resolve |
| Incomplete metadata | Fill every field, no placeholders |
| Misleading screenshots | Screenshots match actual app UI |
| Performance issues | Profile with Instruments |
| In-app purchase issues | N/A for v1.0 (no IAP yet) |

### 6.5 Phase 3 Deliverables

- [ ] App submitted to App Store review
- [ ] App approved by Apple
- [ ] App released on iOS 26 launch day
- [ ] Product Hunt launch executed
- [ ] Social media launch posts published
- [ ] Day-1 reviews requested from beta testers
- [ ] Crash monitoring active
- [ ] No critical bugs reported

---

## 7. Phase 4: Post-Launch Observation & Data Collection

**Duration:** 4–6 weeks after launch
**Goal:** Validate product-market fit, understand user behavior, build rating before monetization

### 7.1 What to Measure

These metrics will inform every monetization decision:

| Metric | How to Measure | Target | Why It Matters |
|--------|---------------|--------|---------------|
| Daily downloads | App Store Connect | 50+/day first week | Baseline demand |
| Day 1 retention | App Store Connect (App Analytics) | > 30% | Users find immediate value |
| Day 7 retention | App Store Connect | > 20% | Users form a habit |
| Day 30 retention | App Store Connect | > 10% | Long-term engagement |
| App Store rating | App Store Connect | 4.5+ | Social proof for conversion |
| Review count | App Store Connect | 20+ in first month | Critical mass for credibility |
| Crash rate | Xcode Organizer | < 1% | Stability |
| Session duration | App Store Connect (estimated) | > 3 min | Users are engaged |
| Most used tab | Not measurable without analytics (offline) | — | Inferred from reviews/feedback |
| Feature requests | Reviews + beta feedback | — | Prioritize Pro features |

**Important:** Because IdeaTamer is offline-first with zero analytics, we rely on:
- App Store Connect's built-in metrics (downloads, retention, crashes, sessions)
- User reviews and ratings
- TestFlight/beta feedback
- Direct user communication (support email, social media)

### 7.2 Review Prompting Strategy

Use `SKStoreReviewController` strategically (Apple allows 3 prompts per 365 days):

| Trigger | When | Why |
|---------|------|-----|
| First quest completion | After the +500 XP celebration and confetti | User just had a peak positive emotion |
| First duel win | After seeing "You beat your past self!" | Another peak moment |
| 7-day streak | After streak badge award | User is invested |

**Rules:**
- Never prompt after a frustration (failed action, error)
- Never prompt on first launch
- Minimum 7 days between prompts
- Respect `requestReview()` system limits

### 7.3 User Feedback Collection

| Channel | Setup |
|---------|-------|
| App Store reviews | Monitor and respond to every review (especially 1–3 stars) |
| Support email | Listed in App Store metadata — respond within 24 hours |
| Twitter/X mentions | Monitor #IdeaTamer and @mentions |
| Reddit mentions | Search periodically |
| TestFlight feedback | Keep beta channel open for power users |

### 7.4 Key Questions to Answer Before Monetization

| Question | How to Answer | Impact on Monetization |
|----------|--------------|----------------------|
| Are users completing quests? | Reviews mentioning "finished" or "completed" | If yes → focus enforcement is working → gamification resonates |
| Do users talk about the duel? | Reviews mentioning "duel", "compete", "past self" | If yes → duel is loved → enhanced duel features for Pro |
| What do users request most? | Feature requests in reviews | Build most-requested features as Pro exclusives |
| Are users sharing? | Social media mentions with IdeaTamer share cards | If yes → premium share card templates have value |
| What causes 1-star reviews? | Read every negative review | Fix before adding monetization |
| Is retention > 10% at Day 30? | App Store Connect | If < 10% → fix retention first, don't monetize yet |

### 7.5 Go/No-Go Decision for Monetization

After 4–6 weeks, evaluate:

| Metric | GO (proceed to Phase 5) | WAIT (extend Phase 4) | PIVOT |
|--------|------------------------|----------------------|-------|
| Downloads (total) | > 1,000 | 200–1,000 | < 200 |
| Day 7 retention | > 15% | 10–15% | < 10% |
| App Store rating | > 4.0 | 3.5–4.0 | < 3.5 |
| Review sentiment | Positive, mentions core features | Mixed | Negative |
| Quest completions mentioned | Yes | Sometimes | Never |
| Duel feature mentioned | Yes | — | Never (feature isn't resonating) |

**If WAIT:** Spend 2–4 more weeks fixing issues, improving onboarding, addressing feedback. Re-evaluate.

**If PIVOT:** Core product needs rethinking. Don't add monetization to a product that isn't working.

### 7.6 Phase 4 Deliverables

- [ ] 4-6 weeks of App Store Connect data collected
- [ ] All reviews read and responded to
- [ ] Feature request list compiled and ranked
- [ ] Bug reports addressed (v1.0.1 patch if needed)
- [ ] Go/No-Go decision documented
- [ ] Monetization feature list finalized based on data
- [ ] lessons.md updated with launch learnings

---

## 8. Phase 5: Monetization — v1.1 Pro Update

**Duration:** 2–3 weeks development + 1 week testing
**Goal:** Introduce IdeaTamer Pro subscription without removing any existing free features

### 5.0 Golden Rule: Never Take Away What's Already Free

**Every feature that shipped in v1.0 stays free forever.** Pro only adds NEW features and EXPANSIONS on top of what exists. This is non-negotiable — violating this principle will generate backlash and 1-star reviews.

Users who installed v1.0 already have:
- Full Weekly Duel (4 rounds, VS card, momentum, W/L/D result)
- Full badge system (all 7 badges)
- Social sharing with branded cards
- Unlimited milestones per quest
- 10-idea inbox cap
- Active quest widget
- All streak tracking

**None of this gets locked.** Instead, we add new layers on top.

### 5.0.1 Grandfathering Strategy

Users who installed v1.0 (before Pro existed) are **"Founding Users"** and keep ALL v1.0 features unlimited, forever — even features that new free users won't have.

**Implementation (at v1.1 migration):**

```swift
// In PlayerProfile model — add new property
var isFoundingUser: Bool = false

// In fetch-or-create pattern (when v1.1 launches):
// If PlayerProfile already exists → this is a v1.0 user → set isFoundingUser = true
// If PlayerProfile is newly created → this is a new install → isFoundingUser = false

func fetchOrCreateProfile(context: ModelContext) -> PlayerProfile {
    let descriptor = FetchDescriptor<PlayerProfile>()
    if let existing = try? context.fetch(descriptor).first {
        // Existing user — mark as founding user (one-time migration)
        if !existing.isFoundingUser {
            existing.isFoundingUser = true
        }
        return existing
    }
    // New user — not a founding user
    let profile = PlayerProfile()
    profile.isFoundingUser = false
    context.insert(profile)
    return profile
}
```

**Access logic in ProAccessService:**

```swift
var maxMilestones: Int {
    if profile.isFoundingUser || isPro { return .max }
    return 5  // New free users only
}

var maxInboxIdeas: Int {
    if profile.isFoundingUser || isPro { return .max }
    return 10  // New free users only
}

// Founding users keep everything from v1.0
// But NEW Pro features (analytics, templates, etc.) require Pro for everyone
func hasAccess(to feature: ProFeature) -> Bool {
    switch feature {
    // v1.0 features → founding users get free, new users get free
    case .weeklyDuel, .allBadges, .shareCards:
        return true  // These stay free for EVERYONE

    // v1.0 limits that expand for Pro
    case .unlimitedMilestones, .expandedInbox:
        return profile.isFoundingUser || isPro

    // NEW features (never existed in v1.0) → Pro only for everyone
    case .analytics, .streakFreeze, .questTemplates,
         .duelInsights, .duelFullHistory, .premiumShareTemplates,
         .monthlyChallenges, .customThemes, .appIcons,
         .streakWidget, .duelWidget:
        return isPro
    }
}
```

### 5.0.2 Revised Free vs Pro Feature Matrix

**Principle: v1.0 features = free forever. New layers = Pro.**

| Feature | v1.0 User (Founding) | New Free User (post v1.1) | Pro User |
|---------|---------------------|--------------------------|----------|
| **CORE (unchanged for everyone)** | | | |
| Quick capture + scoring | ✅ | ✅ | ✅ |
| 1 active quest | ✅ | ✅ | ✅ |
| XP, levels, level-up celebrations | ✅ | ✅ | ✅ |
| Park, Done tabs | ✅ | ✅ | ✅ |
| **DUEL (v1.0 = free, enhancements = Pro)** | | | |
| Weekly Duel (4 rounds, VS card, result) | ✅ | ✅ | ✅ |
| Momentum score | ✅ | ✅ | ✅ |
| Share duel result | ✅ | ✅ | ✅ |
| Duel history (current + last week) | ✅ | ✅ | ✅ |
| **Duel full history (all weeks, trend chart)** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Duel insights ("best week", "win streak", trends)** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **BADGES (v1.0 = free)** | | | |
| All 7 badges | ✅ | ✅ | ✅ |
| **Future new badge drops (8+)** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **SHARING (v1.0 = free, templates = Pro)** | | | |
| Share cards (current design) | ✅ | ✅ | ✅ |
| **Premium share templates (seasonal, custom)** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **MILESTONES & INBOX (grandfathered)** | | | |
| Milestones per quest | Unlimited (grandfathered) | 5 max | Unlimited |
| Inbox capacity | Unlimited (grandfathered) | 10 ideas | 25 ideas |
| **STREAKS (v1.0 = free, freeze = Pro)** | | | |
| Capture + focus streak tracking | ✅ | ✅ | ✅ |
| **Streak freeze (2x/month)** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **WIDGETS (v1.0 = free, new widgets = Pro)** | | | |
| Active quest widget | ✅ | ✅ | ✅ |
| **Streak widget** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Duel status widget** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **100% NEW FEATURES (Pro for everyone)** | | | |
| **Analytics Dashboard** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Quest Templates** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Daily Reflection** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Monthly Challenges** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **App icon alternatives** | ❌ Pro | ❌ Pro | ✅ **NEW** |
| **Theme customization** | ❌ Pro | ❌ Pro | ✅ **NEW** |

**Summary:**
- **v1.0 users:** Everything they have today stays free. Pro adds entirely new features.
- **New free users (post v1.1):** Get the full core experience (including duel!) but with limits on milestones (5) and inbox (10). Pro removes limits + adds new features.
- **Pro users:** Everything unlimited + all new features.

### 5.1 StoreKit 2 Foundation (3-4 days)

| Task | Details | Est. |
|------|---------|------|
| Create `Products.storekit` | Local StoreKit configuration file for testing | 0.5 day |
| Create `StoreService.swift` | Product loading, purchase, restore, transaction listener | 1 day |
| Create `ProAccessService.swift` | Feature gating logic with grandfathering | 0.5 day |
| Create `ProFeature` enum | All gated features enumerated (distinguish v1.0 vs new) | 0.5 day |
| Add `isFoundingUser` to PlayerProfile | Migration logic in fetch-or-create | 0.5 day |
| App Store Connect setup | Subscription group, products, pricing, free trial | 0.5 day |
| Unit tests | ProAccessService (founding user logic, feature gating) | 1 day |

### 5.2 Feature Gating Implementation (2-3 days)

**Only these features get gated for NEW free users:**

| Feature | View/ViewModel Affected | Gating Logic |
|---------|------------------------|-------------|
| Milestone limit (5) | FocusViewModel | `if !isFoundingUser && !isPro → limit 5` |
| Inbox limit (10) | InboxViewModel | `if !isFoundingUser && !isPro → limit 10` (already exists) |

**These features are NEW and Pro-only for everyone (including founding users):**

| Feature | View/ViewModel Affected | Implementation |
|---------|------------------------|---------------|
| Streak Freeze | StreakService, PlayerProfile | New property + freeze logic |
| Duel Full History | DuelViewModel, DuelView | New "History" section with all weeks |
| Duel Insights | DuelViewModel, DuelView | New "Insights" section with trends |
| Premium Share Templates | ShareCardService | New template designs |
| Streak Widget | WidgetService | New widget type |
| Duel Widget | WidgetService | New widget type |

**These stay FREE for ALL users (no gating):**

| Feature | Notes |
|---------|-------|
| Weekly Duel (4 rounds, VS card, result) | Core duel experience untouched |
| All 7 current badges | No change |
| Current share card design | No change |
| XP, levels, streaks | No change |
| Active quest widget | No change |

### 5.3 Paywall Implementation (2-3 days)

| Task | Details |
|------|---------|
| `PaywallView.swift` | Full-screen modal — hero section, 3 benefits, pricing toggle, CTA |
| `PaywallCard.swift` | Inline "Upgrade to Pro" card for contextual prompts |
| `ProBadge.swift` | Small "PRO" indicator on new locked features |
| Paywall trigger system | Contextual triggers (see below) |
| Dismiss cooldown | 7-day suppression after dismissal — don't nag |
| Restore purchases | Button in Settings + on paywall |
| Subscription status view | Settings section showing current plan, renewal date, manage link |

**Paywall triggers (contextual, not intrusive):**

| Trigger | Context | Copy |
|---------|---------|------|
| Duel insights teaser | After viewing duel result | "Want to see your full duel history and insights? Try Pro." |
| 6th milestone attempt | When adding milestone #6 (new free user) | "Upgrade to add unlimited milestones." |
| Streak break | When streak resets | "Wish you had a Streak Freeze? Included in Pro." |
| New badge drop | When future badges are added | "New badges available! Upgrade to unlock them." |
| Premium template preview | When viewing quest templates | "Jumpstart your quest with Pro templates." |

### 5.4 Streak Freeze Feature (1 day)

| Component | Details |
|-----------|---------|
| Model change | Add `streakFreezeCount: Int` and `streakFreezeLastReset: Date?` to PlayerProfile |
| Service logic | In StreakService, before resetting streak: check if freeze available → consume freeze instead of reset |
| Monthly reset | Reset freeze count to 2 on first day of each month |
| UI | Small "freeze" icon next to streak counter; toast when freeze is consumed |
| Paywall hook | "Protect your streak — included in IdeaTamer Pro" |

### 5.5 Communication Strategy

How to announce Pro to existing free users — emphasis on "nothing taken away":

| Channel | Message |
|---------|---------|
| App Store "What's New" | "NEW: IdeaTamer Pro adds Analytics, Streak Freeze, Premium Templates, and more. Everything you already have stays free — forever. As a founding user, you also keep unlimited milestones and inbox." |
| In-app (first launch after update) | Celebratory banner: "Thank you for being a founding user! All your current features stay free forever. Check out what's new in Pro →" — tappable, dismissible, shown once |
| Twitter/X | "IdeaTamer Pro is here! New features: Analytics Dashboard, Streak Freeze, Quest Templates, Duel Insights. And a promise: everything from v1.0 stays free forever. Founding users keep unlimited everything." |
| Respond to any concerns | "We made a promise: v1.0 features stay free forever. Pro only adds NEW features. Founding users get extra perks as thanks for being early." |

### 5.6 Testing Checklist

| Test | How |
|------|-----|
| **Grandfathering** | |
| Existing user updates to v1.1 | Verify `isFoundingUser = true` is set |
| Founding user milestone limit | Verify unlimited milestones (no gating) |
| Founding user inbox limit | Verify unlimited inbox (no gating) |
| Founding user accesses duel | Verify full duel access (no gating) |
| Founding user sees new Pro features | Verify Pro badge on analytics, templates, etc. |
| Fresh install on v1.1 | Verify `isFoundingUser = false` |
| New free user milestone limit | Verify 5 max enforced |
| New free user inbox limit | Verify 10 max enforced |
| **StoreKit Purchases** | |
| Purchase monthly subscription | StoreKit sandbox |
| Purchase annual subscription | StoreKit sandbox |
| Purchase lifetime | StoreKit sandbox |
| Upgrade monthly → annual | StoreKit sandbox |
| Restore purchases | Fresh install → restore |
| Free trial → paid transition | StoreKit sandbox (fast-forward time) |
| Subscription cancellation | Verify graceful downgrade (founding user keeps founding perks) |
| Expired subscription | New features locked, v1.0 features intact |
| Refunded subscription | Same as expired |
| **UX Flow** | |
| Free tier completeness | Full user journey without Pro — capture, score, quest, duel, badges |
| Paywall display on all triggers | Manual testing each trigger |
| Paywall dismiss cooldown | Dismiss → verify 7-day suppression |
| Offline purchase (airplane mode) | Should queue and process when online |

### 5.7 Phase 5 Deliverables

- [ ] `isFoundingUser` flag added to PlayerProfile with migration logic
- [ ] StoreKit 2 fully integrated (StoreService)
- [ ] ProAccessService with grandfathering logic
- [ ] Feature gating implemented (founding vs new free vs Pro)
- [ ] PaywallView designed and implemented
- [ ] Paywall triggers configured (contextual, not intrusive)
- [ ] Streak Freeze implemented (Pro-only, new feature)
- [ ] Duel Full History (Pro-only, new feature)
- [ ] Duel Insights (Pro-only, new feature)
- [ ] Restore purchases working
- [ ] Subscription status in Settings
- [ ] All grandfathering tests passing
- [ ] All StoreKit sandbox tests passing
- [ ] App Store Connect products configured
- [ ] v1.1 submitted to App Store

---

## 9. Phase 6: Pro Value Expansion — v1.2

**Duration:** 2 weeks
**Goal:** Add features that increase Pro perceived value and reduce churn

### 6.1 Analytics Dashboard (3-4 days)

| Component | Details |
|-----------|---------|
| `AnalyticsView.swift` | New view accessible from Settings or a dedicated section |
| XP chart (Swift Charts) | Line chart showing weekly XP earned over time |
| Completion trends | Bar chart showing quests completed per month |
| Quest duration comparison | Average time to complete quests over time |
| Streak history | Visual streak calendar (like GitHub contribution graph) |
| "Productivity Score" | Composite weekly score based on XP, milestones, streaks |
| Data source | Computed from WeeklySnapshot history + CurrentWeekTracker |

### 6.2 Quest Templates (1-2 days)

| Template | Milestones |
|----------|-----------|
| Blog Post | Research → Outline → Draft → Edit → Publish |
| Side Project | Define MVP → Design → Build → Test → Ship |
| YouTube Video | Script → Film → Edit → Thumbnail → Upload |
| Design Project | Brief → Wireframe → Design → Review → Deliver |
| Podcast Episode | Research → Outline → Record → Edit → Publish |
| Course/Workshop | Outline → Content → Slides → Rehearse → Deliver |
| Custom | Start from scratch (current behavior) |

**Implementation:**
- Store templates as JSON in app bundle
- Template selector shown when activating a quest from Park
- User can customize milestone titles after template is applied
- Free users see templates but can't use them (Pro badge)

### 6.3 Daily Reflection Prompt (1-2 days)

| Component | Details |
|-----------|---------|
| Notification | Daily at user-configured time: "How's [Quest Name] going?" |
| Response options | "Made progress" / "Hit a blocker" / "Took a break" |
| Data storage | Simple log entries in a new `ReflectionEntry` model |
| Analytics tie-in | Show reflection patterns in Analytics Dashboard |
| Settings | Toggle on/off, configure time |

### 6.4 Detailed Duel Insights (1 day)

| Insight | Implementation |
|---------|---------------|
| "Your best week ever was [date] with [X] XP" | Max query on WeeklySnapshot.xpEarned |
| "You've improved XP by [X]% over your first week" | Compare current vs first snapshot |
| "Current duel winning streak: [X] weeks" | Count consecutive .win results |
| "You complete quests [X] days faster than average" | Compare recent vs historical completionDays |
| "Strongest round: [Milestones]" | Count wins per round type |

### 6.5 Phase 6 Deliverables

- [ ] Analytics Dashboard with 4+ chart types
- [ ] Quest Templates (6+ templates)
- [ ] Daily Reflection system (notification + logging)
- [ ] Detailed Duel Insights (5+ insight types)
- [ ] All new features properly gated behind Pro
- [ ] v1.2 submitted to App Store

---

## 10. Phase 7: Growth & Retention — v1.3+

**Duration:** Ongoing (monthly updates)
**Goal:** Sustain engagement, reduce churn, grow organically

### 7.1 Monthly Update Cadence

| Month | Update | Key Features |
|-------|--------|-------------|
| Month 1 post-monetization | v1.3 | Monthly Challenges system + 2 new badges |
| Month 2 | v1.4 | App icon alternatives (Pro) + theme customization |
| Month 3 | v1.5 | Export/Import (JSON) for data backup + more templates |
| Month 4 | v1.6 | Improved share cards (seasonal designs) + 2 new badges |
| Month 5 | v1.7 | Siri Shortcuts integration (voice capture) |
| Month 6 (December) | v1.8 | **IdeaTamer Wrapped** — year-in-review summary |

### 7.2 Monthly Challenges System (v1.3)

| Challenge Type | Example | Duration | Reward |
|---------------|---------|----------|--------|
| XP Challenge | "Earn 500 XP this month" | Monthly | Special badge |
| Completion Challenge | "Complete 2 quests this month" | Monthly | Bonus XP |
| Streak Challenge | "Maintain a 14-day streak" | Monthly | Special badge |
| Capture Challenge | "Capture 15 ideas this month" | Monthly | Bonus XP |
| Duel Challenge | "Win 3 duels in a row" | Ongoing | Special badge |

**Implementation:**
- `Challenge` model with type, target, progress, deadline
- `ChallengeService` evaluating progress
- UI: Challenge card on Inbox or Settings
- Pro-only feature

### 7.3 IdeaTamer Wrapped (v1.8, December)

Annual summary à la Spotify Wrapped:

| Page | Content |
|------|---------|
| 1 | "Your Year in IdeaTamer" — total ideas captured, scored, completed |
| 2 | "You earned [X] XP and reached Level [Y]" — XP journey |
| 3 | "Your longest streak: [X] days" — streak highlight |
| 4 | "You beat your past self [X] times" — duel record |
| 5 | "Your productivity archetype: [The Finisher / The Sprinter / The Thinker]" — fun personality result |
| 6 | Shareable summary card — all key stats in one beautiful card |

**Archetype logic (fun, based on patterns):**
- **The Finisher:** High quest completion rate, long focus streaks
- **The Sprinter:** Fast quest completion times, high XP bursts
- **The Thinker:** High idea capture rate, high average scores
- **The Warrior:** High duel win rate, consistent week-over-week improvement
- **The Collector:** Most badges unlocked, longest overall streaks

### 7.4 Ongoing Growth Tactics

| Tactic | Frequency | Details |
|--------|-----------|---------|
| App Store keyword optimization | Monthly | Monitor search rankings, adjust keywords |
| Apple Search Ads | Ongoing | $5–10/day, target "productivity", "idea tracker", "gamified focus" |
| Respond to all reviews | Daily | Especially 1–3 star reviews — shows active development |
| Social media posting | Weekly | Tips, user stories, update previews |
| Feature user achievements | Monthly | With permission, share power user stories on social |
| Apple editorial re-pitch | Quarterly | After each major update, re-submit for featuring |
| Seasonal promotions | Quarterly | Offer first month free, promotional pricing |
| Subscription offer codes | As needed | For marketing campaigns, influencer partnerships |

### 7.5 Churn Reduction Strategies

| Strategy | Implementation |
|----------|---------------|
| Streak freeze (already in Pro) | Prevents rage-quit from broken streaks |
| Win-back notification | After 3 days inactive: "Your streak is at risk! Open IdeaTamer to keep it alive." |
| Monthly challenge variety | New challenges each month prevent staleness |
| Regular badge drops | New badges every 2 months give completionists reasons to stay |
| Feature updates in "What's New" | Show subscribers that their payment funds active development |
| Cancellation feedback | When detecting cancelled subscription, show "We'd love to know why" survey |
| Win-back offer | After 30 days lapsed: offer 1 month free to resubscribe |

### 7.6 Phase 7 Success Metrics

| Metric | 6 Months Post-Monetization | 12 Months |
|--------|---------------------------|-----------|
| Active subscribers | 500+ | 2,000+ |
| MRR | $1,250+ | $5,000+ |
| Monthly churn | < 8% | < 6% |
| App Store rating | 4.5+ | 4.7+ |
| Social shares/month | 50+ | 200+ |
| Review count | 100+ | 500+ |

---

## 11. Phase 8: Long-term Vision — v2.0

**Timeline:** 6–12 months after v1.0 launch
**Goal:** Platform expansion and premium features

### 8.1 Potential v2.0 Features

| Feature | Effort | Revenue Impact | Priority |
|---------|--------|---------------|----------|
| iCloud Sync (CloudKit) | High (3–4 weeks) | High — multi-device support is #1 request | P0 |
| iPad support | Medium (2 weeks) | Medium — expands addressable market | P1 |
| Apple Watch complication | Low (1 week) | Low — engagement, not revenue | P2 |
| Live Activities (lock screen progress) | Low (1 week) | Medium — visibility + engagement | P1 |
| Siri Shortcuts (voice capture) | Low (3 days) | Low — convenience | P2 |
| Historical analytics (charts over months) | Medium (1 week) | Medium — Pro value | P1 |
| Custom hero/rival colors | Low (2 days) | Low — Pro perk | P2 |
| CSV/JSON export | Low (2 days) | Low — power user feature | P2 |
| Localization (multi-language) | High (ongoing) | High — opens non-English markets | P1 |
| Mac Catalyst / macOS native | High (3–4 weeks) | Medium — additional purchase opportunity | P2 |

### 8.2 Pricing Evolution

As value increases, pricing can adjust:

| Timeline | Pricing | Justification |
|----------|---------|--------------|
| v1.1 launch | $2.99/mo, $19.99/yr | Initial pricing, competitive |
| 6 months (if strong retention) | $3.99/mo, $24.99/yr | More Pro features justify increase |
| v2.0 (with iCloud sync) | $4.99/mo, $34.99/yr | Multi-device is premium |
| Grandfather existing subscribers | Keep original price | Reward loyalty, reduce churn |

### 8.3 Team Scaling Consideration

| Revenue Level | Team Size | What to Hire |
|--------------|-----------|-------------|
| < $3K/month | Solo | You do everything |
| $3K–10K/month | Solo + contractors | Part-time designer, part-time marketer |
| $10K–30K/month | 2–3 people | Full-time designer or marketing person |
| $30K+/month | Small team | Consider hiring iOS developer |

---

## 12. Risk Contingencies

### 12.1 What If Nobody Downloads? (< 200 downloads in first month)

| Action | Details |
|--------|---------|
| Revisit App Store metadata | Keywords, screenshots, description may not be compelling |
| Increase marketing effort | More social posting, Reddit, Product Hunt relaunch |
| Apple Search Ads | Even $5/day can make a difference |
| Get featured on a blog/YouTube | Reach out to more reviewers |
| Improve screenshots | A/B test different hero images |
| Don't panic | Many successful apps had slow starts |

### 12.2 What If Rating Drops Below 4.0?

| Action | Details |
|--------|---------|
| Read every negative review | Find patterns — is it bugs? Confusion? Missing features? |
| Fix the top complaint immediately | Ship a patch within 1 week |
| Respond to reviews | Show users you're listening |
| Improve onboarding | Most confusion happens in first 5 minutes |
| Delay monetization | Don't add a paywall to an app users are frustrated with |

### 12.3 What If Monetization Conversion Is < 1%?

| Action | Details |
|--------|---------|
| A/B test paywall copy | Different headlines, different benefits emphasized |
| A/B test paywall timing | Try showing earlier or later in user journey |
| Add more Pro value | The Pro tier may not be compelling enough |
| Lower price | Try $1.99/mo or $14.99/yr |
| Try promotional pricing | First month $0.99 |
| Ask churned users why | Email survey or in-app feedback |

### 12.4 What If Apple Rejects the App?

| Rejection Reason | Fix |
|-----------------|-----|
| Privacy policy missing/broken | Fix URL, resubmit |
| Crash during review | Test on same device model as reviewer, fix crash |
| Metadata issue | Correct metadata, resubmit |
| IAP configuration wrong (v1.1) | Fix StoreKit config, resubmit |
| "Not enough features" | Unlikely given our feature depth, but add more screenshots showing depth |
| Guideline violation | Read specific guideline cited, fix, resubmit |

---

## 13. Budget & Resource Planning

### 13.1 Costs (Estimated)

| Item | Cost | Frequency | Notes |
|------|------|-----------|-------|
| Apple Developer Program | $99/year | Annual | Required for App Store |
| Domain (ideatamer.app) | $15–40/year | Annual | For landing page + privacy policy |
| GitHub Pages hosting | Free | — | For landing page |
| Apple Search Ads | $150–300/month | Monthly (optional) | Start after monetization |
| Design tools (Figma) | Free tier or $15/month | Monthly | For screenshots and marketing assets |
| Total pre-monetization | ~$120/year | — | Just developer account + domain |
| Total post-monetization | ~$300–400/month | — | Including Search Ads |

### 13.2 Time Investment

| Phase | Estimated Time | Calendar Duration |
|-------|---------------|-------------------|
| Phase 1 (Polish) | 40–50 hours | 2 weeks |
| Phase 2 (Marketing) | 20–30 hours | 4–8 weeks (parallel) |
| Phase 3 (Submission) | 5–10 hours | 1–2 weeks |
| Phase 4 (Observation) | 5 hours/week | 4–6 weeks |
| Phase 5 (Monetization) | 60–80 hours | 2–3 weeks |
| Phase 6 (Pro Value) | 40–50 hours | 2 weeks |
| Phase 7+ (Ongoing) | 10–15 hours/week | Ongoing |

---

## 14. Decision Checkpoints

Critical moments where you must stop, evaluate, and decide:

### Checkpoint 1: Pre-Submission (end of Phase 1)

**Question:** Is the app production-ready?

| Criteria | Required |
|----------|----------|
| All tests pass | Yes |
| No critical accessibility gaps | Yes |
| Performance targets met | Yes |
| Tested on real device | Yes |
| 3+ beta testers confirm "feels ready" | Yes |

**If NO:** Extend Phase 1. Do not submit a buggy app.

### Checkpoint 2: Post-Launch (end of Phase 4)

**Question:** Should we proceed with monetization?

| Criteria | Go | Wait | Stop |
|----------|-----|------|------|
| Downloads | > 1,000 | 200–1,000 | < 200 |
| Day 7 retention | > 15% | 10–15% | < 10% |
| Rating | > 4.0 | 3.5–4.0 | < 3.5 |
| Quest completions in reviews | Mentioned | — | Never |

**If WAIT:** Fix issues for 2–4 weeks, re-evaluate.
**If STOP:** Rethink product, gather more feedback, consider pivoting.

### Checkpoint 3: Post-Monetization (4 weeks after v1.1)

**Question:** Is the monetization model working?

| Criteria | Healthy | Concerning | Pivot |
|----------|---------|-----------|-------|
| Trial start rate | > 4% | 2–4% | < 2% |
| Trial-to-paid | > 35% | 20–35% | < 20% |
| Monthly churn | < 10% | 10–15% | > 15% |
| Rating impact | Stayed 4.0+ | Dropped 0.2 | Dropped 0.5+ |

**If CONCERNING:** Adjust pricing, paywall timing, or Pro features.
**If PIVOT:** Consider different monetization (lower price, different feature split, tips model).

### Checkpoint 4: 6-Month Review

**Question:** Is this sustainable?

| Criteria | Scale Up | Maintain | Reconsider |
|----------|----------|---------|-----------|
| MRR | > $2,000 | $500–2,000 | < $500 |
| Subscriber trend | Growing | Stable | Declining |
| Rating | 4.5+ | 4.0–4.5 | < 4.0 |
| Your motivation | High | Medium | Low |

**If SCALE UP:** Invest in marketing, consider v2.0 features.
**If MAINTAIN:** Keep monthly updates, organic growth.
**If RECONSIDER:** Evaluate time investment vs. return. Consider making fully free again as portfolio piece, or pivoting approach.

---

## Quick Reference: Complete Phase Checklist

```
PHASE 1: POLISH & QA (2 weeks)
├── [ ] Accessibility audit complete
├── [ ] Empty states verified
├── [ ] Edge cases tested
├── [ ] Performance profiled
├── [ ] Dark mode verified
├── [ ] Full test suite passing
└── [ ] Tested on 3+ device sizes

PHASE 2: PRE-LAUNCH MARKETING (4-8 weeks, parallel)
├── [ ] App icon finalized
├── [ ] 6-10 App Store screenshots
├── [ ] App Store metadata written
├── [ ] Privacy Policy & Terms live
├── [ ] 8+ #BuildInPublic posts
├── [ ] TestFlight beta completed (50+ testers)
├── [ ] Apple editorial pitch submitted
├── [ ] Product Hunt listing drafted
└── [ ] Press kit ready

PHASE 3: SUBMISSION & LAUNCH (1-2 weeks)
├── [ ] Pre-submission checklist complete
├── [ ] App submitted and approved
├── [ ] Released on iOS 26 launch day
├── [ ] Product Hunt launched
├── [ ] Social media blitz executed
└── [ ] Day-1 reviews requested

PHASE 4: OBSERVATION (4-6 weeks)
├── [ ] Metrics tracked (downloads, retention, rating)
├── [ ] All reviews responded to
├── [ ] Feature requests compiled
├── [ ] v1.0.1 patch shipped (if needed)
├── [ ] Go/No-Go decision for monetization
└── [ ] CHECKPOINT 2 evaluated

PHASE 5: MONETIZATION v1.1 (2-3 weeks)
├── [ ] isFoundingUser flag + migration logic
├── [ ] StoreKit 2 integrated (StoreService)
├── [ ] ProAccessService with grandfathering
├── [ ] Feature gating (founding vs new free vs Pro)
├── [ ] PaywallView designed & built
├── [ ] Streak Freeze (Pro-only, new feature)
├── [ ] Duel Full History (Pro-only, new feature)
├── [ ] Duel Insights (Pro-only, new feature)
├── [ ] All grandfathering + sandbox tests passing
├── [ ] Communication strategy executed
└── [ ] v1.1 submitted

PHASE 6: PRO VALUE v1.2 (2 weeks)
├── [ ] Analytics Dashboard
├── [ ] Quest Templates
├── [ ] Daily Reflection
├── [ ] Detailed Duel Insights
└── [ ] v1.2 submitted

PHASE 7: GROWTH v1.3+ (ongoing)
├── [ ] Monthly Challenges system
├── [ ] App icon alternatives
├── [ ] Export/Import
├── [ ] IdeaTamer Wrapped (December)
├── [ ] Ongoing ASO optimization
└── [ ] CHECKPOINT 3 & 4 evaluated

PHASE 8: v2.0 (6-12 months)
├── [ ] iCloud Sync
├── [ ] iPad support
├── [ ] Live Activities
├── [ ] Localization
└── [ ] Pricing evolution
```

---

*— End of Document —*
