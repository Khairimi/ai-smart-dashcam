import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart';

Future<void> land(WidgetTester tester, String route) =>
    pumpApp(tester, route, landscapeSize, store: InMemoryStore());
Future<void> phone(WidgetTester tester, String route) =>
    pumpApp(tester, route, phoneSize, store: InMemoryStore());

void main() {
  group('camera ON / OFF (DEMO, visual only)', () {
    testWidgets('landscape front camera: ON -> OFF -> ON', (tester) async {
      await land(tester, '/camera/front');
      expect(find.text('Camera ON'), findsOneWidget);
      expect(find.text('FRONT CAMERA'), findsOneWidget);

      await tester.tap(find.text('Camera ON'));
      await tester.pumpAndSettle();
      expect(find.text('Camera OFF'), findsOneWidget);
      expect(find.text('Camera is off'), findsOneWidget);
      expect(find.text('CAMERA OFF'), findsWidgets); // header pill + feed label
      expect(find.text('FRONT CAMERA'), findsNothing);

      await tester.tap(find.text('Camera OFF'));
      await tester.pumpAndSettle();
      expect(find.text('Camera ON'), findsOneWidget);
      expect(find.text('FRONT CAMERA'), findsOneWidget);
    });

    testWidgets('landscape: the switch is shared with the cabin camera',
        (tester) async {
      await land(tester, '/camera/cabin');
      await tester.tap(find.text('Camera ON'));
      await tester.pumpAndSettle();
      expect(find.text('Camera is off'), findsOneWidget);
      await tester.tap(find.text('Front Camera'));
      await tester.pumpAndSettle();
      expect(find.text('Camera is off'), findsOneWidget);
    });

    testWidgets('mobile: Home camera card and tile open the camera screen',
        (tester) async {
      await phone(tester, '/home');
      await tester.tap(find.text('Dashcam Connected'));
      await tester.pumpAndSettle();
      expect(find.text('Dashcam – Front Camera'), findsOneWidget);
      expect(find.text('Camera ON'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Camera'));
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();
      expect(find.text('Dashcam – Front Camera'), findsOneWidget);
    });

    testWidgets('mobile: Camera OFF updates the camera screen and Home',
        (tester) async {
      await phone(tester, '/camera/front');
      expect(find.textContaining('Recording'), findsOneWidget);
      await tester.tap(find.text('Camera ON'));
      await tester.pumpAndSettle();
      expect(find.text('Camera OFF'), findsOneWidget);
      expect(find.text('Camera Off — not recording'), findsOneWidget);
      expect(find.text('Camera is off'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Camera Off'), findsOneWidget); // Home status line
      expect(find.text('Recording On'), findsNothing);
    });

    testWidgets('mobile: Front / Cabin buttons switch the camera view',
        (tester) async {
      await phone(tester, '/camera/front');
      await tester.tap(find.text('Cabin Camera'));
      await tester.pumpAndSettle();
      expect(find.text('Dashcam – Cabin Camera'), findsOneWidget);
      expect(find.text('CABIN CAMERA'), findsOneWidget);
    });
  });

  group('Voice SOS on the landscape display', () {
    testWidgets('Simulate Voice Command reaches the Police Contact DEMO',
        (tester) async {
      await land(tester, '/sos/voice');
      await tester.tap(find.text('Simulate Voice Command'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('Heard: “Please help me”'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pump();
      expect(find.text('Police Contact (DEMO)'), findsOneWidget);
      expect(find.text('Simulation only — no emergency call has been made.'),
          findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('Call 999 shows the Police Contact DEMO, not a real call',
        (tester) async {
      await land(tester, '/sos/voice');
      await tester.tap(find.text('Call 999'));
      await tester.pumpAndSettle();
      expect(find.text('Police Contact (DEMO)'), findsOneWidget);
      expect(find.text('Simulation only — no emergency call has been made.'),
          findsOneWidget);
    });
  });

  group('buttons that used to do nothing', () {
    testWidgets('audio: Alert Sound pill cycles and Next/Previous change track',
        (tester) async {
      await land(tester, '/hub/audio');
      expect(find.text('Standard'), findsOneWidget);
      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle();
      expect(find.text('Soft'), findsOneWidget);

      expect(find.text('Calming Music – AI Recommended'), findsOneWidget);
      await tester.tap(find.byTooltip('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Focus Drive – AI Recommended'), findsOneWidget);
      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      expect(find.text('Calming Music – AI Recommended'), findsOneWidget);
    });

    testWidgets('mobile audio: Next track and Alert Sound work', (tester) async {
      await phone(tester, '/hub/audio');
      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle();
      expect(find.text('Soft'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Next'));
      await tester.tap(find.byTooltip('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Focus Drive – AI Recommended'), findsOneWidget);
    });

    testWidgets('landscape Records: vault and incident log open sample lists',
        (tester) async {
      await land(tester, '/records');
      await tester.tap(find.text('Smart Incident Evidence Vault'));
      await tester.pumpAndSettle();
      expect(find.text('Accident Evidence'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Road Incident Report Log'));
      await tester.pumpAndSettle();
      expect(find.text('Accident detected'), findsOneWidget);
    });

    testWidgets('mobile Records: vault, log and recordings respond',
        (tester) async {
      await phone(tester, '/records');
      await tester.tap(find.text('Smart Incident Evidence Vault'));
      await tester.pumpAndSettle();
      expect(find.text('Hit-and-Run'), findsWidgets);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cabin Monitoring'));
      await tester.pumpAndSettle();
      expect(find.text('Playing: Cabin Monitoring'), findsOneWidget);
    });

    testWidgets('parking recent alert rows open a DEMO dialog (mobile)',
        (tester) async {
      await phone(tester, '/safety/parking');
      await tester.ensureVisible(find.text('Motion Detected'));
      await tester.tap(find.text('Motion Detected'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Sample parking event'), findsOneWidget);
    });

    testWidgets('cloud icon opens the alerts summary (landscape and mobile)',
        (tester) async {
      await land(tester, '/camera/front');
      await tester.tap(find.byTooltip('Cloud and alerts'));
      await tester.pumpAndSettle();
      expect(find.text('Cloud & Alerts'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await phone(tester, '/home');
      await tester.tap(find.byIcon(Icons.cloud_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Cloud & Alerts'), findsOneWidget);
    });

    testWidgets('Home Live Location card opens Trip Sharing', (tester) async {
      await phone(tester, '/home');
      await tester.tap(find.text('Live Location ›'));
      await tester.pumpAndSettle();
      expect(find.text('Recent Trips'), findsOneWidget);
    });
  });
}
