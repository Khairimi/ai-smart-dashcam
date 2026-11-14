import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// "● REC 00:12:34" pill. Time is passed in; the shipped source is simulated.
class RecIndicator extends StatelessWidget {
  const RecIndicator({super.key, required this.elapsed, this.active = true});

  final Duration elapsed;

  /// `false` = the (DEMO) camera is switched off.
  final bool active;

  static String format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: AppRadii.pillRadius,
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Text('CAMERA OFF', style: AppTypography.caption),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.redTint,
        borderRadius: AppRadii.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.redRecDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text('REC',
              style: AppTypography.caption.copyWith(color: AppColors.redSos)),
          const SizedBox(width: 8),
          Text(format(elapsed), style: AppTypography.caption),
        ],
      ),
    );
  }
}
