# Phase 5 Plan — Local State, Persistence and Simulated Data

Status: **APPROVED WITH CONDITIONS (2026-11-14).** Phase 5.2 is the only step authorised so far; see §11 for progress.
Written: 2026-11-14 · Branch `feature/figma-implementation` · Baseline: commit `f2a6967`
(CI run 43567060263: analyze, `flutter test`, `flutter build web --release` all succeeded; 23 widget tests).

Status vocabulary used throughout:

| Label | Meaning |
|---|---|
| **IMPLEMENTED** | Works for real, locally, inside the app (navigation, local state, local storage). |
| **DEMO** | The UI reacts, but the outcome is fake or a dialog saying "DEMO / SIMULATED". No real call, SMS, dispatch, camera, GPS, AI or recording exists. |
| **INCOMPLETE** | No Figma frame, or the frame is unfinished; shown as an `IncompleteScreen` or not built. |

Phase 5 does **not** change the DEMO label of anything that depends on hardware, AI, GPS or emergency services.

## Approved decisions (owner, 2026-11-14)

| ID | Decision (as approved) |
|---|---|
| **D1** | Build the data layer and wire **existing approved screens only**. Screens without Figma frames stay **INCOMPLETE**. **No provisional screens.** |
| **D2** | The Parking Guardian indicator reflects the real toggle state: **"Parking Guardian Off"** when all three parking protection toggles (motion, impact, auto-recording) are off, **"Parking Guardian On"** when at least one is on. |
| **D3** | `shared_preferences` **2.5.6** approved for small, non-sensitive local demo data, with typed models, versioned JSON, validation, error handling and a storage abstraction. |
| **D4** | Seed the Figma sample events and recording metadata **once** on first run, clearly identified as **DEMO**; never recreate deleted sample records on later launches. |
| **D5** | **No new settings screen.** Persist only settings that already have a UI control (or a confirmed need). |
| **D6** | Remove unused **`url_launcher`** after confirming zero references (confirmed: 0 imports in `lib/` and `test/`). **Keep `flutter_svg`** for future Figma assets. Keep `mocktail` only if used for testing (Phase 5.2 uses it for storage-failure tests). |

Conditions: preserve Phase 4 layouts and navigation; no Firebase, real GPS, recording, AI detection or emergency dispatch; no new screens;
no unrelated refactoring; trips, parking history, events and recordings are **not** part of 5.2; commit locally, **do not push** until the
owner has reviewed the implementation report; no merge, no deploy.

Where this section conflicts with the original proposal below, **this section wins**. In particular §1.7/§4 (D6) and §3.A (banner text) are superseded.

---

## 0. Phase 4 closure (STEP 1)

- CI for `f2a6967` is green: analyze ✔, `flutter test` ✔, `flutter build web --release` ✔. Latest code commit `6133640`: 23/23 tests.
- Nothing merged to `main`.
- Known limitations carried from `docs/QA_REPORT.md` (none block Phase 5):
  - colours, fonts and sizes are sampled/estimated, not read from Figma Inspect;
  - Voice SOS circle is larger than Figma; landscape Records rows are taller than Figma; quick-nav/header icons look small;
  - camera pictures and maps are vector placeholders;
  - "Dashcam Con…" / "Recordin…" show an ellipsis at 320 px;
  - mobile frames missing or unfinished: Find My Car, Saved Parking, Trip Sharing, Manual SOS, Voice SOS, Cabin Monitoring,
    Audio; no landscape frames for Home and Accident SOS;
  - widget tests cannot run on the owner's Windows machine (Smart App Control); **CI is the only test runner**.

---

## 1. Current architecture assessment (STEP 2)

### 1.1 Code size and layers

About 3,800 lines of Dart in `lib/`, feature-first (`features/*`), shared design system (`core/theme`, `core/widgets`), two
shells (`app/shells.dart`), `go_router` with a 5-branch `StatefulShellRoute` and 16 routes. State lives in a single file,
`lib/shared/providers.dart` (66 lines).

### 1.2 Riverpod providers today

| Provider | Type | Holds | Persisted? |
|---|---|---|---|
| `dashcamDeviceProvider` | `Provider<DashcamDevice>` | `SimulatedDashcamDevice` | – |
| `recElapsedProvider` | `StreamProvider<Duration>` | fake REC timer, restarts at 00:12:34 every launch | no (and should not be) |
| `assistantServiceProvider` | `Provider<AssistantService>` | canned replies | – |
| `togglesProvider` | `NotifierProvider<Map<String,bool>>` | 11 toggles (`parking.*`, `audio.*`, `alerts.*`, `ai.restBreak`) | **no** |
| `tripSharingProvider` | `FlagNotifier(true)` | "trip is shared" boolean | **no** |
| `drowsinessAlertProvider` | `FlagNotifier(false)` | overlay on the cabin camera (transient) | no (should stay transient) |
| `discreetModeProvider` | `FlagNotifier(false)` | Manual SOS "Discreet Mode" | **no** |

### 1.3 Data models and mock data

- **There are no domain models.** The only typed value is `Duration`.
- Sample data is **hard-coded inside widgets**: about 17 occurrences in 9 files (destination "Mid Valley Megamall", ETA
  10:18 AM, 28.4 km, "Highway A1, Km 120.5", "RNR Pagoh Selatan", "Jalan Universiti, Skudai", 80 km/h, 00:24:18, "Today,
  8:36 PM", contacts "Dad"/"Sister", "Standard", Volume 70%, 30:00 …). The same facts are duplicated across screens
  (e.g. ETA/destination in Trip Sharing and Rest Stop; recordings in Records and Accident).
- `SimulatedServices` exist for the dashcam clock and assistant replies only (`lib/shared/simulated/`).

### 1.4 What is simulated or non-functional today

| Screen (layout) | IMPLEMENTED (real, local) | DEMO | INCOMPLETE |
|---|---|---|---|
| Front camera (L) | navigation, quick-nav | picture, timestamp, REC time | no mobile frame |
| Cabin camera (L) | navigation; alert overlay (in-memory) | "Simulate drowsiness" trigger, the alert itself | no mobile frame |
| Trip Sharing (L) | Start/Stop flips an in-memory flag | destination/ETA/contacts, **Share Link** dialog | mobile frame missing |
| Manual SOS (L) | hold-to-activate gesture, Discreet toggle (in-memory) | activation result, 3 call buttons (dialogs), location, contacts | mobile frame missing |
| Voice SOS (L) | – | "Listening…/Recognized" chips, 4 quick actions (dialogs) | mobile frame missing |
| Parking (L+M) | 3 toggles (in-memory) | recent alerts, evidence/tracking rows (dialogs), "Parking Guardian On" banner is **static** even if toggles are off | – |
| Smart Hub (L) | navigation | – | no mobile frame |
| Audio & Music (L) | 4 toggles (in-memory), play/pause icon flips | track, prev/next (no-op), volume, "Standard" pill (not changeable) | mobile frame unfinished |
| Records (L) / Evidence (M) | 3 alert toggles (in-memory, landscape) | vault/log cards and every recording row (dialogs), the recording list | – |
| Nexio AI (L+M) | navigation, rest-break toggle (in-memory) | every reply (canned), "Listening…" | – |
| Rest Stop (L) | – | destination, ETA, distance, map | no mobile frame |
| Home (M) | quick-action navigation | **everything displayed** (speed, duration, passengers, cabin states, location, connection) | no landscape frame |
| Accident SOS (M) | navigation link | alert content, clip, 3 call buttons | no landscape frame |
| Find My Car / Saved Parking (M) | – | – | **INCOMPLETE** (frames partly captured) |

Dead handlers: audio prev/next (`onTap ?? () {}`); Alert Sound pill and Volume are display-only.

### 1.5 What should persist across restarts

| Persist | Why | Notes |
|---|---|---|
| 11 toggles (`parking.motion/impact/auto`, `audio.system/voice/cabin/aiPref`, `alerts.fcw/ldw/sls`, `ai.restBreak`) | They are user preferences; today they reset on every launch | |
| Discreet Mode | SOS demo configuration | |
| Trip history + the active trip's start time | Needed for trip management | |
| Saved parking records | Needed for parking management | |
| Safety events + recording metadata | Needed for records/history | seed data on first run (see 3.D) |
| **Do not persist** | | drowsiness overlay (transient), REC timer (simulated clock), AI reply dialogs, hold progress |

Not persisted because there is no UI and no design: volume, alert-sound choice, theme or language ("user interface
preferences" — see decision D5).

### 1.6 Shared state needs (today: duplicated or inconsistent)

1. Parking toggles ↔ "Parking Guardian On" banner (currently disconnected).
2. Active trip ↔ Trip Sharing ↔ Home (duration, passengers) ↔ Rest Stop (destination/ETA).
3. Safety events ↔ Parking "Recent Alerts" ↔ Records "Recent Recordings" ↔ Cabin drowsiness alert ↔ Home "AI Cabin
   Monitoring" ↔ AI answers ("Is there any safety alert?", "Show my latest recording").
4. Settings ↔ the same feature shown on several screens (alerts toggles on Records; features listed on Nexio AI).

### 1.7 Packages

| Package | Used? | Phase 5 view |
|---|---|---|
| `flutter_riverpod 3.5` | yes | keep; use `Notifier` / `AsyncNotifier` |
| `go_router`, `google_fonts` | yes | keep |
| `url_launcher` | **declared, never imported** | **remove (D6 approved)** — also guarantees no accidental `tel:`/SMS |
| `flutter_svg` | declared, never imported | **keep** for future Figma assets (D6) |
| `mocktail` (dev) | not used by any test yet | keep; used from 5.2 for storage-failure tests (D6) |
| **`shared_preferences 2.5.6`** (not yet added) | – | **proposed, the only new dependency** — supports Android, iOS, **Web** (localStorage), pub points 160, requires Flutter ≥ 3.41 (we use 3.47.9) |

### 1.8 Architectural risks found

| # | Risk | Mitigation in this plan |
|---|---|---|
| R1 | Stringly-typed toggles map (`Map<String,bool>`) — typos silently return `false` | typed `AppSettings` model; keep string keys only as storage names |
| R2 | Sample data copied into widgets | single seed/simulated data source; widgets read providers |
| R3 | Lesson from Phase 4: `LayoutBuilder` inside `IntrinsicHeight`, and overflow hidden in release builds | new list UIs must scroll; QA must include debug cold-loads at 320/360/375/390/1672 |
| R4 | Tests cannot run locally; every check costs a push + ~4 min CI | small commits; keep logic in plain Dart classes (fast, deterministic); a tiny in-memory store for tests |
| R5 | Periodic timers fail widget tests ("Timer still pending") | already overridden (`recElapsedProvider`); keep every new timer behind an injectable `Clock` |
| R6 | Async startup (reading storage) could flash default values | read `SharedPreferences` once in `main()` before `runApp`, inject through `ProviderScope.overrides` |
| R7 | Web `localStorage` is plain text, per-origin and shared by tabs | store only non-sensitive demo data (see 2.3); last-write-wins across tabs is documented |
| R8 | Local data grows unbounded | cap each collection (trips 100, parking 50, events 200, recordings 100) |
| R9 | Corrupt/old JSON could crash startup | tolerant decoding → error state with "Reset demo data"; versioned keys (`dashcam.v1.*`) |
| R10 | New list/detail screens have **no Figma frames** | decision D1 below — do not invent designs |

---

## 2. Proposed approach (STEP 3 — overview)

### 2.1 Persistence choice and justification

**`shared_preferences` with one JSON document per collection**, behind a small `KeyValueStore` interface.

| Option | Verdict |
|---|---|
| **`shared_preferences`** | **Chosen.** One small package, first-party, works on Web + Android + iOS with no setup. Our data is tiny (a few hundred records, each < 300 bytes) and is read whole, which suits a JSON document. |
| `sqflite` / `drift` | Rejected: heavier, Web needs wasm/worker setup, more CI/build risk, and there are no relational queries or large data to justify it. |
| `hive` / `isar` | Rejected: extra dependency and code generation for no real gain here. |
| Raw `localStorage` / `dart:html` | Rejected: web-only, would break Android. |
| Firebase / cloud | Out of scope (owner decision: no login, no cloud). |

Because the store is an interface (`KeyValueStore`) and repositories are interfaces, a later phase can swap in Firestore or
SQLite **without touching the UI**.

### 2.2 State design

- Settings: a typed immutable `AppSettings` in a synchronous `NotifierProvider` (values are pre-loaded in `main()`).
- Collections (trips, parking, events, recordings): `AsyncNotifierProvider` so every screen can show
  **loading / empty / error / data** consistently.
- A single `Clock` interface (system clock in the app, fixed/fake clock in tests) so durations and "Today, 8:36 PM" are testable.
- Repositories are plain Dart classes (no Flutter imports) so they are fast to test.

### 2.3 Privacy rules for stored data (requirement 9)

Allow-list, enforced by models and tests:

- Stored: toggle booleans, simulated trip/parking/event/recording **metadata** (ids, timestamps, durations, free labels such as
  "Level B2 • Bay A-18"), all marked `simulated: true`.
- **Never stored:** real phone numbers or contact details, real GPS coordinates, device identifiers, camera/audio data,
  anything typed into the AI input.
- Emergency contacts remain the display-only demo names "Dad"/"Sister" (no editing UI exists; no numbers stored).
- A "Reset demo data" action clears everything under the `dashcam.v1.` prefix.
- No analytics, no network.

---

## 3. Feature-by-feature plan

### A. Persistent settings

- **Model:** `AppSettings { parkingMotion, parkingImpact, parkingAuto, audioSystem, audioVoice, audioCabin, audioAiPreference,
  alertForwardCollision, alertLaneDeparture, alertSpeedLimit, aiRestBreak, sosDiscreetMode }` + `schemaVersion`.
- **Storage:** one JSON string at `dashcam.v1.settings`; missing keys fall back to the current defaults (all `true`, discreet `false`).
- **Wiring (no UI change):** replace `togglesProvider` and `discreetModeProvider` with `settingsProvider`. The Parking, Audio,
  Records and AI screens keep their exact look and read/write the typed model.
- **Consistency fix:** the Parking banner "Parking Guardian On" now reflects the three parking toggles (it is static today).
  **D2 (approved):** the landscape label reads "Parking Guardian On" if at least one parking toggle is on, otherwise "Parking Guardian Off". The mobile banner has no such text in Figma, so only in the all-off state its subtitle "Monitoring your vehicle" is replaced by "Parking Guardian Off". Limitation: the title "Parking Mode Active" is a design string and is unchanged.
- **Recording preferences:** the only recording-related controls in the design are the *Auto Recording* parking toggle and the
  Home "Recording On" label. Both stay DEMO (no recorder); the toggle persists. There is no recording-settings screen to build.
- **SOS demo configuration:** persist Discreet Mode only. Contacts stay static demo names.
- **UI preferences:** none exist in the design → nothing to persist (D5).
- Status after: toggles **IMPLEMENTED** (persisted); the features they represent stay **DEMO**.

### B. Simulated trip management

- **Model:** `Trip { id, startedAt, endedAt?, destination, plannedDistanceKm, shared, simulated=true, endReason (completed|interrupted) }`;
  derived `duration`, `isActive`.
- **Behaviour:** *Start Sharing* creates an active simulated trip (destination from the seed, e.g. "Mid Valley Megamall"),
  *Stop Sharing* ends it and stores it in history. Only **one** active trip at a time.
- **Restart behaviour:** the active trip is stored with `startedAt`; on launch, if it is older than 12 h it is closed as
  `interrupted` (prevents "trip lasted 9 days").
- **Wiring to existing UI:**
  - Landscape Trip Sharing: pill/state and buttons use the trip controller (Start disabled while active, as today).
  - Mobile Home: "Trip Duration" shows the active trip's elapsed time (or `--:--:--` when none); speed and passengers stay
    SIMULATED labels.
  - Rest Stop: destination/ETA come from the active trip when there is one, else the seed.
- **Trip history and summary:** **no Figma frame exists** → see D1. Domain, repository and tests are built regardless.
- Status after: start/stop/history store **IMPLEMENTED** (local); Share Link, GPS, ETA, distance **DEMO**; history/summary screens **INCOMPLETE** pending D1.

### C. Simulated parking management

- **Model:** `ParkingRecord { id, savedAt, level, bay, label, simulated=true }` (shape taken from the partial Figma capture:
  "Level B2 • Bay A-18", "Parked For 02:24:18", walking route 220 m / 3 min — the walking route stays a DEMO value).
- **Operations:** save a mock record, list newest first, delete one, delete all; one record may be marked *current* (feeds
  "Parked For …").
- **UI:** the Find My Car / Saved Parking frames are INCOMPLETE → see D1. Until approved, only the domain, repository and tests ship.
- Status after: repository **IMPLEMENTED**; screens **INCOMPLETE**; location/route/GPS **DEMO**.

### D. Records and safety events

- **Models:**
  - `RecordingMeta { id, title, subtitle, kind (accident|hitAndRun|cabin|parking), durationSeconds, createdAt, locked, simulated=true }`
  - `SafetyEvent { id, type (motion|impact|drowsiness|forwardCollision|laneDeparture|speedLimit|accident), occurredAt, severity, recordingId?, simulated=true }`
- **Seed data (first run only):** the Figma samples — Accident Evidence 00:30, Hit-and-Run 00:24, Cabin Monitoring 01:15; Motion
  Detected "Today, 8:36 PM"; Impact Detected — all marked SIMULATED. A `seeded` flag prevents re-seeding after the user deletes/resets.
- **Event creation:** the existing "Simulate drowsiness" button now also writes a `drowsiness` event (labelled simulated).
  No real detection is added.
- **Wiring to existing UI (no layout change):**
  - Mobile Records & Evidence → "Recent Recordings" list from the repository (rows keep the DEMO dialog on tap).
  - Parking (L+M) → "Recent Alerts" from `motion`/`impact` events.
  - Home → "AI Cabin Monitoring" Drowsiness pill follows the latest drowsiness event (Normal / Alert), still SIMULATED.
  - Nexio AI (simulated service) can answer "Is there any safety alert?" and "Show my latest recording" from the stored events/recordings, still labelled simulated.
- **Filtering / viewing:** filter chips, a recordings list screen, the Evidence Vault and Incident Log screens are not in Figma → D1.
  The repository supports filtering by type and date range from day one (tested).
- Status after: recent lists **IMPLEMENTED** (local data), the events/clips themselves **DEMO**; vault/log/filter screens **INCOMPLETE** pending D1.

### E. Shared state, loading / empty / error

- Every collection provider exposes `AsyncValue`. One small shared widget `StateMessage` (loading spinner, empty text, error with
  "Reset demo data") built only from existing tokens (`CreamCard`, `AppTypography`). It is state chrome, not a Figma screen (D1).
- Cross-screen consistency is achieved by deriving, not copying: Home, Trip Sharing and Rest Stop all read the trip provider;
  Parking, Records, Home and AI all read the event repository.
- A **dev-only** route `/dev/data` (next to `/dev/gallery`, not linked from the UI) shows stored counts and offers "Reset demo
  data" — so no unplanned UI is added to approved screens.

---

## 4. Decisions (all answered — see "Approved decisions" at the top)

D1–D6 were answered on 2026-11-14. D5 clarification: no settings screen; only controls that exist today are persisted, so volume, alert sound,
theme and language are **not** stored.

---

## 5. Suggested file structure

```
lib/
  core/
    clock.dart                      Clock interface + SystemClock
    storage/
      key_value_store.dart          interface (getString/setString/remove/keys)
      shared_prefs_store.dart       SharedPreferences implementation
      in_memory_store.dart          for tests and a safe fallback
  features/
    settings/    domain/app_settings.dart · data/settings_repository.dart · presentation/settings_providers.dart
    trips/       domain/trip.dart · domain/trip_repository.dart · data/local_trip_repository.dart · presentation/trip_controller.dart
    parking/     domain/parking_record.dart · domain/parking_repository.dart · data/local_parking_repository.dart · presentation/parking_controller.dart
    records/     domain/{recording_meta,safety_event}.dart · domain/*_repository.dart · data/local_*_repository.dart · presentation/records_controller.dart
    dev/         dev_data_screen.dart   (route /dev/data only)
  shared/
    providers.dart                  keeps device/assistant/rec-timer providers; bootstrap overrides
    simulated/seed_data.dart        the Figma sample data, in one place, all marked simulated
    widgets/state_message.dart      loading / empty / error (existing tokens only)
test/
  core/ (store, clock) · features/<feature>/ (model JSON, repository, controller) · widgets (updated existing tests with in-memory store overrides)
```

Storage keys (all prefixed `dashcam.v1.`): `settings`, `trips`, `parking`, `events`, `recordings`, `seeded`. One JSON document per key
(atomic replace). Caps: trips 100, parking 50, events 200, recordings 100 (oldest dropped).

---

## 6. Testing strategy

All tests run in **GitHub Actions only** (local runner is blocked); keep pure-Dart logic testable without widgets.

1. **Model tests:** JSON round-trip; unknown/missing fields; schema-version handling; allow-list (no forbidden fields serialised).
2. **Repository tests** with `InMemoryStore`: create/read/delete, ordering, caps, filtering, corrupt JSON → error, `seeded` flag, reset.
3. **Controller tests** with a `ProviderContainer` + fake `Clock`: trip start/stop/duration, one active trip, 12 h `interrupted`
   rule, parking save/delete, event creation from the simulated trigger.
4. **Restart test:** mutate state, create a **new** container over the same store, assert it is restored.
5. **Widget tests:** the 23 existing tests stay green (providers overridden with an in-memory store); add tests for wired screens
   (toggle persistence, Parking banner follows toggles, Trip Sharing start/stop updates Home duration, Records list from repository,
   empty and error states).
6. **Real-Chrome QA (same method as Phase 4):** debug cold loads at 320/360/375/390/1672 checking the console for overflow;
   **reload-persistence** check (toggle, reload the page, toggle still set); two-tab last-write-wins note.
7. **No-real-action guard:** a test asserting no code path imports `url_launcher` or opens `tel:`/`sms:` URIs (and removal per D6).
8. Existing guard rails stay: no periodic timers in tests (inject `Clock`/override streams).

---

## 7. Risks and limitations (summary)

- **Design gaps (R10/D1)** are the biggest scope risk: much of "trip history", "saved parking" and "filtering records" has no Figma frame.
- Persisted data is **demo data in plain text** (localStorage / app preferences); acceptable only because nothing sensitive is stored (2.3).
- Web: storage is per-browser-profile and per-origin; clearing site data wipes it; two tabs can overwrite each other.
- Android: `shared_preferences` is not for large or sensitive data — fine for this scope; a database would be needed for real recordings metadata at scale.
- No real recording, camera, AI, GPS, calls, SMS or dispatch will exist after Phase 5; everything derived from them remains **DEMO**
  and keeps its SIMULATED badge.
- CI-only testing lengthens the fix loop; mitigated by small commits and plain-Dart logic.
- Time/clock edge cases (device clock changes, time zones): timestamps stored as UTC ISO-8601, displayed in local time; "Today" is computed through the `Clock`.

---

## 8. Estimated effort

Assumes one developer, decisions D1–D6 answered, no new Figma frames, CI as the only test runner. Ranges are working days
including tests and a Phase-4-style QA pass.

| Step | Scope | Estimate |
|---|---|---|
| 5.2 | Storage layer, bootstrap, typed settings, wire 12 toggles, Parking banner, restart tests, remove `url_launcher` | 1.5 – 2 d |
| 5.3 | Events + recordings (models, repos, seed, wiring to Records/Parking/Home/AI, simulated drowsiness event) | 2 – 3 d |
| 5.4 | Trips (model, controller, wiring to Trip Sharing/Home/Rest Stop, interrupted rule) | 1.5 – 2 d |
| 5.5 | Parking records (domain, repo, tests; UI only if D1 allows) | 1 – 1.5 d (+1 – 2 d if provisional screens approved) |
| 5.6 | Loading/empty/error widget, `/dev/data` reset page, full QA, docs | 1.5 – 2 d |
| | **Total (no new screens)** | **≈ 7.5 – 10.5 d** |
| | If provisional screens are approved (D1-b) | **≈ +3 – 5 d** |

---

## 9. Recommended implementation order

1. **5.2 Foundation + settings** (smallest change, biggest user-visible win: toggles survive a restart; unlocks every later step).
2. **5.3 Events + recordings** (feeds three existing screens and the AI answers).
3. **5.4 Trips** (builds on the clock and store; touches Trip Sharing, Home, Rest Stop).
4. **5.5 Parking records** (domain first; UI waits for D1).
5. **5.6 States, dev reset page, full QA, documentation, final CI verification.**

Each step ends with: `flutter analyze`, `flutter build web`, green CI, Phase-4-style QA for the screens touched, a QA report
update, and a local commit; pushes and merges only with owner approval.

---

## 10. Out of scope for Phase 5

Firebase/Auth/cloud, real emergency calls/SMS/dispatch, real camera/recording/AI/GPS/maps, background services, push
notifications, Vercel deployment, merging into `main`, redesigning any approved Figma screen.

---

## 11. Progress

| Step | Status |
|---|---|
| 5.1 Plan | **Approved with conditions** (2026-11-14) |
| 5.2 Settings and storage foundation | **In progress** — report to follow; local commit only, not pushed |
| 5.3 Events + recordings | not started |
| 5.4 Trips | not started |
| 5.5 Parking records | not started |
| 5.6 States, dev reset page, final QA | not started |
