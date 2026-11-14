import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/widgets.dart';
import '../../shared/providers.dart';
import 'widgets/camera_feed.dart';
import 'widgets/camera_toggle.dart';

/// Landscape 01 — Dashcam – Front Camera (`48-5606`). Content only; header
/// and quick-nav come from the shell. The picture and timestamp are DEMO
/// values; the Camera ON/OFF button only changes what is shown.
class FrontCameraScreen extends ConsumerWidget {
  const FrontCameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CameraFeed(
      scene: CameraScene.front,
      label: 'FRONT CAMERA',
      timestamp: 'Jan 26, 2025   16:32:06',
      off: !ref.watch(cameraOnProvider),
      topRight: const CameraToggle(),
    );
  }
}
