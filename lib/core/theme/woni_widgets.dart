import 'dart:ui';
import 'package:flutter/material.dart';
import 'woni_theme.dart';

// ─── BUTTONS ────────────────────────────────────────────────────────────────

enum WoniButtonVariant { primary, success, danger, ghost, gradient }

class WoniButton extends StatelessWidget {
  const WoniButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = WoniButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.small = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final WoniButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool small;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (bg, fg, shadow) = switch (variant) {
      WoniButtonVariant.primary => (
          isDark ? WoniColors.blueDark : WoniColors.blue,
          Colors.white,
          WoniShadows.blue(),
        ),
      WoniButtonVariant.gradient => (
          null, // bg handled by gradient decoration
          Colors.white,
          WoniShadows.blue(),
        ),
      WoniButtonVariant.success => (
          isDark ? WoniColors.greenDark : WoniColors.green,
          Colors.white,
          WoniShadows.green(),
        ),
      WoniButtonVariant.danger => (
          isDark ? WoniColors.coralDark : WoniColors.coral,
          Colors.white,
          <BoxShadow>[],
        ),
      WoniButtonVariant.ghost => (
          null,
          null,
          <BoxShadow>[],
        ),
    };

    final height = small ? 36.0 : 48.0;
    final hPad   = small ? 12.0 : 20.0;
    final radius = small ? WoniRadius.lg : WoniRadius.full;

    Widget content = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(fg ?? WoniColors.blue),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 14 : 16),
                const SizedBox(width: 6),
              ],
              Text(label, style: WoniTextStyles.button.copyWith(fontSize: small ? 12 : 15)),
            ],
          );

    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: fullWidth ? double.infinity : null,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        decoration: BoxDecoration(
          color: variant == WoniButtonVariant.gradient
              ? null
              : (bg ?? (isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2)),
          gradient: variant == WoniButtonVariant.gradient
              ? LinearGradient(colors: [WoniColors.blue, const Color(0xFF7B6EF6)])
              : null,
          borderRadius: radius,
          border: variant == WoniButtonVariant.ghost
              ? Border.all(
                  color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
                )
              : null,
          boxShadow: shadow,
        ),
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: TextStyle(color: fg ?? (isDark ? WoniColors.darkText1 : WoniColors.lightText1)),
          child: IconTheme(
            data: IconThemeData(color: fg ?? (isDark ? WoniColors.darkText1 : WoniColors.lightText1)),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ─── CHIP ───────────────────────────────────────────────────────────────────

enum WoniChipVariant { blue, green, coral, neutral }

class WoniChip extends StatelessWidget {
  const WoniChip({super.key, required this.label, this.variant = WoniChipVariant.blue, this.prefix});

  final String label;
  final WoniChipVariant variant;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bg, fg) = switch (variant) {
      WoniChipVariant.blue    => (WoniColors.blue.withOpacity(0.08),  isDark ? WoniColors.blueDark : WoniColors.blue),
      WoniChipVariant.green   => (WoniColors.green.withOpacity(0.08), isDark ? WoniColors.greenDark : WoniColors.green),
      WoniChipVariant.coral   => (WoniColors.coral.withOpacity(0.08), isDark ? WoniColors.coralDark : WoniColors.coral),
      WoniChipVariant.neutral => (
          isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
          isDark ? WoniColors.darkText2 : WoniColors.lightText2,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: WoniRadius.full),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) ...[prefix!, const SizedBox(width: 4)],
          Text(label, style: WoniTextStyles.bodySecondary.copyWith(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── GLASS CARD (iOS-style frosted glass) ───────────────────────────────────

class WoniCard extends StatelessWidget {
  const WoniCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(WoniSpacing.lg),
    this.radius = const BorderRadius.all(Radius.circular(16)),
    this.margin,
    this.gradient,
    this.color,
    this.glass = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius radius;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final Color? color;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Stack(
          children: [
            Container(
              padding: padding,
              decoration: BoxDecoration(
                color: isDark
                    ? WoniColors.current.darkGlass.withValues(alpha: 0.82)
                    : Color.lerp(
                        WoniColors.current.lightGlass,
                        WoniColors.blue,
                        0.06,
                      )!.withValues(alpha: 0.80),
                borderRadius: radius,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : WoniColors.blue.withValues(alpha: 0.10),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            ),
            Positioned.fill(
              child: WoniGlare(isDark: isDark),
            ),
          ],
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}

// ─── GLASS GLARE (top-left + bottom-right highlight streaks) ─────────────

class WoniGlare extends StatelessWidget {
  const WoniGlare({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tA = isDark ? 0.22 : 0.55;
    final bA = isDark ? 0.14 : 0.35;
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Top glare — full width, bright peak biased left ──
          Positioned(
            top: 0.5,
            left: 0,
            right: 0,
            height: 1.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: tA * 0.3),
                    Colors.white.withValues(alpha: tA),
                    Colors.white.withValues(alpha: tA * 0.7),
                    Colors.white.withValues(alpha: tA * 0.3),
                    Colors.white.withValues(alpha: 0),
                  ],
                  stops: const [0.05, 0.25, 0.50, 0.75, 0.95],
                ),
              ),
            ),
          ),
          // Top soft glow
          Positioned(
            top: 1.5,
            left: 0,
            right: 0,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: tA * 0.20),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          // ── Bottom glare — full width, bright peak biased right ──
          Positioned(
            bottom: 0.5,
            left: 0,
            right: 0,
            height: 1.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: bA * 0.3),
                    Colors.white.withValues(alpha: bA * 0.7),
                    Colors.white.withValues(alpha: bA),
                    Colors.white.withValues(alpha: bA * 0.3),
                  ],
                  stops: const [0.05, 0.25, 0.50, 0.75, 0.95],
                ),
              ),
            ),
          ),
          // Bottom soft glow
          Positioned(
            bottom: 1.5,
            left: 0,
            right: 0,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withValues(alpha: bA * 0.15),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AMOUNT TEXT ─────────────────────────────────────────────────────────────

class WoniAmount extends StatelessWidget {
  const WoniAmount({
    super.key,
    required this.amount,
    this.large = false,
    this.showSign = true,
    this.currency = '\u20a9',
  });

  final int amount;
  final bool large;
  final bool showSign;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = amount >= 0;
    final color = isPositive
        ? (isDark ? WoniColors.greenDark : WoniColors.green)
        : (isDark ? WoniColors.coralDark : WoniColors.coral);
    final sign  = isPositive ? (showSign ? '+' : '') : '-';
    final abs   = amount.abs();
    final formatted = _formatKRW(abs);

    return Text(
      '$sign$formatted$currency',
      style: (large ? WoniTextStyles.amountLarge : WoniTextStyles.amount).copyWith(color: color),
    );
  }

  String _formatKRW(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ─── SECTION HEADER ─────────────────────────────────────────────────────────

class WoniSectionHeader extends StatelessWidget {
  const WoniSectionHeader({super.key, required this.title, this.action, this.actionLabel = '\u0432\u0441\u0451 \u2192'});

  final String title;
  final VoidCallback? action;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text(
          title,
          style: WoniTextStyles.caption.copyWith(
            color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
          ),
        ),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: action,
            child: Text(
              actionLabel,
              style: WoniTextStyles.caption.copyWith(
                color: isDark ? WoniColors.blueDark : WoniColors.blue,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── AI INPUT BAR (Clean — no pulse) ────────────────────────────────────────

class WoniAIBar extends StatefulWidget {
  const WoniAIBar({super.key, this.onSubmit, this.onCamera, this.placeholder = '4500 \ucee4\ud53c \uc5b4\uc81c...'});

  final void Function(String)? onSubmit;
  final VoidCallback? onCamera;
  final String placeholder;

  @override
  State<WoniAIBar> createState() => _WoniAIBarState();
}

class _WoniAIBarState extends State<WoniAIBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: WoniRadius.full,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Static dot indicator (no pulse)
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: WoniTextStyles.body.copyWith(
                color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: WoniTextStyles.body.copyWith(
                  color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (val) {
                widget.onSubmit?.call(val);
                _ctrl.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onCamera,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STRETCHY GLASS SCOPE TOGGLE (same animation as navbar) ─────────────────

class WoniScopeToggle extends StatefulWidget {
  const WoniScopeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    this.labels = const ['Personal', 'Family'],
  });

  final int selected;
  final void Function(int) onChanged;
  final List<String> labels;

  @override
  State<WoniScopeToggle> createState() => _WoniScopeToggleState();
}

class _WoniScopeToggleState extends State<WoniScopeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _prevIndex = widget.selected;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant WoniScopeToggle old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) {
      _prevIndex = old.selected;
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
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final inactiveColor = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    const toggleHeight = 36.0;
    const toggleRadius = 12.0;
    const hPad = 3.0;
    const overX = 2.0;
    const overY = 1.0;
    const totalH = toggleHeight + overY * 2;
    final itemCount = widget.labels.length;

    return SizedBox(
      height: totalH,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final innerWidth = totalWidth - overX * 2;
          final btnWidth = (innerWidth - hPad * 2) / itemCount;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Layer 1: Glass background ──
              Positioned(
                left: overX,
                right: overX,
                top: overY,
                height: toggleHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(toggleRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(toggleRadius),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Layer 2: Stretchy glass lens indicator ──
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  final t = _ctrl.value;

                  final leadT = Curves.easeOutCubic.transform(t);
                  final trailT = Curves.easeOutCubic.transform(
                    (t * 1.05 - 0.05).clamp(0.0, 1.0),
                  );

                  final fromPos = hPad + _prevIndex * btnWidth;
                  final toPos = hPad + widget.selected * btnWidth;

                  double indLeft;
                  double indRight;

                  if (toPos >= fromPos) {
                    indLeft = fromPos + (toPos - fromPos) * trailT;
                    indRight = fromPos + btnWidth + (toPos - fromPos) * leadT;
                  } else {
                    indLeft = fromPos + (toPos - fromPos) * leadT;
                    indRight = fromPos + btnWidth + (toPos - fromPos) * trailT;
                  }

                  final stretch = (indRight - indLeft) / btnWidth;
                  final squeeze = stretch > 1.0
                      ? 1.0 + (stretch - 1.0) * 0.50
                      : 1.0;

                  final squeezeH = totalH / squeeze;
                  final squeezeTop = (totalH - squeezeH) / 2;

                  final pixelLeft = overX + indLeft - overX;
                  final pixelWidth = (indRight - indLeft) + overX * 2;

                  return Positioned(
                    left: pixelLeft,
                    top: squeezeTop,
                    width: pixelWidth,
                    height: squeezeH,
                    child: _ToggleGlassLens(
                      radius: toggleRadius,
                      isDark: isDark,
                      shimmerT: t,
                    ),
                  );
                },
              ),

              // ── Layer 3: Label buttons ──
              Positioned(
                left: overX + hPad,
                right: overX + hPad,
                top: overY,
                height: toggleHeight,
                child: Row(
                  children: widget.labels.asMap().entries.map((e) {
                    final isActive = e.key == widget.selected;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onChanged(e.key),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: WoniTextStyles.body.copyWith(
                              fontSize: 13,
                              color: isActive ? accent : inactiveColor,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            ),
                            child: Text(e.value),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Glass lens for toggle indicator ─────────────────────────────────────────

class _ToggleGlassLens extends StatelessWidget {
  const _ToggleGlassLens({
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
            ],
          ),
          child: _ToggleShimmer(t: shimmerT),
        ),
      ),
    );
  }
}

// ── Shimmer for toggle ──────────────────────────────────────────────────────

class _ToggleShimmer extends StatelessWidget {
  const _ToggleShimmer({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    if (t <= 0 || t >= 1) return const SizedBox.expand();

    final opacity = t < 0.2
        ? (t / 0.2) * 0.65
        : 0.65 * (1 - ((t - 0.2) / 0.8));

    return Transform.translate(
      offset: Offset((t * 2 - 1) * 80, 0),
      child: Container(
        width: 30,
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

// ─── BALANCE CARD (Clean — no gradient, no decorative circles) ──────────────

class WoniBalanceCard extends StatelessWidget {
  const WoniBalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.period = '\u0424\u0435\u0432\u0440\u0430\u043b\u044c 2026',
  });

  final int balance;
  final int income;
  final int expense;
  final String period;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(WoniSpacing.lg),
              decoration: BoxDecoration(
                color: isDark
                    ? WoniColors.current.darkGlass.withValues(alpha: 0.82)
                    : WoniColors.current.lightGlass.withValues(alpha: 0.80),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u0411\u0430\u043b\u0430\u043d\u0441 \u00b7 $period',
                    style: WoniTextStyles.caption.copyWith(color: textColor2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${balance >= 0 ? '+' : ''}${_fmt(balance)}\u20a9',
                    style: WoniTextStyles.amountLarge.copyWith(color: accent),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _Stat(
                        label: '\u0414\u043e\u0445\u043e\u0434',
                        value: income,
                        positive: true,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _Stat(
                        label: '\u0420\u0430\u0441\u0445\u043e\u0434',
                        value: expense,
                        positive: false,
                        isDark: isDark,
                      ),
                    ],
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
    );
  }

  String _fmt(int n) {
    final abs = n.abs();
    if (abs >= 1000000) return '${(abs / 1000000).toStringAsFixed(1)}M';
    final s = abs.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.positive, required this.isDark});
  final String label;
  final int value;
  final bool positive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final abs = value.abs();
    final display = abs >= 1000000
        ? '${(abs / 1000000).toStringAsFixed(1)}M\u20a9'
        : '$abs\u20a9';
    final color = positive
        ? (isDark ? WoniColors.greenDark : WoniColors.green)
        : (isDark ? WoniColors.coralDark : WoniColors.coral);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: WoniRadius.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: WoniTextStyles.caption.copyWith(
              color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
            )),
            const SizedBox(height: 2),
            Text(display, style: WoniTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            )),
          ],
        ),
      ),
    );
  }
}
