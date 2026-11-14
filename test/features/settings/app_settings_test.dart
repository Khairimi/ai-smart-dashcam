import 'dart:convert';

import 'package:ai_smart_dashcam/features/settings/domain/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

String doc(Map<String, Object?> data, {Object? v = 1}) =>
    jsonEncode({'v': v, 'data': data});

void main() {
  group('defaults', () {
    test('match the values the app showed before persistence existed', () {
      final d = AppSettings.defaults();
      for (final s in Setting.values) {
        expect(d[s], s == Setting.sosDiscreetMode ? isFalse : isTrue,
            reason: s.name);
      }
      expect(Setting.values.length, 12);
    });

    test('storage keys are unique', () {
      final keys = Setting.values.map((s) => s.storageKey).toSet();
      expect(keys.length, Setting.values.length);
    });

    test('copyWith changes one setting and leaves the original untouched', () {
      final a = AppSettings.defaults();
      final b = a.copyWith(Setting.parkingMotion, false);
      expect(a[Setting.parkingMotion], isTrue);
      expect(b[Setting.parkingMotion], isFalse);
      expect(b[Setting.parkingImpact], isTrue);
      expect(a == AppSettings.defaults(), isTrue);
      expect(a == b, isFalse);
    });
  });

  group('parkingGuardianOn (decision D2)', () {
    AppSettings with3(bool m, bool i, bool a) => AppSettings.defaults()
        .copyWith(Setting.parkingMotion, m)
        .copyWith(Setting.parkingImpact, i)
        .copyWith(Setting.parkingAuto, a);

    test('is off only when all three parking toggles are off', () {
      expect(with3(false, false, false).parkingGuardianOn, isFalse);
    });

    test('is on when at least one parking toggle is on', () {
      expect(with3(true, false, false).parkingGuardianOn, isTrue);
      expect(with3(false, true, false).parkingGuardianOn, isTrue);
      expect(with3(false, false, true).parkingGuardianOn, isTrue);
      expect(with3(true, true, true).parkingGuardianOn, isTrue);
    });

    test('is not affected by non-parking settings', () {
      final s = with3(false, false, false).copyWith(Setting.audioSystem, true);
      expect(s.parkingGuardianOn, isFalse);
    });
  });

  group('codec', () {
    test('encodes a versioned document and decodes it back', () {
      final s = AppSettings.defaults()
          .copyWith(Setting.alertLaneDeparture, false)
          .copyWith(Setting.sosDiscreetMode, true);
      final raw = AppSettingsCodec.encode(s);
      final map = jsonDecode(raw) as Map<String, Object?>;
      expect(map['v'], AppSettingsCodec.schemaVersion);
      expect((map['data'] as Map).length, Setting.values.length);

      final r = AppSettingsCodec.decode(raw);
      expect(r.status, SettingsLoadStatus.ok);
      expect(r.settings, s);
    });

    test('stored document contains only the version and boolean settings', () {
      final map = jsonDecode(AppSettingsCodec.encode(AppSettings.defaults()))
          as Map<String, Object?>;
      expect(map.keys.toSet(), {'v', 'data'});
      expect((map['data'] as Map).values.every((v) => v is bool), isTrue);
    });

    test('nothing stored -> defaults, firstRun', () {
      final r = AppSettingsCodec.decode(null);
      expect(r.status, SettingsLoadStatus.firstRun);
      expect(r.settings, AppSettings.defaults());
    });

    test('older document missing newer keys -> ok, missing ones default', () {
      final r = AppSettingsCodec.decode(doc({'parking.motion': false}));
      expect(r.status, SettingsLoadStatus.ok);
      expect(r.settings[Setting.parkingMotion], isFalse);
      expect(r.settings[Setting.audioSystem], isTrue);
    });

    test('unknown keys are ignored', () {
      final r = AppSettingsCodec.decode(
          doc({'future.thing': 5, 'ai.restBreak': false}));
      expect(r.status, SettingsLoadStatus.ok);
      expect(r.settings[Setting.aiRestBreak], isFalse);
    });

    test('wrong-typed value -> only that setting is defaulted, invalidData', () {
      final r = AppSettingsCodec.decode(doc(
          {'parking.motion': 'yes', 'parking.impact': false, 'sos.discreet': 1}));
      expect(r.status, SettingsLoadStatus.invalidData);
      expect(r.settings[Setting.parkingMotion], isTrue); // default
      expect(r.settings[Setting.parkingImpact], isFalse); // valid part kept
      expect(r.settings[Setting.sosDiscreetMode], isFalse); // default
    });

    test('newer schema version -> defaults, unsupportedVersion', () {
      final r = AppSettingsCodec.decode(doc({'parking.motion': false}, v: 2));
      expect(r.status, SettingsLoadStatus.unsupportedVersion);
      expect(r.settings, AppSettings.defaults());
    });

    test('malformed input never throws and yields defaults with invalidData',
        () {
      final bad = <String>[
        '',
        'not json {{',
        'null',
        '123',
        '"text"',
        '[]',
        '{}',
        '{"v":1}',
        '{"v":"1","data":{}}',
        '{"v":0,"data":{}}',
        '{"v":-3,"data":{}}',
        '{"v":1,"data":[]}',
        '{"v":1,"data":"x"}',
        '{"v":null,"data":{}}',
      ];
      for (final raw in bad) {
        final r = AppSettingsCodec.decode(raw);
        expect(r.status, SettingsLoadStatus.invalidData, reason: raw);
        expect(r.settings, AppSettings.defaults(), reason: raw);
      }
    });
  });
}
