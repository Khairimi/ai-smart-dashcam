import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// Mobile bottom nav (Figma component 378 × 64): Home · Safety · Records ·
/// Trips · Nexio Ai. Active tab = blue-grey pill (#BBC9D4 tint per audit).
/// Icons are Material stand-ins for the Figma outline icons.
class MobileBottomNav extends StatelessWidget {
  const MobileBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const _tabs = <(String, IconData)>[
    ('Home', Icons.home_outlined),
    ('Safety', Icons.directions_car_outlined),
    ('Records', Icons.radio_button_checked_outlined),
    ('Trips', Icons.map_outlined),
    ('Nexio Ai', Icons.auto_awesome_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardMobile,
        borderRadius: AppRadii.pillRadius,
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: Semantics(
                selected: i == currentIndex,
                button: true,
                label: _tabs[i].$1,
                excludeSemantics: true,
                child: InkWell(
                  borderRadius: AppRadii.pillRadius,
                  onTap: () => onSelected(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: i == currentIndex
                          ? AppColors.blueNavActive.withValues(alpha: 0.5)
                          : null,
                      borderRadius: AppRadii.tileRadius,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_tabs[i].$2, size: 22, color: AppColors.blueSlate),
                        Text(_tabs[i].$1,
                            style: AppTypography.caption
                                .copyWith(color: AppColors.blueSlate)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
