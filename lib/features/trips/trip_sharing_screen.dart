import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import '../camera/widgets/camera_feed.dart';

/// Landscape 03 — Trip Sharing (`48-5696`). Destination/ETA/contacts are
/// SIMULATED sample values; sharing is a local flag only.
class TripSharingScreen extends ConsumerWidget {
  const TripSharingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharing = ref.watch(tripSharingProvider);
    final notifier = ref.read(tripSharingProvider.notifier);
    final gap = context.u(16);
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: CameraFeed(
            scene: CameraScene.front,
            label: sharing ? 'Trip Currently Shared' : 'Trip Not Shared',
            labelBackground:
                sharing ? AppColors.greenTint : AppColors.surfaceCard,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: 10,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusPill(
                    label: sharing ? 'Trip Currently Shared' : 'Trip Not Shared',
                    background:
                        sharing ? AppColors.greenTint : AppColors.surfaceCard,
                    foreground: sharing
                        ? AppColors.greenAccent
                        : AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.u(10)),
                Expanded(
                  child: _InfoRow(
                      icon: Icons.my_location_outlined,
                      title: 'Destination',
                      sub: 'Mid Valley Megamall'),
                ),
                SizedBox(height: context.u(8)),
                Expanded(
                  child: _InfoRow(
                      icon: Icons.schedule,
                      title: 'ETA 10:18 AM',
                      sub: 'Distance 28.4 km'),
                ),
                SizedBox(height: context.u(8)),
                Expanded(
                  child: _InfoRow(
                      icon: Icons.groups_outlined,
                      title: 'Receiving Contacts',
                      sub: 'Family  •  Guardian'),
                ),
                SizedBox(height: context.u(10)),
                Row(children: [
                  Expanded(
                    child: PillButton(
                        label: 'Start Sharing',
                        onPressed: sharing ? null : () => notifier.set(true)),
                  ),
                  SizedBox(width: context.u(8)),
                  Expanded(
                    child: PillButton(
                        label: 'Stop Sharing',
                        onPressed: sharing ? () => notifier.set(false) : null),
                  ),
                  SizedBox(width: context.u(8)),
                  Expanded(
                    child: PillButton(
                      label: 'Share Link',
                      onPressed: () => showDemoDialog(context,
                          title: 'Share Link',
                          message:
                              'Link sharing needs a backend that is not connected yet.'),
                    ),
                  ),
                ]),
                SizedBox(height: context.u(6)),
                const Align(
                    alignment: Alignment.centerRight, child: SimulatedBadge()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.sub});
  final IconData icon;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => SettingRow(
        icon: icon,
        title: title,
        subtitle: sub,
        iconSize: (c.maxHeight * .6).clamp(24, 56),
        scale: context.u(1),
      ),
    );
  }
}
