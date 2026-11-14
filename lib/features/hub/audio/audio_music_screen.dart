import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_providers.dart';

/// Landscape 08 — Audio & Music (`48-5958`). Toggles are local state. The
/// player and the "AI recommended" track are DEMO only: no audio plays.
class AudioMusicScreen extends ConsumerStatefulWidget {
  const AudioMusicScreen({super.key});

  @override
  ConsumerState<AudioMusicScreen> createState() => _AudioMusicScreenState();
}

class _AudioMusicScreenState extends ConsumerState<AudioMusicScreen> {
  bool _playing = false;

  Widget _toggle(Setting setting) {
    final on = ref.watch(settingsProvider)[setting];
    return OnToggleChip(
      value: on,
      onChanged: (v) => ref.read(settingsProvider.notifier).set(setting, v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = context.u(14);
    final rows = <(String, String, Widget)>[
      ('System Audio', 'Customize system audio', _toggle(Setting.audioSystem)),
      ('Alert Sound', 'Customize alert sound',
          StatusPill(
              label: alertSounds[ref.watch(alertSoundProvider)],
              background: AppColors.greenToggleBg,
              onTap: () => ref
                  .read(alertSoundProvider.notifier)
                  .step(alertSounds.length))),
      ('Voice Guidance', 'Customize voice guidance', _toggle(Setting.audioVoice)),
      ('In-Cabin Music', 'Customize in-cabin music', _toggle(Setting.audioCabin)),
    ];
    final aiPref = ref.watch(settingsProvider)[Setting.audioAiPreference];
    final track = audioTracks[ref.watch(audioTrackProvider)];
    void skip(int by) =>
        ref.read(audioTrackProvider.notifier).step(audioTracks.length, by: by);
    return Column(
      children: [
        CreamCard(
          padding: EdgeInsets.symmetric(
              horizontal: context.u(22), vertical: context.u(12)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Audio & Music Settings', style: AppTypography.cardTitle),
                Text(
                    'Manage system audio, alerts, voice guidance, and in-cabin music',
                    style: AppTypography.caption),
              ],
            ),
          ),
        ),
        SizedBox(height: gap),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 10,
                child: Column(children: [
                  for (final r in rows)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: context.u(6)),
                        child: SettingRow(
                          icon: Icons.music_note,
                          title: r.$1,
                          subtitle: r.$2,
                          trailing: r.$3,
                          iconSize: context.u(34),
                          scale: context.u(1),
                        ),
                      ),
                    ),
                ]),
              ),
              SizedBox(width: gap),
              Expanded(
                flex: 11,
                child: Container(
                  padding: EdgeInsets.all(context.u(20)),
                  decoration: BoxDecoration(
                    color: AppColors.greenTint,
                    borderRadius: AppRadii.cardRadius,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(track.$1, style: AppTypography.cardTitle),
                        ),
                        const SimulatedBadge(),
                      ]),
                      SizedBox(height: context.u(6)),
                      Text(track.$2,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textPrimary)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ctl(Icons.skip_previous, 'Previous', () => skip(-1 + audioTracks.length)),
                          _ctl(_playing ? Icons.pause : Icons.play_arrow,
                              _playing ? 'Pause' : 'Play',
                              () => setState(() => _playing = !_playing)),
                          _ctl(Icons.skip_next, 'Next', () => skip(1)),
                        ],
                      ),
                      const Spacer(),
                      Center(
                          child: Text('Volume 70%',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.greenAccent))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: gap),
        CreamCard(
          padding: EdgeInsets.symmetric(
              horizontal: context.u(16), vertical: context.u(8)),
          child: Row(children: [
            Expanded(
              child: Text(
                  'Music Preference (AI Suggestion)  •  ${aiPref ? 'On' : 'Off'}',
                  style: AppTypography.label),
            ),
            _toggle(Setting.audioAiPreference),
          ]),
        ),
      ],
    );
  }

  Widget _ctl(IconData icon, String tip, VoidCallback? onTap) => IconButton(
        tooltip: tip,
        onPressed: onTap,
        iconSize: context.u(30),
        color: AppColors.greenAccent,
        icon: Icon(icon),
      );
}
