/// Source of dashcam status. The only implementation shipped is simulated
/// (see shared/simulated). Real hardware is not integrated.
abstract interface class DashcamDevice {
  /// Elapsed recording time, emitted as it changes.
  Stream<Duration> recordingElapsed();
}
