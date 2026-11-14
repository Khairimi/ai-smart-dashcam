import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

enum CameraScene { front, cabin }

/// Flat vector stand-in for the Figma camera illustrations (sky / trees / road
/// for front; cabin interior for cabin). Approximate geometry — not a live feed.
class CameraFeedPlaceholder extends StatelessWidget {
  const CameraFeedPlaceholder({super.key, this.scene = CameraScene.front});

  final CameraScene scene;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.cardRadius,
      child: CustomPaint(
        painter: _ScenePainter(scene),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene);
  final CameraScene scene;

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    void rect(double t, double b, Color c) {
      p.color = c;
      canvas.drawRect(Rect.fromLTRB(0, s.height * t, s.width, s.height * b), p);
    }

    if (scene == CameraScene.front) {
      rect(0, .56, AppColors.sceneSky);
      rect(.56, .98, const Color(0xFF86A66B));
      rect(.58, 1, AppColors.sceneRoad);
      p.color = AppColors.sceneTrees;
      for (var i = 0; i < 7; i++) {
        canvas.drawCircle(
            Offset(s.width * (.08 + i * .14), s.height * .62), s.height * .12, p);
      }
      p.color = const Color(0xFF6A6E75);
      canvas.drawRect(
          Rect.fromLTWH(s.width * .40, s.height * .60, s.width * .2, s.height * .4),
          p);
      p.color = const Color(0xFF3A4450);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  s.width * .43, s.height * .64, s.width * .1, s.height * .2),
              const Radius.circular(10)),
          p);
    } else {
      rect(0, .2, const Color(0xFF948E88));
      rect(.2, .74, const Color(0xFFB8B2AB));
      rect(.74, 1, const Color(0xFF636363));
      p.color = const Color(0xFFE0BB9B);
      canvas.drawCircle(Offset(s.width * .2, s.height * .32), s.height * .18, p);
      p.color = const Color(0xFF3F4A57);
      canvas.drawRect(
          Rect.fromLTWH(s.width * .13, s.height * .5, s.width * .15, s.height * .3),
          p);
      p.color = const Color(0xFFD4AC9B);
      canvas.drawCircle(Offset(s.width * .76, s.height * .45), s.height * .1, p);
      p.color = const Color(0xFFE5BDB9);
      canvas.drawRect(
          Rect.fromLTWH(s.width * .72, s.height * .55, s.width * .1, s.height * .2),
          p);
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.scene != scene;
}
