import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

/// Mobile Nearby Rest Stop (DEMO layout). Destination, ETA, distance and the
/// map are made up; Navigate only shows a DEMO dialog.
class MobileRestStopScreen extends StatelessWidget {
  const MobileRestStopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const card = AppColors.surfaceCardMobile;
    return MobilePage(
      title: 'Nearby Rest Stop',
      children: [
        const Row(children: [
          StatusPill(label: 'Sharing Live'),
          Spacer(),
          SimulatedBadge(),
        ]),
        const SizedBox(height: 10),
        const SizedBox(height: 200, child: MapPlaceholder(markers: 6)),
        const SizedBox(height: 12),
        const SettingRow(
            icon: Icons.local_cafe_outlined,
            title: 'RNR Pagoh Selatan',
            subtitle: 'Destination',
            color: card),
        const SizedBox(height: 8),
        const SettingRow(
            icon: Icons.schedule, title: 'ETA 10:18 AM', color: card),
        const SizedBox(height: 8),
        const SettingRow(
            icon: Icons.straighten, title: 'Distance 28.4 km', color: card),
        const SizedBox(height: 12),
        PillButton(
          label: 'Navigate',
          background: AppColors.blueSlate,
          foreground: Colors.white,
          outlined: false,
          onPressed: () => showDemoDialog(context,
              title: 'Navigate to RNR Pagoh Selatan',
              message:
                  'Turn-by-turn navigation is not connected in this prototype.'),
        ),
      ],
    );
  }
}
