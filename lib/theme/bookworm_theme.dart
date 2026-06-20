import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bookworm_colors.dart';

abstract final class BookwormTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: BookwormColors.primary,
      onPrimary: BookwormColors.onPrimary,
      primaryContainer: BookwormColors.primaryContainer,
      onPrimaryContainer: BookwormColors.onPrimaryContainer,
      secondary: BookwormColors.secondary,
      onSecondary: BookwormColors.onSecondary,
      secondaryContainer: BookwormColors.secondaryContainer,
      onSecondaryContainer: BookwormColors.secondary,
      tertiary: BookwormColors.tertiary,
      onTertiary: BookwormColors.onPrimary,
      tertiaryContainer: BookwormColors.tertiaryContainer,
      onTertiaryContainer: BookwormColors.onTertiaryFixed,
      error: BookwormColors.error,
      onError: BookwormColors.onPrimary,
      surface: BookwormColors.surface,
      onSurface: BookwormColors.onSurface,
      onSurfaceVariant: BookwormColors.onSurfaceVariant,
      outline: BookwormColors.outline,
      outlineVariant: BookwormColors.outlineVariant,
    );

    final headlineFont = GoogleFonts.notoSerifTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();
    final labelFont = GoogleFonts.publicSansTextTheme();

    final textTheme = bodyFont.copyWith(
      displayLarge: headlineFont.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: BookwormColors.onSurface,
      ),
      headlineLarge: headlineFont.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: BookwormColors.onSurface,
      ),
      headlineMedium: headlineFont.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: BookwormColors.onSurface,
      ),
      headlineSmall: headlineFont.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: BookwormColors.onSurface,
      ),
      titleLarge: headlineFont.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: BookwormColors.onSurface,
      ),
      titleMedium: headlineFont.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: BookwormColors.onSurface,
      ),
      bodyLarge: bodyFont.bodyLarge?.copyWith(color: BookwormColors.onSurface),
      bodyMedium: bodyFont.bodyMedium?.copyWith(color: BookwormColors.onSurface),
      bodySmall: bodyFont.bodySmall?.copyWith(
        color: BookwormColors.onSurfaceVariant,
      ),
      labelLarge: labelFont.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: labelFont.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 0.8,
      ),
      labelSmall: labelFont.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 10,
        letterSpacing: 1.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BookwormColors.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: BookwormColors.surface.withValues(alpha: 0.95),
        foregroundColor: BookwormColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.notoSerif(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: BookwormColors.primary,
          letterSpacing: -0.5,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BookwormColors.primary,
        foregroundColor: BookwormColors.onPrimary,
        elevation: 6,
      ),
      cardTheme: CardThemeData(
        color: BookwormColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: BookwormColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
