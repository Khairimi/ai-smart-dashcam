import 'package:flutter/material.dart';

import '../../../core/layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';

/// "Driver Drowsiness Detected" card (Figma 02b).
class DrowsinessAlertCard extends StatelessWidget {
  const DrowsinessAlertCard({
    super.key,
    required this.onFindRestStop,
    required this.onIgnore,
  });

  final VoidCallback onFindRestStop;
  final VoidCallback onIgnore;

  @override
  Widget build(BuildContext context) {
    return CreamCard(
      color: AppColors.redTint,
      padding: EdgeInsets.all(context.u(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.warning_amber_rounded, size: context.u(20)),
            SizedBox(width: context.u(8)),
            Expanded(
              child: Text('Driver Drowsiness Detected',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle),
            ),
            SizedBox(width: context.u(8)),
            const SimulatedBadge(),
          ]),
          SizedBox(height: context.u(8)),
          Text('You seem tired. Please take a short break',
              style: AppTypography.body),
          SizedBox(height: context.u(4)),
          Text('DEMO — simulated driver-fatigue warning, no real detection.',
              style: AppTypography.caption),
          SizedBox(height: context.u(14)),
          Row(children: [
            Expanded(
              flex: 3,
              child: PillButton(
                label: 'Find Nearest Rest Stop',
                onPressed: onFindRestStop,
                background: AppColors.greenButton,
                foreground: Colors.white,
                outlined: false,
              ),
            ),
            SizedBox(width: context.u(10)),
            Expanded(
              flex: 2,
              child: PillButton(label: 'Ignore', onPressed: onIgnore),
            ),
          ]),
        ],
      ),
    );
  }
}
