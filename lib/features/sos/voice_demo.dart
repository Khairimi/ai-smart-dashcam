import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

/// Stages of the scripted Voice SOS simulation.
enum VoiceStage { idle, listening, heard, detected }

const voicePhrase = 'Please help me';

/// Plays the scripted sequence: listening -> phrase heard -> emergency
/// detected -> Police Contact DEMO dialog. There is no microphone, speech
/// recognition, call, SMS or dispatch.
Future<void> runVoiceDemo(
  State state, {
  required void Function(VoiceStage) onStage,
}) async {
  onStage(VoiceStage.listening);
  await Future<void>.delayed(const Duration(milliseconds: 1400));
  if (!state.mounted) return;
  onStage(VoiceStage.heard);
  await Future<void>.delayed(const Duration(milliseconds: 1200));
  if (!state.mounted) return;
  onStage(VoiceStage.detected);
  await Future<void>.delayed(const Duration(milliseconds: 1200));
  if (!state.mounted) return;
  await showPoliceContactDemo(state.context, phrase: voicePhrase);
  if (state.mounted) onStage(VoiceStage.idle);
}

/// Status chips for each stage (plus the DEMO badge).
class VoiceStageChips extends StatelessWidget {
  const VoiceStageChips({super.key, required this.stage});

  final VoiceStage stage;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        switch (stage) {
          VoiceStage.idle => const StatusPill(
              label: 'Ready — press Simulate Voice Command',
              background: AppColors.surfaceCard,
              foreground: AppColors.textSecondary),
          VoiceStage.listening => const StatusPill(label: 'Listening…'),
          VoiceStage.heard =>
            const StatusPill(label: 'Heard: “$voicePhrase”'),
          VoiceStage.detected => const StatusPill(
              label: '⚠ Emergency Detected (simulated)',
              background: AppColors.redTint,
              foreground: AppColors.redSos),
        },
        const SimulatedBadge(),
      ],
    );
  }
}
