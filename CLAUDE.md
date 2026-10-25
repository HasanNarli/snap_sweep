# SnapSweep

Tinder-style photo gallery cleaner (Flutter, Android + iOS).
Repo: https://github.com/HasanNarli/snap_sweep

## Project rules

- **Everything in English:** variables, functions, classes, files, folders, architecture names, comments, commit messages, branch names, docs. No Turkish identifiers anywhere in code.
- **Comments:** short, one-line comments where they help. No long comment blocks.
- **User-facing text** is the only exception: it is localized (TR + EN) via ARB files, never hard-coded in widgets.
- **Chat with the user in Turkish.**
- **Work autonomously:** the user may leave mid-task. Don't stop to ask for routine permissions or confirmations; finish the task, verify it (`flutter analyze`, build/tests), then report. Ask only for real product decisions.
- **Never commit or push on your own.** Leave changes uncommitted so the user can review them; commit/push only when the user explicitly asks.

## Product decisions

- **Swipe:** left = delete, right = keep. Swiping does not delete immediately; the photo is added to a "to delete" list.
- **Batch delete:** At the end of a session a "Review" screen lists the marked photos; one system confirmation deletes them all. Undo button available while swiping.
- **Free tier:** 15 random photos per day (ungrouped, from the whole gallery). Rewarded ad grants +10, max 2 ads per day.
- **Premium (subscription):** Unlimited swipes + filters: screenshots, screen recordings, videos, date range. Similar/duplicate detection deferred to v1.1.
- **Pricing:** Yearly + lifetime (one-time). NO weekly plan. Competitive TR pricing; exact TRY prices set near release.
- **Positioning:** "Your photos never leave your phone" (no server), show freed space (MB/GB), clean experience (only user-initiated rewarded ads, no banners/interstitials).
- **Permissions:** Request full gallery access; handle limited (iOS "selected photos", Android 14 partial) and denied states properly.

## Design language

- **Source of truth:** the user's Stitch design in Figma: https://www.figma.com/design/2ww8YFJYfyUuVyIfxpNyh2 (frames: Onboarding 1:2, Home 1:69, Swipe 1:248, Review 1:328). Read it via Figma MCP before changing a screen.
- **Direction:** warm, editorial, calm premium. Light from the design; dark is a derived warm twin. Follows system mode.
- **Font:** Inter 300–700 (bundled in `assets/fonts`, OFL). Big light numerals (e.g. "1.2 GB"); text styles live in `AppTheme._textTheme`.
- **Colors:** semantic tokens in `AppPalette` (background #F9F8F5, surface, border #EBE6DF, fill #F4F1EB, track, label #1A1A1A, secondary #7A756D, tertiary, accent brown #8A5A36, accentSoft, delete #E03838, keep #10B981). Primary buttons are ink (`cta`), inverted in dark. Never hard-code colors in widgets.
- **Components:** white cards with hairline borders (`palette.card()`), grouped lists (`GroupedSection`/`GroupedRow`/`IconTile`/`TagLabel`), `Frosted` pills, `RoundIconButton`.
- **No bottom tab bar** (keeps the screen count low and the swipe screen immersive).
- **Not in v1:** duplicate/blurry detection is shown as "Soon" rows only; never claim it in copy.
- **Motion & feel:** Cupertino page transitions and bouncing scroll on both platforms, haptics on decisions.

## Screens (keep the count minimal)

1. **Onboarding + permission** – photo stack hero, "Clear space. Keep memories.", 3 feature rows, "Allow Photo Access" / "Not Now"; permission screen when denied.
2. **Home** – greeting, storage reclaimed card (+this week chip, cleaned/sessions/avg size), daily session card (resets countdown, progress, "Start cleaning"), smart categories (Pro locked; duplicates/blurry "Soon"), upgrade card.
3. **Swipe** – "7 of 15" header, 4:5 card with frosted date • size pill, delete/undo/keep controls, "Marked • 4.2 MB" toast, "Finish".
4. **Review & delete** – grid with per-photo size labels and Kept state, select/deselect all, trash note, "Delete 10 photos (216.7 MB)" + "Keep all", then result screen.
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
- [x] Phase 4 – Home: daily swipes, stats, locked categories
- [x] Phase 5 – Polish: icon, splash, real-device testing, large-gallery performance
- [ ] Phase 6 – Premium (RevenueCat) + paywall + filters + rewarded ads
- [ ] Phase 7 – Release: privacy policy, store assets, Android first then iOS
- [ ] v1.1 – Similar/duplicate photo detection

Tick the box when a phase is done.

## Dev environment

- Windows (Android) + Mac (iOS build/test).
- Design: Google Stitch → Figma; if a Figma link is given, read it via Figma MCP and implement in Flutter.
- Bundle ID: `com.hasannarli.snapsweep` (iOS and Android)
- Claude Code permissions: safe shared rules in `.claude/settings.json` (destructive git commands denied); broad personal allows go in the git-ignored `.claude/settings.local.json`.
