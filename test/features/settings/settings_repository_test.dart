import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/core/storage/key_value_store.dart';
import 'package:ai_smart_dashcam/core/storage/storage_keys.dart';
import 'package:ai_smart_dashcam/features/settings/data/settings_repository.dart';
import 'package:ai_smart_dashcam/features/settings/domain/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStore extends Mock implements KeyValueStore {}

void main() {
  test('first run: defaults and firstRun status', () {
    final r = SettingsRepository(InMemoryStore()).load();
    expect(r.status, SettingsLoadStatus.firstRun);
    expect(r.settings, AppSettings.defaults());
  });

  test('save then load round-trips through the store', () async {
    final store = InMemoryStore();
    final repo = SettingsRepository(store);
    final s = AppSettings.defaults().copyWith(Setting.audioVoice, false);
    expect(await repo.save(s), isTrue);
    expect(store.getString(StorageKeys.settings), isNotNull);

    final r = repo.load();
    expect(r.status, SettingsLoadStatus.ok);
    expect(r.settings, s);
  });

  test('corrupt stored data is recovered with defaults (no exception)', () {
    final store = InMemoryStore({StorageKeys.settings: 'garbage{{'});
    final r = SettingsRepository(store).load();
    expect(r.status, SettingsLoadStatus.invalidData);
    expect(r.settings, AppSettings.defaults());
  });

  test('a storage read that throws -> defaults with readFailed', () {
    final store = MockStore();
    when(() => store.getString(any())).thenThrow(StateError('boom'));
    final r = SettingsRepository(store).load();
    expect(r.status, SettingsLoadStatus.readFailed);
    expect(r.settings, AppSettings.defaults());
  });

  test('a storage write that throws -> save returns false, never throws',
      () async {
    final store = MockStore();
    when(() => store.setString(any(), any())).thenThrow(StateError('quota'));
    expect(await SettingsRepository(store).save(AppSettings.defaults()), isFalse);
  });

  test('an asynchronously failing write -> save returns false', () async {
    final store = MockStore();
    when(() => store.setString(any(), any()))
        .thenAnswer((_) => Future<void>.error(StateError('quota')));
    expect(await SettingsRepository(store).save(AppSettings.defaults()), isFalse);
  });

  test('clear removes the stored document; failure returns false', () async {
    final store = InMemoryStore({StorageKeys.settings: '{}'});
    expect(await SettingsRepository(store).clear(), isTrue);
    expect(store.getString(StorageKeys.settings), isNull);

    final bad = MockStore();
    when(() => bad.remove(any())).thenThrow(StateError('x'));
    expect(await SettingsRepository(bad).clear(), isFalse);
  });

  test('only the settings key is written', () async {
    final store = InMemoryStore();
    await SettingsRepository(store).save(AppSettings.defaults());
    expect(store.keys, {StorageKeys.settings});
  });
}
