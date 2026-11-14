import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// Marks simulated (DEMO) content: nothing behind it is real. Not part of the
/// Figma design.
class SimulatedBadge extends StatelessWidget {
  const SimulatedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.purpleTint,
        borderRadius: AppRadii.pillRadius,
      ),
      child: Text('DEMO',
          style: AppTypography.caption
              .copyWith(fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}
