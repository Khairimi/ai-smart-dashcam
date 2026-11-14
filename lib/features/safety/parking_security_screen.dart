import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../settings/domain/app_settings.dart';
import '../settings/presentation/settings_providers.dart';

/// Parking & Vehicle Security — landscape `48-5853` and mobile `4-427`.
/// Toggles are local state. "Recent alerts" are SIMULATED sample entries; no
/// motion/impact sensing exists.
class ParkingSecurityScreen extends ConsumerWidget {
  const ParkingSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      context.isMobile ? const _Mobile() : const _Landscape();
}

Widget _toggle(WidgetRef ref, Setting setting) {
  final on = ref.watch(settingsProvider)[setting];
  return OnToggleChip(
    value: on,
    onChanged: (v) => ref.read(settingsProvider.notifier).set(setting, v),
  );
}

class _Landscape extends ConsumerWidget {
  const _Landscape();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gap = context.u(16);
    // Decision D2: reflects the real toggle state.
    final guardianOn = ref.watch(settingsProvider).parkingGuardianOn;
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: context.u(24)),
            decoration: BoxDecoration(
              color: AppColors.greenTint,
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: AppColors.borderCard),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Parking Mode Active',
                      style: AppTypography.screenTitle.copyWith(fontSize: 26)),
                  SizedBox(height: context.u(4)),
                  Text('Monitoring your vehicle while parked',
                      style: AppTypography.body),
                ]),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(guardianOn ? 'Parking Guardian On' : 'Parking Guardian Off',
                      style: AppTypography.caption.copyWith(
                          color: guardianOn
                              ? AppColors.greenAccent
                              : AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: gap),
        Expanded(
          flex: 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 11,
                child: CreamCard(
                  padding: EdgeInsets.all(context.u(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart Parking Guardian',
                          style: AppTypography.cardTitle),
                      SizedBox(height: context.u(8)),
                      for (final e in const [
                        (Setting.parkingMotion, 'Motion Detection'),
                        (Setting.parkingImpact, 'Impact Detection'),
                        (Setting.parkingAuto, 'Auto Recording'),
                      ])
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: context.u(6)),
                            child: SettingRow(
                              icon: Icons.radio_button_checked,
                              title: e.$2,
                              subtitle: 'Monitoring active',
                              trailing: _toggle(ref, e.$1),
                              scale: context.u(1),
                              iconSize: context.u(34),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                flex: 10,
                child: CreamCard(
                  padding: EdgeInsets.all(context.u(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('Recent Alerts', style: AppTypography.cardTitle),
                        const Spacer(),
                        const SimulatedBadge(),
                      ]),
                      SizedBox(height: context.u(8)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: context.u(6)),
                          child: SettingRow(
                            icon: Icons.warning_amber_rounded,
                            title: 'Motion Detected',
                            subtitle: 'Recent parking event',
                            onTap: () => showDemoDialog(context,
                                title: 'Motion Detected',
                                message:
                                    'Sample parking event: motion near the vehicle at 8:36 PM.'),
                            scale: context.u(1),
                            iconSize: context.u(34),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: context.u(6)),
                          child: SettingRow(
                            icon: Icons.crop_square_outlined,
                            title: 'Impact Detected',
                            subtitle: 'Evidence captured automatically',
                            onTap: () => showDemoDialog(context,
                                title: 'Impact Detected',
                                message:
                                    'Sample parking event: impact recorded and locked as evidence.'),
                            scale: context.u(1),
                            iconSize: context.u(34),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Mobile extends ConsumerWidget {
  const _Mobile();

  Widget _carThumb({double w = 96, double h = 64}) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: w,
          height: h,
          child: const CameraFeedPlaceholder(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Decision D2: the mobile banner has no guardian text in Figma, so only the
    // all-off state replaces the subtitle.
    final guardianOn = ref.watch(settingsProvider).parkingGuardianOn;
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const MobileHeader(title: 'Parking & Vehicle Security'),
            const SizedBox(height: 16),
            CreamCard(
              color: AppColors.surfaceCardMobile,
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                _carThumb(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('✓ Parking Mode Active',
                          style: AppTypography.cardTitle),
                      Text(
                          guardianOn
                              ? 'Monitoring your vehicle'
                              : 'Parking Guardian Off',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            CreamCard(
              color: AppColors.surfaceCardMobile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smart Parking Guardian', style: AppTypography.cardTitle),
                  const SizedBox(height: 12),
                  for (final e in const [
                    (Setting.parkingMotion, 'Motion Detection'),
                    (Setting.parkingImpact, 'Impact Detection'),
                    (Setting.parkingAuto, 'Auto Recording'),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        Expanded(
                            child: Text(e.$2, style: AppTypography.label)),
                        _toggle(ref, e.$1),
                      ]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CreamCard(
              color: AppColors.surfaceCardMobile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text('Recent Alerts',
                            style: AppTypography.cardTitle)),
                    const SimulatedBadge(),
                  ]),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => showDemoDialog(context,
                        title: 'Motion Detected',
                        message:
                            'Sample parking event: motion near the vehicle at 8:36 PM.'),
                    child: Row(children: [
                      _carThumb(w: 84, h: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Motion Detected', style: AppTypography.label),
                            Text('Today, 8:36 PM', style: AppTypography.caption),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const Divider(height: 20, color: AppColors.borderCard),
                  InkWell(
                    onTap: () => showDemoDialog(context,
                        title: 'Impact Detected',
                        message:
                            'Sample parking event: impact recorded and locked as evidence.'),
                    child: Row(children: [
                      _carThumb(w: 84, h: 48),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text('Impact Detected',
                              style: AppTypography.label)),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SettingRow(
              icon: Icons.play_arrow,
              title: 'Hit-and-Run Evidence Capture',
              subtitle: 'Save and lock important parking footage',
              color: AppColors.surfaceCardMobile,
              onTap: () => showDemoDialog(context,
                  title: 'Hit-and-Run Evidence Capture',
                  message: 'Evidence storage is not connected yet.'),
            ),
            const SizedBox(height: 12),
            SettingRow(
              icon: Icons.my_location,
              title: 'Stolen Vehicle Tracking',
              subtitle: 'View your vehicle’s last known location',
              color: AppColors.surfaceCardMobile,
              onTap: () => showDemoDialog(context,
                  title: 'Stolen Vehicle Tracking',
                  message: 'GPS tracking is not connected yet.'),
            ),
          ],
        ),
      ),
    );
  }
}
