import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';

/// Nexio AI — landscape 10 (`48-6070`) and mobile "AI Assistant" (`9-356`).
/// Replies come from a SIMULATED service; no AI model or microphone is used.
class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ask(String q) async {
    final text = q.trim();
    if (text.isEmpty) return;
    if (text == 'Find a nearby rest stop') {
      context.go('/ai/rest-stop');
      return;
    }
    final reply = await ref.read(assistantServiceProvider).reply(text);
    if (!mounted) return;
    _controller.clear();
    await showDemoDialog(context, title: 'Nexio AI', message: reply);
  }

  Widget _input({bool landscape = false}) => TextField(
        controller: _controller,
        onSubmitted: _ask,
        style: AppTypography.body,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Type a message…',
          hintStyle: AppTypography.caption,
          prefixIcon: landscape ? const Icon(Icons.music_note, size: 14) : null,
          suffixIcon: landscape
              ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                      widthFactor: 1,
                      child: Text('● Listening…',
                          style: TextStyle(fontSize: 11))),
                )
              : IconButton(
                  tooltip: 'Send',
                  icon: const Icon(Icons.send, size: 16),
                  onPressed: () => _ask(_controller.text),
                ),
          filled: true,
          fillColor: landscape ? AppColors.surfaceCard : const Color(0xFFEFE4D9),
          border: OutlineInputBorder(
            borderRadius: AppRadii.pillRadius,
            borderSide: landscape
                ? const BorderSide(color: AppColors.borderCard)
                : BorderSide.none,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) =>
      context.isMobile ? _mobile(context) : _landscape(context);

  static const _suggestions = [
    'Is there any safety alert?',
    'Find a nearby rest stop',
    'Show my latest recording',
    'How can I drive safer?',
  ];
  static const _assist = [
    'Forward Collision Warning',
    'Lane Departure Warning',
    'Speed Limit Recognition',
    'Voice Command Control',
    'AI Rest Break Reminder',
  ];

  Widget _landscape(BuildContext context) {
    final gap = context.u(16);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 11,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(children: [
                    Container(
                      width: context.u(120),
                      height: context.u(120),
                      decoration: const BoxDecoration(
                          color: AppColors.purpleTint, shape: BoxShape.circle),
                    ),
                    SizedBox(width: context.u(24)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('How can I help?',
                              style: AppTypography.screenTitle
                                  .copyWith(fontSize: 26)),
                          SizedBox(height: context.u(8)),
                          Text(
                              'Ask about vehicle status, alerts, nearby rest stops or driving safety.',
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: context.u(10)),
                _input(landscape: true),
                SizedBox(height: context.u(12)),
                Text('Suggested Questions', style: AppTypography.cardTitle),
                SizedBox(height: context.u(8)),
                Wrap(
                  spacing: context.u(18),
                  runSpacing: context.u(8),
                  children: [
                    for (final s in _suggestions)
                      InkWell(
                        onTap: () => _ask(s),
                        child: Text(s, style: AppTypography.caption),
                      ),
                  ],
                ),
                SizedBox(height: context.u(4)),
                const Align(
                    alignment: Alignment.centerRight, child: SimulatedBadge()),
              ],
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: 10,
          child: CreamCard(
            padding: EdgeInsets.all(context.u(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Road Safety Assistance', style: AppTypography.cardTitle),
                SizedBox(height: context.u(10)),
                for (final a in _assist)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: context.u(8)),
                      child: Material(
                        color: AppColors.surfaceCard,
                        shape: StadiumBorder(
                            side: BorderSide(color: AppColors.borderCard)),
                        child: InkWell(
                          customBorder: const StadiumBorder(),
                          onTap: () => _ask(a),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.u(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(a,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.label),
                            ),
                          ),
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

  Widget _mobile(BuildContext context) {
    final restOn = ref.watch(togglesProvider)['ai.restBreak'] ?? false;
    const items = [
      ('Forward Collision Warning', 'Potential collision risk ahead'),
      ('Lane Departure Warning', 'Unintentional lane drift'),
      ('Speed Limit Recognition', 'Recognized signs & speed alerts'),
      ('Voice Command Control', 'SOS, recordings and navigation'),
    ];
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const MobileHeader(title: 'AI Assistant'),
            const SizedBox(height: 16),
            CreamCard(
              color: AppColors.surfaceCardMobile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.auto_awesome, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text('How can I help?',
                            style: AppTypography.screenTitle
                                .copyWith(fontSize: 19))),
                    const SimulatedBadge(),
                  ]),
                  const SizedBox(height: 8),
                  Text(
                      'Ask about vehicle status, alerts, nearby rest stops or incident videos.',
                      style: AppTypography.caption),
                  const SizedBox(height: 12),
                  _input(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Road Safety Assistance',
                style: AppTypography.cardTitle.copyWith(fontSize: 17)),
            const SizedBox(height: 10),
            for (final i in items) ...[
              SettingRow(
                icon: Icons.radio_button_checked,
                title: i.$1,
                subtitle: i.$2,
                color: AppColors.surfaceCardMobile,
                onTap: () => _ask(i.$1),
              ),
              const SizedBox(height: 10),
            ],
            SettingRow(
              icon: Icons.coffee_outlined,
              title: 'AI Rest Break Reminder',
              subtitle: 'Suggests a rest break after long driving',
              color: AppColors.surfaceCardMobile,
              trailing: OnToggleChip(
                value: restOn,
                onChanged: (v) =>
                    ref.read(togglesProvider.notifier).set('ai.restBreak', v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
