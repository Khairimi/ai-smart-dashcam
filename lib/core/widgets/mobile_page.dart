import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'mobile_header.dart';

/// Standard mobile screen frame: cream background, safe area, header, scrolling
/// column. Used by the DEMO mobile screens that have no dedicated Figma frame.
class MobilePage extends StatelessWidget {
  const MobilePage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgCreamMobile,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            MobileHeader(title: title),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
