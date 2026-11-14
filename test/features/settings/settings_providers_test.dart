import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/core/storage/key_value_store.dart';
import 'package:ai_smart_dashcam/core/storage/storage_keys.dart';
import 'package:ai_smart_dashcam/features/settings/domain/app_settings.dart';
import 'package:ai_smart_dashcam/features/settings/presentation/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/app_harness.dart' show PersistentFakeStore;

class MockStore extends Mock implements KeyValueStore {}

ProviderContainer containerFor(KeyValueStore store) {
  final c = ProviderContainer(
      overrides: [keyValueStoreProvider.overrideWithValue(store)]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('default values on a fresh persistent store', () {
    final c = containerFor(PersistentFakeStore());
    expect(c.read(settingsProvider), AppSettings.defaults());
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.firstRun);
  });

  test('the default store (nothing overridden) is in-memory: status memoryOnly',
      () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(settingsProvider), AppSettings.defaults());
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.memoryOnly);
  });

  test('a change is saved and survives an app restart (new container, same store)',
      () async {
    final store = PersistentFakeStore();
    final first = containerFor(store);
    await first.read(settingsProvider.notifier).set(Setting.parkingMotion, false);
    await first.read(settingsProvider.notifier).set(Setting.sosDiscreetMode, true);
    expect(first.read(settingsStorageStatusProvider), SettingsStorageStatus.ok);

    final restarted = containerFor(store);
    final s = restarted.read(settingsProvider);
    expect(s[Setting.parkingMotion], isFalse);
    expect(s[Setting.sosDiscreetMode], isTrue);
    expect(s[Setting.parkingImpact], isTrue);
    expect(restarted.read(settingsStorageStatusProvider), SettingsStorageStatus.ok);
  });

  test('setting the same value again does not write', () async {
    final store = MockStore();
    when(() => store.isPersistent).thenReturn(true);
    when(() => store.getString(any())).thenReturn(null);
    when(() => store.setString(any(), any())).thenAnswer((_) async {});
    final c = containerFor(store);
    await c.read(settingsProvider.notifier).set(Setting.audioSystem, true);
    verifyNever(() => store.setString(any(), any()));
  });

  test('rapid changes: the last one wins in storage', () async {
    final store = PersistentFakeStore();
    final c = containerFor(store);
    final n = c.read(settingsProvider.notifier);
    final f1 = n.set(Setting.audioCabin, false);
    final f2 = n.set(Setting.audioCabin, true);
    final f3 = n.set(Setting.audioCabin, false);
    await Future.wait([f1, f2, f3]);
    expect(c.read(settingsProvider)[Setting.audioCabin], isFalse);
    final restarted = containerFor(store);
    expect(restarted.read(settingsProvider)[Setting.audioCabin], isFalse);
  });

  test('malformed stored data: app starts with defaults, status recovered, '
      'and a later change repairs the stored document', () async {
    final store = PersistentFakeStore({StorageKeys.settings: 'nope{{'});
    final c = containerFor(store);
    expect(c.read(settingsProvider), AppSettings.defaults());
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.recovered);

    await c.read(settingsProvider.notifier).set(Setting.alertSpeedLimit, false);
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.ok);
    final restarted = containerFor(store);
    expect(restarted.read(settingsProvider)[Setting.alertSpeedLimit], isFalse);
  });

  test('storage that cannot be read: defaults, status readFailed', () {
    final store = MockStore();
    when(() => store.isPersistent).thenReturn(true);
    when(() => store.getString(any())).thenThrow(StateError('blocked'));
    final c = containerFor(store);
    expect(c.read(settingsProvider), AppSettings.defaults());
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.readFailed);
  });

  test('a failing write keeps the change in memory and reports writeFailed; '
      'a later successful write recovers', () async {
    final store = MockStore();
    when(() => store.isPersistent).thenReturn(true);
    when(() => store.getString(any())).thenReturn(null);
    when(() => store.setString(any(), any()))
        .thenAnswer((_) => Future<void>.error(StateError('quota')));
    final c = containerFor(store);
    final n = c.read(settingsProvider.notifier);

    await n.set(Setting.parkingImpact, false);
    expect(c.read(settingsProvider)[Setting.parkingImpact], isFalse);
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.writeFailed);

    when(() => store.setString(any(), any())).thenAnswer((_) async {});
    await n.set(Setting.parkingImpact, true);
    expect(c.read(settingsStorageStatusProvider), SettingsStorageStatus.ok);
  });

  test('resetToDefaults restores and saves the defaults', () async {
    final store = PersistentFakeStore();
    final c = containerFor(store);
    final n = c.read(settingsProvider.notifier);
    await n.set(Setting.audioVoice, false);
    await n.resetToDefaults();
    expect(c.read(settingsProvider), AppSettings.defaults());
    expect(containerFor(store).read(settingsProvider), AppSettings.defaults());
  });

  test('disposing the container while a save is pending does not throw',
      () async {
    final store = InMemoryStore();
    final c = ProviderContainer(
        overrides: [keyValueStoreProvider.overrideWithValue(store)]);
    final f = c.read(settingsProvider.notifier).set(Setting.audioSystem, false);
    c.dispose();
    await f;
  });
}
