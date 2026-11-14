import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/assistant_service.dart';
import '../core/services/dashcam_device.dart';
import 'simulated/simulated_services.dart';

final dashcamDeviceProvider =
    Provider<DashcamDevice>((ref) => const SimulatedDashcamDevice());

final assistantServiceProvider =
    Provider<AssistantService>((ref) => const SimulatedAssistantService());

/// Recording time shown in the REC pill (SIMULATED).
final recElapsedProvider = StreamProvider<Duration>(
  (ref) => ref.watch(dashcamDeviceProvider).recordingElapsed(),
);

/// Simple local boolean flag.
class FlagNotifier extends Notifier<bool> {
  FlagNotifier(this._initial);
  final bool _initial;

  @override
  bool build() => _initial;

  void set(bool v) => state = v;
}

/// DEMO camera switch. Only changes what the app shows; no camera exists.
final cameraOnProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(true));

/// Index into a short list (alert sound choice, demo track …).
class IndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void step(int length, {int by = 1}) => state = (state + by) % length;
}

const alertSounds = ['Standard', 'Soft', 'Loud'];
final alertSoundProvider =
    NotifierProvider<IndexNotifier, int>(IndexNotifier.new);

const audioTracks = <(String, String)>[
  ('Calming Music – AI Recommended', 'Relaxing Ambient  •  30:00'),
  ('Focus Drive – AI Recommended', 'Soft Instrumental  •  28:30'),
  ('Night Highway – AI Recommended', 'Lo-fi Chill  •  35:10'),
];
final audioTrackProvider =
    NotifierProvider<IndexNotifier, int>(IndexNotifier.new);

/// Trip currently shared (Figma shows the shared state).
final tripSharingProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(true));

/// Drowsiness alert overlay on the cabin camera. Triggered manually through a
/// SIMULATED control — there is no real detection.
final drowsinessAlertProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(false));
