# SnapSweep

Tinder-style photo gallery cleaner (Flutter, Android + iOS).
Repo: https://github.com/HasanNarli/snap_sweep (private)

## Project rules

- **Everything in English:** variables, functions, classes, files, folders, architecture names, comments, commit messages, branch names, docs. No Turkish identifiers anywhere in code.
- **Comments:** short, one-line comments where they help. No long comment blocks.
- **User-facing text** is the only exception: it is localized (TR + EN) via ARB files, never hard-coded in widgets.
- **Chat with the user in Turkish.**
- **Work autonomously:** the user may leave mid-task. Don't stop to ask for routine permissions or confirmations; finish the task, verify it (`flutter analyze`, build/tests), commit and push, then report. Ask only for real product decisions.

## Product decisions

- **Swipe:** left = delete, right = keep. Swiping does not delete immediately; the photo is added to a "to delete" list.
- **Batch delete:** At the end of a session a "Review" screen lists the marked photos; one system confirmation deletes them all. Undo button available while swiping.
- **Free tier:** 15 random photos per day (ungrouped, from the whole gallery). Rewarded ad grants +10, max 2 ads per day.
- **Premium (subscription):** Unlimited swipes + filters: screenshots, screen recordings, videos, date range. Similar/duplicate detection deferred to v1.1.
- **Pricing:** Yearly + lifetime (one-time). NO weekly plan. Competitive TR pricing; exact TRY prices set near release.
- **Positioning:** "Your photos never leave your phone" (no server), show freed space (MB/GB), clean experience (only user-initiated rewarded ads, no banners/interstitials).
- **Permissions:** Request full gallery access; handle limited (iOS "selected photos", Android 14 partial) and denied states properly.

## Design language

- **Direction:** calm, premium, Apple-inspired. Follows system light/dark mode.
- **Font:** Inter (bundled in `assets/fonts`, OFL). Tight letter-spacing on large titles; text styles live in `AppTheme._textTheme`.
- **Colors:** semantic tokens in `AppPalette` (background, surface, fill, label, secondaryLabel, separator, accent, delete, keep, premium). One accent (blue); red/green only for delete/keep decisions. Never hard-code colors in widgets.
- **Components:** soft shadows instead of borders, stadium buttons, iOS-style grouped lists (`GroupedSection`/`GroupedRow`/`IconTile`), `ActivityRing`, `SegmentedProgress`, `Frosted` pills, `RoundIconButton`.
- **Motion & feel:** Cupertino page transitions and bouncing scroll on both platforms, haptics on decisions, respect "reduce motion".
- Photos are the hero: full-bleed cards, blurred current photo as swipe backdrop.

## Screens (keep the count minimal)

1. **Welcome + permission** – single welcome page (animated swipe demo + feature list), "Continue" requests permission; "Open Settings" on denied/limited.
2. **Home** – remaining daily swipes, total freed space, "Start swiping", locked premium category cards.
3. **Swipe** – card stack, undo, counter (7/15), date + file size, "Finish".
4. **Review & delete** – grid of marked photos, deselect, "Delete 12 photos (340 MB)", result/celebration.
5. **Paywall** – Phase 6.
- **Settings** – bottom sheet: restore purchases, privacy policy, rate app, contact.

Out of swipes: bottom sheet → [Watch ad +10] / [Premium: unlimited].

## Tech stack

- `photo_manager` – permissions, asset listing, thumbnails, deletion
- `flutter_card_swiper` – card stack
- `flutter_riverpod` – state management
- `shared_preferences` – daily swipe counter, stats
- `purchases_flutter` (RevenueCat) – subscriptions (Phase 6)
- `google_mobile_ads` – rewarded ads (Phase 6; needs iOS ATT + KVKK/GDPR consent)
- Localization: TR + EN from the start (`flutter_localizations` + ARB)
- Random pick: never load the whole gallery into memory; get the total count, fetch assets at random indexes.

## Roadmap

- [x] Phase 0 – Foundation: theme, folder structure, routing, TR/EN
- [x] Phase 1 – Onboarding + permission (full/limited/denied)
- [x] Phase 2 – Swipe screen: random 15, swipe, undo, to-delete list
- [x] Phase 3 – Review & batch delete, freed space, result screen
- [ ] Phase 4 – Home: daily swipes, stats, locked categories
- [ ] Phase 5 – Polish: icon, splash, real-device testing, large-gallery performance
- [ ] Phase 6 – Premium (RevenueCat) + paywall + filters + rewarded ads
- [ ] Phase 7 – Release: privacy policy, store assets, Android first then iOS
- [ ] v1.1 – Similar/duplicate photo detection

Tick the box when a phase is done.

## Dev environment

- Windows (Android) + Mac (iOS build/test).
- Design: Google Stitch → Figma; if a Figma link is given, read it via Figma MCP and implement in Flutter.
- Bundle ID: `com.snapsweep.snap_sweep`
- Claude Code permissions are pre-approved in `.claude/settings.json` (destructive git commands denied).
