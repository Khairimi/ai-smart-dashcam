# Flutter Implementation Plan

Status: **approved architecture** (2026-11-14). One Flutter codebase, two adaptive layouts: in-car landscape dashboard (`InCarShell`) and mobile app (`MobileShell`).

## Decisions in force

| Decision | Source |
|---|---|
| Flutter single codebase; separate adaptive layouts for in-car landscape and mobile | Approved by owner |
| **No Firebase login** for now — app runs without auth | Owner |
| Unfinished Figma screens are shipped as clearly labelled **INCOMPLETE** placeholders, not invented designs | Owner |
| Figma design is the source of truth — no redesign | Owner |
| Hardware/AI/GPS data via interfaces; only `Simulated*` adapters, visibly badged **SIMULATED** | Brief §9 |
| Push/merge only with owner approval; work on `feature/figma-implementation` | Brief §5 |

## Incomplete Figma screens (render `IncompleteScreen` placeholder)

| Mobile frame | Node | Reason |
|---|---|---|
| 03 • AI Cabin Monitoring | `48-8522` | Frame unfinished (empty "Audio & Music Settings" rows) |
| 03 • AI Cabin Monitoring (2nd copy) | unresolved | Not captured |
| 02 • Find My Car | unresolved | Partially captured — implement only after full capture |
| 04 • Manual SOS (mobile) | unresolved | Not captured — mobile route falls back to landscape-derived layout only after confirmation |
| 05 • Voice SOS (mobile) | unresolved | Not captured |
| 06 • Saved Parking | unresolved | Not captured |
| 07 • Trip Sharing (mobile) | unresolved | Not captured |

These move to "implement" once full captures/node IDs are obtained (sign in to Figma in the browser so Inspect values can be read).

## Phases

### Phase 2 — Project initialization (local machine, Flutter SDK required)
1. `flutter create --org com.khairimi --project-name ai_smart_dashcam --platforms=web,android,ios .` inside the repo (keeps existing `docs/`).
2. Add packages: `go_router`, `flutter_riverpod`, `url_launcher`, `google_fonts` (or bundled font once confirmed), `flutter_svg`.
   Dev: `flutter_lints`, `mocktail`.
3. Folder structure per `ARCHITECTURE.md`; `analysis_options.yaml` with `flutter_lints`.
4. Verify: `flutter analyze`, `flutter test`, `flutter run -d chrome`.

### Phase 3 — Design system (`lib/core/theme`, `lib/core/widgets`)
- `AppColors` from `FIGMA_AUDIT.md` §4 (marked *sampled* until confirmed in Inspect).
- `AppTypography`, `AppRadii` (card 18, tile 14, pill 999), `AppSpacing` (4-pt scale).
- Widgets: `CreamCard`, `StatusPill`, `OnToggleChip`, `IconBadge`, `InCarHeader`, `RecIndicator`, `QuickNavBar` (5 tiles), `MobileBottomNav` (5 tabs), `CameraFeedPlaceholder` (sky/trees/road vector), `SimulatedBadge`, `IncompleteScreen`.
- Widget tests for each.

### Phase 4 — Screens
Order (shared chrome first, then highest-value screens):
1. Shells + router (`StatefulShellRoute`, breakpoint switch at 1024 / 768).
2. Landscape: 01 Front Camera → 02 Cabin (+ drowsiness overlay) → 07 Smart Hub → 04 Manual SOS → 05 Voice SOS → 03 Trip Sharing → 06 Parking → 09 Records → 08 Audio → 10 AI Assistant → 11 Rest Stop.
3. Mobile: Home (`4-3`) → Accident SOS (`4-378`) → Records & Evidence (`9-4`) → Parking (`4-427`) → AI Assistant (`9-356`) → Incomplete placeholders.

### Phase 5 — Logic
- Riverpod providers per feature; `Simulated*` adapters: dashcam status/REC timer, detection events (drowsiness alert trigger), location/ETA, speech (Voice SOS), assistant replies.
- Real: hold-to-activate SOS gesture, `tel:` calls (999 etc. — confirm numbers), toggles persisted locally (`shared_preferences`).
- Loading / empty / error states for every async provider.

### Phase 6 — Backend
Deferred (no login). Repository interfaces kept so Firestore can be added later; `docs/FIREBASE_SETUP.md` documents the steps only.

### Phase 7 — QA
- Widget + golden tests per screen at 1440×810, 1024×576, 390×844, 320×568.
- `integration_test` for navigation and web deep-link refresh.
- `docs/QA_REPORT.md` with PASS / FAIL / INCOMPLETE only for executed tests.

### Phase 8 — Deployment prep
- GitHub Actions: `flutter analyze` + `flutter test` + `flutter build web --release` → deploy `build/web` to Vercel (via Vercel CLI + token secret), `vercel.json` SPA rewrite to `/index.html`.
- Android: app id, icons (`flutter_launcher_icons`), splash (`flutter_native_splash`), `flutter build apk` / `appbundle`.
- iOS: document signing; build only on macOS/Xcode.

### Phase 9 — Final report
`README.md`, `DEPLOYMENT.md`, `QA_REPORT.md`, outstanding integrations list.
