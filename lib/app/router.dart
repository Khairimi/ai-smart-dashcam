import 'package:go_router/go_router.dart';

import 'design_gallery.dart';

/// Placeholder router. Shells and feature routes are added in Phase 4.
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DesignGallery(),
    ),
  ],
);
