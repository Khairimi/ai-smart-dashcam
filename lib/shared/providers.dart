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

/// Trip currently shared (Figma shows the shared state).
final tripSharingProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(true));

/// Drowsiness alert overlay on the cabin camera. Triggered manually through a
/// SIMULATED control — there is no real detection.
final drowsinessAlertProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(false));
