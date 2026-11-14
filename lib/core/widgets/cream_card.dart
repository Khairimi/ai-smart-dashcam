import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Cream surface with 1 px warm outline and no shadow (FIGMA_AUDIT §4).
class CreamCard extends StatelessWidget {
  const CreamCard({
    super.key,
    required this.child,
    this.color = AppColors.surfaceCard,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final BorderRadius? radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppRadii.cardRadius;
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: r,
        side: const BorderSide(color: AppColors.borderCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
