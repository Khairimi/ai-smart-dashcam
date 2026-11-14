import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Mobile "Records & Evidence" (`9-4`). Recordings are SIMULATED samples.
class RecordsEvidenceMobile extends StatelessWidget {
  const RecordsEvidenceMobile({super.key});

  @override
  Widget build(BuildContext context) {
    void soon(String t) => showDemoDialog(context,
        title: t, message: 'Evidence storage is not connected yet.');
    const recent = [
      ('Accident Evidence', 'Pre & post incident • 00:30'),
      ('Hit-and-Run', 'Parking impact • 00:24'),
      ('Cabin Monitoring', 'Night vision • 01:15'),
    ];
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const MobileHeader(title: 'Records & Evidence'),
            const SizedBox(height: 20),
            Text('Protected Recordings',
                style: AppTypography.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            SettingRow(
              icon: Icons.crop_square_outlined,
              title: 'Smart Incident Evidence Vault',
              subtitle: 'Protected accident, SOS and parking clips',
              color: AppColors.surfaceCardMobile,
              onTap: () => soon('Smart Incident Evidence Vault'),
            ),
            const SizedBox(height: 10),
            SettingRow(
              icon: Icons.list_alt_outlined,
              title: 'Road Incident Report Log',
              subtitle: 'Timestamp, GPS, notes and video evidence',
              color: AppColors.surfaceCardMobile,
              onTap: () => soon('Road Incident Report Log'),
            ),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(
                  child: Text('Recent Recordings',
                      style: AppTypography.label.copyWith(fontSize: 14))),
              const SimulatedBadge(),
            ]),
            const SizedBox(height: 10),
            for (final r in recent) ...[
              CreamCard(
                color: AppColors.surfaceCardMobile,
                padding: const EdgeInsets.all(8),
                onTap: () => soon(r.$1),
                child: Row(children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E0E5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: AppColors.blueSlate, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.$1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(fontSize: 14)),
                        Text(r.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
