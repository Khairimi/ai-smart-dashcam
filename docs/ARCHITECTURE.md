# Architecture (approved 2026-11-14)

## Recommendation: keep Flutter (single codebase)

Nothing in the Figma file argues for Next.js. The design is an app UI — a landscape in-car display plus a phone app — not a content website. Android and iOS are core targets, and Flutter Web covers the Vercel demo. **No architecture change is proposed.**

## Stack

| Concern | Choice | Why |
|---|---|---|
| UI | Flutter 3.x stable, Material 3 **with a fully custom cream theme** | Gives one codebase across web, Android and iOS; no stock Material look |
| Routing | `go_router` with `StatefulShellRoute` | Supports deep links, web refresh on nested routes and browser back |
| State | `flutter_riverpod` | Testable, and lets real and simulated adapters swap behind interfaces |
| Backend | Firebase Auth, Cloud Firestore, Storage (behind repositories) | Matches the brief; only used where a feature needs it |
| Calls | `url_launcher` (`tel:`) | SOS call buttons can work for real on mobile |
| Maps | Placeholder vector map → `google_maps_flutter` / `flutter_map` later | Needs an API key decision |
| Fonts | Bundled (family TBC from Inspect; Inter likely) | Offline in-car use |

## Layering (feature-first)

```
lib/
  app/            app.dart, router.dart, shells (InCarShell, MobileShell)
  core/theme/     AppColors, AppTypography, AppRadii, AppSpacing, AppTheme
  core/widgets/   CreamCard, StatusPill, ToggleChip, QuickNavBar, MobileBottomNav, RecIndicator, SimulatedBadge
  core/services/  interfaces: DashcamDevice, DetectionEventSource, LocationService, SpeechService, AssistantService
  features/<feature>/{data,domain,presentation}
  shared/simulated/   SIMULATED adapters (each visibly badged in the UI)
```

## Hardware/AI honesty rule

Every value that would come from the dashcam, an AI model or GPS goes through an interface. The only implementation shipped is `Simulated*`, and any screen fed by it shows a small "SIMULATED" badge. No detection result is presented as real.

## Breakpoints

- ≥ 1024 wide and landscape → `InCarShell` (header + 5-tile quick-nav), tuned against 1672 × 941 frames at 1440/1280/1024
- 768–1023 → in-car layout with condensed side panels (derived, no Figma frame)
- < 768 → `MobileShell` (bottom nav), tuned at 430/390/375/320

## Decisions

- Approved: one Flutter codebase, separate adaptive layouts (in-car landscape + mobile).
- Firebase login: **not implemented** for now.
- Unfinished Figma screens: marked **INCOMPLETE** (see `IMPLEMENTATION_PLAN.md`).

## Original open questions (for history)

1. **One app or two?** The landscape frames (quick-nav: cameras/trip/hub/SOS) and the mobile frames (tabs: Home/Safety/Records/Trips/AI) have different navigation models. Proposed: one app with two shells sharing routes, as above.
2. **Toolchain:** Flutter cannot be installed in Claude's sandbox (pub.dev and Google storage are blocked), so code written here can't be compiled or tested here. Verification would have to happen in GitHub Actions or on your machine.
3. **Auth:** No login screen exists in Figma. Should Firebase Auth be added (needs a designed screen), or should the app be anonymous/demo for now?
4. **Mobile gaps:** Frames 02/04/05/06/07 were only partly captured, and one frame (`48-8522`) is unfinished.
