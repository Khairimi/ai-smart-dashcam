import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'cream_card.dart';

/// Placeholder for Figma frames that are unfinished or not captured
/// (IMPLEMENTATION_PLAN "Incomplete Figma screens"). No design is invented.
class IncompleteScreen extends StatelessWidget {
  const IncompleteScreen({super.key, required this.title, this.reason});

  final String title;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: CreamCard(
            color: AppColors.redTint,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.construction_outlined,
                    color: AppColors.redSos, size: 32),
                const SizedBox(height: AppSpacing.md),
                Text('INCOMPLETE', style: AppTypography.label),
                const SizedBox(height: AppSpacing.xs),
                Text(title,
                    textAlign: TextAlign.center,
                    style: AppTypography.cardTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  reason ??
                      'The Figma frame for this screen is unfinished or not yet captured.',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
