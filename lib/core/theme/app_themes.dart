import 'package:flutter/material.dart';

// ─── THEME ID ────────────────────────────────────────────────────────────────

enum AppThemeId {
  winterSteel,
  // ── old themes ──
  mintPanic,
  paulSmith,
  skyPurple,
  darkFire,
  // ── new themes from mockup ──
  steelSand,
  crimsonNight,
  mintDark,
  neonTropic,
  skyLavender,
  candyPop,
  duskPalette,
}

// ─── THEME DATA ──────────────────────────────────────────────────────────────

class WoniThemeData {
  const WoniThemeData({
    required this.id,
    required this.name,
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
  });

  final AppThemeId id;
  final String name;

  final Color accent;
  final Color accentLight;

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

  final List<Color> previewColors;
}

// ─── 8 THEME PRESETS ─────────────────────────────────────────────────────────
// Правило: darkBg — самый тёмный, darkSurface/darkGlass — заметно светлее
// (минимум +10-15 по каждому каналу) чтобы блоки чётко выделялись на фоне.
// ─────────────────────────────────────────────────────────────────────────────

const kThemes = <WoniThemeData>[

  // ── 1. Winter Steel (default) ─────────────────────────────────────────────
  WoniThemeData(
    id: AppThemeId.winterSteel,
    name: 'Winter Steel',
    accent: Color(0xFF379683),
    accentLight: Color(0xFF557A95),
    darkBg: Color(0xFF0E1012),
    darkSurface: Color(0xFF1C1E22),
    darkSurface2: Color(0xFF262A30),
    darkBorder: Color(0xFF353840),
    darkBorderMuted: Color(0xFF2C3038),
    darkText1: Color(0xFFE4E2E0),
    darkText2: Color(0xFF8A8884),
    darkText3: Color(0xFF5C5A58),
    darkGlass: Color(0xFF1C1E22),
    darkGradient: [Color(0xFF0E1012), Color(0xFF121418), Color(0xFF14181C), Color(0xFF121418), Color(0xFF0E1012)],
    lightBg: Color(0xFFF5F4F2),
    lightSurface: Color(0xFFF0EDE8),
    lightSurface2: Color(0xFFE5E0DA),
    lightSurface3: Color(0xFFDAD5CE),
    lightBorder: Color(0xFFC8C2B8),
    lightBorderMuted: Color(0xFFD5D0C8),
    lightText1: Color(0xFF222020),
    lightText2: Color(0xFF5A5855),
    lightText3: Color(0xFF8A8885),
    lightGlass: Color(0xFFF0EDE8),
    lightGradient: [Color(0xFFE2E0DA), Color(0xFFD8D4CC), Color(0xFFCED8D5), Color(0xFFD8D4CC), Color(0xFFE2E0DA)],
    previewColors: [Color(0xFF5D5C61), Color(0xFF379683), Color(0xFF7395AE), Color(0xFF557A95), Color(0xFFB1A296)],
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // OLD THEMES (оригинальные)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Mint Panic — Яркий неон + фиолетовый ──────────────────────────────────
  WoniThemeData(
    id: AppThemeId.mintPanic,
    name: 'Mint Panic',
    accent: Color(0xFF16FFBD),
    accentLight: Color(0xFF12C998),
    darkBg: Color(0xFF08050F),       // глубокий фиолет-чёрный
    darkSurface: Color(0xFF1E1030),  // ЯРКИЙ фиолетовый — чётко видно
    darkSurface2: Color(0xFF2A1840),
    darkBorder: Color(0xFF3D2858),
    darkBorderMuted: Color(0xFF321E48),
    darkText1: Color(0xFFF0E8F8),
    darkText2: Color(0xFF9A85A8),
    darkText3: Color(0xFF6E5C7C),
    darkGlass: Color(0xFF1E1030),    // фиолетовый оттенок блоков
    darkGradient: [Color(0xFF08050F), Color(0xFF120A1E), Color(0xFF180E2A), Color(0xFF120A1E), Color(0xFF08050F)],
    lightBg: Color(0xFFFFF5F8),
    lightSurface: Color(0xFFFFF0F5),
    lightSurface2: Color(0xFFFFE8F0),
    lightSurface3: Color(0xFFFFDDE8),
    lightBorder: Color(0xFFE8C8D8),
    lightBorderMuted: Color(0xFFF0D8E5),
    lightText1: Color(0xFF3D1A2B),
    lightText2: Color(0xFF885A70),
    lightText3: Color(0xFFB08A9B),
    lightGlass: Color(0xFFFFF0F5),
    lightGradient: [Color(0xFFFFD8E8), Color(0xFFF5C5D8), Color(0xFFCCF5E0), Color(0xFFD8F5CC), Color(0xFFFFE0EC)],
    previewColors: [Color(0xFF1E1030), Color(0xFFF070A1), Color(0xFF16FFBD), Color(0xFF12C998), Color(0xFF439F76)],
  ),

  // ── Paul Smith — Глубокий индиго ──────────────────────────────────────────
  WoniThemeData(
    id: AppThemeId.paulSmith,
    name: 'Paul Smith',
    accent: Color(0xFF99CED3),
    accentLight: Color(0xFF4D6D9A),
    darkBg: Color(0xFF08091A),       // тёмный индиго
    darkSurface: Color(0xFF141836),  // ЯРКИЙ синий — чётко видно
    darkSurface2: Color(0xFF1C2248),
    darkBorder: Color(0xFF283060),
    darkBorderMuted: Color(0xFF202850),
    darkText1: Color(0xFFE4E8F0),
    darkText2: Color(0xFF8A92A8),
    darkText3: Color(0xFF5C6680),
    darkGlass: Color(0xFF141836),    // синий оттенок блоков
    darkGradient: [Color(0xFF08091A), Color(0xFF0E1028), Color(0xFF121435), Color(0xFF0E1028), Color(0xFF08091A)],
    lightBg: Color(0xFFF8F5F2),
    lightSurface: Color(0xFFF5F0EB),
    lightSurface2: Color(0xFFEDE6E0),
    lightSurface3: Color(0xFFE2DAD4),
    lightBorder: Color(0xFFD0C8C0),
    lightBorderMuted: Color(0xFFDDD5CE),
    lightText1: Color(0xFF2A2830),
    lightText2: Color(0xFF6A6470),
    lightText3: Color(0xFF9A94A0),
    lightGlass: Color(0xFFF5F0EB),
    lightGradient: [Color(0xFFE8DDD0), Color(0xFFDDD0C2), Color(0xFFCCDDE8), Color(0xFFDDCCD5), Color(0xFFEDE8E2)],
    previewColors: [Color(0xFF141836), Color(0xFF4D6D9A), Color(0xFF86B3D1), Color(0xFF99CED3), Color(0xFFEDB5BF)],
  ),

  // ── Sky Purple — Глубокий аметист ─────────────────────────────────────────
  WoniThemeData(
    id: AppThemeId.skyPurple,
    name: 'Sky Purple',
    accent: Color(0xFF84CEEB),
    accentLight: Color(0xFF5680E9),
    darkBg: Color(0xFF060818),       // тёмный ультрамарин
    darkSurface: Color(0xFF10143A),  // ЯРКИЙ пурпурно-синий — чётко видно
    darkSurface2: Color(0xFF181E50),
    darkBorder: Color(0xFF222862),
    darkBorderMuted: Color(0xFF1C2255),
    darkText1: Color(0xFFE0E4F8),
    darkText2: Color(0xFF8088B0),
    darkText3: Color(0xFF585E88),
    darkGlass: Color(0xFF10143A),    // пурпурно-синий оттенок блоков
    darkGradient: [Color(0xFF060818), Color(0xFF0C0E28), Color(0xFF101238), Color(0xFF0C0E28), Color(0xFF060818)],
    lightBg: Color(0xFFF2F0FA),
    lightSurface: Color(0xFFF0EEFA),
    lightSurface2: Color(0xFFE6E2F5),
    lightSurface3: Color(0xFFDAD5F0),
    lightBorder: Color(0xFFC5C0E0),
    lightBorderMuted: Color(0xFFD5D0EA),
    lightText1: Color(0xFF1A1A3D),
    lightText2: Color(0xFF5A5888),
    lightText3: Color(0xFF8A88B0),
    lightGlass: Color(0xFFF0EEFA),
    lightGradient: [Color(0xFFDDD5F0), Color(0xFFCCD2F5), Color(0xFFC0E0F5), Color(0xFFD5C8EC), Color(0xFFE2DEF0)],
    previewColors: [Color(0xFF10143A), Color(0xFF5680E9), Color(0xFF84CEEB), Color(0xFFC1C8E4), Color(0xFF8860D0)],
  ),

  // ── Dark Fire — Чистый чёрный + огненный акцент ───────────────────────────
  WoniThemeData(
    id: AppThemeId.darkFire,
    name: 'Dark Fire',
    accent: Color(0xFFFF652F),
    accentLight: Color(0xFF14A76C),
    darkBg: Color(0xFF0A0606),       // тёмный с красноватым оттенком
    darkSurface: Color(0xFF1E1210),  // тёплый коричнево-красный
    darkSurface2: Color(0xFF2A1A16),
    darkBorder: Color(0xFF3A2820),
    darkBorderMuted: Color(0xFF30201A),
    darkText1: Color(0xFFF0F0F0),
    darkText2: Color(0xFF8A8A8A),
    darkText3: Color(0xFF5A5A5A),
    darkGlass: Color(0xFF1E1210),    // тёплый коричнево-красный блоков
    darkGradient: [Color(0xFF0A0606), Color(0xFF120A08), Color(0xFF180E0C), Color(0xFF120A08), Color(0xFF0A0606)],
    lightBg: Color(0xFFF8F5F0),
    lightSurface: Color(0xFFF5F0EA),
    lightSurface2: Color(0xFFEDE5DD),
    lightSurface3: Color(0xFFE2DAD0),
    lightBorder: Color(0xFFD0C5B8),
    lightBorderMuted: Color(0xFFDDD2C8),
    lightText1: Color(0xFF1A1A1A),
    lightText2: Color(0xFF5A5A5A),
    lightText3: Color(0xFF8A8A8A),
    lightGlass: Color(0xFFF5F0EA),
    lightGradient: [Color(0xFFEDE0CC), Color(0xFFE5D5C0), Color(0xFFEADDB8), Color(0xFFE5D5C0), Color(0xFFEDE0CC)],
    previewColors: [Color(0xFF1E1210), Color(0xFF747474), Color(0xFFFF652F), Color(0xFFFFE400), Color(0xFF14A76C)],
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // NEW THEMES (из макета) — ЯРКИЕ, ЧЁТКО РАЗЛИЧИМЫЕ
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Steel & Sand — Холодный стальной-синий ─────────────────────────────────
  WoniThemeData(
    id: AppThemeId.steelSand,
    name: 'Steel & Sand',
    accent: Color(0xFF7A9E9E),
    accentLight: Color(0xFF8B7A60),
    darkBg: Color(0xFF060A10),       // глубокий стально-чёрный
    darkSurface: Color(0xFF121E2C),  // чёткий стальной-синий
    darkSurface2: Color(0xFF1A2838),
    darkBorder: Color(0xFF283648),
    darkBorderMuted: Color(0xFF202E40),
    darkText1: Color(0xFFE4E2DD),
    darkText2: Color(0xFF8A8880),
    darkText3: Color(0xFF5C5A52),
    darkGlass: Color(0xFF121E2C),    // стальной-синий блоков
    darkGradient: [Color(0xFF060A10), Color(0xFF0A1018), Color(0xFF0E1622), Color(0xFF0A1018), Color(0xFF060A10)],
    lightBg: Color(0xFFF6F4EE),
    lightSurface: Color(0xFFF0ECE0),
    lightSurface2: Color(0xFFE5DED2),
    lightSurface3: Color(0xFFDAD4C6),
    lightBorder: Color(0xFFC8C0B0),
    lightBorderMuted: Color(0xFFD8D0C0),
    lightText1: Color(0xFF1E1E1A),
    lightText2: Color(0xFF5A584E),
    lightText3: Color(0xFF8A8878),
    lightGlass: Color(0xFFF0ECE0),
    lightGradient: [Color(0xFFE5E0D0), Color(0xFFDDD6C5), Color(0xFFD0CCB5), Color(0xFFDDD6C5), Color(0xFFE5E0D0)],
    previewColors: [Color(0xFF121E2C), Color(0xFF253A42), Color(0xFF7A9E9E), Color(0xFF8B7A60), Color(0xFFC8B898)],
  ),

  // ── Crimson Night — Бордовый/кроваво-красный ──────────────────────────────
  WoniThemeData(
    id: AppThemeId.crimsonNight,
    name: 'Crimson Night',
    accent: Color(0xFFE82848),
    accentLight: Color(0xFFB81840),
    darkBg: Color(0xFF0A0406),       // тёмный с бордовым
    darkSurface: Color(0xFF2A0E14),  // ЯРКИЙ бордовый — сразу видно красный
    darkSurface2: Color(0xFF381620),
    darkBorder: Color(0xFF4A2230),
    darkBorderMuted: Color(0xFF401A28),
    darkText1: Color(0xFFF0E8E6),
    darkText2: Color(0xFF908582),
    darkText3: Color(0xFF605552),
    darkGlass: Color(0xFF2A0E14),    // бордовый оттенок блоков
    darkGradient: [Color(0xFF0A0406), Color(0xFF14080C), Color(0xFF1E0C12), Color(0xFF14080C), Color(0xFF0A0406)],
    lightBg: Color(0xFFFCF2F2),
    lightSurface: Color(0xFFF8E4E4),
    lightSurface2: Color(0xFFF0D5D5),
    lightSurface3: Color(0xFFE8C8C8),
    lightBorder: Color(0xFFD8B0B0),
    lightBorderMuted: Color(0xFFE2C0C0),
    lightText1: Color(0xFF2D1A1A),
    lightText2: Color(0xFF785858),
    lightText3: Color(0xFFA88888),
    lightGlass: Color(0xFFF8E4E4),
    lightGradient: [Color(0xFFF0D8D8), Color(0xFFE8C8C8), Color(0xFFDEB8B8), Color(0xFFE8C8C8), Color(0xFFF0D8D8)],
    previewColors: [Color(0xFF2A0E14), Color(0xFF3A1420), Color(0xFFE82848), Color(0xFFB81840), Color(0xFF6A2030)],
  ),

  // ── Mint Dark — Изумрудно-зелёный ─────────────────────────────────────────
  WoniThemeData(
    id: AppThemeId.mintDark,
    name: 'Mint Dark',
    accent: Color(0xFF00E8A2),
    accentLight: Color(0xFF00A876),
    darkBg: Color(0xFF040C08),       // тёмный зелёный-чёрный
    darkSurface: Color(0xFF0A2A1C),  // ЯРКИЙ изумрудный — чётко зелёный
    darkSurface2: Color(0xFF103828),
    darkBorder: Color(0xFF1A4A38),
    darkBorderMuted: Color(0xFF144030),
    darkText1: Color(0xFFE0F0EA),
    darkText2: Color(0xFF7A9A8A),
    darkText3: Color(0xFF506A5E),
    darkGlass: Color(0xFF0A2A1C),    // изумрудный оттенок блоков
    darkGradient: [Color(0xFF040C08), Color(0xFF081810), Color(0xFF0C2018), Color(0xFF081810), Color(0xFF040C08)],
    lightBg: Color(0xFFF0F8F4),
    lightSurface: Color(0xFFDEF5EA),
    lightSurface2: Color(0xFFCCF0DD),
    lightSurface3: Color(0xFFBBE8D2),
    lightBorder: Color(0xFF98D8B8),
    lightBorderMuted: Color(0xFFAAE2C8),
    lightText1: Color(0xFF1A2E25),
    lightText2: Color(0xFF507060),
    lightText3: Color(0xFF80A090),
    lightGlass: Color(0xFFDEF5EA),
    lightGradient: [Color(0xFFCCF0DD), Color(0xFFBBE8D0), Color(0xFFAAE0C2), Color(0xFFBBE8D0), Color(0xFFCCF0DD)],
    previewColors: [Color(0xFF0A2A1C), Color(0xFF1A3028), Color(0xFF00E8A2), Color(0xFF00A876), Color(0xFF2A4A3E)],
  ),

  // ── Neon Tropic — Ядовито-жёлто-зелёный ───────────────────────────────────
  WoniThemeData(
    id: AppThemeId.neonTropic,
    name: 'Neon Tropic',
    accent: Color(0xFF39FF14),
    accentLight: Color(0xFF22BB10),
    darkBg: Color(0xFF060A02),       // тёмный оливковый
    darkSurface: Color(0xFF142608),  // ЯРКИЙ оливково-зелёный
    darkSurface2: Color(0xFF1C3210),
    darkBorder: Color(0xFF284418),
    darkBorderMuted: Color(0xFF203A12),
    darkText1: Color(0xFFE8F0E0),
    darkText2: Color(0xFF8A9A78),
    darkText3: Color(0xFF5A6A4E),
    darkGlass: Color(0xFF142608),    // оливково-зелёный блоков
    darkGradient: [Color(0xFF060A02), Color(0xFF0C1606), Color(0xFF10200A), Color(0xFF0C1606), Color(0xFF060A02)],
    lightBg: Color(0xFFF4FAF0),
    lightSurface: Color(0xFFE2F8D5),
    lightSurface2: Color(0xFFD5F2C5),
    lightSurface3: Color(0xFFC8EAB8),
    lightBorder: Color(0xFFA8D898),
    lightBorderMuted: Color(0xFFB8E2A8),
    lightText1: Color(0xFF1A2510),
    lightText2: Color(0xFF4A6438),
    lightText3: Color(0xFF7A9A68),
    lightGlass: Color(0xFFE2F8D5),
    lightGradient: [Color(0xFFD0F0B8), Color(0xFFC0E8A8), Color(0xFFB0E098), Color(0xFFC0E8A8), Color(0xFFD0F0B8)],
    previewColors: [Color(0xFF142608), Color(0xFFFF8C00), Color(0xFFFF3080), Color(0xFF20CC30), Color(0xFF39FF14)],
  ),

  // ── Sky Lavender — Яркий лавандовый-фиолетовый ────────────────────────────
  WoniThemeData(
    id: AppThemeId.skyLavender,
    name: 'Sky Lavender',
    accent: Color(0xFF9B7AE8),
    accentLight: Color(0xFF7B5CC8),
    darkBg: Color(0xFF080618),       // глубокий фиолет
    darkSurface: Color(0xFF1A1240),  // ЯРКИЙ фиолетовый — чётко видно
    darkSurface2: Color(0xFF241A52),
    darkBorder: Color(0xFF302468),
    darkBorderMuted: Color(0xFF2A1E5A),
    darkText1: Color(0xFFE8E4F2),
    darkText2: Color(0xFF8A85A0),
    darkText3: Color(0xFF5C5870),
    darkGlass: Color(0xFF1A1240),    // фиолетовый оттенок блоков
    darkGradient: [Color(0xFF080618), Color(0xFF100C28), Color(0xFF141035), Color(0xFF100C28), Color(0xFF080618)],
    lightBg: Color(0xFFF4F2FC),
    lightSurface: Color(0xFFE8E0FC),
    lightSurface2: Color(0xFFDCD4F8),
    lightSurface3: Color(0xFFD0C8F2),
    lightBorder: Color(0xFFB8AEE8),
    lightBorderMuted: Color(0xFFC8BEF0),
    lightText1: Color(0xFF201C30),
    lightText2: Color(0xFF5A5570),
    lightText3: Color(0xFF8A85A0),
    lightGlass: Color(0xFFE8E0FC),
    lightGradient: [Color(0xFFDCD0F8), Color(0xFFCEC2F4), Color(0xFFC0B5EC), Color(0xFFCEC2F4), Color(0xFFDCD0F8)],
    previewColors: [Color(0xFF1A1240), Color(0xFF3A3060), Color(0xFF9B7AE8), Color(0xFF7B5CC8), Color(0xFFC8B8F0)],
  ),

  // ── Candy Pop — Ярко-розовый/маджента ─────────────────────────────────────
  WoniThemeData(
    id: AppThemeId.candyPop,
    name: 'Candy Pop',
    accent: Color(0xFFFF6B8A),
    accentLight: Color(0xFFE04878),
    darkBg: Color(0xFF0C0408),       // тёмный розово-чёрный
    darkSurface: Color(0xFF2C0C1C),  // ЯРКИЙ розовый/маджента — чётко видно
    darkSurface2: Color(0xFF3A1428),
    darkBorder: Color(0xFF4C2038),
    darkBorderMuted: Color(0xFF421830),
    darkText1: Color(0xFFF2E8EE),
    darkText2: Color(0xFFA08594),
    darkText3: Color(0xFF705868),
    darkGlass: Color(0xFF2C0C1C),    // розовый/маджента блоков
    darkGradient: [Color(0xFF0C0408), Color(0xFF180810), Color(0xFF200C16), Color(0xFF180810), Color(0xFF0C0408)],
    lightBg: Color(0xFFFFF4F4),
    lightSurface: Color(0xFFFFE4E4),
    lightSurface2: Color(0xFFFCD6D6),
    lightSurface3: Color(0xFFF8C8C8),
    lightBorder: Color(0xFFF0AAA8),
    lightBorderMuted: Color(0xFFF5BAB8),
    lightText1: Color(0xFF301820),
    lightText2: Color(0xFF805060),
    lightText3: Color(0xFFB08090),
    lightGlass: Color(0xFFFFE4E4),
    lightGradient: [Color(0xFFFFD0CC), Color(0xFFFCC2BC), Color(0xFFF8B2AB), Color(0xFFFCC2BC), Color(0xFFFFD0CC)],
    previewColors: [Color(0xFF2C0C1C), Color(0xFFFF6B8A), Color(0xFFE04878), Color(0xFF2DD4A8), Color(0xFF20A882)],
  ),

  // ── Dusk Palette — Глубокий сине-серый/петроль ────────────────────────────
  WoniThemeData(
    id: AppThemeId.duskPalette,
    name: 'Dusk Palette',
    accent: Color(0xFF5BA8A8),
    accentLight: Color(0xFFD88CA5),
    darkBg: Color(0xFF04080E),       // глубокий тёмно-синий
    darkSurface: Color(0xFF0C1E30),  // ЯРКИЙ петроль/тёмно-синий
    darkSurface2: Color(0xFF142A3E),
    darkBorder: Color(0xFF1E3850),
    darkBorderMuted: Color(0xFF183044),
    darkText1: Color(0xFFE0E4E8),
    darkText2: Color(0xFF8890A0),
    darkText3: Color(0xFF586068),
    darkGlass: Color(0xFF0C1E30),    // петроль блоков
    darkGradient: [Color(0xFF04080E), Color(0xFF081220), Color(0xFF0C1828), Color(0xFF081220), Color(0xFF04080E)],
    lightBg: Color(0xFFF2F4F8),
    lightSurface: Color(0xFFE0E8F4),
    lightSurface2: Color(0xFFD4DCEC),
    lightSurface3: Color(0xFFC8D0E4),
    lightBorder: Color(0xFFB0BAD0),
    lightBorderMuted: Color(0xFFC0C8DA),
    lightText1: Color(0xFF1C2028),
    lightText2: Color(0xFF555A68),
    lightText3: Color(0xFF888D9A),
    lightGlass: Color(0xFFE0E8F4),
    lightGradient: [Color(0xFFD0D8EA), Color(0xFFC4CCE0), Color(0xFFB8C2D8), Color(0xFFC4CCE0), Color(0xFFD0D8EA)],
    previewColors: [Color(0xFF0C1E30), Color(0xFF5BA8A8), Color(0xFF7ABCBC), Color(0xFFD88CA5), Color(0xFFB06880)],
  ),
];

WoniThemeData themeById(AppThemeId id) => kThemes.firstWhere((t) => t.id == id);
