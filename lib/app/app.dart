import 'package:flutter/material.dart';

import 'router.dart';

/// Root widget. Theme is a placeholder until Phase 3 (design system).
class DashcamApp extends StatelessWidget {
  const DashcamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Smart Dashcam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF1E8),
      ),
      routerConfig: appRouter,
    );
  }
}
