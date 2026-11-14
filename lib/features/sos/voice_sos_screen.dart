import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

/// Landscape 05 — Voice SOS (`48-5810`). Speech recognition is NOT connected:
/// the "Listening…" / "Command Recognized" chips are static sample states
/// (SIMULATED). Figma shows a music-note glyph in the circle; kept as drawn.
class VoiceSosScreen extends StatelessWidget {
  const VoiceSosScreen({super.key});

  static const _actions = ['Call 999', 'Call Family', 'Call Spouse', 'Send SOS'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(20)),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.greenTint, shape: BoxShape.circle),
                        child: Icon(Icons.music_note,
                            color: AppColors.greenAccent, size: context.u(40)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Say the command',
                          style: AppTypography.screenTitle
                              .copyWith(fontSize: 26)),
                      SizedBox(height: context.u(14)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.u(16), vertical: context.u(10)),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderCard),
                          borderRadius: AppRadii.tileRadius,
                        ),
                        child: Text('“SOS, help me”',
                            style: AppTypography.cardTitle
                                .copyWith(fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(height: context.u(14)),
                      Wrap(spacing: context.u(14), runSpacing: 8, children: [
                        StatusPill(
                          label: 'Listening…',
                          leading: Icon(Icons.circle,
                              size: context.u(8), color: AppColors.greenAccent),
                        ),
                        StatusPill(
                          label: 'Command Recognized',
                          leading: Icon(Icons.check,
                              size: context.u(12), color: AppColors.greenAccent),
                        ),
                        const SimulatedBadge(),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.u(14)),
        Expanded(
          flex: 3,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Emergency Actions', style: AppTypography.label),
                SizedBox(height: context.u(8)),
                Row(children: [
                  for (var i = 0; i < _actions.length; i++) ...[
                    if (i > 0) SizedBox(width: context.u(12)),
                    Expanded(
                      child: PillButton(
                        label: _actions[i],
                        onPressed: () => showDemoDialog(context,
                            title: _actions[i],
                            message:
                                'Calls and SOS dispatch are not connected in this build.'),
                      ),
                    ),
                  ],
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
