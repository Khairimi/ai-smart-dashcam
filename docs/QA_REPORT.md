# QA Report

Only executed checks are recorded. Status: PASS / FAIL / BLOCKED / INCOMPLETE.

## Environment (2026-11-14)

Flutter 3.47.9 (stable), Dart 3.13.7, Android SDK 36, Chrome 157, Windows 11 25H2. `flutter doctor -v`: no issues. Xcode unavailable (iOS builds need macOS).

## Phase 2 — scaffold

| Check | Result | Notes |
|---|---|---|
| `flutter analyze` | PASS | No issues |
| `flutter build web` | PASS | `build/web` produced (git-ignored) |
| `flutter test` (widget tests) | **BLOCKED** | See below |
| `flutter run -d chrome` (debug) | PASS (launch) | Debug build compiled, Chrome connected in 30.7 s, no errors in the tool log. Page content not visually captured in debug mode (headless capture hit the loader). |
| Render check, release build served locally (headless Chrome screenshot) | PASS | Cream background and placeholder text render. Console shows only the bootstrap info line; no errors/warnings. |

### BLOCKED: widget tests (`flutter_tester.exe`)

- **Symptom:** `flutter test` fails at load: "An Application Control policy has blocked this file" for
  `C:\src\flutter\bin\cache\artifacts\engine\windows-x64\flutter_tester.exe`.
- **Diagnosis (read-only):** Windows Event Log `Microsoft-Windows-CodeIntegrity/Operational` shows events 3033/3077/3118
  ("Smart App Control Block Details"): the unsigned `flutter_tester.exe`, launched by `dartvm.exe`, does not meet the
  required signing level. `VerifiedAndReputablePolicyState = 1` (Smart App Control in enforce mode).
- **Not done, by decision:** Smart App Control / Defender were not disabled and no broad exclusions were added.
- **Alternative tried:** `flutter test --platform chrome` did not finish within 5 minutes and was stopped. Not recorded as PASS.
- **Impact:** widget/golden tests are written but cannot be executed locally. They can run in CI (GitHub Actions, Linux),
  or on a machine/dev-drive where Smart App Control permits the tester. Test results must not be claimed until executed.
- **Status:** BLOCKED.

## Phase 3 — design system

| Check | Result | Notes |
|---|---|---|
| `flutter analyze` | PASS | No issues |
| `flutter build web` | PASS | |
| Visual check, release build (headless Chrome screenshot of `DesignGallery`) | PASS | All components render on cream bg; no console errors. Compared by eye against `docs/figma-reference` only — no pixel diff. |
| Widget tests (`test/core_widgets_test.dart`, `test/widget_test.dart`) | **BLOCKED** | Written (7 tests) but not executed: Smart App Control blocks `flutter_tester.exe` (see above). Not claimed as passing. |

Observations: in the headless run the Inter font was not visibly applied (Roboto-like fallback), consistent with
`google_fonts` runtime fetching; bundle the font once the family is confirmed.

## Phase 4 — shells, routing, screens

| Check | Result | Notes |
|---|---|---|
| `flutter analyze` | PASS | No issues |
| `flutter build web --release` | PASS | |
| Deep links, release build behind an SPA-fallback server (`/camera/front`, `/camera/cabin`, `/trips/share`, `/sos`, `/sos/voice`, `/safety/parking`, `/hub`, `/hub/audio`, `/records`, `/ai`, `/ai/rest-stop`, `/home`, `/sos/accident`, `/trips/find-car`) | PASS | Each URL loaded directly and rendered the expected screen (headless Chrome screenshots) |
| Visual check, in-car 1672 × 941 (11 routes) | PASS (by eye) | Compared with `docs/figma-reference/L*`; no pixel diff |
| Visual check, mobile 390 × 844 (home, parking, records, AI, accident, incomplete) | PASS (by eye) | iframe of exact size inside headless Chrome (plain `--window-size` is clamped to ~500 px) |
| Visual check, mobile 375 × 812 and 320 × 568 (home, AI, accident, parking) | PASS (by eye) | No overflow stripes/clipping seen; "Dashcam Connected" truncates to an ellipsis at 320 px |
| Browser console | PASS | Only the Flutter bootstrap info line |
| Widget tests (`test/widget_test.dart`: 13 route/interaction tests; `test/core_widgets_test.dart`: 7; total 20) | **BLOCKED locally** | Smart App Control blocks `flutter_tester.exe`. **CI has not run** — no pass is claimed. |
| GitHub Actions (`.github/workflows/ci.yml`) | **NOT RUN** | Workflow committed locally only; nothing pushed |

Caveats: the release build does not paint RenderFlex overflow stripes, so overflow was judged visually. Flutter's test
font (Ahem) makes overflow assertions meaningless; the widget tests deliberately ignore overflow errors.

### Differences from Figma / unverified values

- All colours, type sizes, radii and the font (Inter, via `google_fonts`) are sampled/estimated, not read from Inspect.
- In-car sizes are scaled from width (`textScale = width / 1672 × 1.7`, clamped); Figma has no scale spec. Quick-nav and
  header icons are small relative to the frame because they are not scaled.
- Icons are Material stand-ins for the Figma glyphs. Voice SOS keeps the music-note glyph as drawn (audit text says "mic").
- Camera pictures, map art (landscape 11 map is a dark grid placeholder; real map art unverified) and avatars are vector placeholders.
- Added UI not in Figma: `SIMULATED` badges, a "Simulate drowsiness" control to reach the 02b alert state, DEMO dialogs
  for actions that are not connected, and a derived "Off" look for toggles.
- The Accident SOS screen (`/sos/accident`) is not linked from the UI because there is no crash detection; reach it by URL.
- Landscape/mobile frames that do not exist (landscape Home/Accident; mobile cameras/Hub/Audio/Rest Stop/SOS/Voice SOS/
  Trip Sharing/Find My Car/Saved Parking/Cabin Monitoring) render `INCOMPLETE`.
