import '../../core/services/assistant_service.dart';
import '../../core/services/dashcam_device.dart';

/// SIMULATED dashcam. Starts at the Figma sample time 00:12:34 and counts up.
/// Not connected to any hardware.
class SimulatedDashcamDevice implements DashcamDevice {
  const SimulatedDashcamDevice();

  static const Duration start = Duration(minutes: 12, seconds: 34);

  @override
  Stream<Duration> recordingElapsed() async* {
    var t = start;
    yield t;
    yield* Stream.periodic(const Duration(seconds: 1), (_) {
      t += const Duration(seconds: 1);
      return t;
    });
  }
}

/// DEMO assistant: predefined answers chosen by keyword. No AI model is
/// involved and the answers are not based on any real vehicle data.
class SimulatedAssistantService implements AssistantService {
  const SimulatedAssistantService();

  static const _answers = <(List<String>, String)>[
    (
      ['safety alert', 'any alert'],
      'No active safety alerts right now. Today: 1 drowsiness warning at 09:12 AM '
          'and 2 parking events (motion 8:36 PM, impact 8:41 PM).'
    ),
    (
      ['rest stop', 'rest break', 'tired'],
      'The nearest rest stop is RNR Pagoh Selatan, 28.4 km ahead '
          '(ETA 10:18 AM). I suggest a 15-minute break.'
    ),
    (
      ['recording', 'footage', 'clip'],
      'Your latest recording is "Accident Evidence" (00:30), saved to the '
          'Evidence Vault and locked.'
    ),
    (
      ['drive safer', 'safer'],
      'Keep a 3-second gap, stay in your lane and take a break every two hours. '
          'Your last trip scored 92/100 for smooth driving.'
    ),
    (
      ['forward collision'],
      'Forward Collision Warning is ON. It alerts you when the gap to the car '
          'ahead becomes unsafe.'
    ),
    (
      ['lane departure'],
      'Lane Departure Warning is ON. You will be alerted if the car drifts out of '
          'its lane without signalling.'
    ),
    (
      ['speed limit'],
      'Speed Limit Recognition is ON. Current limit: 90 km/h. You are driving at '
          '80 km/h.'
    ),
    (
      ['voice command', 'voice'],
      'Voice Command Control understands: "SOS, help me", "show latest recording" '
          'and "find a rest stop".'
    ),
    (
      ['trip', 'destination'],
      'You are heading to Mid Valley Megamall, ETA 10:18 AM, 28.4 km remaining.'
    ),
    (
      ['parking', 'park', 'car'],
      'Your car is parked at Level B2, Bay A-18 (Mid Valley Megamall).'
    ),
  ];

  @override
  Future<String> reply(String prompt) async {
    final p = prompt.toLowerCase();
    for (final (keys, answer) in _answers) {
      if (keys.any(p.contains)) return answer;
    }
    return 'I can help with safety alerts, rest stops, recordings, parking and '
        'driving tips. Try one of the suggested questions.';
  }
}
