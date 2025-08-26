import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static Color eerieBlack = const Color(0xFF121212);
  static Color trueWhite = const Color(0xFFFFFFFF);
  static Color tropicalIndigo = const Color(0xFF9381FF);

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: eerieBlack,
      primaryColor: tropicalIndigo,
      textTheme: _textTheme(),
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      // Displays - Pour splash screens, onboarding
      displayLarge: GoogleFonts.lato(fontSize: 52.sp, fontWeight: FontWeight.w700, color: trueWhite),
      displayMedium: GoogleFonts.lato(fontSize: 28.sp, fontWeight: FontWeight.w600, color: trueWhite),
      displaySmall: GoogleFonts.lato(fontSize: 24.sp, fontWeight: FontWeight.w600, color: trueWhite),

      // Headlines - Titres de pages, sections principales
      headlineLarge: GoogleFonts.lato(fontSize: 24.sp, fontWeight: FontWeight.w600, color: trueWhite),
      headlineMedium: GoogleFonts.lato(fontSize: 20.sp, fontWeight: FontWeight.w600, color: trueWhite),
      headlineSmall: GoogleFonts.lato(fontSize: 18.sp, fontWeight: FontWeight.w500, color: trueWhite),

      // Titles - Noms produits, titres cards, prix principaux
      titleLarge: GoogleFonts.lato(fontSize: 18.sp, fontWeight: FontWeight.w600, color: trueWhite),
      titleMedium: GoogleFonts.lato(fontSize: 16.sp, fontWeight: FontWeight.w500, color: trueWhite),
      titleSmall: GoogleFonts.lato(fontSize: 14.sp, fontWeight: FontWeight.w500, color: trueWhite),

      // Body - Descriptions, texte courant
      bodyLarge: GoogleFonts.lato(fontSize: 16.sp, fontWeight: FontWeight.w400, color: trueWhite),
      bodyMedium: GoogleFonts.lato(fontSize: 14.sp, fontWeight: FontWeight.w400, color: trueWhite),
      bodySmall: GoogleFonts.lato(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey[600]),

      // Labels - Boutons, badges, infos secondaires
      labelLarge: GoogleFonts.lato(fontSize: 14.sp, fontWeight: FontWeight.w500, color: trueWhite),
      labelMedium: GoogleFonts.lato(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey[700]),
      labelSmall: GoogleFonts.lato(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.grey[600]),
    );
  }
}
