import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.interTextTheme();
  final textTheme = baseTextTheme.copyWith(
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 52,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      height: 1.02,
      letterSpacing: -0.6,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
      letterSpacing: 0.15,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15,
      color: AppColors.textPrimary,
      height: 1.55,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      color: AppColors.textSecondary,
      height: 1.45,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
    ),
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBar,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
    ),
    cardColor: AppColors.card,
    dividerColor: AppColors.border,
    iconTheme: const IconThemeData(color: AppColors.ink),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceTint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: GoogleFonts.inter(color: AppColors.secondary, fontSize: 14),
      labelStyle: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.ink),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceTint,
      selectedColor: AppColors.glaze,
      disabledColor: AppColors.surfaceTint,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: AppColors.border),
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
