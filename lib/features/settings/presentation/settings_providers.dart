import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/in_memory_store.dart';
import '../../../core/storage/key_value_store.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

/// The storage in use. `main()` overrides it with the real `shared_preferences`
/// store; the default (and the fallback when storage cannot be opened) is a
/// non-persistent in-memory store.
final keyValueStoreProvider = Provider<KeyValueStore>((ref) => InMemoryStore());

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(keyValueStoreProvider)),
);

/// Result of reading storage once at startup.
final settingsLoadResultProvider = Provider<SettingsLoadResult>(
  (ref) => ref.watch(settingsRepositoryProvider).load(),
);

/// Health of settings storage, for diagnostics (no UI is added for it).
enum SettingsStorageStatus {
  /// Persisted and healthy.
  ok,

  /// First launch: defaults in use, nothing stored yet.
  firstRun,

  /// Stored data was invalid or from a newer version: defaults (or the valid
  /// parts) are in use.
  recovered,

  /// Reading storage failed: defaults in use.
  readFailed,

  /// The last save failed: changes are kept only until the app closes.
  writeFailed,

  /// Storage is unavailable: settings last for this session only.
  memoryOnly,
}

class SettingsStorageStatusNotifier extends Notifier<SettingsStorageStatus> {
  @override
  SettingsStorageStatus build() {
    if (!ref.watch(keyValueStoreProvider).isPersistent) {
      return SettingsStorageStatus.memoryOnly;
    }
    return switch (ref.watch(settingsLoadResultProvider).status) {
      SettingsLoadStatus.ok => SettingsStorageStatus.ok,
      SettingsLoadStatus.firstRun => SettingsStorageStatus.firstRun,
      SettingsLoadStatus.invalidData ||
      SettingsLoadStatus.unsupportedVersion =>
        SettingsStorageStatus.recovered,
      SettingsLoadStatus.readFailed => SettingsStorageStatus.readFailed,
    };
  }

  void saveSucceeded() {
    if (state == SettingsStorageStatus.writeFailed) {
      state = SettingsStorageStatus.ok;
    } else if (state == SettingsStorageStatus.firstRun ||
        state == SettingsStorageStatus.recovered ||
        state == SettingsStorageStatus.readFailed) {
      // The stored document now matches the in-memory settings.
      state = SettingsStorageStatus.ok;
    }
  }

  void saveFailed() => state = SettingsStorageStatus.writeFailed;
}

final settingsStorageStatusProvider =
    NotifierProvider<SettingsStorageStatusNotifier, SettingsStorageStatus>(
  SettingsStorageStatusNotifier.new,
);

/// Current settings. Changes update the UI immediately and are saved in the
/// background; saves are serialised so the last change always wins.
class SettingsNotifier extends Notifier<AppSettings> {
  Future<void> _queue = Future<void>.value();

  @override
  AppSettings build() => ref.watch(settingsLoadResultProvider).settings;

  /// Sets one setting. Completes when the save has finished (or failed).
  Future<void> set(Setting setting, bool value) {
    if (state[setting] == value) return _queue;
    state = state.copyWith(setting, value);
    return _enqueueSave();
  }

  /// Restores defaults and saves them.
  Future<void> resetToDefaults() {
    state = AppSettings.defaults();
    return _enqueueSave();
  }

  Future<void> _enqueueSave() {
    _queue = _queue.then((_) async {
      if (!ref.mounted) return;
      final ok = await ref.read(settingsRepositoryProvider).save(state);
      if (!ref.mounted) return;
      final status = ref.read(settingsStorageStatusProvider.notifier);
      if (ok) {
        status.saveSucceeded();
      } else {
        debugPrint('Settings could not be saved; kept in memory only.');
        status.saveFailed();
      }
    });
    return _queue;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
