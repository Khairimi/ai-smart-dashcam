import 'package:ai_smart_dashcam/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots to scaffold route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DashcamApp()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Phase 2 scaffold'), findsOneWidget);
  });
}
