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
    this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Widget? leading;

  /// Makes the pill a button (e.g. to cycle a DEMO choice).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = DecoratedBox(
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
    if (onTap == null) return pill;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: pill,
      ),
    );
  }
}
