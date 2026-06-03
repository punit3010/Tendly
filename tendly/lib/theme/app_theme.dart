import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TColors {
  TColors._();
  static const forest        = Color(0xFF0A3D2E);
  static const forestMid     = Color(0xFF1A5C44);
  static const forestLight   = Color(0xFF2E7D5A);
  static const teal          = Color(0xFF3D9970);
  static const tealSoft      = Color(0xFFE8F5EE);
  static const bg            = Color(0xFFFAFAF7);
  static const surface       = Color(0xFFFFFFFF);
  static const surface2      = Color(0xFFF4F4F0);
  static const terracotta    = Color(0xFFC4622D);
  static const terracottaSoft= Color(0xFFFAEEE6);
  static const textPrimary   = Color(0xFF0F1F19);
  static const textSecondary = Color(0xFF4A6355);
  static const textMuted     = Color(0xFF8FA99A);
  static const border        = Color(0xFFE8EDE8);
  static const mintAccent    = Color(0xFFA8DFC4);
  static const error         = Color(0xFFDC2626);
  // Room card gradients
  static const storyGradStart    = Color(0xFF0A3D2E);
  static const storyGradEnd      = Color(0xFF1A5C44);
  static const kitchenGradStart  = Color(0xFF5C3317);
  static const kitchenGradEnd    = Color(0xFF8B4C23);
  static const activitiesGradStart = Color(0xFF1A3A5C);
  static const activitiesGradEnd   = Color(0xFF2D5A8E);
  static const healthGradStart   = Color(0xFF3A1A5C);
  static const healthGradEnd     = Color(0xFF5E2D8E);
}

class TRadius {
  TRadius._();
  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(24));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(32));
}

class TShadow {
  TShadow._();
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F0A3D2E), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A0A3D2E), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x140A3D2E), blurRadius: 16, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0A0A3D2E), blurRadius: 6,  offset: Offset(0, 2)),
  ];
}

// Consistent header sizing across ALL screens
class THeader {
  THeader._();
  static const double sidePad      = 20.0;
  static const double bottomPad    = 14.0;
  static const double roomBotPad   = 18.0;
}

class TText {
  TText._();
  static TextStyle display(double size, {FontStyle style = FontStyle.normal, Color? color}) =>
      TextStyle(fontFamily: 'Fraunces', fontSize: size, fontWeight: FontWeight.w400,
          fontStyle: style, color: color, height: 1.15);

  static TextStyle body(double size,
          {FontWeight weight = FontWeight.w400, Color? color, double? height}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle eyebrow({Color? color}) => GoogleFonts.dmSans(
      fontSize: 10, fontWeight: FontWeight.w700,
      letterSpacing: 1.2, color: color ?? TColors.textMuted);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: TColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: TColors.forest,
      primary: TColors.forest,
      secondary: TColors.teal,
      surface: TColors.surface,
      error: TColors.error,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.forest,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.forest,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: TRadius.md),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    ),
    dividerColor: TColors.border,
  );
}
