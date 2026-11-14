import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/core/storage/key_value_store.dart';
import 'package:ai_smart_dashcam/core/storage/storage_keys.dart';
import 'package:ai_smart_dashcam/features/settings/domain/app_settings.dart';
import 'package:ai_smart_dashcam/features/settings/presentation/settings_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/app_harness.dart';

class MockStore extends Mock implements KeyValueStore {}

void main() {
  group('defaults (fresh install)', () {
    testWidgets('Audio & Music shows its four "On" chips', (tester) async {
      await pumpApp(tester, '/hub/audio', landscapeSize, store: PersistentFakeStore());
      expect(find.text('On'), findsNWidgets(4));
      expect(find.text('Off'), findsNothing);
    });

    testWidgets('Manual SOS: Discreet Mode starts off', (tester) async {
      await pumpApp(tester, '/sos', landscapeSize, store: PersistentFakeStore());
      expect(find.text('Discreet Mode'), findsOneWidget);
      expect(find.text('Discreet Mode: On'), findsNothing);
    });
  });

  group('persistence across restart', () {
    testWidgets('a parking toggle stays off after closing and reopening the app',
        (tester) async {
      final store = PersistentFakeStore();
      await pumpApp(tester, '/safety/parking', landscapeSize, store: store);
      expect(find.text('On'), findsNWidgets(3));

      await tester.tap(find.text('On').first);
      await tester.pumpAndSettle();
      expect(find.text('Off'), findsOneWidget);

      await closeApp(tester);
      await pumpApp(tester, '/safety/parking', landscapeSize, store: store);
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('On'), findsNWidgets(2));
    });

    testWidgets('stored settings are applied on launch (audio + SOS)',
        (tester) async {
      final store = PersistentFakeStore({
        StorageKeys.settings: AppSettingsCodec.encode(AppSettings.defaults()
            .copyWith(Setting.audioSystem, false)
            .copyWith(Setting.sosDiscreetMode, true)),
      });
      await pumpApp(tester, '/hub/audio', landscapeSize, store: store);
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('On'), findsNWidgets(3));

      await closeApp(tester);
      await pumpApp(tester, '/sos', landscapeSize, store: store);
      expect(find.text('Discreet Mode: On'), findsOneWidget);
    });

    testWidgets('Discreet Mode is saved when toggled', (tester) async {
      final store = PersistentFakeStore();
      await pumpApp(tester, '/sos', landscapeSize, store: store);
      await tester.tap(find.text('Discreet Mode'));
      await tester.pumpAndSettle();
      expect(find.text('Discreet Mode: On'), findsOneWidget);

      await closeApp(tester);
      await pumpApp(tester, '/sos', landscapeSize, store: store);
      expect(find.text('Discreet Mode: On'), findsOneWidget);
    });

    testWidgets('mobile AI Rest Break Reminder persists', (tester) async {
      final store = PersistentFakeStore();
      await pumpApp(tester, '/ai', phoneSize, store: store);
      await tester.ensureVisible(find.text('On'));
      await tester.tap(find.text('On'));
      await tester.pumpAndSettle();
      expect(find.text('Off'), findsOneWidget);

      await closeApp(tester);
      await pumpApp(tester, '/ai', phoneSize, store: store);
      await tester.ensureVisible(find.text('Off'));
      expect(find.text('Off'), findsOneWidget);
    });
  });

  group('Parking Guardian indicator (decision D2)', () {
    testWidgets('landscape: Off when all three toggles are off, On when any is on',
        (tester) async {
      await pumpApp(tester, '/safety/parking', landscapeSize, store: PersistentFakeStore());
      expect(find.text('Parking Guardian On'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('On').first);
        await tester.pumpAndSettle();
      }
      expect(find.text('Parking Guardian Off'), findsOneWidget);
      expect(find.text('Parking Guardian On'), findsNothing);

      await tester.tap(find.text('Off').first);
      await tester.pumpAndSettle();
      expect(find.text('Parking Guardian On'), findsOneWidget);
    });

    testWidgets('mobile: subtitle becomes "Parking Guardian Off" only when all are off',
        (tester) async {
      await pumpApp(tester, '/safety/parking', phoneSize, store: PersistentFakeStore());
      expect(find.text('Monitoring your vehicle'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('On').first);
        await tester.pumpAndSettle();
      }
      expect(find.text('Parking Guardian Off'), findsOneWidget);
      expect(find.text('Monitoring your vehicle'), findsNothing);
    });

    testWidgets('banner reflects stored settings on launch', (tester) async {
      final allOff = AppSettings.defaults()
          .copyWith(Setting.parkingMotion, false)
          .copyWith(Setting.parkingImpact, false)
          .copyWith(Setting.parkingAuto, false);
      await pumpApp(tester, '/safety/parking', landscapeSize,
          store: PersistentFakeStore(
              {StorageKeys.settings: AppSettingsCodec.encode(allOff)}));
      expect(find.text('Parking Guardian Off'), findsOneWidget);
    });
  });

  group('bad storage', () {
    testWidgets('malformed stored data: app opens with defaults and keeps working',
        (tester) async {
      final store = PersistentFakeStore({StorageKeys.settings: 'not json {{'});
      await pumpApp(tester, '/safety/parking', landscapeSize, store: store);
      expect(find.text('On'), findsNWidgets(3));
      expect(find.text('Parking Guardian On'), findsOneWidget);
      expect(containerOf(tester).read(settingsStorageStatusProvider),
          SettingsStorageStatus.recovered);

      // A change repairs the stored document.
      await tester.tap(find.text('On').first);
      await tester.pumpAndSettle();
      expect(AppSettingsCodec.decode(store.getString(StorageKeys.settings)).status,
          SettingsLoadStatus.ok);
    });

    testWidgets('failing storage: the toggle still works, nothing crashes',
        (tester) async {
      final store = MockStore();
      when(() => store.isPersistent).thenReturn(true);
      when(() => store.getString(any())).thenReturn(null);
      when(() => store.setString(any(), any()))
          .thenAnswer((_) => Future<void>.error(StateError('quota exceeded')));

      await pumpApp(tester, '/safety/parking', landscapeSize, store: store);
      await tester.tap(find.text('On').first);
      await tester.pumpAndSettle();

      expect(find.text('Off'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(containerOf(tester).read(settingsStorageStatusProvider),
          SettingsStorageStatus.writeFailed);
    });

    testWidgets('unreadable storage: app opens with defaults', (tester) async {
      final store = MockStore();
      when(() => store.isPersistent).thenReturn(true);
      when(() => store.getString(any())).thenThrow(StateError('blocked'));
      when(() => store.setString(any(), any())).thenAnswer((_) async {});

      await pumpApp(tester, '/hub/audio', landscapeSize, store: store);
      expect(find.text('On'), findsNWidgets(4));
      expect(containerOf(tester).read(settingsStorageStatusProvider),
          SettingsStorageStatus.readFailed);
    });

    testWidgets('session-only storage (in-memory fallback): works, reports memoryOnly',
        (tester) async {
      // The default provider store is the in-memory fallback used when real
      // storage cannot be opened.
      final store = InMemoryStore();
      await pumpApp(tester, '/safety/parking', landscapeSize, store: store);
      await tester.tap(find.text('On').first);
      await tester.pumpAndSettle();
      expect(find.text('Off'), findsOneWidget);
      expect(containerOf(tester).read(settingsStorageStatusProvider),
          SettingsStorageStatus.memoryOnly);
    });
  });
}
