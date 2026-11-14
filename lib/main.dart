import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';
import 'core/storage/in_memory_store.dart';
import 'core/storage/key_value_store.dart';
import 'core/storage/shared_prefs_store.dart';
import 'features/settings/presentation/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean URLs (no #) so deep links work with an SPA rewrite on the host.
  usePathUrlStrategy();

  // Open local storage once, before the first frame, so settings never flash
  // their defaults. If storage is unavailable (e.g. blocked), the app still
  // runs with session-only settings.
  KeyValueStore store;
  try {
    store = await SharedPrefsStore.open();
  } catch (e) {
    debugPrint('Local storage unavailable; settings will not persist: $e');
    store = InMemoryStore();
  }

  runApp(ProviderScope(
    overrides: [keyValueStoreProvider.overrideWithValue(store)],
    child: const DashcamApp(),
  ));
}
