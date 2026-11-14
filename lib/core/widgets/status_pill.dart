import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// Fully rounded tinted label (date pill, "Trip Currently Shared", etc.).
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.background = AppColors.greenTint,
    this.foreground = AppColors.greenAccent,
    this.leading,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.pillRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 6)],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
