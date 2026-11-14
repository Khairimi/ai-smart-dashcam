import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Tinted rounded icon box (blue by default) used in list rows.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.size = 40,
    this.background = AppColors.blueTint,
    this.color = AppColors.blueSlate,
    this.circle = false,
  });

  final IconData icon;
  final double size;
  final Color background;
  final Color color;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : AppRadii.tileRadius,
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}
