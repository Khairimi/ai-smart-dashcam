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

/// Default values of every local toggle (keys are used across screens).
const Map<String, bool> kDefaultToggles = {
  'parking.motion': true,
  'parking.impact': true,
  'parking.auto': true,
  'audio.system': true,
  'audio.voice': true,
  'audio.cabin': true,
  'audio.aiPref': true,
  'alerts.fcw': true,
  'alerts.ldw': true,
  'alerts.sls': true,
  'ai.restBreak': true,
};

/// Local (in-memory) toggle state. Not persisted yet.
class TogglesNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => kDefaultToggles;

  void set(String key, bool value) => state = {...state, key: value};
}

final togglesProvider =
    NotifierProvider<TogglesNotifier, Map<String, bool>>(TogglesNotifier.new);

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

/// Discreet mode on Manual SOS.
final discreetModeProvider =
    NotifierProvider<FlagNotifier, bool>(() => FlagNotifier(false));
