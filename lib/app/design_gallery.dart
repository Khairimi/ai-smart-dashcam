import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/widgets.dart';

/// Temporary dev page showing every Phase 3 component. Replaced by the real
/// shells/routes in Phase 4.
class DesignGallery extends StatefulWidget {
  const DesignGallery({super.key});

  @override
  State<DesignGallery> createState() => _DesignGalleryState();
}

class _DesignGalleryState extends State<DesignGallery> {
  bool _on = true;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const InCarHeader(
                title: 'Design system gallery',
                recElapsed: Duration(minutes: 12, seconds: 34)),
            const SizedBox(height: AppSpacing.lg),
            Row(children: const [
              StatusPill(label: 'Trip Currently Shared'),
              SizedBox(width: AppSpacing.md),
              StatusPill(
                  label: 'Jan 26, 2025  16:32:06',
                  background: AppColors.redTint,
                  foreground: AppColors.textPrimary),
              SizedBox(width: AppSpacing.md),
              SimulatedBadge(),
            ]),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 220,
              child: Row(children: const [
                Expanded(child: CameraFeedPlaceholder()),
                SizedBox(width: AppSpacing.lg),
                Expanded(child: CameraFeedPlaceholder(scene: CameraScene.cabin)),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            CreamCard(
              child: Row(children: [
                const IconBadge(icon: Icons.sensors),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                    child: Text('Motion Detection',
                        style: AppTypography.cardTitle)),
                OnToggleChip(value: _on, onChanged: (v) => setState(() => _on = v)),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(spacing: AppSpacing.md, runSpacing: AppSpacing.md, children: [
              PillButton(label: 'Start Sharing', onPressed: () {}),
              PillButton(
                  label: 'Find Nearest Rest Stop',
                  onPressed: () {},
                  background: AppColors.greenButton,
                  foreground: Colors.white,
                  outlined: false),
            ]),
            const SizedBox(height: AppSpacing.xl),
            QuickNavBar(onSelected: (_) {}),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: SizedBox(
                width: 378,
                child: MobileBottomNav(
                    currentIndex: _tab,
                    onSelected: (i) => setState(() => _tab = i)),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SizedBox(
                height: 200,
                child: IncompleteScreen(title: '03 • AI Cabin Monitoring')),
          ],
        ),
      ),
    );
  }
}
