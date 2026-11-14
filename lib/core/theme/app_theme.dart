import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Fully custom cream theme (not stock Material look).
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blueSlate,
          surface: AppColors.surfaceCard,
        ).copyWith(
          primary: AppColors.blueSlate,
          error: AppColors.redSos,
          surface: AppColors.surfaceCard,
        ),
        textTheme: TextTheme(
          titleLarge: AppTypography.screenTitle,
          titleMedium: AppTypography.cardTitle,
          bodyMedium: AppTypography.body,
          labelMedium: AppTypography.label,
          bodySmall: AppTypography.caption,
        ),
      );
}
