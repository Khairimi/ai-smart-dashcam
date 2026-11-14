import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import 'widgets/camera_feed.dart';
import 'widgets/camera_toggle.dart';
import 'widgets/drowsiness_alert_card.dart';

/// Landscape 02 / 02b — Dashcam – Cabin Camera (`48-5657`, `58-6`).
/// The drowsiness alert is only shown via a SIMULATED trigger; no real
/// detection exists.
class CabinCameraScreen extends ConsumerWidget {
  const CabinCameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(drowsinessAlertProvider);
    final notifier = ref.read(drowsinessAlertProvider.notifier);
    return CameraFeed(
      scene: CameraScene.cabin,
      label: 'CABIN CAMERA',
      labelBackground: AppColors.redTint,
      off: !ref.watch(cameraOnProvider),
      topRight: Row(mainAxisSize: MainAxisSize.min, children: [
        const CameraToggle(),
        const SizedBox(width: 8),
        PillButton(
          label: alert ? 'Clear alert' : 'Simulate drowsiness',
          onPressed: () => notifier.set(!alert),
        ),
      ]),
      overlay: alert
          ? Align(
              alignment: const Alignment(0, .72),
              child: FractionallySizedBox(
                widthFactor: .6,
                child: DrowsinessAlertCard(
                  onFindRestStop: () {
                    notifier.set(false);
                    context.go('/ai/rest-stop');
                  },
                  onIgnore: () => notifier.set(false),
                ),
              ),
            )
          : null,
    );
  }
}
