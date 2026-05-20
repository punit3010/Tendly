import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TendlyColors {
  static const Color primary       = Color(0xFF1D9E75);
  static const Color primaryLight  = Color(0xFF9FE1CB);
  static const Color primaryMist   = Color(0xFFE1F5EE);
  static const Color primaryDark   = Color(0xFF0F6E56);
  static const Color primaryDeep   = Color(0xFF085041);
  static const Color background    = Color(0xFFF0FAF5);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color border        = Color(0xFFD0EDE3);
  static const Color textPrimary   = Color(0xFF085041);
  static const Color textSecondary = Color(0xFF0F6E56);
  static const Color textHint      = Color(0xFF9FE1CB);
  static const Color amber         = Color(0xFFEF9F27);
  static const Color amberLight    = Color(0xFFFAEEDA);
  static const Color amberDark     = Color(0xFF633806);
}

class TendlyTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ColorScheme.light(
      primary:    TendlyColors.primary,
      secondary:  TendlyColors.primaryLight,
      surface:    TendlyColors.surface,
    ),
    scaffoldBackgroundColor: TendlyColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor:  TendlyColors.primary,
      foregroundColor:  Colors.white,
      elevation:        0,
      centerTitle:      true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:  TendlyColors.primary,
        foregroundColor:  Colors.white,
        minimumSize:      const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: TendlyColors.textPrimary,
        minimumSize:     const Size(double.infinity, 48),
        side:            const BorderSide(color: TendlyColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:      true,
      fillColor:   TendlyColors.surface,
      hintStyle:   GoogleFonts.poppins(
        color: TendlyColors.textHint, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TendlyColors.border)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TendlyColors.border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: TendlyColors.primary, width: 1.5)),
    ),
  );
}
