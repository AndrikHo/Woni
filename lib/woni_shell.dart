import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/core/theme/woni_icons.dart';
import 'package:woni/features/home/presentation/screens/home_screen.dart';
import 'package:woni/features/finance/presentation/screens/finance_page.dart';
import 'package:woni/features/account/presentation/screens/account_screen.dart';

class WoniShell extends StatefulWidget {
  const WoniShell({super.key});

  @override
  State<WoniShell> createState() => _WoniShellState();
}

class _WoniShellState extends State<WoniShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    FinancePage(),
    AccountScreen(),
  ];

  void _onTap(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ── Background gradient (theme-dependent) ──
            Builder(
              builder: (context) {
                final state = AppStateScope.of(context);
                final isDark = state.themeMode == ThemeMode.dark;
                final gradient = isDark
                    ? WoniColors.current.darkGradient
                    : WoniColors.current.lightGradient;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradient,
                    ),
                  ),
                );
              },
            ),
            IndexedStack(index: _index, children: _screens),
          ],
        ),
        bottomNavigationBar: _IslandNavBar(
          selectedIndex: _index,
          onTap: _onTap,
        ),
      ),
    );
  }
}

// ─── DYNAMIC ISLAND NAV BAR ─────────────────────────────────────────────────

class _IslandNavBar extends StatefulWidget {
  const _IslandNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final void Function(int) onTap;

  @override
  State<_IslandNavBar> createState() => _IslandNavBarState();
}

class _IslandNavBarState extends State<_IslandNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _prevIndex = widget.selectedIndex;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant _IslandNavBar old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _prevIndex = old.selectedIndex;
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final inactiveColor = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    const islandHeight = 52.0;
    const islandRadius = 16.0;
    const hPad = 4.0;
    const itemCount = 3;
    const overX = 3.0;
    const overY = 2.0;
    const totalHeight = islandHeight + overY * 2;

    final labels = [S.tabHome, S.tabFinance, S.tabAccount];
    final icons = [WoniIconType.home, WoniIconType.finance, WoniIconType.account];

    return Padding(
      padding: EdgeInsets.only(
        left: 52 - overX,
        right: 52 - overX,
        bottom: bottomPad + 14 - overY,
      ),
      child: SizedBox(
        height: totalHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final islandWidth = totalWidth - overX * 2;
            final btnWidth = (islandWidth - hPad * 2) / itemCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Layer 1: Island glass background ──
                Positioned(
                  left: overX,
                  right: overX,
                  top: overY,
                  height: islandHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(islandRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? WoniColors.current.darkGlass.withValues(alpha: 0.82)
                                  : WoniColors.current.lightGlass.withValues(alpha: 0.80),
                              borderRadius: BorderRadius.circular(islandRadius),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.06),
                                width: 0.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                      alpha: isDark ? 0.4 : 0.12),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: WoniGlare(isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Layer 2: Stretchy glass lens indicator ──
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, _) {
                    final t = _ctrl.value;

                    // Lead: snaps to target quickly
                    final leadT = Curves.easeOutCubic.transform(t);
                    // Trail: waits 5%, then catches up with soft landing
                    final trailT = Curves.easeOutCubic.transform(
                      (t * 1.05 - 0.05).clamp(0.0, 1.0),
                    );

                    final fromPos = hPad + _prevIndex * btnWidth;
                    final toPos = hPad + widget.selectedIndex * btnWidth;
                    double indLeft;
                    double indRight;

                    if (toPos >= fromPos) {
                      // Moving right: right edge leads, left trails
                      indLeft = fromPos + (toPos - fromPos) * trailT;
                      indRight = fromPos + btnWidth + (toPos - fromPos) * leadT;
                    } else {
                      // Moving left: left edge leads, right trails
                      indLeft = fromPos + (toPos - fromPos) * leadT;
                      indRight = fromPos + btnWidth + (toPos - fromPos) * trailT;
                    }

                    // Vertical squeeze: narrower when stretched most
                    final stretch = (indRight - indLeft) / btnWidth; // 1.0 = normal, >1 = stretched
                    final squeeze = stretch > 1.0
                        ? 1.0 + (stretch - 1.0) * 0.50 // stronger vertical shrink
                        : 1.0;

                    final pixelLeft = overX + indLeft - overX;
                    final pixelWidth = (indRight - indLeft) + overX * 2;

                    final squeezeHeight = totalHeight / squeeze;
                    final squeezeTop = (totalHeight - squeezeHeight) / 2;

                    return Positioned(
                      left: pixelLeft,
                      top: squeezeTop,
                      width: pixelWidth,
                      height: squeezeHeight,
                      child: _GlassLens(
                        radius: islandRadius,
                        isDark: isDark,
                        shimmerT: t,
                      ),
                    );
                  },
                ),

                // ── Layer 3: Buttons ──
                Positioned(
                  left: overX + hPad,
                  right: overX + hPad,
                  top: overY,
                  height: islandHeight,
                  child: Row(
                    children: List.generate(itemCount, (i) {
                      final isActive = i == widget.selectedIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onTap(i),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: islandHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WoniIcon(
                                  icons[i],
                                  size: 22,
                                  active: isActive,
                                ),
                                const SizedBox(height: 1),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: WoniTextStyles.label.copyWith(
                                    fontSize: 10,
                                    color: isActive ? accent : inactiveColor,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  child: Text(labels[i]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Glass lens indicator ────────────────────────────────────────────────────

class _GlassLens extends StatelessWidget {
  const _GlassLens({
    required this.radius,
    required this.isDark,
    required this.shimmerT,
  });

  final double radius;
  final bool isDark;
  final double shimmerT;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.white.withValues(alpha: 0.04),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.50),
                      Colors.white.withValues(alpha: 0.20),
                    ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.40),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.3),
                blurRadius: 0,
                offset: const Offset(0, 0.5),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.10),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _Shimmer(t: shimmerT),
        ),
      ),
    );
  }
}

// ── One-shot shimmer glint ──────────────────────────────────────────────────

class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    if (t <= 0 || t >= 1) return const SizedBox.expand();

    final opacity = t < 0.2
        ? (t / 0.2) * 0.65
        : 0.65 * (1 - ((t - 0.2) / 0.8));

    return Transform.translate(
      offset: Offset((t * 2 - 1) * 140, 0),
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0)),
              Colors.white.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
