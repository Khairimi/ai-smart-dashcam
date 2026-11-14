import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography. Family is PROVISIONAL (Inter-like per audit; not confirmed in
/// Inspect) and sizes are ESTIMATED from screenshots (title 20–22, card title
/// 15–18, body/caption 11–13). Note: google_fonts downloads at runtime;
/// bundle the confirmed family before offline in-car use (ARCHITECTURE.md).
abstract final class AppTypography {
  static TextStyle _base(double size, FontWeight weight, Color color) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

  static TextStyle get screenTitle =>
      _base(21, FontWeight.w600, AppColors.textPrimary);
  static TextStyle get cardTitle =>
      _base(16, FontWeight.w600, AppColors.textPrimary);
  static TextStyle get body =>
      _base(13, FontWeight.w400, AppColors.textPrimary);
  static TextStyle get label =>
      _base(12, FontWeight.w600, AppColors.textPrimary);
  static TextStyle get caption =>
      _base(11, FontWeight.w400, AppColors.textSecondary);
}
