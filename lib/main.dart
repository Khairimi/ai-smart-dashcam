import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';

void main() {
  // Clean URLs (no #) so deep links work with an SPA rewrite on the host.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: DashcamApp()));
}
