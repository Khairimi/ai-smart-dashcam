import 'key_value_store.dart';

/// Non-persistent [KeyValueStore]. Used by tests and as the safe fallback when
/// real storage cannot be opened (e.g. blocked in a private browsing window).
class InMemoryStore implements KeyValueStore {
  InMemoryStore([Map<String, String>? initial]) : _data = {...?initial};

  final Map<String, String> _data;

  @override
  bool get isPersistent => false;

  @override
  String? getString(String key) => _data[key];

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;

  @override
  Future<void> remove(String key) async => _data.remove(key);

  @override
  Set<String> get keys => _data.keys.toSet();
}
