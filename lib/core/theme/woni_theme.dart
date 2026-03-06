import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_themes.dart';

// ─── COLOR TOKENS (dynamic per theme) ────────────────────────────────────────

class WoniColors {
  WoniColors._();

  // ── Current theme ──
  static WoniThemeData _t = kThemes[0]; // default: Winter Steel
  static void setTheme(WoniThemeData theme) => _t = theme;
  static WoniThemeData get current => _t;

  // ── Accent (theme-dependent) ──
  static Color get blue    => _t.accentLight;
  static Color get blueDark => _t.accent;
  static Color get blue50  => _t.accentLight.withValues(alpha: 0.08);
  static Color get blue100 => _t.accentLight.withValues(alpha: 0.15);
  static Color get blue700 => Color.lerp(_t.accentLight, Colors.black, 0.2)!;

  // ── Semantic colors (universal — don't change per theme) ──
  static const green    = Color(0xFF1A8A5A);
  static const green50  = Color(0xFFE5F7EE);
  static const green100 = Color(0xFFC8F0DA);
  static const green700 = Color(0xFF0F6B3A);

  static const coral    = Color(0xFFD43545);
  static const coral50  = Color(0xFFFFF0F0);
  static const coral100 = Color(0xFFFFDDE0);
  static const coral700 = Color(0xFFAA1525);

  static const violet   = Color(0xFF5E7EB8);
  static const warning  = Color(0xFFD48A15);

  static const greenDark  = Color(0xFF00E676);
  static const coralDark  = Color(0xFFFF5252);
  static const warningDark = Color(0xFFFFAB40);

  // ── Light theme neutrals (theme-dependent) ──
  static Color get lightBg          => _t.lightBg;
  static Color get lightSurface     => _t.lightSurface;
  static Color get lightSurface2    => _t.lightSurface2;
  static Color get lightSurface3    => _t.lightSurface3;
  static Color get lightBorder      => _t.lightBorder;
  static Color get lightBorderMuted => _t.lightBorderMuted;
  static Color get lightText1       => _t.lightText1;
  static Color get lightText2       => _t.lightText2;
  static Color get lightText3       => _t.lightText3;

  // ── Dark theme neutrals (theme-dependent) ──
  static Color get darkBg          => _t.darkBg;
  static Color get darkSurface     => _t.darkSurface;
  static Color get darkSurface2    => _t.darkSurface2;
  static Color get darkBorder      => _t.darkBorder;
  static Color get darkBorderMuted => _t.darkBorderMuted;
  static Color get darkText1       => _t.darkText1;
  static Color get darkText2       => _t.darkText2;
  static Color get darkText3       => _t.darkText3;

  // Shift type colors
  static Color get shiftRegular  => blue;
  static const shiftNight    = Color(0xFFD48A15);
  static const shiftHoliday  = Color(0xFFD43545);
  static const shiftOvertime = Color(0xFF5E7EB8);
}

// ─── TYPOGRAPHY (Inter) ──────────────────────────────────────────────────────

class WoniTextStyles {
  WoniTextStyles._();

  static final display = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.2,
  );

  static final heading1 = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.2,
  );

  static final heading2 = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w600, height: 1.3,
  );

  static final body = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodySecondary = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
  );

  static final caption = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.3,
  );

  static final amount = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, height: 1,
  );

  static final amountLarge = GoogleFonts.inter(
    fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1,
  );

  static final button = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600, height: 1,
  );

  static final label = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, height: 1,
  );
}

// ─── THEME ──────────────────────────────────────────────────────────────────

class WoniTheme {
  WoniTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark()  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final interFamily = GoogleFonts.inter().fontFamily;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? WoniColors.blueDark : WoniColors.blue,
      onPrimary: Colors.white,
      secondary: isDark ? WoniColors.greenDark : WoniColors.green,
      onSecondary: Colors.white,
      error: isDark ? WoniColors.coralDark : WoniColors.coral,
      onError: Colors.white,
      surface: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      onSurface: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
      fontFamily: interFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        elevation: 0, scrolledUnderElevation: 0,
        titleTextStyle: WoniTextStyles.heading2.copyWith(
          color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
        ),
        iconTheme: IconThemeData(
          color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        selectedItemColor: isDark ? WoniColors.blueDark : WoniColors.blue,
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
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDark ? WoniColors.darkBorderMuted : WoniColors.lightBorderMuted,
          ),
        ),
        color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? WoniColors.darkBorderMuted : WoniColors.lightBorderMuted,
        space: 0, thickness: 1,
      ),
    );
  }
}

// ─── SPACING ────────────────────────────────────────────────────────────────

class WoniSpacing {
  WoniSpacing._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double xxl  = 24;
  static const double xxxl = 32;
}

// ─── RADIUS ─────────────────────────────────────────────────────────────────

class WoniRadius {
  WoniRadius._();
  static const xs   = BorderRadius.all(Radius.circular(4));
  static const sm   = BorderRadius.all(Radius.circular(6));
  static const md   = BorderRadius.all(Radius.circular(8));
  static const lg   = BorderRadius.all(Radius.circular(12));
  static const xl   = BorderRadius.all(Radius.circular(16));
  static const full = BorderRadius.all(Radius.circular(9999));
}

// ─── SHADOWS ────────────────────────────────────────────────────────────────

class WoniShadows {
  WoniShadows._();

  static List<BoxShadow> sm(bool isDark) => [
    BoxShadow(color: Colors.black.withOpacity(isDark ? 0.20 : 0.04), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> md(bool isDark) => [
    BoxShadow(color: Colors.black.withOpacity(isDark ? 0.30 : 0.06), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> lg(bool isDark) => [
    BoxShadow(color: Colors.black.withOpacity(isDark ? 0.40 : 0.08), blurRadius: 24, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> blue() => [
    BoxShadow(color: WoniColors.blue.withOpacity(0.20), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> green() => [
    BoxShadow(color: WoniColors.green.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 3)),
  ];
}
