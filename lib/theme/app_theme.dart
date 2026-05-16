import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  final textTheme = GoogleFonts.cormorantGaramondTextTheme().copyWith(
    headlineLarge: GoogleFonts.cormorantGaramond(
      fontSize: 52,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      height: 1.02,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 34,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
      letterSpacing: 0.2,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15,
      color: AppColors.textPrimary,
      height: 1.55,
    ),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
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
      seedColor: AppColors.bronze,
      brightness: Brightness.light,
      primary: AppColors.bronze,
      secondary: AppColors.ink,
      surface: Colors.white,
    ),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceTint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF9B8675),
        fontSize: 14,
      ),
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
        borderSide: const BorderSide(color: AppColors.bronze, width: 1.4),
      ),
    ),
  );
}
