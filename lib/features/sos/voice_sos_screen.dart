import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import 'voice_demo.dart';

/// Landscape 05 — Voice SOS (`48-5810`). Speech recognition is NOT connected:
/// "Simulate Voice Command" plays a scripted sequence (see voice_demo.dart).
/// Figma shows a music-note glyph in the circle; kept as drawn.
class VoiceSosScreen extends StatefulWidget {
  const VoiceSosScreen({super.key});

  @override
  State<VoiceSosScreen> createState() => _VoiceSosScreenState();
}

class _VoiceSosScreenState extends State<VoiceSosScreen> {
  VoiceStage _stage = VoiceStage.idle;

  static const _actions = ['Call 999', 'Call Family', 'Call Spouse', 'Send SOS'];

  Future<void> _simulate() async {
    if (_stage != VoiceStage.idle) return;
    await runVoiceDemo(this, onStage: (s) => setState(() => _stage = s));
  }

  @override
  Widget build(BuildContext context) {
    final busy = _stage != VoiceStage.idle;
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
                    child: GestureDetector(
                      onTap: _simulate,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.greenTint,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _stage == VoiceStage.listening
                                    ? AppColors.greenAccent
                                    : Colors.transparent,
                                width: 3),
                          ),
                          child: Icon(Icons.music_note,
                              color: AppColors.greenAccent, size: context.u(40)),
                        ),
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
                          style: AppTypography.screenTitle.copyWith(fontSize: 26)),
                      SizedBox(height: context.u(10)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.u(16), vertical: context.u(8)),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderCard),
                          borderRadius: AppRadii.tileRadius,
                        ),
                        child: Text(
                            _stage == VoiceStage.heard ||
                                    _stage == VoiceStage.detected
                                ? '“$voicePhrase”'
                                : '“SOS, help me”',
                            style: AppTypography.cardTitle
                                .copyWith(fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(height: context.u(10)),
                      VoiceStageChips(stage: _stage),
                      SizedBox(height: context.u(12)),
                      PillButton(
                        label: busy ? 'Simulating…' : 'Simulate Voice Command',
                        background: AppColors.greenButton,
                        foreground: Colors.white,
                        outlined: false,
                        onPressed: busy ? null : _simulate,
                      ),
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
                        onPressed: () => i == 0
                            ? showPoliceContactDemo(context)
                            : showDemoDialog(context,
                                title: _actions[i],
                                message:
                                    'Calls and SOS dispatch are not part of this prototype.'),
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
