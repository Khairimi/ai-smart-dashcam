import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers.dart';

/// Landscape 08 — Audio & Music (`48-5958`). Toggles are local state. The
/// player and the "AI recommended" track are DEMO only: no audio plays.
class AudioMusicScreen extends ConsumerStatefulWidget {
  const AudioMusicScreen({super.key});

  @override
  ConsumerState<AudioMusicScreen> createState() => _AudioMusicScreenState();
}

class _AudioMusicScreenState extends ConsumerState<AudioMusicScreen> {
  bool _playing = false;

  Widget _toggle(String key) {
    final on = ref.watch(togglesProvider)[key] ?? false;
    return OnToggleChip(
      value: on,
      onChanged: (v) => ref.read(togglesProvider.notifier).set(key, v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = context.u(14);
    final rows = <(String, String, Widget)>[
      ('System Audio', 'Customize system audio', _toggle('audio.system')),
      ('Alert Sound', 'Customize alert sound',
          const StatusPill(label: 'Standard', background: AppColors.greenToggleBg)),
      ('Voice Guidance', 'Customize voice guidance', _toggle('audio.voice')),
      ('In-Cabin Music', 'Customize in-cabin music', _toggle('audio.cabin')),
    ];
    final aiPref = ref.watch(togglesProvider)['audio.aiPref'] ?? false;
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
                          child: Text('Calming Music – AI Recommended',
                              style: AppTypography.cardTitle),
                        ),
                        const SimulatedBadge(),
                      ]),
                      SizedBox(height: context.u(6)),
                      Text('Relaxing Ambient  •  30:00',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textPrimary)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ctl(Icons.skip_previous, 'Previous', null),
                          _ctl(_playing ? Icons.pause : Icons.play_arrow,
                              _playing ? 'Pause' : 'Play',
                              () => setState(() => _playing = !_playing)),
                          _ctl(Icons.skip_next, 'Next', null),
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
            _toggle('audio.aiPref'),
          ]),
        ),
      ],
    );
  }

  Widget _ctl(IconData icon, String tip, VoidCallback? onTap) => IconButton(
        tooltip: tip,
        onPressed: onTap ?? () {},
        iconSize: context.u(30),
        color: AppColors.greenAccent,
        icon: Icon(icon),
      );
}
