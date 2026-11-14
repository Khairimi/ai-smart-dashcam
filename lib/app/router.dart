import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder router. Shells and feature routes are added in Phase 4.
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('AI Smart Dashcam — Phase 2 scaffold')),
      ),
    ),
  ],
);
