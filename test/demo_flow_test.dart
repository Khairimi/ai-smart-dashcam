import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/shared/demo_data.dart';
import 'package:ai_smart_dashcam/shared/providers.dart';
import 'package:ai_smart_dashcam/shared/simulated/simulated_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart';

Future<void> phone(WidgetTester tester, String route) =>
    pumpApp(tester, route, phoneSize, store: InMemoryStore());

void main() {
  group('DEMO mobile screens replace the old placeholders', () {
    testWidgets('every mobile route renders real content (no INCOMPLETE)',
        (tester) async {
      const expected = <String, String>{
        '/sos': 'Emergency SOS',
        '/sos/voice': 'Say the command',
        '/trips/find-car': 'Level B2 • Bay A-18',
        '/trips/find-car/saved': 'Level 1 • Bay C-07',
        '/trips/share': 'Recent Trips',
        '/safety/cabin': 'Simulate drowsiness',
        '/hub': 'Audio & Music',
        '/hub/audio': 'Calming Music – AI Recommended',
        '/ai/rest-stop': 'RNR Pagoh Selatan',
      };
      for (final e in expected.entries) {
        await phone(tester, e.key);
        expect(find.text(e.value), findsWidgets, reason: e.key);
        expect(find.text('INCOMPLETE'), findsNothing, reason: e.key);
      }
    });

    testWidgets('Home DEMO shortcuts reach the hub and the accident demo',
        (tester) async {
      await phone(tester, '/home');
      await tester.ensureVisible(find.text('Smart Hub'));
      await tester.tap(find.text('Smart Hub'));
      await tester.pumpAndSettle();
      expect(find.text('Records & Evidence'), findsOneWidget);

      await phone(tester, '/home');
      await tester.ensureVisible(find.text('DEMO: Accident'));
      await tester.tap(find.text('DEMO: Accident'));
      await tester.pumpAndSettle();
      expect(find.text('Accident SOS Alert'), findsOneWidget);
    });

    testWidgets('Home trip duration starts at the Figma sample', (tester) async {
      await phone(tester, '/home');
      expect(find.text('00:24:18'), findsOneWidget);
    });
  });

  group('cabin monitoring demo', () {
    testWidgets('Simulate drowsiness shows the alert and Home reflects it',
        (tester) async {
      await phone(tester, '/safety/cabin');
      await tester.ensureVisible(find.text('Simulate drowsiness'));
      await tester.tap(find.text('Simulate drowsiness'));
      await tester.pumpAndSettle();
      expect(find.text('Driver Drowsiness Detected'), findsOneWidget);
      expect(find.text('Alert'), findsOneWidget);

      // The same shared flag drives the Home card.
      await phone(tester, '/home');
      containerOf(tester).read(drowsinessAlertProvider.notifier).set(true);
      await tester.pump();
      expect(find.text('Alert'), findsOneWidget);
    });

    testWidgets('Find Nearest Rest Stop leads to the mobile rest stop',
        (tester) async {
      await phone(tester, '/safety/cabin');
      containerOf(tester).read(drowsinessAlertProvider.notifier).set(true);
      await tester.pump();
      await tester.tap(find.text('Find Nearest Rest Stop'));
      await tester.pumpAndSettle();
      expect(find.text('RNR Pagoh Selatan'), findsWidgets);
    });
  });

  group('parking and trips demo data (in memory)', () {
    testWidgets('save a spot, see it listed, remove it', (tester) async {
      await phone(tester, '/trips/find-car');
      expect(find.text('Saved Parking (2)'), findsOneWidget);
      await tester.tap(find.text('Save Current Spot'));
      await tester.pumpAndSettle();
      expect(find.text('Saved Parking (3)'), findsOneWidget);
      expect(find.text('Level B1 • Bay D-11'), findsOneWidget);

      await tester.tap(find.text('Saved Parking (3)'));
      await tester.pumpAndSettle();
      expect(find.text('Level B1 • Bay D-11'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove Level B1 • Bay D-11'));
      await tester.pumpAndSettle();
      expect(find.text('Level B1 • Bay D-11'), findsNothing);
      expect(find.text('Level B2 • Bay A-18'), findsOneWidget);
    });

    testWidgets('removing every spot shows an empty state', (tester) async {
      await phone(tester, '/trips/find-car/saved');
      for (final tip in ['Level B2 • Bay A-18', 'Level 1 • Bay C-07']) {
        await tester.tap(find.byTooltip('Remove $tip'));
        await tester.pumpAndSettle();
      }
      expect(find.text('No saved parking spots.'), findsOneWidget);
    });

    testWidgets('stopping trip sharing adds a trip to Recent Trips',
        (tester) async {
      await phone(tester, '/trips/share');
      expect(find.text('Just now • 28.4 km • 00:24:18'), findsNothing);
      await tester.ensureVisible(find.text('Stop Sharing'));
      await tester.tap(find.text('Stop Sharing'));
      await tester.pumpAndSettle();
      expect(find.text('Trip Not Shared'), findsWidgets);
      expect(find.text('Just now • 28.4 km • 00:24:18'), findsOneWidget);
    });

    test('sample state starts with 2 parking spots and 3 trips', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(parkingSpotsProvider).length, 2);
      expect(c.read(tripHistoryProvider).length, 3);
    });
  });

  group('mobile SOS demos never do anything real', () {
    testWidgets('call button shows a DEMO dialog', (tester) async {
      await phone(tester, '/sos');
      await tester.ensureVisible(find.text('Call Police'));
      await tester.tap(find.text('Call Police'));
      await tester.pumpAndSettle();
      expect(find.textContaining('DEMO / SIMULATED'), findsOneWidget);
    });

    testWidgets('voice SOS: Simulate Voice Command -> Please help me -> '
        'emergency detected -> Police Contact DEMO', (tester) async {
      await phone(tester, '/sos/voice');
      expect(find.text('Simulate Voice Command'), findsOneWidget);
      await tester.tap(find.text('Simulate Voice Command'));
      await tester.pump();
      expect(find.text('Listening…'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('Heard: “Please help me”'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1300));
      expect(find.text('⚠ Emergency Detected (simulated)'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pump();
      expect(find.text('Police Contact (DEMO)'), findsOneWidget);
      expect(find.text('Simulation only — no emergency call has been made.'),
          findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Ready — press Simulate Voice Command'), findsOneWidget);
    });

    testWidgets('mobile audio play button toggles to pause', (tester) async {
      await phone(tester, '/hub/audio');
      await tester.ensureVisible(find.byIcon(Icons.play_arrow));
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });

  group('predefined AI replies', () {
    const ai = SimulatedAssistantService();

    test('each suggested question has its own specific answer', () async {
      final fallback = await ai.reply('zzzz');
      for (final q in [
        'Is there any safety alert?',
        'Find a nearby rest stop',
        'Show my latest recording',
        'How can I drive safer?',
        'Forward Collision Warning',
        'Lane Departure Warning',
        'Speed Limit Recognition',
        'Voice Command Control',
        'AI Rest Break Reminder',
      ]) {
        final a = await ai.reply(q);
        expect(a, isNot(fallback), reason: q);
        expect(a.toLowerCase(), isNot(contains('not connected')), reason: q);
      }
    });

    test('unknown questions get a helpful fallback', () async {
      expect(await ai.reply('what is the weather'), contains('I can help'));
    });
  });
}
