import 'package:flutter/material.dart';

import '../core/layout.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/widgets.dart';

/// Picks the landscape or mobile body for one route. A null body means the
/// Figma frame is missing/unfinished for that layout, so the clearly-labelled
/// [IncompleteScreen] is shown instead (no design is invented).
class AdaptiveScreen extends StatelessWidget {
  const AdaptiveScreen({
    super.key,
    required this.title,
    this.landscape,
    this.mobile,
    this.landscapeReason = 'No landscape Figma frame exists for this screen.',
    this.mobileReason = 'No mobile Figma frame exists for this screen.',
  });

  final String title;
  final Widget? landscape;
  final Widget? mobile;
  final String landscapeReason;
  final String mobileReason;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return mobile ??
          ColoredBox(
            color: AppColors.bgCreamMobile,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: MobileHeader(title: title),
                  ),
                  Expanded(
                    child:
                        IncompleteScreen(title: title, reason: mobileReason),
                  ),
                ],
              ),
            ),
          );
    }
    return landscape ??
        IncompleteScreen(title: title, reason: landscapeReason);
  }
}
