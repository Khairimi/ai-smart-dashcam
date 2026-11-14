import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Minimum inner card width (px) at which a cabin row (label + pill) fits on
/// one line; below it the label sits above the pill. Measured against the
/// widest row ("Distraction" + "Focused") — an estimate, not a Figma value.
const double _kCabinRowMinInline = 132;

/// Mobile 01 — Home Dashboard (`4-3`). Every value (connection, speed, trip
/// duration, passengers, cabin AI states, location) is a SIMULATED sample;
/// no dashcam, AI or GPS is connected.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = AppColors.surfaceCardMobile;
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            Row(children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blueSlate, width: 3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text('NEXIO',
                      style: AppTypography.cardTitle.copyWith(
                          fontSize: 17, letterSpacing: .5))),
              const CloudDot(),
            ]),
            const SizedBox(height: 16),
            CreamCard(
              color: bg,
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                const SizedBox(
                    width: 96, height: 64, child: CameraFeedPlaceholder()),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.greenAccent, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('Dashcam Connected',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.cardTitle),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.circle,
                            color: AppColors.redSos, size: 8),
                        const SizedBox(width: 8),
                        // Expanded (not Flexible + Spacer, which split the free
                        // space 50/50 and truncated the text needlessly).
                        Expanded(
                          child: Text('Recording On',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body),
                        ),
                        const SimulatedBadge(),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            CreamCard(
              color: bg,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: const Row(children: [
                _Stat(Icons.speed, 'Current Speed', '80 km/h'),
                _Stat(Icons.schedule, 'Trip Duration', '00:24:18'),
                _Stat(Icons.groups_outlined, 'Passengers', '4'),
              ]),
            ),
            const SizedBox(height: 12),
            // The layout choice is made by a LayoutBuilder placed OUTSIDE the
            // IntrinsicHeight (LayoutBuilder inside it is not allowed). Each
            // row below is a plain Row/Column, so its intrinsic height is exact.
            LayoutBuilder(
              builder: (context, c) {
                // Inner width of one half-width card (gap 12, padding 12 each side).
                final inner = (c.maxWidth - 12) / 2 - 24;
                final stacked = inner < _kCabinRowMinInline;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CreamCard(
                          color: bg,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Live Location ›',
                                  style: AppTypography.label),
                              const SizedBox(height: 8),
                              const SizedBox(
                                  height: 110,
                                  child: MapPlaceholder(markers: 8)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CreamCard(
                          color: bg,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Single line, scaled down slightly on very narrow
                              // phones (~7% at 320 px) so the title never wraps:
                              // a wrapped title was measured as one line by
                              // IntrinsicHeight and overflowed by 17 px.
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text('AI Cabin Monitoring',
                                    maxLines: 1, style: AppTypography.label),
                              ),
                              const SizedBox(height: 8),
                              for (final r in const [
                                ('Drowsiness', 'Normal'),
                                ('Distraction', 'Focused'),
                                ('Emotion', 'Calm'),
                                ('Seatbelt', 'Fastened'),
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: _CabinRow(
                                      label: r.$1,
                                      value: r.$2,
                                      stacked: stacked),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text('Quick Actions',
                style: AppTypography.cardTitle.copyWith(fontSize: 17)),
            const SizedBox(height: 10),
            Row(children: [
              _Action('Manual SOS', Icons.priority_high, AppColors.redTint,
                  AppColors.redSos, () => context.go('/sos')),
              const SizedBox(width: 8),
              _Action('Voice SOS', Icons.music_note, bg, AppColors.blueSlate,
                  () => context.go('/sos/voice')),
              const SizedBox(width: 8),
              _Action('Find My Car', Icons.directions_car_outlined, bg,
                  AppColors.blueSlate, () => context.go('/trips/find-car')),
              const SizedBox(width: 8),
              _Action('Trip Sharing', Icons.north_east, bg, AppColors.blueSlate,
                  () => context.go('/trips/share')),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: AppTypography.cardTitle.copyWith(fontSize: 17)),
          ),
        ]),
      );
}

class _Action extends StatelessWidget {
  const _Action(this.label, this.icon, this.bg, this.fg, this.onTap);
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: CreamCard(
          color: bg,
          onTap: onTap,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(fontSize: 11)),
          ]),
        ),
      );
}

/// One "AI Cabin Monitoring" row. Plain Row/Column so intrinsic height is exact.
class _CabinRow extends StatelessWidget {
  const _CabinRow({
    required this.label,
    required this.value,
    required this.stacked,
  });

  final String label;
  final String value;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 2),
          StatusPill(label: value),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption),
        ),
        StatusPill(label: value),
      ],
    );
  }
}
