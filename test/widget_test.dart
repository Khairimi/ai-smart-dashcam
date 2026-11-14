import 'package:ai_smart_dashcam/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots to design gallery', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DashcamApp()));
    await tester.pumpAndSettle();
    expect(find.text('Design system gallery'), findsOneWidget);
  });
}
