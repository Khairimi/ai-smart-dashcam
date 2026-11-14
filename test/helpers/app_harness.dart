import 'package:ai_smart_dashcam/app/app.dart';
import 'package:ai_smart_dashcam/app/router.dart';
import 'package:ai_smart_dashcam/core/storage/in_memory_store.dart';
import 'package:ai_smart_dashcam/core/storage/key_value_store.dart';
import 'package:ai_smart_dashcam/features/settings/presentation/settings_providers.dart';
import 'package:ai_smart_dashcam/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory store that reports itself as persistent, so the app treats it like
/// real storage (status `ok`, not `memoryOnly`). Share one instance between two
/// pumps to simulate an app restart.
class PersistentFakeStore extends InMemoryStore {
  PersistentFakeStore([super.initial]);

  @override
  bool get isPersistent => true;
}

/// flutter_test renders text with the Ahem font, so RenderFlex overflow errors
/// are test-font artefacts; real overflow QA is done in a browser.
void ignoreOverflowErrors() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.toString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

const landscapeSize = Size(1672, 941);
const phoneSize = Size(390, 844);

/// Pumps the whole app at [route] with [store] as local storage.
Future<void> pumpApp(
  WidgetTester tester,
  String route,
  Size size, {
  required KeyValueStore store,
}) async {
  ignoreOverflowErrors();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      // No periodic timer in tests.
      recElapsedProvider.overrideWith(
          (ref) => Stream.value(const Duration(minutes: 12, seconds: 34))),
    ],
    child: DashcamApp(router: buildRouter(initialLocation: route)),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

/// Tears the app down (as if the app were closed).
Future<void> closeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

ProviderContainer containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(DashcamApp)));
