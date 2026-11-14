import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';

/// Landscape 04 — Manual SOS / Guardian Mode (`48-5810`… see SCREEN_MAPPING).
/// Hold-to-activate is a real gesture, but activation only shows a DEMO
/// dialog: no emergency message is sent and no call is placed.
class ManualSosScreen extends ConsumerWidget {
  const ManualSosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discreet = ref.watch(discreetModeProvider);
    final gap = context.u(14);
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.u(28), vertical: context.u(16)),
            decoration: BoxDecoration(
              color: AppColors.redSos,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: context.u(26)),
                        SizedBox(width: context.u(10)),
                        Flexible(
                          child: Text('Emergency SOS',
                              style: AppTypography.screenTitle
                                  .copyWith(color: Colors.white)),
                        ),
                      ]),
                      SizedBox(height: context.u(4)),
                      Text(
                        'Send live location, dashcam clips and trip details to emergency contacts.',
                        style:
                            AppTypography.caption.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.u(24)),
                Expanded(
                  flex: 2,
                  child: HoldToActivateButton(
                    label: 'Hold to Activate SOS',
                    background: AppColors.redSosButton,
                    fill: const Color(0xFFC93A33),
                    onActivated: () => showDemoDialog(context,
                        title: 'SOS activated',
                        message:
                            'In a real build this would alert your emergency contacts. Dispatch is not connected.'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: gap),
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CreamCard(
                  padding: EdgeInsets.all(context.u(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.my_location, size: context.u(16)),
                        SizedBox(width: context.u(8)),
                        Text('Current Location', style: AppTypography.cardTitle),
                        const Spacer(),
                        const SimulatedBadge(),
                      ]),
                      SizedBox(height: context.u(10)),
                      Text('Highway A1, Km 120.5',
                          style: AppTypography.label
                              .copyWith(color: AppColors.blueSlate)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: CreamCard(
                  padding: EdgeInsets.all(context.u(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Emergency Contacts', style: AppTypography.cardTitle),
                      SizedBox(height: context.u(10)),
                      Wrap(spacing: context.u(14), children: [
                        Text('✓ Dad', style: AppTypography.body),
                        Text('•', style: AppTypography.body),
                        Text('✓ Sister', style: AppTypography.body),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: gap),
        Row(children: [
          Expanded(
            child: PillButton(
              label: discreet ? 'Discreet Mode: On' : 'Discreet Mode',
              background:
                  discreet ? AppColors.greenToggleBg : AppColors.surfaceCard,
              onPressed: () =>
                  ref.read(discreetModeProvider.notifier).set(!discreet),
            ),
          ),
          SizedBox(width: gap),
          for (final l in ['Call Ambulance', 'Call Police', 'Call Emergency Contact']) ...[
            Expanded(
              child: PillButton(
                label: l,
                onPressed: () => showDemoDialog(context,
                    title: l,
                    message:
                        'Placing calls is not wired in this build (emergency numbers still to be confirmed).'),
              ),
            ),
            if (l != 'Call Emergency Contact') SizedBox(width: gap),
          ],
        ]),
      ],
    );
  }
}
