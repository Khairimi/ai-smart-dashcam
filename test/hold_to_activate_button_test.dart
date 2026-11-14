import 'package:ai_smart_dashcam/core/widgets/hold_to_activate_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _fill = Color(0xFFC93A33);

Future<void> _pump(WidgetTester tester, VoidCallback onActivated) {
  return tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 60,
          child: HoldToActivateButton(
            label: 'Hold to Activate SOS',
            background: const Color(0xFFE3968C),
            fill: _fill,
            onActivated: onActivated,
          ),
        ),
      ),
    ),
  ));
}

Finder get _fillFinder =>
    find.byWidgetPredicate((w) => w is ColoredBox && w.color == _fill);

void main() {
  testWidgets('progress fill is visible (full height) and grows while holding',
      (tester) async {
    var count = 0;
    await _pump(tester, () => count++);
    final g = await tester.startGesture(tester.getCenter(find.byType(HoldToActivateButton)));

    await tester.pump(const Duration(milliseconds: 500));
    final s1 = tester.getSize(_fillFinder);
    expect(s1.height, 60, reason: 'fill must span the full button height');
    expect(s1.width, greaterThan(0));

    await tester.pump(const Duration(milliseconds: 500));
    final s2 = tester.getSize(_fillFinder);
    expect(s2.width, greaterThan(s1.width), reason: 'fill grows while held');
    expect(count, 0, reason: 'not activated before the full duration');

    await g.up();
    await tester.pumpAndSettle();
  });

  testWidgets('releasing early resets the progress and does not activate',
      (tester) async {
    var count = 0;
    await _pump(tester, () => count++);
    final g = await tester.startGesture(tester.getCenter(find.byType(HoldToActivateButton)));
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.getSize(_fillFinder).width, greaterThan(0));

    await g.up();
    await tester.pumpAndSettle();
    expect(tester.getSize(_fillFinder).width, 0);
    expect(count, 0);
  });

  testWidgets('completing the hold activates exactly once, even if held longer',
      (tester) async {
    var count = 0;
    await _pump(tester, () => count++);
    final g = await tester.startGesture(tester.getCenter(find.byType(HoldToActivateButton)));

    await tester.pump(const Duration(milliseconds: 2100));
    expect(count, 1);
    await tester.pump(const Duration(seconds: 3));
    expect(count, 1, reason: 'holding longer must not re-activate');

    await g.up();
    await tester.pumpAndSettle();
    expect(count, 1);
    expect(tester.getSize(_fillFinder).width, 0, reason: 'progress resets after activation');
  });
}
