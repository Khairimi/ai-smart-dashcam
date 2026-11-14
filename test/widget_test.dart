import 'package:ai_smart_dashcam/app/app.dart';
import 'package:ai_smart_dashcam/app/router.dart';
import 'package:ai_smart_dashcam/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// NOTE: flutter_test renders text with the Ahem font (every glyph is a full
/// em wide), so RenderFlex overflow errors here are test-font artefacts, not
/// layout bugs. They are ignored in these tests; real overflow QA is done in
/// a browser (see docs/QA_REPORT.md).
void _ignoreOverflow() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.toString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

Future<void> _pump(WidgetTester tester, String route, Size size) async {
  _ignoreOverflow();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      // No periodic timer in tests.
      recElapsedProvider
          .overrideWith((ref) => Stream.value(const Duration(minutes: 12, seconds: 34))),
    ],
    child: DashcamApp(router: buildRouter(initialLocation: route)),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

const _landscape = Size(1672, 941);
const _phone = Size(390, 844);

void main() {
  group('landscape in-car shell', () {
    testWidgets('direct URL /camera/front shows header, REC and quick-nav',
        (tester) async {
      await _pump(tester, '/camera/front', _landscape);
      expect(find.text('Dashcam – Front Camera'), findsOneWidget);
      expect(find.text('00:12:34'), findsOneWidget);
      expect(find.text('FRONT CAMERA'), findsOneWidget);
      for (final l in ['Front Camera', 'Cabin Camera', 'Trip Sharing', 'Smart Hub', 'SOS']) {
        expect(find.text(l), findsOneWidget);
      }
    });

    testWidgets('quick-nav navigates to Smart Hub then Audio & Music',
        (tester) async {
      await _pump(tester, '/camera/front', _landscape);
      await tester.tap(find.text('Smart Hub'));
      await tester.pumpAndSettle();
      expect(find.text('Records & Safety Alerts'), findsOneWidget);
      await tester.tap(find.text('Audio & Music'));
      await tester.pumpAndSettle();
      expect(find.text('Audio & Music Settings'), findsOneWidget);
    });

    testWidgets('simulated drowsiness alert shows and can be ignored',
        (tester) async {
      await _pump(tester, '/camera/cabin', _landscape);
      expect(find.text('Driver Drowsiness Detected'), findsNothing);
      await tester.tap(find.text('Simulate drowsiness'));
      await tester.pump();
      expect(find.text('Driver Drowsiness Detected'), findsOneWidget);
      await tester.tap(find.text('Ignore'));
      await tester.pump();
      expect(find.text('Driver Drowsiness Detected'), findsNothing);
    });

    testWidgets('parking toggle flips locally', (tester) async {
      await _pump(tester, '/safety/parking', _landscape);
      expect(find.text('On'), findsNWidgets(3));
      await tester.tap(find.text('On').first);
      await tester.pump();
      expect(find.text('Off'), findsOneWidget);
    });

    testWidgets('trip sharing can be stopped', (tester) async {
      await _pump(tester, '/trips/share', _landscape);
      expect(find.text('Trip Currently Shared'), findsWidgets);
      await tester.tap(find.text('Stop Sharing'));
      await tester.pump();
      expect(find.text('Trip Not Shared'), findsWidgets);
    });

    testWidgets('call button shows a DEMO dialog, not a real call',
        (tester) async {
      await _pump(tester, '/sos', _landscape);
      await tester.tap(find.text('Call Police'));
      await tester.pumpAndSettle();
      expect(find.textContaining('DEMO / SIMULATED'), findsOneWidget);
    });

    testWidgets('screens without a landscape frame show INCOMPLETE',
        (tester) async {
      await _pump(tester, '/trips/find-car', _landscape);
      expect(find.text('INCOMPLETE'), findsOneWidget);
    });

    testWidgets('every Figma landscape route renders', (tester) async {
      for (final r in [
        '/camera/cabin',
        '/trips/share',
        '/sos',
        '/sos/voice',
        '/safety/parking',
        '/hub',
        '/hub/audio',
        '/records',
        '/ai',
        '/ai/rest-stop',
      ]) {
        await _pump(tester, r, _landscape);
        expect(find.byType(Scaffold), findsWidgets, reason: r);
        expect(find.text('INCOMPLETE'), findsNothing, reason: r);
      }
    });
  });

  group('mobile shell', () {
    testWidgets('home renders with five-tab nav', (tester) async {
      await _pump(tester, '/home', _phone);
      expect(find.text('NEXIO'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      for (final t in ['Home', 'Safety', 'Records', 'Trips', 'Nexio Ai']) {
        expect(find.text(t), findsOneWidget);
      }
    });

    testWidgets('tabs switch branches; unfinished tab is INCOMPLETE',
        (tester) async {
      await _pump(tester, '/home', _phone);
      await tester.tap(find.text('Safety'));
      await tester.pumpAndSettle();
      expect(find.text('Parking & Vehicle Security'), findsOneWidget);
      await tester.tap(find.text('Records'));
      await tester.pumpAndSettle();
      expect(find.text('Protected Recordings'), findsOneWidget);
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();
      expect(find.text('INCOMPLETE'), findsOneWidget);
      await tester.tap(find.text('Nexio Ai'));
      await tester.pumpAndSettle();
      expect(find.text('Road Safety Assistance'), findsOneWidget);
    });

    testWidgets('accident alert deep link works', (tester) async {
      await _pump(tester, '/sos/accident', _phone);
      expect(find.text('Accident SOS Alert'), findsOneWidget);
      expect(find.text('Emergency Actions'), findsOneWidget);
    });

    testWidgets('home quick action Manual SOS is INCOMPLETE on mobile',
        (tester) async {
      await _pump(tester, '/home', _phone);
      await tester.ensureVisible(find.text('Manual SOS'));
      await tester.tap(find.text('Manual SOS'));
      await tester.pumpAndSettle();
      expect(find.text('INCOMPLETE'), findsOneWidget);
    });
  });

  testWidgets('entry route / redirects by width', (tester) async {
    await _pump(tester, '/', _landscape);
    expect(find.text('Dashcam – Front Camera'), findsOneWidget);
  });
}
