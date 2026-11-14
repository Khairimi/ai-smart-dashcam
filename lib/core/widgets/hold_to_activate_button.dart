import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Press-and-hold button. Fills while held; calls [onActivated] only if the
/// pointer stays down for [duration]. Releasing early cancels.
class HoldToActivateButton extends StatefulWidget {
  const HoldToActivateButton({
    super.key,
    required this.label,
    required this.onActivated,
    required this.background,
    required this.fill,
    this.foreground = Colors.white,
    this.duration = const Duration(seconds: 2),
  });

  final String label;
  final VoidCallback onActivated;
  final Color background;
  final Color fill;
  final Color foreground;
  final Duration duration;

  @override
  State<HoldToActivateButton> createState() => _HoldToActivateButtonState();
}

class _HoldToActivateButtonState extends State<HoldToActivateButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) {
            widget.onActivated();
            _c.value = 0;
          }
        });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      hint: 'Press and hold for ${widget.duration.inSeconds} seconds',
      child: Listener(
        onPointerDown: (_) => _c.forward(),
        onPointerUp: (_) => _c.reverse(),
        onPointerCancel: (_) => _c.reverse(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(child: ColoredBox(color: widget.background)),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _c.value,
                      child: ColoredBox(color: widget.fill),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(widget.label,
                      textAlign: TextAlign.center,
                      style: AppTypography.cardTitle
                          .copyWith(color: widget.foreground)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
