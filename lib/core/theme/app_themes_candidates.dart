import 'package:flutter/material.dart';
import 'app_themes.dart';

// ─── CANDIDATE THEMES ───────────────────────────────────────────────────────
//
// 7 тем-кандидатов из макета. Сохранены отдельно для выбора.
// Чтобы подключить — перенести нужные в kThemes (app_themes.dart)
// и добавить id в enum AppThemeId.
//
// 1. Steel & Sand     — Холодный премиум
// 2. Crimson Night     — Дерзкая тёмная
// 3. Mint Dark         — Свежая кибер
// 4. Neon Tropic       — Яркая тропик
// 5. Sky Lavender      — Воздушная пастель
// 6. Candy Pop         — Розовый + мятный
// 7. Dusk Palette      — Серо-голубой + розовый
// ─────────────────────────────────────────────────────────────────────────────

// Временный enum — при подключении заменить на AppThemeId
enum CandidateThemeId {
  steelSand,
  crimsonNight,
  mintDark,
  neonTropic,
  skyLavender,
  candyPop,
  duskPalette,
}

class CandidateTheme {
  const CandidateTheme({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.accent,
    required this.accentLight,
    required this.darkBg,
    required this.darkSurface,
    required this.darkSurface2,
    required this.darkBorder,
    required this.darkBorderMuted,
    required this.darkText1,
    required this.darkText2,
    required this.darkText3,
    required this.darkGlass,
    required this.darkGradient,
    required this.lightBg,
    required this.lightSurface,
    required this.lightSurface2,
    required this.lightSurface3,
    required this.lightBorder,
    required this.lightBorderMuted,
    required this.lightText1,
    required this.lightText2,
    required this.lightText3,
    required this.lightGlass,
    required this.lightGradient,
    required this.previewColors,
    required this.cardGradient,
  });

  final CandidateThemeId id;
  final String name;
  final String subtitle;

  // Accent
  final Color accent;
  final Color accentLight;

  // Dark
  final Color darkBg;
  final Color darkSurface;
  final Color darkSurface2;
  final Color darkBorder;
  final Color darkBorderMuted;
  final Color darkText1;
  final Color darkText2;
  final Color darkText3;
  final Color darkGlass;
  final List<Color> darkGradient;

  // Light
  final Color lightBg;
  final Color lightSurface;
  final Color lightSurface2;
  final Color lightSurface3;
  final Color lightBorder;
  final Color lightBorderMuted;
  final Color lightText1;
  final Color lightText2;
  final Color lightText3;
  final Color lightGlass;
  final List<Color> lightGradient;

  // Preview (5 colors) + card gradient (for bank card)
  final List<Color> previewColors;
  final List<Color> cardGradient;

  /// Convert to WoniThemeData for use in the app.
  /// Requires a valid AppThemeId to be passed.
  WoniThemeData toWoniTheme(AppThemeId appId) => WoniThemeData(
        id: appId,
        name: name,
        accent: accent,
        accentLight: accentLight,
        darkBg: darkBg,
        darkSurface: darkSurface,
        darkSurface2: darkSurface2,
        darkBorder: darkBorder,
        darkBorderMuted: darkBorderMuted,
        darkText1: darkText1,
        darkText2: darkText2,
        darkText3: darkText3,
        darkGlass: darkGlass,
        darkGradient: darkGradient,
        lightBg: lightBg,
        lightSurface: lightSurface,
        lightSurface2: lightSurface2,
        lightSurface3: lightSurface3,
        lightBorder: lightBorder,
        lightBorderMuted: lightBorderMuted,
        lightText1: lightText1,
        lightText2: lightText2,
        lightText3: lightText3,
        lightGlass: lightGlass,
        lightGradient: lightGradient,
        previewColors: previewColors,
      );
}

// ─── 7 CANDIDATE THEMES ─────────────────────────────────────────────────────

const kCandidateThemes = <CandidateTheme>[
  // ── 1. Steel & Sand — Холодный премиум ────────────────────────────────────
  // Стальные серые тона + тёплый песочный акцент. Сдержанная элегантность.
  // Карточка: тёмный градиент от стального тила к тёплому песку.
  CandidateTheme(
    id: CandidateThemeId.steelSand,
    name: 'Steel & Sand',
    subtitle: 'Холодный премиум',
    accent: Color(0xFF7A9E9E),       // muted steel-teal
    accentLight: Color(0xFF8B7A60),  // warm sand
    // ── Dark ──
    darkBg: Color(0xFF111418),
    darkSurface: Color(0xFF1A1E24),
    darkSurface2: Color(0xFF242830),
    darkBorder: Color(0xFF333A44),
    darkBorderMuted: Color(0xFF2A3038),
    darkText1: Color(0xFFE4E2DD),
    darkText2: Color(0xFF8A8880),
    darkText3: Color(0xFF5C5A52),
    darkGlass: Color(0xFF1A1E24),
    darkGradient: [
      Color(0xFF111418),
      Color(0xFF161C22),
      Color(0xFF1A2228),
      Color(0xFF1C2020),
      Color(0xFF111418),
    ],
    // ── Light ──
    lightBg: Color(0xFFF6F4EF),
    lightSurface: Color(0xFFF0ECE4),
    lightSurface2: Color(0xFFE5E0D6),
    lightSurface3: Color(0xFFDAD5CA),
    lightBorder: Color(0xFFC8C2B5),
    lightBorderMuted: Color(0xFFD8D2C5),
    lightText1: Color(0xFF1E2028),
    lightText2: Color(0xFF5A5850),
    lightText3: Color(0xFF8A8878),
    lightGlass: Color(0xFFF0ECE4),
    lightGradient: [
      Color(0xFFE8E2D5),
      Color(0xFFDDD5C8),
      Color(0xFFD0CCC0),
      Color(0xFFDDD5C8),
      Color(0xFFE8E2D5),
    ],
    previewColors: [
      Color(0xFF1A2A35),
      Color(0xFF253A42),
      Color(0xFF7A9E9E),
      Color(0xFF8B7A60),
      Color(0xFFC8B898),
    ],
    cardGradient: [
      Color(0xFF1A3028),
      Color(0xFF253530),
      Color(0xFF2A3025),
      Color(0xFF302A1E),
      Color(0xFF282218),
    ],
  ),

  // ── 2. Crimson Night — Дерзкая тёмная ─────────────────────────────────────
  // Глубокий чёрный с дерзким красным. Карточка: тёмно-бордовый градиент.
  CandidateTheme(
    id: CandidateThemeId.crimsonNight,
    name: 'Crimson Night',
    subtitle: 'Дерзкая тёмная',
    accent: Color(0xFFE82848),       // bright crimson
    accentLight: Color(0xFFB81840),  // deep crimson
    // ── Dark ──
    darkBg: Color(0xFF100A0C),
    darkSurface: Color(0xFF1C1418),
    darkSurface2: Color(0xFF281E22),
    darkBorder: Color(0xFF3A2830),
    darkBorderMuted: Color(0xFF302028),
    darkText1: Color(0xFFF0E8EC),
    darkText2: Color(0xFF908588),
    darkText3: Color(0xFF605558),
    darkGlass: Color(0xFF1C1418),
    darkGradient: [
      Color(0xFF100A0C),
      Color(0xFF1A1015),
      Color(0xFF22151C),
      Color(0xFF1A1015),
      Color(0xFF100A0C),
    ],
    // ── Light ──
    lightBg: Color(0xFFFFF5F6),
    lightSurface: Color(0xFFF8F0F2),
    lightSurface2: Color(0xFFF0E5E8),
    lightSurface3: Color(0xFFE8DADD),
    lightBorder: Color(0xFFD8C5C8),
    lightBorderMuted: Color(0xFFE5D5D8),
    lightText1: Color(0xFF2D1A20),
    lightText2: Color(0xFF785A62),
    lightText3: Color(0xFFA88A92),
    lightGlass: Color(0xFFF8F0F2),
    lightGradient: [
      Color(0xFFF5D0D5),
      Color(0xFFECC0C8),
      Color(0xFFE8B5BE),
      Color(0xFFECC0C8),
      Color(0xFFF5D0D5),
    ],
    previewColors: [
      Color(0xFF1C1418),
      Color(0xFF3A2830),
      Color(0xFFE82848),
      Color(0xFFB81840),
      Color(0xFF6A2030),
    ],
    cardGradient: [
      Color(0xFF2A0A14),
      Color(0xFF3A1220),
      Color(0xFF4A1828),
      Color(0xFF3A1220),
      Color(0xFF2A0A14),
    ],
  ),

  // ── 3. Mint Dark — Свежая кибер ───────────────────────────────────────────
  // Кибер-минт на тёмном изумруде. Карточка: тёмный изумрудно-мятный градиент.
  CandidateTheme(
    id: CandidateThemeId.mintDark,
    name: 'Mint Dark',
    subtitle: 'Свежая кибер',
    accent: Color(0xFF00E8A2),       // bright mint
    accentLight: Color(0xFF00A876),  // deep mint
    // ── Dark ──
    darkBg: Color(0xFF08100E),
    darkSurface: Color(0xFF101E1A),
    darkSurface2: Color(0xFF1A2A25),
    darkBorder: Color(0xFF283A34),
    darkBorderMuted: Color(0xFF203028),
    darkText1: Color(0xFFE0F0EA),
    darkText2: Color(0xFF7A9A8A),
    darkText3: Color(0xFF506A5E),
    darkGlass: Color(0xFF101E1A),
    darkGradient: [
      Color(0xFF08100E),
      Color(0xFF0C1814),
      Color(0xFF10201C),
      Color(0xFF0C1814),
      Color(0xFF08100E),
    ],
    // ── Light ──
    lightBg: Color(0xFFF0F8F5),
    lightSurface: Color(0xFFE8F5F0),
    lightSurface2: Color(0xFFDDF0E8),
    lightSurface3: Color(0xFFD0E8DE),
    lightBorder: Color(0xFFB8D8CC),
    lightBorderMuted: Color(0xFFC8E5D8),
    lightText1: Color(0xFF1A2E25),
    lightText2: Color(0xFF507060),
    lightText3: Color(0xFF80A090),
    lightGlass: Color(0xFFE8F5F0),
    lightGradient: [
      Color(0xFFD0F0E0),
      Color(0xFFC0E8D5),
      Color(0xFFB0E0C8),
      Color(0xFFC0E8D5),
      Color(0xFFD0F0E0),
    ],
    previewColors: [
      Color(0xFF08100E),
      Color(0xFF1A3028),
      Color(0xFF00E8A2),
      Color(0xFF00A876),
      Color(0xFF2A4A3E),
    ],
    cardGradient: [
      Color(0xFF0A2A20),
      Color(0xFF103830),
      Color(0xFF184038),
      Color(0xFF103830),
      Color(0xFF0A2A20),
    ],
  ),

  // ── 4. Neon Tropic — Яркая тропик ─────────────────────────────────────────
  // Кислотный неон + тропические цвета. Карточка: яркий неоново-зелёный → жёлтый.
  CandidateTheme(
    id: CandidateThemeId.neonTropic,
    name: 'Neon Tropic',
    subtitle: 'Яркая тропик',
    accent: Color(0xFF39FF14),       // neon green
    accentLight: Color(0xFF22BB10),  // vivid green
    // ── Dark ──
    darkBg: Color(0xFF0A0E08),
    darkSurface: Color(0xFF141A10),
    darkSurface2: Color(0xFF1E2518),
    darkBorder: Color(0xFF303820),
    darkBorderMuted: Color(0xFF262E1A),
    darkText1: Color(0xFFE8F0E0),
    darkText2: Color(0xFF8A9A78),
    darkText3: Color(0xFF5A6A4E),
    darkGlass: Color(0xFF141A10),
    darkGradient: [
      Color(0xFF0A0E08),
      Color(0xFF101810),
      Color(0xFF162018),
      Color(0xFF101810),
      Color(0xFF0A0E08),
    ],
    // ── Light ──
    lightBg: Color(0xFFF5FAF0),
    lightSurface: Color(0xFFEEF8E8),
    lightSurface2: Color(0xFFE2F2DA),
    lightSurface3: Color(0xFFD5EACC),
    lightBorder: Color(0xFFB8D8A8),
    lightBorderMuted: Color(0xFFC8E5BC),
    lightText1: Color(0xFF1A2510),
    lightText2: Color(0xFF4A6438),
    lightText3: Color(0xFF7A9A68),
    lightGlass: Color(0xFFEEF8E8),
    lightGradient: [
      Color(0xFFD5F0C0),
      Color(0xFFC8E8B0),
      Color(0xFFBCE0A0),
      Color(0xFFC8E8B0),
      Color(0xFFD5F0C0),
    ],
    previewColors: [
      Color(0xFF0A0E08),
      Color(0xFFFF8C00),
      Color(0xFFFF3080),
      Color(0xFF20CC30),
      Color(0xFF39FF14),
    ],
    cardGradient: [
      Color(0xFF1A4010),
      Color(0xFF2A6818),
      Color(0xFF48A020),
      Color(0xFF70CC18),
      Color(0xFFA0E810),
    ],
  ),

  // ── 5. Sky Lavender — Воздушная пастель ───────────────────────────────────
  // Нежная лаванда. Карточка: мягкий лавандово-голубой градиент.
  CandidateTheme(
    id: CandidateThemeId.skyLavender,
    name: 'Sky Lavender',
    subtitle: 'Воздушная пастель',
    accent: Color(0xFF9B7AE8),       // soft lavender
    accentLight: Color(0xFF7B5CC8),  // deep lavender
    // ── Dark ──
    darkBg: Color(0xFF14121C),
    darkSurface: Color(0xFF1E1A28),
    darkSurface2: Color(0xFF282435),
    darkBorder: Color(0xFF383250),
    darkBorderMuted: Color(0xFF302A42),
    darkText1: Color(0xFFE8E4F2),
    darkText2: Color(0xFF8A85A0),
    darkText3: Color(0xFF5C5870),
    darkGlass: Color(0xFF1E1A28),
    darkGradient: [
      Color(0xFF14121C),
      Color(0xFF1A1625),
      Color(0xFF201A2C),
      Color(0xFF1A1625),
      Color(0xFF14121C),
    ],
    // ── Light ──
    lightBg: Color(0xFFF5F2FC),
    lightSurface: Color(0xFFEEEBF8),
    lightSurface2: Color(0xFFE4E0F2),
    lightSurface3: Color(0xFFD8D2EA),
    lightBorder: Color(0xFFC5BEE0),
    lightBorderMuted: Color(0xFFD5D0EA),
    lightText1: Color(0xFF201C30),
    lightText2: Color(0xFF5A5570),
    lightText3: Color(0xFF8A85A0),
    lightGlass: Color(0xFFEEEBF8),
    lightGradient: [
      Color(0xFFE0D8F5),
      Color(0xFFD5CCF0),
      Color(0xFFC8C0E8),
      Color(0xFFD5CCF0),
      Color(0xFFE0D8F5),
    ],
    previewColors: [
      Color(0xFF14121C),
      Color(0xFF3A3060),
      Color(0xFF9B7AE8),
      Color(0xFF7B5CC8),
      Color(0xFFC8B8F0),
    ],
    cardGradient: [
      Color(0xFFC5B8E8),
      Color(0xFFB8B0E8),
      Color(0xFFB0BEE8),
      Color(0xFFAAC0EA),
      Color(0xFFA8C8E8),
    ],
  ),

  // ── 6. Candy Pop — Розовый + мятный ───────────────────────────────────────
  // Игривый коралл с мятным. Карточка: тёплый коралловый → розовый.
  CandidateTheme(
    id: CandidateThemeId.candyPop,
    name: 'Candy Pop',
    subtitle: 'Розовый + мятный',
    accent: Color(0xFFFF6B8A),       // coral pink
    accentLight: Color(0xFFE04878),  // deeper coral
    // ── Dark ──
    darkBg: Color(0xFF140A10),
    darkSurface: Color(0xFF201420),
    darkSurface2: Color(0xFF2C1E2A),
    darkBorder: Color(0xFF402838),
    darkBorderMuted: Color(0xFF352030),
    darkText1: Color(0xFFF2E8F0),
    darkText2: Color(0xFFA08598),
    darkText3: Color(0xFF705868),
    darkGlass: Color(0xFF201420),
    darkGradient: [
      Color(0xFF140A10),
      Color(0xFF1C1018),
      Color(0xFF221620),
      Color(0xFF1C1018),
      Color(0xFF140A10),
    ],
    // ── Light ──
    lightBg: Color(0xFFFFF5F5),
    lightSurface: Color(0xFFFFF0EE),
    lightSurface2: Color(0xFFFFE5E2),
    lightSurface3: Color(0xFFFFD8D5),
    lightBorder: Color(0xFFF0C0C0),
    lightBorderMuted: Color(0xFFF5D0CE),
    lightText1: Color(0xFF301820),
    lightText2: Color(0xFF805060),
    lightText3: Color(0xFFB08090),
    lightGlass: Color(0xFFFFF0EE),
    lightGradient: [
      Color(0xFFFFDDD5),
      Color(0xFFFDD0C8),
      Color(0xFFF8C0B8),
      Color(0xFFFDD0C8),
      Color(0xFFFFDDD5),
    ],
    previewColors: [
      Color(0xFF140A10),
      Color(0xFFFF6B8A),
      Color(0xFFE04878),
      Color(0xFF2DD4A8),
      Color(0xFF20A882),
    ],
    cardGradient: [
      Color(0xFFFF9080),
      Color(0xFFFF7878),
      Color(0xFFFF6880),
      Color(0xFFFF5888),
      Color(0xFFFF4890),
    ],
  ),

  // ── 7. Dusk Palette — Серо-голубой + розовый ──────────────────────────────
  // Приглушённый тил + тёплый розовый. Карточка: мягкий тиловый градиент.
  CandidateTheme(
    id: CandidateThemeId.duskPalette,
    name: 'Dusk Palette',
    subtitle: 'Серо-голубой + розовый',
    accent: Color(0xFF5BA8A8),       // muted teal
    accentLight: Color(0xFFD88CA5),  // muted rose
    // ── Dark ──
    darkBg: Color(0xFF101418),
    darkSurface: Color(0xFF181E24),
    darkSurface2: Color(0xFF222830),
    darkBorder: Color(0xFF303840),
    darkBorderMuted: Color(0xFF283035),
    darkText1: Color(0xFFE0E4E8),
    darkText2: Color(0xFF8890A0),
    darkText3: Color(0xFF586068),
    darkGlass: Color(0xFF181E24),
    darkGradient: [
      Color(0xFF101418),
      Color(0xFF151C22),
      Color(0xFF1A2228),
      Color(0xFF151C22),
      Color(0xFF101418),
    ],
    // ── Light ──
    lightBg: Color(0xFFF4F5F8),
    lightSurface: Color(0xFFECEFF4),
    lightSurface2: Color(0xFFE2E5EC),
    lightSurface3: Color(0xFFD5D8E0),
    lightBorder: Color(0xFFC0C5D0),
    lightBorderMuted: Color(0xFFCDD2DA),
    lightText1: Color(0xFF1C2028),
    lightText2: Color(0xFF555A65),
    lightText3: Color(0xFF888D98),
    lightGlass: Color(0xFFECEFF4),
    lightGradient: [
      Color(0xFFDDE0E8),
      Color(0xFFD2D5DD),
      Color(0xFFC8CCD5),
      Color(0xFFD2D5DD),
      Color(0xFFDDE0E8),
    ],
    previewColors: [
      Color(0xFF101418),
      Color(0xFF5BA8A8),
      Color(0xFF7ABCBC),
      Color(0xFFD88CA5),
      Color(0xFFB06880),
    ],
    cardGradient: [
      Color(0xFF4A9090),
      Color(0xFF58A0A0),
      Color(0xFF68ACAC),
      Color(0xFF78B8B8),
      Color(0xFF88C4C4),
    ],
  ),
];
