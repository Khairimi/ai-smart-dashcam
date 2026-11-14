import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Every setting that has a control in the approved UI (decision D5: no new
/// settings screen). [storageKey] is the name inside the stored JSON document;
/// [defaultValue] matches what the app showed before settings were persisted.
enum Setting {
  parkingMotion('parking.motion'),
  parkingImpact('parking.impact'),
  parkingAuto('parking.auto'), // "Auto Recording" (DEMO: no recorder exists)
  audioSystem('audio.system'),
  audioVoice('audio.voice'),
  audioCabin('audio.cabin'),
  audioAiPreference('audio.aiPref'),
  alertForwardCollision('alerts.fcw'),
  alertLaneDeparture('alerts.ldw'),
  alertSpeedLimit('alerts.sls'),
  aiRestBreak('ai.restBreak'),
  sosDiscreetMode('sos.discreet', defaultValue: false);

  const Setting(this.storageKey, {this.defaultValue = true});

  final String storageKey;
  final bool defaultValue;
}

/// Immutable, typed set of boolean settings. Every [Setting] always has a value.
@immutable
class AppSettings {
  const AppSettings._(this._values);

  /// All settings at their defaults.
  factory AppSettings.defaults() => AppSettings.fromValues(const {});

  /// Missing settings fall back to their default.
  factory AppSettings.fromValues(Map<Setting, bool> values) =>
      AppSettings._(Map.unmodifiable({
        for (final s in Setting.values) s: values[s] ?? s.defaultValue,
      }));

  final Map<Setting, bool> _values;

  bool operator [](Setting s) => _values[s]!;

  AppSettings copyWith(Setting s, bool value) =>
      AppSettings._(Map.unmodifiable({..._values, s: value}));

  /// Decision D2: the Parking Guardian is "On" when at least one parking
  /// protection toggle (motion, impact, auto recording) is on.
  bool get parkingGuardianOn =>
      this[Setting.parkingMotion] ||
      this[Setting.parkingImpact] ||
      this[Setting.parkingAuto];

  @override
  bool operator ==(Object other) =>
      other is AppSettings && mapEquals(_values, other._values);

  @override
  int get hashCode => Object.hashAll(_values.entries.map((e) => Object.hash(e.key, e.value)));

  @override
  String toString() => 'AppSettings($_values)';
}

/// Why settings have the values they have.
enum SettingsLoadStatus {
  /// Valid stored document.
  ok,

  /// Nothing stored yet: defaults.
  firstRun,

  /// Stored data was malformed (bad JSON, wrong shape, wrong version field or
  /// non-boolean values). Valid parts are kept, everything else is defaulted.
  invalidData,

  /// Stored with a newer schema than this app understands: defaults are used
  /// and the stored data is left untouched until the next successful save.
  unsupportedVersion,

  /// Reading from storage threw: defaults are used.
  readFailed,
}

class SettingsLoadResult {
  const SettingsLoadResult(this.settings, this.status);
  final AppSettings settings;
  final SettingsLoadStatus status;
}

/// Versioned JSON: `{"v":1,"data":{"parking.motion":true, …}}`.
/// Decoding never throws.
abstract final class AppSettingsCodec {
  static const int schemaVersion = 1;

  static String encode(AppSettings settings) => jsonEncode({
        'v': schemaVersion,
        'data': {for (final s in Setting.values) s.storageKey: settings[s]},
      });

  static SettingsLoadResult decode(String? raw) {
    if (raw == null) {
      return SettingsLoadResult(AppSettings.defaults(), SettingsLoadStatus.firstRun);
    }
    final Object? root;
    try {
      root = jsonDecode(raw);
    } catch (_) {
      return _invalid();
    }
    if (root is! Map<String, Object?>) return _invalid();

    final v = root['v'];
    if (v is! int || v < 1) return _invalid();
    if (v > schemaVersion) {
      return SettingsLoadResult(
          AppSettings.defaults(), SettingsLoadStatus.unsupportedVersion);
    }

    final data = root['data'];
    if (data is! Map<String, Object?>) return _invalid();

    var clean = true;
    final values = <Setting, bool>{};
    for (final s in Setting.values) {
      final value = data[s.storageKey];
      if (value is bool) {
        values[s] = value;
      } else {
        // Missing keys are normal (a setting added later); wrong types are not.
        if (data.containsKey(s.storageKey)) clean = false;
      }
    }
    return SettingsLoadResult(AppSettings.fromValues(values),
        clean ? SettingsLoadStatus.ok : SettingsLoadStatus.invalidData);
  }

  static SettingsLoadResult _invalid() =>
      SettingsLoadResult(AppSettings.defaults(), SettingsLoadStatus.invalidData);
}
