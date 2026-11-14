import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers.dart';

/// DEMO camera switch: "Camera ON" / "Camera OFF". Tapping flips the visible
/// state only; no camera, permission or hardware is involved.
class CameraToggle extends ConsumerWidget {
  const CameraToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(cameraOnProvider);
    return PillButton(
      label: on ? 'Camera ON' : 'Camera OFF',
      background: on ? AppColors.greenTint : AppColors.redTint,
      foreground: on ? AppColors.greenAccent : AppColors.redSos,
      outlined: false,
      onPressed: () => ref.read(cameraOnProvider.notifier).set(!on),
    );
  }
}
