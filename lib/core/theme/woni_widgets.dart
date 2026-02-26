import 'package:flutter/material.dart';
import 'woni_theme.dart';

// ─── BUTTONS ─────────────────────────────────────────────────────────────────

enum WoniButtonVariant { primary, success, danger, ghost }

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
    final (bg, fg, shadow) = switch (variant) {
      WoniButtonVariant.primary => (
          const LinearGradient(colors: [WoniColors.blue, Color(0xFF7B6EF6)]),
          Colors.white,
          WoniShadows.blue(),
        ),
      WoniButtonVariant.success => (
          const LinearGradient(colors: [WoniColors.green, Color(0xFF22A85F)]),
          Colors.white,
          WoniShadows.green(),
        ),
      WoniButtonVariant.danger => (
          const LinearGradient(colors: [WoniColors.coral, Color(0xFFE84343)]),
          Colors.white,
          <BoxShadow>[],
        ),
      WoniButtonVariant.ghost => (
          null,
          null,
          <BoxShadow>[],
        ),
    };

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = small ? 36.0 : 50.0;
    final hPad   = small ? 16.0 : 22.0;
    final radius = small ? WoniRadius.sm : WoniRadius.md;

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
        duration: const Duration(milliseconds: 120),
        width: fullWidth ? double.infinity : null,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        decoration: BoxDecoration(
          gradient: bg,
          color: bg == null
              ? (isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2)
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

// ─── CHIP ────────────────────────────────────────────────────────────────────

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
      WoniChipVariant.blue    => (WoniColors.blue.withOpacity(0.12),   WoniColors.blue),
      WoniChipVariant.green   => (WoniColors.green.withOpacity(0.12),  WoniColors.green),
      WoniChipVariant.coral   => (WoniColors.coral.withOpacity(0.12),  WoniColors.coral),
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
          Text(label, style: WoniTextStyles.bodySecondary.copyWith(color: fg, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// ─── SURFACE CARD ────────────────────────────────────────────────────────────

class WoniCard extends StatelessWidget {
  const WoniCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(WoniSpacing.lg),
    this.radius = WoniRadius.lg,
    this.margin,
    this.gradient,
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius radius;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? (isDark ? WoniColors.darkSurface : WoniColors.lightSurface)) : null,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
        boxShadow: WoniShadows.sm(isDark),
      ),
      child: child,
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
    this.currency = '₩',
  });

  final int amount;
  final bool large;
  final bool showSign;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive ? WoniColors.green : WoniColors.coral;
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

// ─── SECTION HEADER ──────────────────────────────────────────────────────────

class WoniSectionHeader extends StatelessWidget {
  const WoniSectionHeader({super.key, required this.title, this.action, this.actionLabel = '전체 →'});

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
              style: WoniTextStyles.caption.copyWith(color: WoniColors.blue, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

// ─── AI INPUT BAR ────────────────────────────────────────────────────────────

class WoniAIBar extends StatefulWidget {
  const WoniAIBar({super.key, this.onSubmit, this.onCamera, this.placeholder = '4500 커피 어제...'});

  final void Function(String)? onSubmit;
  final VoidCallback? onCamera;
  final String placeholder;

  @override
  State<WoniAIBar> createState() => _WoniAIBarState();
}

class _WoniAIBarState extends State<WoniAIBar> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
        borderRadius: WoniRadius.md,
        border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder, width: 1.5),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: WoniColors.blue.withOpacity(0.5 + _pulse.value * 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: WoniTextStyles.body.copyWith(
                color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: WoniTextStyles.body.copyWith(
                  color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                  fontSize: 13,
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
                color: WoniColors.blue,
                borderRadius: WoniRadius.sm,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SCOPE TOGGLE ────────────────────────────────────────────────────────────

class WoniScopeToggle extends StatelessWidget {
  const WoniScopeToggle({super.key, required this.selected, required this.onChanged, this.labels = const ['Personal', 'Family']});

  final int selected;
  final void Function(int) onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
        borderRadius: WoniRadius.md,
      ),
      child: Row(
        children: labels.asMap().entries.map((e) {
          final isActive = e.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? WoniColors.blue : Colors.transparent,
                  borderRadius: WoniRadius.sm,
                  boxShadow: isActive ? WoniShadows.blue() : null,
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: WoniTextStyles.body.copyWith(
                    fontSize: 13,
                    color: isActive ? Colors.white : (isDark ? WoniColors.darkText2 : WoniColors.lightText2),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── BALANCE GRADIENT CARD ────────────────────────────────────────────────────

class WoniBalanceCard extends StatelessWidget {
  const WoniBalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.period = 'Февраль 2026',
  });

  final int balance;
  final int income;
  final int expense;
  final String period;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
      padding: const EdgeInsets.all(WoniSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WoniColors.blue, Color(0xFF7B6EF6)],
        ),
        borderRadius: WoniRadius.xl,
        boxShadow: WoniShadows.blue(),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30, right: -30,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40, right: 20,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '잔액 · $period',
                style: WoniTextStyles.caption.copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 6),
              Text(
                '${balance >= 0 ? '+' : ''}${_fmt(balance)}₩',
                style: WoniTextStyles.amountLarge.copyWith(color: Colors.white, fontSize: 34),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Stat(label: '수입', value: income, positive: true),
                  const SizedBox(width: 10),
                  _Stat(label: '지출', value: expense, positive: false),
                ],
              ),
            ],
          ),
        ],
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
  const _Stat({required this.label, required this.value, required this.positive});
  final String label;
  final int value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final abs = value.abs();
    final display = abs >= 1000000
        ? '${(abs / 1000000).toStringAsFixed(1)}M₩'
        : '$abs₩';

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: WoniRadius.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: WoniTextStyles.caption.copyWith(color: Colors.white60, fontSize: 9)),
            const SizedBox(height: 2),
            Text(display, style: WoniTextStyles.body.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
