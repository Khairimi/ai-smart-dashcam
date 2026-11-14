import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import 'records_evidence_screen.dart';

/// Records — landscape 09 "Records & Safety Alerts" (`48-6019`) and mobile
/// "Records & Evidence" (`9-4`). Alert toggles are local state only; no ADAS
/// detection exists.
class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      context.isMobile ? const RecordsEvidenceMobile() : const _Landscape();
}

class _Landscape extends ConsumerWidget {
  const _Landscape();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gap = context.u(16);
    final toggles = ref.watch(togglesProvider);
    void soon(String t) => showDemoDialog(context,
        title: t, message: 'Evidence storage and incident logs are not connected yet.');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 10,
          child: Column(children: [
            Expanded(
              child: CreamCard(
                color: AppColors.blueTint,
                onTap: () => soon('Smart Incident Evidence Vault'),
                padding: EdgeInsets.all(context.u(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Smart Incident Evidence Vault',
                          style: AppTypography.cardTitle.copyWith(fontSize: 20)),
                      SizedBox(height: context.u(14)),
                      Text('Auto-save and lock critical footage',
                          style: AppTypography.body),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: CreamCard(
                onTap: () => soon('Road Incident Report Log'),
                padding: EdgeInsets.all(context.u(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Road Incident Report Log',
                          style: AppTypography.cardTitle.copyWith(fontSize: 20)),
                      SizedBox(height: context.u(14)),
                      Text('View, manage, and export incidents',
                          style: AppTypography.body),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: 11,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      child: Text('Road Safety Alerts',
                          style: AppTypography.cardTitle)),
                  const SimulatedBadge(),
                ]),
                SizedBox(height: context.u(8)),
                for (final e in const [
                  ('alerts.fcw', 'Forward Collision Warning'),
                  ('alerts.ldw', 'Lane Departure Warning'),
                  ('alerts.sls', 'Speed Limit Recognition'),
                ])
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: context.u(8)),
                      child: SettingRow(
                        icon: Icons.warning_amber_rounded,
                        title: e.$2,
                        subtitle: 'Safety detection enabled',
                        iconSize: context.u(34),
                        scale: context.u(1),
                        trailing: OnToggleChip(
                          value: toggles[e.$1] ?? false,
                          onChanged: (v) =>
                              ref.read(togglesProvider.notifier).set(e.$1, v),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
