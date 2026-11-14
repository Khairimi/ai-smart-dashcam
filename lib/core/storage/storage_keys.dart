/// Every key the app may write to local storage. Keys are versioned
/// (`dashcam.v1.`) and the `shared_preferences` adapter only accepts keys in
/// [all] (an allow-list), so nothing else can be stored by accident.
abstract final class StorageKeys {
  static const String settings = 'dashcam.v1.settings';

  /// Add new keys here when a later phase stores a new collection.
  static const Set<String> all = {settings};
}
