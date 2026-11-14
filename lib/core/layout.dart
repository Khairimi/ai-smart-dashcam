import 'package:flutter/widgets.dart';

/// Width below which the mobile portrait layout is used (ARCHITECTURE.md).
const double kMobileBreakpoint = 768;

/// In-car layout reference width (Figma frame 1672 × 941).
const double kInCarReferenceWidth = 1672;

extension LayoutContext on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < kMobileBreakpoint;

  /// Scales a logical size with the in-car text scaler so paddings/icons keep
  /// the same proportions as text. On mobile the scaler is the user's.
  double u(double v) => MediaQuery.textScalerOf(this).scale(v);
}
