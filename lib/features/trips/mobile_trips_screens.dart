import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/demo_data.dart';
import '../../shared/providers.dart';
import '../../shared/simulated/simulated_services.dart';

const _navNote =
    'Turn-by-turn navigation is not connected in this prototype. In a real '
    'build this would open walking directions.';

/// Mobile Find My Car (DEMO). Content follows the partial Figma capture:
/// "Saved Parking Level B2 • Bay A-18", "Parked For …", "Walking Route 3 min,
/// 220 m", Navigate. Locations and the map are made up.
class FindMyCarScreen extends ConsumerWidget {
  const FindMyCarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(parkingSpotsProvider);
    final elapsed =
        ref.watch(recElapsedProvider).value ?? SimulatedDashcamDevice.start;
    final current = spots.isEmpty ? null : spots.first;
    // DEMO: the original spot "has been parked" 02:24:18 at the Figma sample
    // time and keeps counting.
    final parkedFor = formatHms(
        const Duration(hours: 2, minutes: 24, seconds: 18) +
            (elapsed - SimulatedDashcamDevice.start));

    return MobilePage(
      title: 'Find My Car',
      children: [
        const SizedBox(height: 180, child: MapPlaceholder(markers: 5)),
        const SizedBox(height: 12),
        CreamCard(
          color: AppColors.surfaceCardMobile,
          child: current == null
              ? Text('No saved parking yet. Tap "Save Current Spot".',
                  style: AppTypography.body)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text('Saved Parking',
                              style: AppTypography.cardTitle)),
                      const SimulatedBadge(),
                    ]),
                    const SizedBox(height: 8),
                    Text(current.spot,
                        style: AppTypography.cardTitle
                            .copyWith(color: AppColors.blueSlate)),
                    Text(current.place, style: AppTypography.caption),
                    const SizedBox(height: 8),
                    Text(
                        current.id == 1
                            ? 'Parked For $parkedFor'
                            : 'Saved ${current.savedAt}',
                        style: AppTypography.body),
                    const Divider(height: 20, color: AppColors.borderCard),
                    Row(children: [
                      const Icon(Icons.directions_walk,
                          size: 18, color: AppColors.blueSlate),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('Walking Route  •  3 min  •  220 m',
                              style: AppTypography.body)),
                    ]),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        PillButton(
          label: 'Navigate',
          background: AppColors.blueSlate,
          foreground: Colors.white,
          outlined: false,
          onPressed: current == null
              ? null
              : () => showDemoDialog(context,
                  title: 'Navigate to ${current.spot}', message: _navNote),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: PillButton(
              label: 'Save Current Spot',
              onPressed: () {
                ref.read(parkingSpotsProvider.notifier).saveSample();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Parking spot saved (DEMO location)')));
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PillButton(
              label: 'Saved Parking (${spots.length})',
              onPressed: () => context.go('/trips/find-car/saved'),
            ),
          ),
        ]),
      ],
    );
  }
}

/// Mobile Saved Parking list (DEMO): view and remove saved spots (in memory).
class SavedParkingScreen extends ConsumerWidget {
  const SavedParkingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(parkingSpotsProvider);
    return MobilePage(
      title: 'Saved Parking',
      children: [
        Align(alignment: Alignment.centerRight, child: const SimulatedBadge()),
        const SizedBox(height: 8),
        if (spots.isEmpty) ...[
          CreamCard(
            color: AppColors.surfaceCardMobile,
            child: Text('No saved parking spots.', style: AppTypography.body),
          ),
          const SizedBox(height: 12),
          PillButton(
              label: 'Save Current Spot',
              onPressed: () =>
                  ref.read(parkingSpotsProvider.notifier).saveSample()),
        ] else
          for (final p in spots) ...[
            SettingRow(
              icon: Icons.local_parking,
              title: p.spot,
              subtitle: '${p.place} • ${p.savedAt}',
              color: AppColors.surfaceCardMobile,
              onTap: () => showDemoDialog(context,
                  title: 'Navigate to ${p.spot}', message: _navNote),
              trailing: IconButton(
                tooltip: 'Remove ${p.spot}',
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () =>
                    ref.read(parkingSpotsProvider.notifier).remove(p.id),
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

/// Mobile Trip Sharing (DEMO layout) with a sample trip history. Stopping
/// sharing adds a made-up trip to the list (in memory).
class MobileTripSharingScreen extends ConsumerWidget {
  const MobileTripSharingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharing = ref.watch(tripSharingProvider);
    final notifier = ref.read(tripSharingProvider.notifier);
    final trips = ref.watch(tripHistoryProvider);
    const card = AppColors.surfaceCardMobile;

    return MobilePage(
      title: 'Trip Sharing',
      children: [
        const SizedBox(height: 150, child: MapPlaceholder(markers: 6)),
        const SizedBox(height: 12),
        Row(children: [
          StatusPill(
            label: sharing ? 'Trip Currently Shared' : 'Trip Not Shared',
            background: sharing ? AppColors.greenTint : AppColors.surfaceCard,
            foreground:
                sharing ? AppColors.greenAccent : AppColors.textSecondary,
          ),
          const Spacer(),
          const SimulatedBadge(),
        ]),
        const SizedBox(height: 10),
        const SettingRow(
            icon: Icons.my_location_outlined,
            title: 'Destination',
            subtitle: 'Mid Valley Megamall',
            color: card),
        const SizedBox(height: 8),
        const SettingRow(
            icon: Icons.schedule,
            title: 'ETA 10:18 AM',
            subtitle: 'Distance 28.4 km',
            color: card),
        const SizedBox(height: 8),
        const SettingRow(
            icon: Icons.groups_outlined,
            title: 'Receiving Contacts',
            subtitle: 'Family  •  Guardian',
            color: card),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: PillButton(
                label: 'Start Sharing',
                onPressed: sharing ? null : () => notifier.set(true)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PillButton(
              label: 'Stop Sharing',
              onPressed: sharing
                  ? () {
                      notifier.set(false);
                      ref.read(tripHistoryProvider.notifier).addSharedTrip();
                    }
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PillButton(
              label: 'Share Link',
              onPressed: () => showDemoDialog(context,
                  title: 'Share Link',
                  message: 'Link sharing is not connected in this prototype.'),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: Text('Recent Trips',
                  style: AppTypography.cardTitle.copyWith(fontSize: 16))),
          const SimulatedBadge(),
        ]),
        const SizedBox(height: 10),
        for (final t in trips) ...[
          SettingRow(
            icon: Icons.route_outlined,
            title: t.destination,
            subtitle: '${t.when} • ${t.distance} • ${t.duration}',
            color: card,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
