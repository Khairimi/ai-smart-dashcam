import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Landscape 07 — Smart Hub (`48-5915`): three cards → Audio & Music,
/// Records & Safety Alerts, Nexio AI.
class SmartHubScreen extends StatelessWidget {
  const SmartHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = context.u(16);
    final cards = [
      (Icons.music_note, AppColors.purpleTint, 'Audio & Music',
          'Play music, radio, and manage in-car audio', '/hub/audio'),
      (Icons.crop_square_outlined, AppColors.blueTint, 'Records & Safety Alerts',
          'View recordings, manage alerts, and set safety rules', '/records'),
      (Icons.auto_awesome_outlined, AppColors.redTint, 'Nexio AI',
          'Get driving help, quick answers and hands-free control', '/ai'),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: CreamCard(
              onTap: () => context.go(cards[i].$5),
              padding: EdgeInsets.all(context.u(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: LayoutBuilder(
                        builder: (c, b) => IconBadge(
                          icon: cards[i].$1,
                          circle: true,
                          size: (b.maxHeight * .9).clamp(40, context.u(100)),
                          background: cards[i].$2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.u(12)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cards[i].$3,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cardTitle),
                            SizedBox(height: context.u(6)),
                            Text(cards[i].$4,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption),
                          ],
                        ),
                      ),
                      SizedBox(width: context.u(8)),
                      Semantics(
                        label: 'Open ${cards[i].$3}',
                        excludeSemantics: true,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.u(14), vertical: context.u(6)),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderCard),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(Icons.chevron_right, size: context.u(16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
