import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Mobile 08 — Accident SOS Alert (`4-378`). The "accident" is a static
/// SIMULATED sample: there is no crash detection, and the call buttons only
/// show a DEMO dialog (no calls, no dispatch).
class AccidentAlertScreen extends StatelessWidget {
  const AccidentAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const card = AppColors.surfaceCardMobile;
    void call(String who) => showDemoDialog(context,
        title: who,
        message:
            'Placing calls is not wired in this build (emergency numbers still to be confirmed).');
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const MobileHeader(title: 'AI Smart Dashcam'),
            const SizedBox(height: 16),
            Text('Accident SOS Alert',
                style: AppTypography.screenTitle.copyWith(fontSize: 22)),
            const SizedBox(height: 2),
            Text('A possible accident has been detected by AI.',
                style: AppTypography.caption),
            const SizedBox(height: 14),
            CreamCard(
              color: AppColors.redTint,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.redSos, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Accident Detected',
                          style: AppTypography.cardTitle
                              .copyWith(color: AppColors.redSos)),
                    ),
                    const SimulatedBadge(),
                  ]),
                  const SizedBox(height: 4),
                  Text('Detected at 09:17 AM • Live Event',
                      style: AppTypography.body.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 2.3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CameraFeedPlaceholder(scene: CameraScene.cabin),
                  Center(
                    child: Semantics(
                      button: true,
                      label: 'Play accident clip',
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => showDemoDialog(context,
                            title: 'Accident clip',
                            message: 'Video playback is not connected yet.'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                              color: AppColors.blueSlate,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow,
                              color: Colors.white, size: 26),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    bottom: 10,
                    child: Text('Accident Clip (Preview)  00:30',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SettingRow(
              icon: Icons.my_location,
              title: 'Current Location',
              subtitle: 'Jalan Universiti, Skudai, Johor, Malaysia',
              color: card,
            ),
            const SizedBox(height: 10),
            const SettingRow(
              icon: Icons.check,
              title: 'Emergency Contacts Notified',
              subtitle: 'Accident video, location and time shared',
              color: card,
            ),
            const SizedBox(height: 20),
            Text('Emergency Actions',
                style: AppTypography.cardTitle.copyWith(fontSize: 17)),
            const SizedBox(height: 10),
            Row(children: [
              _Action('Call Ambulance', AppColors.redTint, () => call('Call Ambulance')),
              const SizedBox(width: 8),
              _Action('Call Police', AppColors.blueTint, () => call('Call Police')),
              const SizedBox(width: 8),
              _Action('Call Driver', AppColors.greenTint, () => call('Call Driver')),
            ]),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => context.go('/records'),
                child: Text('Records & Evidence',
                    style: AppTypography.caption.copyWith(
                        decoration: TextDecoration.underline,
                        color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action(this.label, this.color, this.onTap);
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: CreamCard(
          color: color,
          onTap: onTap,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
          child: Center(
            child: Text(label,
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(fontSize: 11)),
          ),
        ),
      );
}
