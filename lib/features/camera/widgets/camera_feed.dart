import 'package:flutter/material.dart';

import '../../../core/layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';

/// Cream pill with a dark dot, used for feed labels ("● FRONT CAMERA").
class FeedPill extends StatelessWidget {
  const FeedPill({
    super.key,
    required this.label,
    this.background = AppColors.surfaceCard,
    this.foreground = AppColors.textPrimary,
    this.dot = true,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.u(14), vertical: context.u(8)),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: context.u(7),
              height: context.u(7),
              decoration:
                  BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            SizedBox(width: context.u(6)),
          ],
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(color: foreground)),
          ),
        ],
      ),
    );
  }
}

/// Camera feed with the Figma overlays. The picture is a vector placeholder
/// (SIMULATED) — no camera is connected.
class CameraFeed extends StatelessWidget {
  const CameraFeed({
    super.key,
    required this.scene,
    required this.label,
    this.labelBackground = AppColors.surfaceCard,
    this.timestamp,
    this.topRight,
    this.overlay,
    this.off = false,
  });

  final CameraScene scene;
  final String label;
  final Color labelBackground;

  /// Front camera shows a date/time pill (simulated value).
  final String? timestamp;
  final Widget? topRight;
  final Widget? overlay;

  /// DEMO camera switched off: hides the picture and shows "Front Camera OFF"
  /// or "Cabin Camera OFF" (the FRONT / CABIN CAMERA label is kept).
  final bool off;

  @override
  Widget build(BuildContext context) {
    final pad = context.u(14);
    return Stack(
      fit: StackFit.expand,
      children: [
        if (off) _OffPanel(scene: scene) else CameraFeedPlaceholder(scene: scene),
        if (timestamp != null && !off)
          Positioned(
            left: pad,
            top: pad,
            child: FeedPill(
              label: timestamp!,
              dot: false,
              background: AppColors.redTint,
            ),
          ),
        Positioned(
          right: pad,
          top: pad,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            ?topRight,
            if (topRight != null) SizedBox(width: context.u(8)),
            const SimulatedBadge(),
          ]),
        ),
        Positioned(
          left: pad,
          bottom: pad,
          child: FeedPill(label: label, background: labelBackground),
        ),
        ?overlay,
      ],
    );
  }
}

class _OffPanel extends StatelessWidget {
  const _OffPanel({required this.scene});

  final CameraScene scene;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.cardRadius,
      child: ColoredBox(
        color: const Color(0xFF2E2A28),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_outlined,
                  color: Colors.white70, size: context.u(44)),
              SizedBox(height: context.u(8)),
              Text(scene == CameraScene.front ? 'Front Camera OFF' : 'Cabin Camera OFF',
                  style: AppTypography.cardTitle.copyWith(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
