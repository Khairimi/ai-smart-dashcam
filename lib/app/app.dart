import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

/// Root widget. [router] can be injected (tests use a fresh router).
class DashcamApp extends StatelessWidget {
  const DashcamApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Smart Dashcam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router ?? appRouter,
    );
  }
}
