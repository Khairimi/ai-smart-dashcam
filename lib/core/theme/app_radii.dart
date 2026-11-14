import 'package:flutter/painting.dart';

/// Radii per FIGMA_AUDIT §4 "Shape" — ESTIMATED (cards 16–20 → 18, tiles ~14).
abstract final class AppRadii {
  static const double card = 18;
  static const double tile = 14;
  static const double pill = 999;

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get tileRadius => BorderRadius.circular(tile);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}
