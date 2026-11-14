import 'package:flutter/painting.dart';

/// Colour tokens from docs/FIGMA_AUDIT.md §4.
///
/// VERIFICATION STATUS: every value is *sampled* from screenshots (±2–4 per
/// channel) or *estimated*. None has been read from Figma Inspect. Values
/// marked "estimated" were not sampled at all. Replace once confirmed.
abstract final class AppColors {
  // Backgrounds & surfaces (sampled)
  static const Color bgCream = Color(0xFFFAF1E8);
  static const Color bgCreamMobile = Color(0xFFF9F0E7);
  static const Color surfaceCard = Color(0xFFFFF7F2);
  static const Color surfaceCardMobile = Color(0xFFFEF9F3);

  // Lines & text (estimated)
  static const Color borderCard = Color(0xFFF1E3D8);
  static const Color textPrimary = Color(0xFF3B302A);
  static const Color textSecondary = Color(0xFF7A6E66);

  // Red (sampled)
  static const Color redSos = Color(0xFFE45149);
  static const Color redRecDot = Color(0xFFEA6659);
  static const Color redTint = Color(0xFFFDE4DF);
  static const Color redSosButton = Color(0xFFE3968C); // "approx" in audit

  // Green
  static const Color greenTint = Color(0xFFE6F2DE);
  static const Color greenAccent = Color(0xFF4E9049);
  static const Color greenButton = Color(0xFF5A9A5E); // "~" in audit
  static const Color greenToggleBg = Color(0xFFD9EBD5); // "approx" in audit

  // Blue
  static const Color blueTint = Color(0xFFE7EEF6);
  static const Color blueSlate = Color(0xFF4A6E86); // range #4A6E86–#507999
  static const Color blueNavActive = Color(0xFFBBC9D4);

  // Purple
  static const Color purpleTint = Color(0xFFE9E4F8);

  // Illustrated camera placeholder scene
  static const Color sceneSky = Color(0xFFB2C8D5);
  static const Color sceneTrees = Color(0xFF6D8E59);
  static const Color sceneRoad = Color(0xFF7E828B);
}
