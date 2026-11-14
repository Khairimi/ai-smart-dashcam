import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/layout.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/widgets.dart';
import '../shared/providers.dart';
import '../shared/simulated/simulated_services.dart';

/// Chooses the layout from the viewport width (< 768 → mobile).
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    super.key,
    required this.navigationShell,
    required this.path,
  });

  final StatefulNavigationShell navigationShell;
  final String path;

  @override
  Widget build(BuildContext context) => context.isMobile
      ? MobileShell(navigationShell: navigationShell)
      : InCarShell(path: path, child: navigationShell);
}

const Map<String, String> _titles = {
  '/camera/front': 'Dashcam – Front Camera',
  '/camera/cabin': 'Dashcam – Cabin Camera',
  '/trips/share': 'Trip Sharing',
  '/sos': 'Manual SOS / Guardian Mode',
  '/sos/voice': 'Voice SOS',
  '/safety/parking': 'Parking & Vehicle Security',
  '/hub': 'Smart Hub',
  '/hub/audio': 'Audio & Music',
  '/records': 'Records & Safety Alerts',
  '/ai': 'Nexio AI',
  '/ai/rest-stop': 'Nexio AI',
};

/// Where the in-car back button goes when there is nothing to pop.
String backTarget(String path) => switch (path) {
      '/hub/audio' || '/records' || '/ai' => '/hub',
      '/ai/rest-stop' => '/ai',
      _ => '/camera/front',
    };

/// Landscape in-car layout: header + content + persistent 5-tile quick-nav.
/// Text, padding and icon sizes scale with width (reference 1672 px).
class InCarShell extends ConsumerWidget {
  const InCarShell({super.key, required this.path, required this.child});

  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    final scale =
        (mq.size.width / kInCarReferenceWidth * 1.7).clamp(0.85, 1.7).toDouble();
    final elapsed =
        ref.watch(recElapsedProvider).value ?? SimulatedDashcamDevice.start;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(scale)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.bgCream,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  context.u(AppSpacing.xl),
                  context.u(AppSpacing.md),
                  context.u(AppSpacing.xl),
                  context.u(AppSpacing.lg)),
              child: Column(
                children: [
                  InCarHeader(
                    title: _titles[path] ?? 'AI Smart Dashcam',
                    recElapsed: elapsed,
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go(backTarget(path)),
                  ),
                  SizedBox(height: context.u(AppSpacing.md)),
                  Expanded(child: child),
                  SizedBox(height: context.u(AppSpacing.lg)),
                  QuickNavBar(
                    onSelected: (item) => context.go(switch (item) {
                      QuickNavItem.frontCamera => '/camera/front',
                      QuickNavItem.cabinCamera => '/camera/cabin',
                      QuickNavItem.tripSharing => '/trips/share',
                      QuickNavItem.smartHub => '/hub',
                      QuickNavItem.sos => '/sos',
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile portrait layout with the five-tab bottom nav
/// (Home · Safety · Records · Trips · Nexio AI).
class MobileShell extends StatelessWidget {
  const MobileShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCreamMobile,
      body: navigationShell,
      bottomNavigationBar: ColoredBox(
        color: AppColors.bgCreamMobile,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 378),
                child: MobileBottomNav(
                  currentIndex: navigationShell.currentIndex,
                  onSelected: (i) => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
