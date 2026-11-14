import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Landscape 11 — Nearby Rest Stop (`48-6159`). Destination, ETA and
/// distance are SIMULATED sample values; the map is a placeholder.
class RestStopScreen extends StatelessWidget {
  const RestStopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = context.u(20);
    return CreamCard(
      padding: EdgeInsets.all(context.u(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Nearby Rest Stop',
                style: AppTypography.screenTitle.copyWith(fontSize: 24)),
            const Spacer(),
            const StatusPill(label: 'Sharing Live'),
            SizedBox(width: context.u(8)),
            const SimulatedBadge(),
          ]),
          SizedBox(height: context.u(14)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(flex: 5, child: MapPlaceholder(dark: true)),
                SizedBox(width: gap),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Destination', style: AppTypography.caption),
                      Text('RNR Pagoh Selatan', style: AppTypography.cardTitle),
                      const Divider(color: AppColors.borderCard),
                      Text('ETA 10:18 AM', style: AppTypography.cardTitle),
                      Text('Distance  28.4 km', style: AppTypography.body),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
