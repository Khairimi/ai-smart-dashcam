import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';
import 'icon_badge.dart';

/// List row: icon badge, title + optional subtitle, optional trailing widget
/// (toggle chip, arrow, …). Used by parking, audio, alerts and AI lists.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.color = AppColors.surfaceCard,
    this.iconSize = 40,
    this.scale = 1,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color color;
  final double iconSize;

  /// Multiplier for padding (used by the in-car layout).
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.tileRadius,
        side: const BorderSide(color: AppColors.borderCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 10 * scale),
          child: Row(
            children: [
              IconBadge(icon: icon, size: iconSize),
              SizedBox(width: 12 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(fontSize: 14)),
                    if (subtitle != null)
                      Text(subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption),
                  ],
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 8 * scale), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
