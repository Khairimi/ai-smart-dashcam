# Screen Mapping — Figma → Routes → Components

Approved 2026-11-14. Screens marked **INCOMPLETE** render the `IncompleteScreen` placeholder until the Figma frame is finished/captured.

Feature classes: **F** fully implementable · **B** backend (Firebase) required · **H** external hardware/AI/API required (shipped as a labelled **SIMULATED** adapter) · **D** demo/mock only.

## Landscape layout (≥ 1024 px wide, landscape) — `InCarShell`

| Figma | Node | Route | Widget (`lib/features/...`) | Classes |
|---|---|---|---|---|
| 01 Front Camera | `48-5606` | `/camera/front` | `camera/front_camera_screen.dart` | H (live feed, REC state) |
| 02 Cabin Camera | `48-5657` | `/camera/cabin` | `camera/cabin_camera_screen.dart` | H |
| 02b Drowsiness alert | `58-6` | overlay on `/camera/cabin` | `camera/widgets/drowsiness_alert_card.dart` | H (AI detection) · F (UI/actions) |
| 03 Trip Sharing | `48-5696` | `/trips/share` | `trips/trip_sharing_screen.dart` | B (shared trip doc) · H (GPS/ETA) |
| 04 Manual SOS / Guardian | `48-5769` | `/sos` | `sos/manual_sos_screen.dart` | F (hold-to-activate, `tel:` calls) · B (contacts) · H (location, clip upload) |
| 05 Voice SOS | `48-5810` | `/sos/voice` | `sos/voice_sos_screen.dart` | H (speech recognition) · F (`tel:` quick actions) |
| 06 Parking & Security | `48-5853` | `/safety/parking` | `safety/parking_security_screen.dart` | B (settings) · H (motion/impact events) |
| 07 Smart Hub | `48-5915` | `/hub` | `hub/smart_hub_screen.dart` | F |
| 08 Audio & Music | `48-5958` | `/hub/audio` | `hub/audio/audio_music_screen.dart` | B (prefs) · D (player, AI recommendation) |
| 09 Records & Safety Alerts | `48-6019` | `/records` | `records/records_alerts_screen.dart` | B (incident log, toggles) · H (ADAS detection) |
| 10 AI Assistant | `48-6070` | `/ai` | `ai/ai_assistant_screen.dart` | H (LLM/voice) — simulated replies |
| 11 Nearby Rest Stop | `48-6159` | `/ai/rest-stop` | `ai/rest_stop_screen.dart` | H (maps/places API) |

Persistent: `InCarHeader` (back, title, `RecIndicator`, profile icon) and `QuickNavBar` (5 tiles).

## Mobile layout (< 768 px, portrait) — `MobileShell` with bottom nav (Home · Safety · Records · Trips · Nexio AI)

| Figma | Node | Route | Widget | Tab | Classes |
|---|---|---|---|---|---|
| 01 Home Dashboard | `4-3` | `/home` | `home/home_dashboard_screen.dart` | Home | H (speed, cabin AI, location) · D |
| 02 Find My Car — **INCOMPLETE** | unresolved | `/trips/find-car` | `trips/find_my_car_screen.dart` | Trips | B (saved spot) · H (GPS, maps) |
| 03 AI Cabin Monitoring — **INCOMPLETE** | `48-8522` (WIP) | `/safety/cabin` | `safety/cabin_monitoring_screen.dart` | Safety | H — **design incomplete** |
| 04 Manual SOS — **INCOMPLETE** | unresolved | `/sos` | shared with landscape | — | as above |
| 05 Voice SOS — **INCOMPLETE** | unresolved | `/sos/voice` | shared | — | as above |
| 06 Saved Parking — **INCOMPLETE** | unresolved | `/trips/find-car/saved` | `trips/saved_parking_screen.dart` | Trips | B |
| 07 Trip Sharing — **INCOMPLETE** | unresolved | `/trips/share` | shared | Trips | as above |
| 08 Accident SOS Alert | `4-378` | `/sos/accident` | `sos/accident_alert_screen.dart` | Records | H (crash detection) · F (call actions) |
| "09" Records & Evidence | `9-4` | `/records` | `records/records_evidence_screen.dart` (mobile variant) | Records | B · H (video storage) |
| "09" Parking & Security | `4-427` | `/safety/parking` | shared (mobile variant) | Safety | as above |
| "09" AI Assistant | `9-356` | `/ai` | shared (mobile variant) | Nexio AI | H |
| Bottom nav | `26-43` | — | `core/widgets/mobile_bottom_nav.dart` | — | F |

Same route serves both layouts; each screen picks its landscape or mobile body via a `LayoutBuilder` breakpoint, so URLs and browser back behave identically on web.

## Gaps needing a decision

- Smart Hub and Audio & Music have no confirmed mobile frame; Front/Cabin camera have no mobile frame; Home has no landscape frame.
- No login, onboarding, settings, or device-pairing screens exist.
