import '../../../core/storage/key_value_store.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/app_settings.dart';

/// Loads and saves [AppSettings] through a [KeyValueStore]. Never throws:
/// failures are reported through the return values.
class SettingsRepository {
  const SettingsRepository(this._store);

  final KeyValueStore _store;

  SettingsLoadResult load() {
    final String? raw;
    try {
      raw = _store.getString(StorageKeys.settings);
    } catch (_) {
      return SettingsLoadResult(
          AppSettings.defaults(), SettingsLoadStatus.readFailed);
    }
    return AppSettingsCodec.decode(raw);
  }

  /// Returns `false` if the write failed.
  Future<bool> save(AppSettings settings) async {
    try {
      await _store.setString(StorageKeys.settings, AppSettingsCodec.encode(settings));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Removes the stored document. Returns `false` if that failed.
  Future<bool> clear() async {
    try {
      await _store.remove(StorageKeys.settings);
      return true;
    } catch (_) {
      return false;
    }
  }
}
