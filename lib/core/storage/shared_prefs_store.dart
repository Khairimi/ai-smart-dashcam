import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';
import 'storage_keys.dart';

/// [KeyValueStore] backed by `shared_preferences` (Web localStorage, Android
/// SharedPreferences, iOS NSUserDefaults). Only keys in [StorageKeys.all] are
/// accepted; any other key throws an [ArgumentError].
class SharedPrefsStore implements KeyValueStore {
  SharedPrefsStore(this._prefs);

  final SharedPreferencesWithCache _prefs;

  /// Opens storage and loads its cache. Throws if storage is unavailable —
  /// the caller falls back to `InMemoryStore`.
  static Future<SharedPrefsStore> open() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: StorageKeys.all),
    );
    return SharedPrefsStore(prefs);
  }

  @override
  bool get isPersistent => true;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (_) {
      // The package updates its cache before the platform write; if the write
      // fails, re-sync the cache with what is really stored, then report.
      try {
        await _prefs.reloadCache();
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Set<String> get keys => _prefs.keys;
}
