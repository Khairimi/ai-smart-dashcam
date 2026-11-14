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

/// SIMULATED assistant: canned replies, no AI model involved.
class SimulatedAssistantService implements AssistantService {
  const SimulatedAssistantService();

  @override
  Future<String> reply(String prompt) async {
    return 'This is a simulated reply to "$prompt". '
        'Nexio AI is not connected to a real model yet.';
  }
}
