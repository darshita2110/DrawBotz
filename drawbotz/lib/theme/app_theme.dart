import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color yolk      = Color(0xFFFFD93D);
  static const Color yolkDark  = Color(0xFFF4B400);
  static const Color coral     = Color(0xFFFF6B6B);
  static const Color coralDeep = Color(0xFFE84545);
  static const Color mint      = Color(0xFF6BCFB4);
  static const Color lavender  = Color(0xFFA78BFA);
  static const Color sky       = Color(0xFF60C5F1);
  static const Color cream     = Color(0xFFFFF8E7);
  static const Color ink       = Color(0xFF1A1A2E);
  static const Color inkSoft   = Color(0xFF2D2D44);
  static const Color inkMuted  = Color(0xFF16213E);
  static const Color inkDeep   = Color(0xFF060C14);
  static const Color glassLight  = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);

  static const LinearGradient coralGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, Color(0xFFFF9150)],
  );
  static const LinearGradient lavGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lavender, Color(0xFF7C3AED)],
  );
  static const LinearGradient bgGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D0D1F), Color(0xFF1A1A2E), Color(0xFF0F2240)],
    stops: [0.0, 0.4, 1.0],
  );
  static const LinearGradient mintLavGrad = LinearGradient(
    colors: [mint, lavender],
  );
}

class AppTextStyles {
  static TextStyle display(double size, Color color) =>
      GoogleFonts.fredoka(fontSize: size, fontWeight: FontWeight.w700, color: color);
  static TextStyle bold(double size, Color color) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: FontWeight.w800, color: color);
  static TextStyle semiBold(double size, Color color) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: FontWeight.w700, color: color);
  static TextStyle regular(double size, Color color) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: FontWeight.w600, color: color);
  static TextStyle caption(double size, Color color) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.ink,
    colorScheme: ColorScheme.dark(
      primary: AppColors.coral,
      secondary: AppColors.mint,
      tertiary: AppColors.lavender,
      surface: AppColors.inkSoft,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
  );
}