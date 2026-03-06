import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/app_themes.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ThemePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = AppStateScope.of(context);
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final border = isDark ? WoniColors.darkBorder : WoniColors.lightBorder;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? WoniColors.current.darkGlass.withValues(alpha: 0.75)
                    : WoniColors.current.lightGlass.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Pill handle ──
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Title ──
                Text(
                  S.themes,
                  style: WoniTextStyles.heading2.copyWith(color: textColor),
                ),
                const SizedBox(height: 16),

                // ── Theme grid (scrollable) ──
                Flexible(
                  child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: kThemes.map((theme) {
                      final isSelected = state.selectedTheme == theme.id;
                      return GestureDetector(
                        onTap: () {
                          AppStateScope.read(context).setAppTheme(theme.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: WoniSpacing.sm),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? WoniColors.blue.withValues(alpha: 0.10)
                                : isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.03),
                            borderRadius: WoniRadius.lg,
                            border: Border.all(
                              color: isSelected
                                  ? WoniColors.blue.withValues(alpha: 0.40)
                                  : border.withValues(alpha: 0.3),
                              width: isSelected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              // ── Color preview strip ──
                              ClipRRect(
                                borderRadius: WoniRadius.sm,
                                child: SizedBox(
                                  width: 100,
                                  height: 36,
                                  child: Row(
                                    children: theme.previewColors
                                        .map((c) => Expanded(
                                              child: Container(color: c),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // ── Theme name ──
                              Expanded(
                                child: Text(
                                  theme.name,
                                  style: WoniTextStyles.body.copyWith(
                                    color: textColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),

                              // ── Check icon ──
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: WoniColors.blue,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
            Positioned.fill(
              child: WoniGlare(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
