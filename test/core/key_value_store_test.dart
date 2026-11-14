import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/core/storage/shared_prefs_store.dart';
import 'package:ai_smart_dashcam/core/storage/storage_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  group('InMemoryStore', () {
    test('stores, reads and removes strings; is not persistent', () async {
      final s = InMemoryStore({'a': '1'});
      expect(s.isPersistent, isFalse);
      expect(s.getString('a'), '1');
      expect(s.getString('missing'), isNull);
      await s.setString('b', '2');
      expect(s.keys, {'a', 'b'});
      await s.remove('a');
      expect(s.getString('a'), isNull);
    });
  });

  group('SharedPrefsStore (shared_preferences adapter)', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('is persistent and round-trips a value', () async {
      final s = await SharedPrefsStore.open();
      expect(s.isPersistent, isTrue);
      expect(s.getString(StorageKeys.settings), isNull);
      await s.setString(StorageKeys.settings, '{"v":1}');
      expect(s.getString(StorageKeys.settings), '{"v":1}');
      expect(s.keys, {StorageKeys.settings});
    });

    test('a value written by one store is read by a newly opened store (restart)',
        () async {
      final first = await SharedPrefsStore.open();
      await first.setString(StorageKeys.settings, 'hello');
      final second = await SharedPrefsStore.open();
      expect(second.getString(StorageKeys.settings), 'hello');
    });

    test('remove deletes the value', () async {
      final s = await SharedPrefsStore.open();
      await s.setString(StorageKeys.settings, 'x');
      await s.remove(StorageKeys.settings);
      expect(s.getString(StorageKeys.settings), isNull);
    });

    test('keys outside the allow-list are rejected (nothing else can be stored)',
        () async {
      final s = await SharedPrefsStore.open();
      expect(() => s.getString('somebody.else'), throwsArgumentError);
      await expectLater(s.setString('somebody.else', 'x'), throwsArgumentError);
    });
  });
}
