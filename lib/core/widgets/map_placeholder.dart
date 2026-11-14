import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Vector stand-in for map art. NOT a real map: no GPS or map provider is
/// connected. [dark] mimics the black map frame in landscape screen 11
/// (map art unverified at full resolution per FIGMA_AUDIT §1).
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.dark = false, this.markers = 6});

  final bool dark;
  final int markers;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Map placeholder',
      child: ClipRRect(
        borderRadius: AppRadii.tileRadius,
        child: CustomPaint(
          painter: _MapPainter(dark, markers),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.dark, this.markers);
  final bool dark;
  final int markers;

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = dark ? Colors.black : const Color(0xFFEAF0E4);
    canvas.drawRect(Offset.zero & s, p);
    final road = Paint()
      ..color = dark ? const Color(0xFF3A3A3A) : Colors.white
      ..strokeWidth = 3;
    for (var i = 1; i < 4; i++) {
      canvas.drawLine(Offset(0, s.height * i / 4), Offset(s.width, s.height * i / 4), road);
      canvas.drawLine(Offset(s.width * i / 4, 0), Offset(s.width * i / 4, s.height), road);
    }
    final dot = Paint()..color = const Color(0xFF3F8FE0);
    for (var i = 0; i < markers; i++) {
      canvas.drawCircle(
          Offset(s.width * (.15 + (i * .37) % .7), s.height * (.2 + (i * .29) % .6)),
          s.shortestSide * .035,
          dot);
    }
    canvas.drawCircle(Offset(s.width * .78, s.height * .3), s.shortestSide * .04,
        Paint()..color = AppColors.redSos);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.dark != dark || old.markers != markers;
}
