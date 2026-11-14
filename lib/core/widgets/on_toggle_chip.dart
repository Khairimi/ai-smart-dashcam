import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The "On" pill used as a toggle in the Figma frames. Tapping flips it.
/// The "off" look is NOT in Figma and is derived (neutral outline) — flagged.
class OnToggleChip extends StatelessWidget {
  const OnToggleChip({
    super.key,
    required this.value,
    required this.onChanged,
    this.onLabel = 'On',
    this.offLabel = 'Off',
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String onLabel;
  final String offLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      button: true,
      child: Material(
        color: value ? AppColors.greenToggleBg : AppColors.surfaceCard,
        shape: StadiumBorder(
          side: value
              ? BorderSide.none
              : const BorderSide(color: AppColors.borderCard),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onChanged == null ? null : () => onChanged!(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              value ? onLabel : offLabel,
              style: AppTypography.label.copyWith(
                color: value ? AppColors.greenAccent : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined pill button ("Start Sharing", "Call Police", quick actions).
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.background = AppColors.surfaceCard,
    this.foreground = AppColors.textPrimary,
    this.outlined = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: StadiumBorder(
        side: outlined
            ? const BorderSide(color: AppColors.borderCard)
            : BorderSide.none,
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
