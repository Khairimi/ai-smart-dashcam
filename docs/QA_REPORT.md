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
| Widget tests (`test/widget_test.dart`: 13 route/interaction tests; `test/core_widgets_test.dart`: 7; total 20) | **BLOCKED locally; PASS in CI** | Locally blocked by Smart App Control. In GitHub Actions (Linux) run 43561171890 on `07dada3`: `flutter test` succeeded, all 20 tests passed. |
| GitHub Actions (`.github/workflows/ci.yml`) | **PASS** | Run 43561171890 (`07dada3`): analyze, test (20/20), `flutter build web --release` all succeeded. An earlier run (43560793814, `e52aa4c`) failed 3 mobile tests: `LayoutBuilder` inside `IntrinsicHeight` at `home_dashboard_screen.dart:94`; fixed in `07dada3`. |

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

## Phase 4 — Final visual QA (2026-11-14)

Method: debug build served with `flutter run -d web-server` and driven in headless Chrome 157 over the DevTools protocol
(exact viewport sizes, real mouse clicks through the page's accessibility tree, console capture). Debug mode was used because
release builds hide RenderFlex overflow. No application code was changed during this review. Screenshots are in
`docs/qa-screenshots/` (`1672x941/`, `390x844/`, `375x812/`, `320x568/`, `interaction/`).

### Cold page loads (authoritative for overflow)

Every route was loaded from scratch at each size and the browser console was checked.
Note: navigating in-session (`pushState`) can hide a second overflow report, so an earlier in-session sweep that showed
0 issues at 320 px was a false negative and is not relied on.

| Set | Loads | Pass | Fail |
|---|---|---|---|
| Mobile 320×568 / 375×812 / 390×844 × (`/home`, `/safety/parking`, `/records`, `/ai`, `/sos/accident`, `/trips/find-car`) | 18 | 17 | 1 |
| In-car 1672×941 × 13 routes (11 Figma screens + `/home`, `/trips/find-car` placeholders) | 13 | 13 | 0 |

**FAIL — mobile Home at 320 px: "A RenderFlex overflowed by 17 pixels on the bottom"**
(`lib/features/home/home_dashboard_screen.dart:118`, the "AI Cabin Monitoring" card). The card sits in an `IntrinsicHeight`
row; at 320 px the label/pill `Wrap` stacks to two lines per row, so the content is 17 px taller than the intrinsic height.
In release builds the overflow is clipped, hiding the "Emotion" and "Seatbelt" rows. Not reproduced at 360, 375 or 390 px.
Severity: medium (data hidden on very small phones; no crash). **Not fixed** (review-only task).
Screenshot: `docs/qa-screenshots/interaction/cold_home_320.png`.

### Interaction tests (real clicks, debug build)

38/38 scripted checks PASS, plus a separate toggle check (PASS): quick-nav and hub-card navigation; browser back/forward;
header back; cold deep links; drowsiness alert (show, Ignore, Find Nearest Rest Stop → `/ai/rest-stop`); DEMO dialogs
(Call Police, Share Link, Call Ambulance, recording row, parking row, AI replies) open and close; hold-to-activate (early
release does not activate, a 2 s hold shows the DEMO dialog); Discreet Mode, Stop/Start Sharing and the parking switch
(`aria-checked` true → false) toggle; resize 1672 → 390 → 1672 switches shells; five mobile tabs; Home quick action → INCOMPLETE;
Accident → Records & Evidence link; scrolling at 320×568 reaches the bottom of long screens.

Console during the scripted flows: 2 issues. (1) the 320 px overflow above. (2) an engine assertion in
`_computeOnScreenKeyboardInsets` / `_handleBrowserResize`, which appears only with Chrome's *mobile emulation* flag and not
with plain viewport resizing — attributed to the test harness, not the app.

### Figma comparison (by eye; no pixel diff)

All 19 references were compared against the implementation. Landscape L01–L11 and 02b: layout, colours, proportions and
navigation match; mobile M01 Home, M08 Accident, M09 Parking, AI Assistant, Records & Evidence and the bottom-nav component
match at 390 px. `M_wip_audio` (unfinished Figma frame) is intentionally an INCOMPLETE placeholder. Differences:

| Area | Finding | Status |
|---|---|---|
| Voice SOS (landscape) | Green circle larger than in Figma; Quick Actions card has extra empty space below the pills | minor, FAIL (cosmetic) |
| Records (landscape) | Row cards taller than Figma with different gaps | minor, FAIL (cosmetic) |
| Quick-nav / header icons | Small relative to the 1672 frame (icons are not width-scaled) | minor |
| Camera / cabin art | Simple vector placeholders, not the Figma illustrations | known, by design |
| Rest Stop map | Dark grid placeholder; Figma map art unverified | known |
| Hold-to-activate fill | Progress fill was not visible in any headless capture although activation works | INCONCLUSIVE — check in a real browser |
| Colours / fonts / sizes | Still sampled/estimated, not read from Inspect | unverified |
| Text at 320 px | Some titles truncate with an ellipsis ("Dashcam Con…", "Parking & Vehicle Secur…") | acceptable |

### Verdict (before the fix)

**FAIL (narrow):** one medium-severity overflow at 320 px on mobile Home.

## Phase 4 — Home 320 px overflow fix and re-verification

Changes (only `lib/features/home/home_dashboard_screen.dart`):
1. The "AI Cabin Monitoring" rows are now a plain `Row` (label + pill on one line, the Figma layout) or a plain `Column`
   (label above pill) chosen by a `LayoutBuilder` placed **outside** the `IntrinsicHeight`; threshold 132 px of inner card
   width (an estimate, not a Figma value). 320 px stacks; 360/375/390 px keep the one-line Figma layout.
2. The title "AI Cabin Monitoring" is a single line scaled down ~7% at 320 px via `FittedBox`. Root cause of the 17 px
   overflow: the title wrapped to two lines at 320 px but `IntrinsicHeight` had measured one line. (A first attempt that
   only replaced the `Wrap` did **not** fix it; the overflow persisted at `home_dashboard_screen.dart:134`.)
3. Regression fixed: my earlier narrow-width change (`Flexible` + `Spacer`) truncated "Recording On" at every width
   (the two split free space 50/50). Now `Expanded`; "Recording On" is complete at 360/375/390 px.

Cold-load verification (debug build, console watched, content confirmed rendered before capture):

| Width | Result | Evidence |
|---|---|---|
| 320×568 | PASS: no overflow or layout exceptions; Drowsiness/Normal, Distraction/Focused, Emotion/Calm, Seatbelt/Fastened all fully visible | `docs/qa-screenshots/fix/home_320_top.png`, `home_320_cabin.png` |
| 360×640 | PASS | `fix/home_360_top.png` |
| 375×812 | PASS | `fix/home_375_top.png` |
| 390×844 | PASS | `fix/home_390_top.png` |

Remaining small items at 320 px (not bugs of the card): "Dashcam Connected" and "Recording On" show an ellipsis
("Dashcam Con…", "Recordin…") because the connection card is narrow.

Lesson recorded: right after a debug-server restart the first page load can still be blank; two intermediate "no issues"
results at 320 px were from unrendered pages and were discarded. The final run waited for the Home content to render.

`flutter analyze`: PASS. `flutter build web --release`: PASS.

### Hold-to-activate progress fill (SOS screen) — observed FAIL, not fixed

Tested in a real, non-headless Chrome window (`/sos`, 1672×941): pressing and holding "Hold to Activate SOS" for 1.0 s and
1.4 s shows **no progress fill** (`docs/qa-screenshots/interaction/L_sos_holding_headful_1_4s.png`), although a full 2 s hold
does open the DEMO dialog and an early release does not. Probable cause (from reading the code, not yet verified by a fix):
the fill is a child-less `ColoredBox` inside a `FractionallySizedBox` with no `heightFactor`, so it is laid out with zero
height; setting `heightFactor: 1` would be the likely one-line fix in `lib/core/widgets/hold_to_activate_button.dart`.
Outside the approved scope of this fix, so left unchanged pending approval.

### Updated verdict

Home 320 px overflow: **fixed and verified**. Phase 4 therefore has no open overflow defect. One cosmetic/functional-feedback
defect remains (hold fill invisible) plus the cosmetic Figma differences listed above.
