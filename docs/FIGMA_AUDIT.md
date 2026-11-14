# Figma Audit — AI Smart Dashcam

**Source:** `AI Smart Dashcam — 11 Editable Cream UI Screens` (file key `wlJUkksL3vndCwmnLN8Xsk`)
**Audited:** 2026-11-14, view-only access (not signed in), via Figma design and prototype viewers.
**Reference captures:** `docs/figma-reference/*.png` (L = landscape frames, M = mobile frames).

## 1. Access limitations (read first)

| Limitation | Effect | How to resolve |
|---|---|---|
| View-only, signed out — no Inspect / Dev Mode | Colors below are **sampled from screenshots** (±2–4 per channel, JPEG/PNG rendering). Font family, exact font sizes, radii, shadows and spacing are **estimated**, not read. | Sign in to Figma in the browser pane (or grant Dev Mode), or export variables/styles. |
| Mobile layer names don't match content | Several mobile frames are named "09 • …" but show other screens (see §3). | Confirm intended screen per frame. |
| Mobile frame IDs partly unresolved | Frames 02, 04, 05, 06, 07 (mobile) were seen on canvas but their node IDs and full-resolution captures were not obtained. | Re-inspect once signed in. |
| Map image in landscape screen 11 rendered black in the prototype viewer | Map art unverified at full resolution. | Export the image fill. |

## 2. File structure

| Page | Node | Contents |
|---|---|---|
| Page 1 | — | Not inspected (appears empty/unused) |
| **REFERENCE-MATCHED • 11 EDITABLE SCREENS** | `4-2` | **Primary page.** 12 landscape frames + 12 mobile frames + mobile bottom-nav component |
| DASHCAM • SCREENS | `36-2` | Appears to duplicate the landscape frames (02, 04, 06, 08, 10, 11 visible). Treated as non-authoritative. |

## 3. Frame inventory

### 3a. Landscape frames — in-car display / desktop & tablet (frame size **1672 × 941**, drawn inside a black device bezel)

| # | Frame name | Node ID | Capture | Key content |
|---|---|---|---|---|
| 01 | Dashcam – Front Camera | `48-5606` | L01 | Header (back, title, REC 00:12:34 pill, cloud/profile icon); live front-camera view with timestamp pill + "FRONT CAMERA" label; quick-nav row |
| 02 | Dashcam – Cabin Camera | `48-5657` | L02 | Same layout, cabin feed, "CABIN CAMERA" label |
| 02b | Dashcam – Cabin Camera (alert state) | `58-6` | L02b | Overlay card "Driver Drowsiness Detected" — *Find Nearest Rest Stop* (green) / *Ignore* |
| 03 | Trip Sharing | `48-5696` | L03 | Feed + side panel: "Trip Currently Shared" chip, Destination (Mid Valley Megamall), ETA 10:18 AM / 28.4 km, Receiving Contacts (Family • Guardian); Start / Stop Sharing / Share Link |
| 04 | Manual SOS / Guardian Mode | `48-5769` | L04 | Red "Emergency SOS" banner + *Hold to Activate SOS*; Current Location (Highway A1, Km 120.5); Emergency Contacts (Dad, Sister); Discreet Mode / Call Ambulance / Call Police / Call Emergency Contact |
| 05 | Voice SOS | `48-5810` | L05 | Mic circle, "Say the command", "SOS, help me", Listening… / Command Recognized chips; Quick Emergency Actions: Call 999, Call Family, Call Spouse, Send SOS |
| 06 | Parking & Vehicle Security | `48-5853` | L06 | "Parking Mode Active" banner; Smart Parking Guardian toggles (Motion, Impact, Auto Recording); Recent Alerts (Motion, Impact Detected) |
| 07 | Smart Hub | `48-5915` | L07 | 3 cards → Audio & Music, Records & Safety Alerts, Nexio AI |
| 08 | Audio & Music | `48-5958` | L08 | Settings rows (System Audio On, Alert Sound Standard, Voice Guidance On, In-Cabin Music On); "Calming Music – AI Recommended" player (prev/play/next, Volume 70%); Music Preference (AI Suggestion) On |
| 09 | Records & Safety Alerts | `48-6019` | L09 | Smart Incident Evidence Vault; Road Incident Report Log; Road Safety Alerts toggles (Forward Collision, Lane Departure, Speed Limit Recognition) |
| 10 | AI Assistant (title "Nexio AI") | `48-6070` | L10 | "How can I help?" + message input with Listening…; Suggested Questions (4); Road Safety Assistance list (5 items) |
| 11 | AI Assistant – Nearby Rest Stop | `48-6159` | L11 | Map, "Sharing Live" chip, Destination RNR Pagoh Selatan, ETA 10:18 AM, Distance 28.4 km |

The brief's "11 screens" = landscape frames 01–11; 02b is an alert state of 02.

**Shared landscape chrome:** header row + persistent 5-tile quick-nav at the bottom: Front Camera · Cabin Camera · Trip Sharing · Smart Hub (green tint) · SOS (solid red).

### 3b. Mobile frames — phone portrait (iPhone-class with status bar and dynamic island; exact size not confirmed)

| Layer name in Figma | Node ID | Actual content | Capture | Status |
|---|---|---|---|---|
| 01 • Home Dashboard | `4-3` | NEXIO home: Dashcam Connected / Recording On; Current Speed 80 km/h, Trip Duration 00:24:18, Passengers 4; Live Location mini-map; AI Cabin Monitoring (Drowsiness Normal, Distraction Focused, Emotion Calm, Seatbelt Fastened); Quick Actions (Manual SOS, Voice SOS, Find My Car, Trip Sharing) | M01 | ✅ |
| 02 • Find My Car | unresolved | Find My Car map; Saved Parking Level B2 • Bay A-18, Parked For 02:24:18; Walking Route (3 min, 220 m); *Navigate* | partial (canvas) | ⚠️ partial |
| 03 • AI Cabin Monitoring (×2) | `48-8522` + unresolved | `48-8522` contains an **unfinished** "Audio & Music Settings" screen (two empty rows with On toggles) | M_wip_audio | ⚠️ WIP |
| 04 • Manual SOS / Guardian Mode | unresolved | not captured | — | ❌ |
| 05 • Voice SOS | unresolved | header "Voice SOS" seen only | — | ❌ |
| 06 • Find My Car • Saved Parking | unresolved | not captured | — | ❌ |
| 07 • Trip Sharing | unresolved | not captured | — | ❌ |
| 08 • Accident SOS Alert | `4-378` | Accident Detected 09:17 AM • Live Event; clip preview 00:30; Current Location (Jalan Universiti, Skudai, Johor); Emergency Contacts Notified; Call Ambulance / Police / Driver; Records & Evidence link | M08 | ✅ |
| 09 • Accident SOS Alert | `9-4` | **Records & Evidence**: Protected Recordings (Evidence Vault, Incident Report Log); Recent Recordings (Accident Evidence 00:30, Hit-and-Run 00:24, Cabin Monitoring 01:15) | M_canvas_records | ✅ (name mismatch) |
| 09 • Parking & Vehicle Security | `4-427` | Parking Mode Active; Smart Parking Guardian toggles; Recent Alerts; Hit-and-Run Evidence Capture; Stolen Vehicle Tracking | M09 | ✅ |
| 09 • Parking & Vehicle Security | `9-356` | **AI Assistant**: How can I help? + input; Road Safety Assistance (5 items) + AI Rest Break Reminder On | M_ai_assistant | ✅ (name mismatch) |
| Group 1 | `26-43` | Bottom nav component, **378 × 64**: Home · Safety · Records · Trips · Nexio Ai (active tab = blue-grey pill) | M_nav_bar | ✅ |

## 4. Design tokens (sampled — approximate)

| Token | Hex (sampled) | Used for |
|---|---|---|
| `bg.cream` | `#FAF1E8` (mobile `#F9F0E7`) | Screen background |
| `surface.card` | `#FFF7F2` (mobile `#FEF9F3`) | Cards, quick-nav tiles, list rows |
| `border.card` | ~`#F1E3D8` (estimated) | 1 px card outline |
| `text.primary` | ~`#3B302A` (estimated, dark warm brown) | Titles |
| `text.secondary` | ~`#7A6E66` (estimated) | Subtitles, captions |
| `red.sos` | `#E45149` | SOS tile, emergency banner, REC dot (`#EA6659`) |
| `red.tint` | `#FDE4DF` | REC pill, date pill, alert cards |
| `red.sosButton` | `#E3968C` approx | "Hold to Activate SOS" button on red banner |
| `green.tint` | `#E6F2DE` | Smart Hub tile, Parking banner, mic circle, chips |
| `green.accent` | `#4E9049` | Chip text, "Find Nearest Rest Stop" button (~`#5A9A5E`) |
| `green.toggleBg` | `#D9EBD5` approx | "On" pills |
| `blue.tint` | `#E7EEF6` | Records icon circle, Evidence Vault card, icon boxes |
| `blue.slate` | `#4A6E86` – `#507999` | Icons, location link text, active nav pill (`#BBC9D4` tint), Navigate button |
| `purple.tint` | `#E9E4F8` | Audio icon circle, AI avatar |
| `scene.sky/trees/road` | `#B2C8D5` / `#6D8E59` / `#7E828B` | Illustrated camera placeholders |

**Typography (estimated):** geometric/neo-grotesque sans (Inter-like). Hierarchy: screen title ≈ 20–22 px semibold; card titles ≈ 15–18 px semibold; body/captions ≈ 11–13 px regular. **Font family must be confirmed in Inspect.**

**Shape:** cards ≈ 16–20 px radius; pills fully rounded; quick-nav tiles ≈ 14 px radius; very soft or no shadows, 1 px warm outline instead.

**Icons:** simple line glyphs (several rendered as Unicode text glyphs in the file: ▣ ◉ ⌁ ▦ ✆ ♫). Mobile nav uses outline icons (house, car+shield, mic/record, map, sparkles). Plan: map to a single outline icon set (e.g. Lucide) unless SVG exports are provided.

**Images/illustrations:** camera feeds, car thumbnails, faces and maps are flat vector placeholders — not real imagery.

## 5. Navigation & interactions observed

- Prototype links exist only between a few frames (Right-arrow cycled 01 → 02 → 02b → 03 in landscape; 4-3 ↔ 4-378 on mobile). Most navigation is implied, not wired.
- Landscape: quick-nav tiles → 01, 02, 03, 07, 04; Smart Hub cards → 08, 09, 10; Drowsiness alert → 11 (rest stop).
- Mobile: bottom nav tabs; Home Quick Actions → Manual SOS, Voice SOS, Find My Car, Trip Sharing; Accident SOS → Records & Evidence.
- Not in the design: login/sign-up, onboarding, settings/profile, device pairing, loading/empty/error states.

## 6. Responsive intent

Two distinct layouts exist: a **landscape in-car display** (1672 × 941) and a **phone portrait** app. There are no tablet-portrait or intermediate frames; those breakpoints will be derived.
