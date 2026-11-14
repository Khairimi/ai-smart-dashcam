import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DEMO data for the presentation prototype. Everything here is fictional,
/// lives in memory only and resets when the app restarts.

class ParkingSpot {
  const ParkingSpot({
    required this.id,
    required this.spot,
    required this.place,
    required this.savedAt,
  });

  final int id;

  /// e.g. "Level B2 • Bay A-18"
  final String spot;
  final String place;
  final String savedAt;
}

class ParkingSpotsNotifier extends Notifier<List<ParkingSpot>> {
  int _next = 3;
  static const _samples = [
    ('Level B1 • Bay D-11', 'Sunway Pyramid'),
    ('Level 3 • Bay B-03', 'KLCC Car Park'),
    ('Level 2 • Bay A-22', 'IOI City Mall'),
  ];

  @override
  List<ParkingSpot> build() => const [
        ParkingSpot(
            id: 1,
            spot: 'Level B2 • Bay A-18',
            place: 'Mid Valley Megamall',
            savedAt: 'Today, 7:12 AM'),
        ParkingSpot(
            id: 2,
            spot: 'Level 1 • Bay C-07',
            place: 'Skudai Parade',
            savedAt: 'Yesterday, 6:30 PM'),
      ];

  /// DEMO: "saves" a made-up spot as the newest (current) parking location.
  void saveSample() {
    final s = _samples[(_next - 3) % _samples.length];
    state = [
      ParkingSpot(id: _next++, spot: s.$1, place: s.$2, savedAt: 'Just now'),
      ...state,
    ];
  }

  void remove(int id) => state = [for (final p in state) if (p.id != id) p];
}

final parkingSpotsProvider =
    NotifierProvider<ParkingSpotsNotifier, List<ParkingSpot>>(
        ParkingSpotsNotifier.new);

class TripEntry {
  const TripEntry({
    required this.destination,
    required this.when,
    required this.distance,
    required this.duration,
  });

  final String destination;
  final String when;
  final String distance;
  final String duration;
}

class TripHistoryNotifier extends Notifier<List<TripEntry>> {
  @override
  List<TripEntry> build() => const [
        TripEntry(
            destination: 'Mid Valley Megamall',
            when: 'Yesterday, 5:42 PM',
            distance: '28.4 km',
            duration: '00:41:12'),
        TripEntry(
            destination: 'UiTM Johor Campus',
            when: 'Mon, 8:05 AM',
            distance: '12.7 km',
            duration: '00:23:48'),
        TripEntry(
            destination: 'RNR Pagoh Selatan',
            when: 'Sun, 3:10 PM',
            distance: '64.1 km',
            duration: '00:52:30'),
      ];

  /// DEMO: adds a made-up completed trip when sharing is stopped.
  void addSharedTrip() => state = [
        const TripEntry(
            destination: 'Mid Valley Megamall',
            when: 'Just now',
            distance: '28.4 km',
            duration: '00:24:18'),
        ...state,
      ];
}

final tripHistoryProvider =
    NotifierProvider<TripHistoryNotifier, List<TripEntry>>(
        TripHistoryNotifier.new);

/// Formats a duration as hh:mm:ss.
String formatHms(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}

/// Static DEMO lists shown by the Records / Evidence dialogs.
const sampleRecordings = <(String, String)>[
  ('Accident Evidence', 'Pre & post incident • 00:30 • locked'),
  ('Hit-and-Run', 'Parking impact • 00:24 • locked'),
  ('Cabin Monitoring', 'Night vision • 01:15'),
];

const sampleIncidents = <(String, String)>[
  ('Accident detected', 'Today 09:17 AM • Jalan Universiti, Skudai'),
  ('Drowsiness warning', 'Today 09:12 AM • Highway A1, Km 120.5'),
  ('Hit-and-run (parking)', 'Yesterday 8:41 PM • Level B2'),
  ('Motion detected', 'Yesterday 8:36 PM • Level B2'),
];
