import 'package:ai_smart_dashcam/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  test('RecIndicator.format pads h:mm:ss', () {
    expect(RecIndicator.format(const Duration(minutes: 12, seconds: 34)),
        '00:12:34');
    expect(RecIndicator.format(const Duration(hours: 1, seconds: 5)),
        '01:00:05');
  });

  testWidgets('OnToggleChip flips value on tap', (tester) async {
    var value = true;
    await tester.pumpWidget(_wrap(StatefulBuilder(
      builder: (c, set) => OnToggleChip(
          value: value, onChanged: (v) => set(() => value = v)),
    )));
    expect(find.text('On'), findsOneWidget);
    await tester.tap(find.byType(OnToggleChip));
    await tester.pump();
    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('QuickNavBar renders 5 tiles and reports selection',
      (tester) async {
    QuickNavItem? picked;
    await tester.pumpWidget(_wrap(QuickNavBar(onSelected: (i) => picked = i)));
    for (final l in [
      'Front Camera',
      'Cabin Camera',
      'Trip Sharing',
      'Smart Hub',
      'SOS'
    ]) {
      expect(find.text(l), findsOneWidget);
    }
    await tester.tap(find.text('SOS'));
    expect(picked, QuickNavItem.sos);
  });

  testWidgets('MobileBottomNav reports tab index', (tester) async {
    int? picked;
    await tester.pumpWidget(_wrap(
        MobileBottomNav(currentIndex: 0, onSelected: (i) => picked = i)));
    await tester.tap(find.text('Trips'));
    expect(picked, 3);
  });

  testWidgets('IncompleteScreen is clearly labelled', (tester) async {
    await tester.pumpWidget(_wrap(const IncompleteScreen(title: 'Find My Car')));
    expect(find.text('INCOMPLETE'), findsOneWidget);
    expect(find.text('Find My Car'), findsOneWidget);
  });

  testWidgets('SimulatedBadge, StatusPill, CreamCard, PillButton render',
      (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(Column(children: [
      const SimulatedBadge(),
      const StatusPill(label: 'Sharing Live'),
      const CreamCard(child: Text('card')),
      PillButton(label: 'Go', onPressed: () => pressed = true),
    ])));
    expect(find.text('SIMULATED'), findsOneWidget);
    expect(find.text('Sharing Live'), findsOneWidget);
    expect(find.text('card'), findsOneWidget);
    await tester.tap(find.text('Go'));
    expect(pressed, isTrue);
  });

  testWidgets('InCarHeader shows title and REC time', (tester) async {
    await tester.pumpWidget(_wrap(const InCarHeader(
        title: 'Smart Hub', recElapsed: Duration(minutes: 12, seconds: 34))));
    expect(find.text('Smart Hub'), findsOneWidget);
    expect(find.text('00:12:34'), findsOneWidget);
  });
}
