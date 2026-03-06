import 'package:flutter/material.dart';
import 'woni_theme.dart';

enum WoniIconType {
  // Navigation
  home, finance, account,
  // Shifts
  shiftDay, shiftNight, shiftHelmet, shiftBriefcase,
  // Categories
  catFood, catTransport, catShopping, catHousing,
  catHealth, catUtilities, catLeisure, catOther,
}

// ─── SHIFT COLOR BLOCK ─────────────────────────────────────────────────────

class WoniShiftIcon extends StatelessWidget {
  const WoniShiftIcon({
    super.key,
    this.size = 44,
    required this.color,
    this.borderRadius,
    this.showShadow = false,
  });

  final double size;
  final Color color;
  final BorderRadius? borderRadius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size * 0.2);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        boxShadow: showShadow
            ? [BoxShadow(
                color: color.withOpacity(0.20),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )]
            : null,
      ),
    );
  }
}

// ─── SHIFT COLOR CHIP ──────────────────────────────────────────────────────

class WoniShiftChip extends StatelessWidget {
  const WoniShiftChip({
    super.key,
    required this.color,
    this.width = 4,
    this.height = 36,
    this.radius = 2,
  });

  final Color color;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── NAV ICON (Material outline — replaces CustomPainter) ───────────────────

class WoniIcon extends StatelessWidget {
  const WoniIcon(this.type, {super.key, this.size = 24, this.color, this.active = false});

  final WoniIconType type;
  final double size;
  final Color? color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final inactive = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final c = color ?? (active ? accent : inactive);

    final icon = switch (type) {
      WoniIconType.home     => active ? Icons.home_rounded     : Icons.home_outlined,
      WoniIconType.finance  => active ? Icons.account_balance_wallet_rounded : Icons.account_balance_wallet_outlined,
      WoniIconType.account  => active ? Icons.person_rounded   : Icons.person_outline_rounded,
      _ => Icons.circle_outlined,
    };

    return Icon(icon, size: size, color: c);
  }
}

// ─── CATEGORY ICON (Material outline — replaces CustomPainter) ──────────────

class WoniCatIcon extends StatelessWidget {
  const WoniCatIcon(this.type, {super.key, this.size = 24, this.color});
  final WoniIconType type;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? WoniColors.darkText2 : WoniColors.lightText2);

    final icon = switch (type) {
      WoniIconType.catFood      => Icons.restaurant_outlined,
      WoniIconType.catTransport => Icons.directions_bus_outlined,
      WoniIconType.catShopping  => Icons.shopping_bag_outlined,
      WoniIconType.catHousing   => Icons.home_outlined,
      WoniIconType.catHealth    => Icons.local_hospital_outlined,
      WoniIconType.catUtilities => Icons.bolt_outlined,
      WoniIconType.catLeisure   => Icons.sports_esports_outlined,
      WoniIconType.catOther     => Icons.inventory_2_outlined,
      _ => Icons.circle_outlined,
    };

    return Icon(icon, size: size, color: c);
  }
}
