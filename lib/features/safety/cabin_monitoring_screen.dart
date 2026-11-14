import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import '../camera/widgets/camera_feed.dart';
import '../camera/widgets/drowsiness_alert_card.dart';

/// Mobile AI Cabin Monitoring (DEMO layout: the Figma frame is unfinished).
/// All values are scripted. "Simulate drowsiness" shows the same alert as the
/// landscape cabin camera; there is no real detection.
class CabinMonitoringScreen extends ConsumerWidget {
  const CabinMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(drowsinessAlertProvider);
    final notifier = ref.read(drowsinessAlertProvider.notifier);
    const card = AppColors.surfaceCardMobile;
    final rows = <(IconData, String, String, bool)>[
      (Icons.bedtime_outlined, 'Drowsiness', alert ? 'Alert' : 'Normal', alert),
      (Icons.visibility_outlined, 'Distraction', 'Focused', false),
      (Icons.sentiment_satisfied_alt_outlined, 'Emotion', 'Calm', false),
      (Icons.airline_seat_recline_normal_outlined, 'Seatbelt', 'Fastened', false),
    ];
    return MobilePage(
      title: 'AI Cabin Monitoring',
      children: [
        if (alert) ...[
          DrowsinessAlertCard(
            onFindRestStop: () {
              notifier.set(false);
              context.go('/ai/rest-stop');
            },
            onIgnore: () => notifier.set(false),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(
          height: 170,
          child: CameraFeed(
            scene: CameraScene.cabin,
            label: 'CABIN CAMERA',
            labelBackground: AppColors.redTint,
          ),
        ),
        const SizedBox(height: 12),
        for (final r in rows) ...[
          SettingRow(
            icon: r.$1,
            title: r.$2,
            color: card,
            trailing: StatusPill(
              label: r.$3,
              background: r.$4 ? AppColors.redTint : AppColors.greenTint,
              foreground: r.$4 ? AppColors.redSos : AppColors.greenAccent,
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 4),
        PillButton(
          label: alert ? 'Clear alert' : 'Simulate drowsiness',
          onPressed: () => notifier.set(!alert),
        ),
      ],
    );
  }
}
