/// Minimal storage abstraction for small, non-sensitive demo data.
///
/// Reads are synchronous (the backing store is loaded before `runApp`);
/// writes are asynchronous and may throw. Implementations: [InMemoryStore]
/// (tests / fallback) and `SharedPrefsStore` (Web + Android + iOS).
///
/// Do not store secrets, real contact details, real GPS coordinates or
/// device identifiers here.
abstract interface class KeyValueStore {
  /// `false` when data will be lost on restart (in-memory fallback).
  bool get isPersistent;

  /// Returns the stored string or `null`. May throw (e.g. a key that is not
  /// allow-listed, or a value of another type).
  String? getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);

  Set<String> get keys;
}
