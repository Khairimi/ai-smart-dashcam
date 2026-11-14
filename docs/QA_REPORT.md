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
