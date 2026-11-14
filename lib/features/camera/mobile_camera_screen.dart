import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/demo_data.dart';
import '../../shared/providers.dart';
import '../../shared/simulated/simulated_services.dart';
import 'widgets/camera_feed.dart';
import 'widgets/camera_toggle.dart';

/// Mobile camera screen (DEMO layout, no Figma frame): the same demo picture
/// as the in-car screens plus Camera ON/OFF and a Front/Cabin switch. There is
/// no real camera; ON/OFF only changes what is shown.
class MobileCameraScreen extends ConsumerWidget {
  const MobileCameraScreen({super.key, required this.cabin});

  final bool cabin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(cameraOnProvider);
    final elapsed =
        ref.watch(recElapsedProvider).value ?? SimulatedDashcamDevice.start;
    return MobilePage(
      title: cabin ? 'Dashcam – Cabin Camera' : 'Dashcam – Front Camera',
      children: [
        SizedBox(
          height: 240,
          child: CameraFeed(
            scene: cabin ? CameraScene.cabin : CameraScene.front,
            label: cabin ? 'CABIN CAMERA' : 'FRONT CAMERA',
            labelBackground: cabin ? AppColors.redTint : AppColors.surfaceCard,
            timestamp: cabin ? null : 'Jan 26, 2025   16:32:06',
            off: !on,
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          StatusPill(
            label: on
                ? 'Recording  ${formatHms(elapsed)}'
                : 'Camera Off — not recording',
            background: on ? AppColors.redTint : AppColors.surfaceCard,
            foreground: on ? AppColors.redSos : AppColors.textSecondary,
          ),
          const Spacer(),
          const CameraToggle(),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: PillButton(
              label: 'Front Camera',
              background:
                  cabin ? AppColors.surfaceCardMobile : AppColors.blueTint,
              onPressed: () => context.go('/camera/front'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PillButton(
              label: 'Cabin Camera',
              background:
                  cabin ? AppColors.blueTint : AppColors.surfaceCardMobile,
              onPressed: () => context.go('/camera/cabin'),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        PillButton(
          label: 'AI Cabin Monitoring',
          onPressed: () => context.go('/safety/cabin'),
        ),
      ],
    );
  }
}
