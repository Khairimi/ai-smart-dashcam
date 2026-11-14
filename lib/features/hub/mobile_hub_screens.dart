import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import '../settings/domain/app_settings.dart';
import '../settings/presentation/settings_providers.dart';

/// Mobile Smart Hub (DEMO layout): the same three destinations as the
/// landscape hub, as a list.
class MobileSmartHubScreen extends StatelessWidget {
  const MobileSmartHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, Color, String, String, String)>[
      (Icons.music_note, AppColors.purpleTint, 'Audio & Music',
          'Play music, radio, and manage in-car audio', '/hub/audio'),
      (Icons.crop_square_outlined, AppColors.blueTint, 'Records & Evidence',
          'View recordings, manage alerts, and set safety rules', '/records'),
      (Icons.auto_awesome_outlined, AppColors.redTint, 'Nexio AI',
          'Get driving help, quick answers and hands-free control', '/ai'),
    ];
    return MobilePage(
      title: 'Smart Hub',
      children: [
        for (final i in items) ...[
          CreamCard(
            color: AppColors.surfaceCardMobile,
            onTap: () => context.go(i.$5),
            child: Row(children: [
              IconBadge(icon: i.$1, circle: true, size: 48, background: i.$2),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i.$3, style: AppTypography.cardTitle),
                    Text(i.$4, style: AppTypography.caption),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ]),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Mobile Audio & Music (DEMO layout: the Figma frame is unfinished). The
/// toggles are real settings; the player is a DEMO and plays no audio.
class MobileAudioScreen extends ConsumerStatefulWidget {
  const MobileAudioScreen({super.key});

  @override
  ConsumerState<MobileAudioScreen> createState() => _MobileAudioScreenState();
}

class _MobileAudioScreenState extends ConsumerState<MobileAudioScreen> {
  bool _playing = false;

  Widget _toggle(Setting s) => OnToggleChip(
        value: ref.watch(settingsProvider)[s],
        onChanged: (v) => ref.read(settingsProvider.notifier).set(s, v),
      );

  @override
  Widget build(BuildContext context) {
    const card = AppColors.surfaceCardMobile;
    final track = audioTracks[ref.watch(audioTrackProvider)];
    void cycleAlert() =>
        ref.read(alertSoundProvider.notifier).step(alertSounds.length);
    void skip(int by) =>
        ref.read(audioTrackProvider.notifier).step(audioTracks.length, by: by);
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
    return MobilePage(
      title: 'Audio & Music',
      children: [
        for (final r in rows) ...[
          SettingRow(
              icon: Icons.music_note,
              title: r.$1,
              subtitle: r.$2,
              trailing: r.$3,
              onTap: r.$1 == 'Alert Sound' ? cycleAlert : null,
              color: card),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.greenTint,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(track.$1, style: AppTypography.cardTitle)),
                const SimulatedBadge(),
              ]),
              const SizedBox(height: 4),
              Text(track.$2,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      tooltip: 'Previous',
                      iconSize: 30,
                      color: AppColors.greenAccent,
                      onPressed: () => skip(-1 + audioTracks.length),
                      icon: const Icon(Icons.skip_previous)),
                  IconButton(
                      tooltip: _playing ? 'Pause' : 'Play',
                      iconSize: 36,
                      color: AppColors.greenAccent,
                      onPressed: () => setState(() => _playing = !_playing),
                      icon: Icon(_playing ? Icons.pause : Icons.play_arrow)),
                  IconButton(
                      tooltip: 'Next',
                      iconSize: 30,
                      color: AppColors.greenAccent,
                      onPressed: () => skip(1),
                      icon: const Icon(Icons.skip_next)),
                ],
              ),
              Center(
                  child: Text('Volume 70%',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.greenAccent))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SettingRow(
          icon: Icons.auto_awesome_outlined,
          title: 'Music Preference (AI Suggestion)',
          trailing: _toggle(Setting.audioAiPreference),
          color: card,
        ),
      ],
    );
  }
}
