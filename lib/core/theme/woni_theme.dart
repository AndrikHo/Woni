import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── COLOR TOKENS ────────────────────────────────────────────────────────────

class WoniColors {
  WoniColors._();

  // Accent palette
  static const blue   = Color(0xFF4F8EF7);
  static const blue50 = Color(0xFFEBF2FE);
  static const blue100 = Color(0xFFD6E8FF);
  static const blue700 = Color(0xFF2B6FD4);

  static const green   = Color(0xFF34C579);
  static const green50 = Color(0xFFEAFAF2);
  static const green100 = Color(0xFFD1F5E1);
  static const green700 = Color(0xFF1D9455);

  static const coral   = Color(0xFFFF6B6B);
  static const coral50 = Color(0xFFFFF0F0);
  static const coral100 = Color(0xFFFFE0E0);
  static const coral700 = Color(0xFFD43535);

  static const violet = Color(0xFF7B6EF6);

  // Light theme neutrals
  static const lightBg       = Color(0xFFF7F8FA);
  static const lightSurface  = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF0F1F5);
  static const lightBorder   = Color(0x12000000);
  static const lightText1    = Color(0xFF0E0F11);
  static const lightText2    = Color(0xFF6B7280);
  static const lightText3    = Color(0xFFB0B7C3);

  // Dark theme neutrals
  static const darkBg       = Color(0xFF0D0E12);
  static const darkSurface  = Color(0xFF17191F);
  static const darkSurface2 = Color(0xFF21242D);
  static const darkBorder   = Color(0x12FFFFFF);
  static const darkText1    = Color(0xFFF0F1F5);
  static const darkText2    = Color(0xFF8A919E);
  static const darkText3    = Color(0xFF3D4250);

  // Shift type colors
  static const shiftRegular  = blue;
  static const shiftNight    = Color(0xFFF59E0B);
  static const shiftHoliday  = coral;
  static const shiftOvertime = violet;
}

// ─── TYPOGRAPHY ──────────────────────────────────────────────────────────────

class WoniTextStyles {
  WoniTextStyles._();

  static final display = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static final heading1 = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static final heading2 = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.3,
  );

  static final body = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static final bodySecondary = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final caption = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
    height: 1.4,
  );

  static final amount = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    height: 1,
  );

  static final amountLarge = GoogleFonts.nunito(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1,
  );

  static final button = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    height: 1,
  );

  static final label = GoogleFonts.nunito(
    fontSize: 9,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
    height: 1,
  );
}

// ─── THEME ───────────────────────────────────────────────────────────────────

class WoniTheme {
  WoniTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark()  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final nunitoFamily = GoogleFonts.nunito().fontFamily;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: WoniColors.blue,
      onPrimary: Colors.white,
      secondary: WoniColors.green,
      onSecondary: Colors.white,
      error: WoniColors.coral,
      onError: Colors.white,
      surface: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      onSurface: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
      fontFamily: nunitoFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: WoniTextStyles.heading2.copyWith(
          color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
        ),
        iconTheme: IconThemeData(
          color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        selectedItemColor: WoniColors.blue,
        unselectedItemColor: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: WoniTextStyles.label,
        unselectedLabelStyle: WoniTextStyles.label,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
          ),
        ),
        color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
        space: 0,
        thickness: 1,
      ),
    );
  }
}

// ─── SPACING ─────────────────────────────────────────────────────────────────

class WoniSpacing {
  WoniSpacing._();
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

// ─── RADIUS ──────────────────────────────────────────────────────────────────

class WoniRadius {
  WoniRadius._();
  static const sm  = BorderRadius.all(Radius.circular(10));
  static const md  = BorderRadius.all(Radius.circular(14));
  static const lg  = BorderRadius.all(Radius.circular(18));
  static const xl  = BorderRadius.all(Radius.circular(24));
  static const xxl = BorderRadius.all(Radius.circular(32));
  static const full = BorderRadius.all(Radius.circular(100));
}

// ─── SHADOWS ─────────────────────────────────────────────────────────────────

class WoniShadows {
  WoniShadows._();

  static List<BoxShadow> sm(bool isDark) => [
    BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> md(bool isDark) => [
    BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.4 : 0.09),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> blue() => [
    BoxShadow(
      color: WoniColors.blue.withOpacity(0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> green() => [
    BoxShadow(
      color: WoniColors.green.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
