import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';
import 'widgets/camera_feed.dart';

/// Landscape 01 — Dashcam – Front Camera (`48-5606`). Content only; header
/// and quick-nav come from the shell. Timestamp is a simulated sample value.
class FrontCameraScreen extends StatelessWidget {
  const FrontCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CameraFeed(
      scene: CameraScene.front,
      label: 'FRONT CAMERA',
      timestamp: 'Jan 26, 2025   16:32:06',
    );
  }
}
