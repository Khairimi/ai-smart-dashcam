import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'demo_dialog.dart';

/// Mobile screen header: rounded back button, title, cloud icon with red dot.
class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key, required this.title, this.showBack = true});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          Semantics(
            button: true,
            label: 'Back',
            child: Material(
              color: AppColors.surfaceCardMobile,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.borderCard),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.canPop() ? context.pop() : context.go('/home'),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(Icons.chevron_left, size: 22),
                ),
              ),
            ),
          ),
        if (showBack) const SizedBox(width: 12),
        Expanded(
          child: Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle.copyWith(fontSize: 17)),
        ),
        const CloudDot(),
      ],
    );
  }
}

/// Cloud icon with the red notification dot used in mobile headers. Tapping it
/// shows the DEMO alert summary.
class CloudDot extends StatelessWidget {
  const CloudDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Cloud and alerts',
      excludeSemantics: true,
      child: InkResponse(
        radius: 22,
        onTap: () => showDemoDialog(context,
            title: 'Cloud & Alerts',
            message:
                'Cloud sync: connected (sample). 1 new alert: "Motion detected" at 8:36 PM.'),
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.cloud_outlined, size: 22),
              Positioned(
                right: -3,
                top: -2,
                child: SizedBox(
                  width: 7,
                  height: 7,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: AppColors.redSos, shape: BoxShape.circle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
