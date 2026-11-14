import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/layout.dart';
import '../features/ai/ai_assistant_screen.dart';
import '../features/ai/rest_stop_screen.dart';
import '../features/camera/cabin_camera_screen.dart';
import '../features/camera/front_camera_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/hub/audio/audio_music_screen.dart';
import '../features/hub/smart_hub_screen.dart';
import '../features/records/records_alerts_screen.dart';
import '../features/safety/parking_security_screen.dart';
import '../features/sos/accident_alert_screen.dart';
import '../features/sos/manual_sos_screen.dart';
import '../features/sos/voice_sos_screen.dart';
import '../features/trips/trip_sharing_screen.dart';
import 'adaptive_screen.dart';
import 'design_gallery.dart';
import 'shells.dart';

const _cabinWip =
    'The Figma frame "03 • AI Cabin Monitoring" is unfinished (empty rows).';
const _audioWip =
    'The mobile Audio & Music frame (48-8522) is unfinished (empty rows).';
const _notCaptured =
    'This Figma frame was not fully captured yet, so it is not implemented.';

/// Initial route depends on viewport width (decided once at startup).
String _entryRoute() {
  final views = ui.PlatformDispatcher.instance.views;
  if (views.isEmpty) return '/camera/front';
  final v = views.first;
  return v.physicalSize.width / v.devicePixelRatio < kMobileBreakpoint
      ? '/home'
      : '/camera/front';
}

GoRoute _r(String path, Widget Function() build) => GoRoute(
      path: path,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: build()),
    );

GoRouter buildRouter({String? initialLocation}) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', redirect: (context, state) => _entryRoute()),
        // Development-only component gallery (not linked from the UI).
        GoRoute(
            path: '/dev/gallery', builder: (context, state) => const DesignGallery()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              AdaptiveShell(navigationShell: shell, path: state.uri.path),
          branches: [
            // Tab 0 — Home
            StatefulShellBranch(routes: [
              _r('/home', () => const AdaptiveScreen(
                    title: 'Home',
                    mobile: HomeDashboardScreen(),
                  )),
              _r('/camera/front', () => const AdaptiveScreen(
                    title: 'Dashcam – Front Camera',
                    landscape: FrontCameraScreen(),
                  )),
              _r('/camera/cabin', () => const AdaptiveScreen(
                    title: 'Dashcam – Cabin Camera',
                    landscape: CabinCameraScreen(),
                  )),
            ]),
            // Tab 1 — Safety
            StatefulShellBranch(routes: [
              _r('/safety/parking', () => const ParkingSecurityScreen()),
              _r('/safety/cabin', () => const AdaptiveScreen(
                    title: 'AI Cabin Monitoring',
                    mobileReason: _cabinWip,
                  )),
              _r('/sos', () => const AdaptiveScreen(
                    title: 'Manual SOS / Guardian Mode',
                    landscape: ManualSosScreen(),
                    mobileReason: _notCaptured,
                  )),
              _r('/sos/voice', () => const AdaptiveScreen(
                    title: 'Voice SOS',
                    landscape: VoiceSosScreen(),
                    mobileReason: _notCaptured,
                  )),
            ]),
            // Tab 2 — Records
            StatefulShellBranch(routes: [
              _r('/records', () => const RecordsScreen()),
              _r('/sos/accident', () => const AdaptiveScreen(
                    title: 'Accident SOS Alert',
                    mobile: AccidentAlertScreen(),
                  )),
              _r('/hub', () => const AdaptiveScreen(
                    title: 'Smart Hub',
                    landscape: SmartHubScreen(),
                  )),
              _r('/hub/audio', () => const AdaptiveScreen(
                    title: 'Audio & Music',
                    landscape: AudioMusicScreen(),
                    mobileReason: _audioWip,
                  )),
            ]),
            // Tab 3 — Trips
            StatefulShellBranch(routes: [
              _r('/trips/find-car', () => const AdaptiveScreen(
                    title: 'Find My Car',
                    mobileReason: _notCaptured,
                    landscapeReason: _notCaptured,
                  )),
              _r('/trips/find-car/saved', () => const AdaptiveScreen(
                    title: 'Saved Parking',
                    mobileReason: _notCaptured,
                    landscapeReason: _notCaptured,
                  )),
              _r('/trips/share', () => const AdaptiveScreen(
                    title: 'Trip Sharing',
                    landscape: TripSharingScreen(),
                    mobileReason: _notCaptured,
                  )),
            ]),
            // Tab 4 — Nexio AI
            StatefulShellBranch(routes: [
              _r('/ai', () => const AiAssistantScreen()),
              _r('/ai/rest-stop', () => const AdaptiveScreen(
                    title: 'Nearby Rest Stop',
                    landscape: RestStopScreen(),
                  )),
            ]),
          ],
        ),
      ],
    );

final GoRouter appRouter = buildRouter();
