import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'rec_indicator.dart';

/// Landscape header: back chevron, title, REC pill, profile/cloud icon.
class InCarHeader extends StatelessWidget {
  const InCarHeader({
    super.key,
    required this.title,
    required this.recElapsed,
    this.onBack,
    this.onCloud,
    this.cameraOn = true,
  });

  final String title;
  final Duration recElapsed;
  final VoidCallback? onBack;
  final VoidCallback? onCloud;
  final bool cameraOn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(title,
              overflow: TextOverflow.ellipsis, style: AppTypography.screenTitle),
        ),
        RecIndicator(elapsed: recElapsed, active: cameraOn),
        const SizedBox(width: AppSpacing.lg),
        IconButton(
          tooltip: 'Cloud and alerts',
          onPressed: onCloud,
          icon: const Icon(Icons.cloud_outlined, size: 20),
        ),
      ],
    );
  }
}
