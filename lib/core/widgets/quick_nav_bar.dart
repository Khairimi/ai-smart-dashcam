import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum QuickNavItem { frontCamera, cabinCamera, tripSharing, smartHub, sos }

/// Persistent 5-tile quick-nav of the landscape layout. Smart Hub tile is
/// green-tinted, SOS is solid red (FIGMA_AUDIT §3a). Icons are Material
/// stand-ins for the Figma glyphs (no icon export available yet).
class QuickNavBar extends StatelessWidget {
  const QuickNavBar({super.key, this.onSelected});

  final ValueChanged<QuickNavItem>? onSelected;

  static const _items = <(QuickNavItem, String, IconData)>[
    (QuickNavItem.frontCamera, 'Front Camera', Icons.crop_square_outlined),
    (QuickNavItem.cabinCamera, 'Cabin Camera', Icons.circle),
    (QuickNavItem.tripSharing, 'Trip Sharing', Icons.bolt),
    (QuickNavItem.smartHub, 'Smart Hub', Icons.grid_view_outlined),
    (QuickNavItem.sos, 'SOS', Icons.phone_in_talk_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _items.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: _tile(_items[i])),
        ],
      ],
    );
  }

  Widget _tile((QuickNavItem, String, IconData) t) {
    final (item, label, icon) = t;
    final isSos = item == QuickNavItem.sos;
    final isHub = item == QuickNavItem.smartHub;
    final bg = isSos
        ? AppColors.redSos
        : isHub
            ? AppColors.greenTint
            : AppColors.surfaceCard;
    final fg = isSos ? Colors.white : AppColors.textPrimary;
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.tileRadius,
        side: BorderSide(color: isSos ? AppColors.redSos : AppColors.borderCard),
      ),
      child: InkWell(
        borderRadius: AppRadii.tileRadius,
        onTap: onSelected == null ? null : () => onSelected!(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 18, color: isSos ? Colors.white : AppColors.blueSlate),
              const SizedBox(height: 6),
              Text(label,
                  style: AppTypography.label.copyWith(color: fg),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
