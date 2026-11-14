import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../settings/domain/app_settings.dart';
import '../settings/presentation/settings_providers.dart';
import 'voice_demo.dart';

const _callNote =
    'Placing calls is not wired in this prototype. In a real build this would '
    'call the emergency service.';

/// Mobile Manual SOS (DEMO layout: no Figma frame). Built from the landscape
/// screen's content in a single column. The hold gesture is real, the outcome
/// is a DEMO dialog: nothing is sent and no call is placed.
class MobileManualSosScreen extends ConsumerWidget {
  const MobileManualSosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discreet = ref.watch(settingsProvider)[Setting.sosDiscreetMode];
    void call(String who) =>
        showDemoDialog(context, title: who, message: _callNote);
    return MobilePage(
      title: 'Manual SOS / Guardian Mode',
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.redSos,
            borderRadius: AppRadii.cardRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Emergency SOS',
                      style: AppTypography.screenTitle
                          .copyWith(color: Colors.white, fontSize: 20)),
                ),
                const SimulatedBadge(),
              ]),
              const SizedBox(height: 6),
              Text(
                'Send live location, dashcam clips and trip details to emergency contacts.',
                style: AppTypography.caption.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 14),
              HoldToActivateButton(
                label: 'Hold to Activate SOS',
                background: AppColors.redSosButton,
                fill: const Color(0xFFC93A33),
                onActivated: () => showDemoDialog(context,
                    title: 'SOS activated',
                    message:
                        'In a real build this would alert your emergency contacts. Dispatch is not connected.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SettingRow(
          icon: Icons.my_location,
          title: 'Current Location',
          subtitle: 'Highway A1, Km 120.5',
          color: AppColors.surfaceCardMobile,
        ),
        const SizedBox(height: 10),
        const SettingRow(
          icon: Icons.groups_outlined,
          title: 'Emergency Contacts',
          subtitle: '✓ Dad   •   ✓ Sister',
          color: AppColors.surfaceCardMobile,
        ),
        const SizedBox(height: 14),
        PillButton(
          label: discreet ? 'Discreet Mode: On' : 'Discreet Mode',
          background:
              discreet ? AppColors.greenToggleBg : AppColors.surfaceCardMobile,
          onPressed: () => ref
              .read(settingsProvider.notifier)
              .set(Setting.sosDiscreetMode, !discreet),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
              child: PillButton(
                  label: 'Call Ambulance',
                  background: AppColors.redTint,
                  onPressed: () => call('Call Ambulance'))),
          const SizedBox(width: 10),
          Expanded(
              child: PillButton(
                  label: 'Call Police',
                  background: AppColors.blueTint,
                  onPressed: () => call('Call Police'))),
        ]),
        const SizedBox(height: 10),
        PillButton(
            label: 'Call Emergency Contact',
            background: AppColors.greenTint,
            onPressed: () => call('Call Emergency Contact')),
      ],
    );
  }
}

/// Mobile Voice SOS (DEMO layout). "Simulate Voice Command" (or tapping the
/// microphone) plays the scripted sequence; no speech recognition exists.
class MobileVoiceSosScreen extends StatefulWidget {
  const MobileVoiceSosScreen({super.key});

  @override
  State<MobileVoiceSosScreen> createState() => _MobileVoiceSosScreenState();
}

class _MobileVoiceSosScreenState extends State<MobileVoiceSosScreen> {
  VoiceStage _stage = VoiceStage.idle;

  Future<void> _simulate() async {
    if (_stage != VoiceStage.idle) return;
    await runVoiceDemo(this, onStage: (s) => setState(() => _stage = s));
  }

  static const _actions = ['Call 999', 'Call Family', 'Call Spouse', 'Send SOS'];

  @override
  Widget build(BuildContext context) {
    final busy = _stage != VoiceStage.idle;
    return MobilePage(
      title: 'Voice SOS',
      children: [
        CreamCard(
          color: AppColors.surfaceCardMobile,
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Semantics(
              button: true,
              label: 'Tap the microphone to start the demo',
              child: GestureDetector(
                onTap: _simulate,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.greenTint,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: _stage == VoiceStage.listening
                            ? AppColors.greenAccent
                            : Colors.transparent,
                        width: 3),
                  ),
                  child: const Icon(Icons.mic,
                      color: AppColors.greenAccent, size: 52),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Say the command',
                style: AppTypography.screenTitle.copyWith(fontSize: 22)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderCard),
                borderRadius: AppRadii.tileRadius,
              ),
              child: Text(
                  _stage == VoiceStage.heard || _stage == VoiceStage.detected
                      ? '“$voicePhrase”'
                      : '“SOS, help me”',
                  style: AppTypography.cardTitle),
            ),
            const SizedBox(height: 12),
            VoiceStageChips(stage: _stage),
            const SizedBox(height: 14),
            PillButton(
              label: busy ? 'Simulating…' : 'Simulate Voice Command',
              background: AppColors.greenButton,
              foreground: Colors.white,
              outlined: false,
              onPressed: busy ? null : _simulate,
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Text('Quick Emergency Actions',
            style: AppTypography.cardTitle.copyWith(fontSize: 16)),
        const SizedBox(height: 10),
        for (var i = 0; i < _actions.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              for (var j = i; j < i + 2; j++) ...[
                if (j > i) const SizedBox(width: 10),
                Expanded(
                  child: PillButton(
                    label: _actions[j],
                    onPressed: () => j == 0
                        ? showPoliceContactDemo(context)
                        : showDemoDialog(context,
                            title: _actions[j], message: _callNote),
                  ),
                ),
              ],
            ]),
          ),
      ],
    );
  }
}
