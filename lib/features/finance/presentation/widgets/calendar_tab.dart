import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/features/finance/presentation/widgets/shift_preset_settings.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});
  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late DateTime _month;
  DateTime? _selectedDate;
  OverlayEntry? _presetOverlay;
  int _shimmerKey = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  List<ShiftEntry> _monthShifts(List<ShiftEntry> all) =>
      all.where((s) => s.date.year == _month.year && s.date.month == _month.month).toList();

  /// Calculates salary totals correctly:
  /// - hourly/fixedDaily/manualDaily shifts → sum basePay + bonusPay
  /// - fixedMonthly → add full monthly amount once per unique preset
  ({int total, int base, int bonus}) _calcSalary(
      List<ShiftEntry> monthShifts, List<ShiftPreset> presets) {
    int base = 0, bonus = 0;
    final monthlyPresetIds = <String>{};

    for (final s in monthShifts) {
      final preset = presets.where((p) => p.id == s.presetId).firstOrNull;
      if (preset != null && preset.payMode == PayMode.fixedMonthly) {
        monthlyPresetIds.add(preset.id);
      } else {
        base += s.basePay;
        bonus += s.bonusPay;
      }
    }

    for (final id in monthlyPresetIds) {
      final p = presets.where((p) => p.id == id).firstOrNull;
      if (p != null) base += p.fixedMonthlyAmount ?? 0;
    }

    return (total: base + bonus, base: base, bonus: bonus);
  }

  /// Calculates hour statistics by shift type
  ({double totalHours, double overtimeHours, double nightHours}) _calcHoursStats(
      List<ShiftEntry> monthShifts) {
    double totalH = 0, overtimeH = 0, nightH = 0;
    for (final s in monthShifts) {
      final hours = s.hoursWorked;
      totalH += hours;
      if (s.type == ShiftType.overtime || s.type == ShiftType.weekendOvertime) {
        overtimeH += hours;
      }
      if (s.type == ShiftType.night) {
        nightH += hours;
      }
    }
    return (totalHours: totalH, overtimeHours: overtimeH, nightHours: nightH);
  }

  void _showPresetPopup(BuildContext context, DateTime date, Rect cellRect) {
    _presetOverlay?.remove();
    final state = AppStateScope.read(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    _presetOverlay = OverlayEntry(
      builder: (ctx) {
        // Calculate popup width to center it
        final presetCount = state.shiftPresets.length;
        final popupWidth = presetCount * 52.0 + 16;
        // Position centered below the cell
        var left = cellRect.center.dx - popupWidth / 2;
        // Clamp to screen bounds
        left = left.clamp(8.0, screenWidth - popupWidth - 8);

        return Stack(
          children: [
            // Translucent listener: closes popup AND lets tap pass through to calendar cells
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) { _presetOverlay?.remove(); _presetOverlay = null; },
              child: const SizedBox.expand(),
            ),
            Positioned(
              left: left,
              top: cellRect.bottom + 4,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: state.shiftPresets.map((preset) {
                      return GestureDetector(
                        onTap: () {
                          _presetOverlay?.remove();
                          _presetOverlay = null;
                          _assignShift(date, preset);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: preset.color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                preset.name,
                                style: WoniTextStyles.bodySecondary.copyWith(
                                  color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(_presetOverlay!);
  }

  void _assignShift(DateTime date, ShiftPreset preset) {
    int basePay;
    int bonusPay = 0;

    switch (preset.payMode) {
      case PayMode.hourly:
        final calc = ShiftCalculator.calculate(
          start: preset.defaultStart,
          end: preset.defaultEnd,
          type: preset.shiftType,
          breakMinutes: preset.breakMinutes,
          hourlyRate: preset.hourlyRate,
        );
        basePay = calc.basePay;
        bonusPay = calc.bonusPay;

      case PayMode.fixedMonthly:
        basePay = 0; // marker only — full amount shown in salary summary

      case PayMode.fixedDaily:
        basePay = preset.fixedDailyAmount ?? 0;

      case PayMode.manualDaily:
        _showManualAmountDialog(date, preset);
        return;
    }

    _addShiftEntry(date, preset, basePay, bonusPay);
  }

  void _showManualAmountDialog(DateTime date, ShiftPreset preset) {
    final ctrl = TextEditingController();
    final isDark = AppStateScope.of(context).themeMode == ThemeMode.dark;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface2 = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          S.enterAmount,
          style: WoniTextStyles.heading2.copyWith(color: textColor),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: WoniTextStyles.body.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: '50000',
            hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
            suffixText: '₩',
            suffixStyle: WoniTextStyles.body.copyWith(color: textColor3),
            filled: true,
            fillColor: surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.cancel, style: WoniTextStyles.body.copyWith(color: textColor3)),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(ctrl.text.trim()) ?? 0;
              if (amount > 0) {
                Navigator.pop(ctx);
                _addShiftEntry(date, preset, amount, 0);
              }
            },
            child: Text(S.save, style: WoniTextStyles.body.copyWith(color: WoniColors.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _addShiftEntry(DateTime date, ShiftPreset preset, int basePay, int bonusPay) {
    final state = AppStateScope.read(context);
    // Remove existing shifts on this date (replace, not accumulate)
    final existingShifts = state.shifts
        .where((s) => s.date.year == date.year && s.date.month == date.month && s.date.day == date.day)
        .toList();
    for (final old in existingShifts) {
      state.removeShift(old.id);
    }
    state.addShift(ShiftEntry(
      id: 'shift_${state.nextId()}',
      date: date,
      startTime: preset.defaultStart,
      endTime: preset.defaultEnd,
      type: preset.shiftType,
      basePay: basePay,
      bonusPay: bonusPay,
      breakMinutes: preset.breakMinutes,
      presetId: preset.id,
    ));
  }

  @override
  void dispose() {
    _presetOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final monthShifts = _monthShifts(state.shifts);
    final salary = _calcSalary(monthShifts, state.shiftPresets);
    final totalPay = salary.total;
    final totalBase = salary.base;
    final totalBonus = salary.bonus;
    final hoursStats = _calcHoursStats(monthShifts);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(WoniSpacing.lg),
      child: Column(
        children: [
          // ── Salary summary (TOP) ────────────────────────────────────
          WoniCard(
            color: surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.estimatedPay,
                  style: WoniTextStyles.caption.copyWith(color: textColor3, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  '${fmtKRWFull(totalPay)}\u20a9',
                  style: WoniTextStyles.amountLarge.copyWith(color: WoniColors.green),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _MiniStat(label: S.basePay, value: '${fmtKRW(totalBase)}\u20a9', color: WoniColors.blue),
                    _MiniStat(label: S.bonusPay, value: '${fmtKRW(totalBonus)}\u20a9', color: WoniColors.violet),
                    _MiniStat(label: S.shiftsCount, value: '${monthShifts.length}', color: textColor2),
                    _MiniStat(label: S.hoursWorked, value: '${hoursStats.totalHours.toStringAsFixed(1)}h', color: textColor2),
                    _MiniStat(label: S.overtimeHours, value: '${hoursStats.overtimeHours.toStringAsFixed(1)}h', color: WoniColors.violet),
                    _MiniStat(label: S.nightHours, value: '${hoursStats.nightHours.toStringAsFixed(1)}h', color: WoniColors.warning),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: WoniSpacing.lg),

          // ── Calendar block (glass card) ────────────────────────────
          WoniCard(
            color: surface,
            child: Column(
              children: [
                // Month nav
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 24),
                      color: textColor2,
                      onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
                    ),
                    Text(
                      '${S.monthName(_month.month)} ${_month.year}',
                      style: WoniTextStyles.heading2.copyWith(color: textColor),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 24),
                      color: textColor2,
                      onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Weekday headers
                _WeekdayRow(isDark: isDark),
                const SizedBox(height: 4),

                // Calendar grid with Liquid Glass indicator
                _LiquidGlassCalendar(
                  month: _month,
                  shifts: state.shifts,
                  presets: state.shiftPresets,
                  selectedDate: _selectedDate,
                  isDark: isDark,
                  shimmerKey: _shimmerKey,
                  onDayTap: (date, cellRect) {
                    setState(() {
                      _selectedDate = date;
                      _shimmerKey++;
                    });
                    _showPresetPopup(context, date, cellRect);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: WoniSpacing.lg),

          // ── Preset icons strip ──────────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              S.shifts.toUpperCase(),
              style: WoniTextStyles.caption.copyWith(color: textColor3, letterSpacing: 1.0),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: WoniSpacing.sm,
              runSpacing: WoniSpacing.sm,
              children: [
                for (final preset in state.shiftPresets)
                  GestureDetector(
                    onTap: () => ShiftPresetEditor.show(context, preset: preset),
                    child: SizedBox(
                      width: 56,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: preset.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: WoniGlare(isDark: isDark),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preset.name,
                            style: WoniTextStyles.bodySecondary.copyWith(
                              color: textColor2,
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () => ShiftPresetEditor.show(context),
                  child: SizedBox(
                    width: 56,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
                            borderRadius: WoniRadius.lg,
                            border: Border.all(
                              color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(Icons.add_rounded, size: 22, color: textColor3),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.newPreset,
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: textColor3,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: WoniSpacing.xxxl),
        ],
      ),
    );
  }
}

// ── Liquid Glass Calendar Grid ─────────────────────────────────────────────

class _LiquidGlassCalendar extends StatelessWidget {
  const _LiquidGlassCalendar({
    required this.month,
    required this.shifts,
    required this.presets,
    required this.selectedDate,
    required this.isDark,
    required this.shimmerKey,
    required this.onDayTap,
  });

  final DateTime month;
  final List<ShiftEntry> shifts;
  final List<ShiftPreset> presets;
  final DateTime? selectedDate;
  final bool isDark;
  final int shimmerKey;
  final void Function(DateTime date, Rect cellRect) onDayTap;

  static const double gridGap = 4.0;
  static const int gridCols = 7;

  Color _presetColor(ShiftEntry shift) {
    final preset = presets.where((p) => p.id == shift.presetId).firstOrNull;
    return preset?.color ?? shiftTypeColor(shift.type);
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int startOffset = firstDay.weekday - 1;
    if (startOffset < 0) startOffset = 6;
    final prevMonthDays = DateTime(month.year, month.month, 0).day;
    final now = DateTime.now();
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;

    final List<_DayData> days = [];
    for (int i = startOffset - 1; i >= 0; i--) {
      days.add(_DayData(day: prevMonthDays - i, isCurrent: false));
    }
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(_DayData(day: i, isCurrent: true));
    }
    final remaining = 42 - days.length;
    for (int i = 1; i <= remaining; i++) {
      days.add(_DayData(day: i, isCurrent: false));
    }

    int todayIndex = -1;
    int selectedIndex = -1;
    for (int i = 0; i < days.length; i++) {
      if (!days[i].isCurrent) continue;
      final date = DateTime(month.year, month.month, days[i].day);
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        todayIndex = i;
      }
      if (selectedDate != null &&
          date.year == selectedDate!.year &&
          date.month == selectedDate!.month &&
          date.day == selectedDate!.day) {
        selectedIndex = i;
      }
    }

    // Responsive: use LayoutBuilder for full width
    return LayoutBuilder(
      builder: (context, constraints) {
        final availWidth = constraints.maxWidth;
        final cellSize = (availWidth - (gridCols - 1) * gridGap) / gridCols;
        final gridWidth = availWidth;

        // Today indicator position (always visible, static)
        Offset? todayPos;
        if (todayIndex >= 0) {
          final col = todayIndex % gridCols;
          final row = todayIndex ~/ gridCols;
          todayPos = Offset(
            col * (cellSize + gridGap),
            row * (cellSize + gridGap),
          );
        }

        // Selected date indicator position (subtle ring, only when != today AND no shift)
        Offset? selectedPos;
        final selectedDayHasShift = selectedIndex >= 0 && (() {
          final d = days[selectedIndex];
          return d.isCurrent && shifts.any((s) =>
              s.date.year == month.year && s.date.month == month.month && s.date.day == d.day);
        })();
        if (selectedIndex >= 0 && selectedIndex != todayIndex && !selectedDayHasShift) {
          final col = selectedIndex % gridCols;
          final row = selectedIndex ~/ gridCols;
          selectedPos = Offset(
            col * (cellSize + gridGap),
            row * (cellSize + gridGap),
          );
        }

        return SizedBox(
          width: gridWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── TODAY: small underline dash beneath the day number ──
              if (todayPos != null)
                Positioned(
                  top: todayPos.dy + cellSize * 0.72,
                  left: todayPos.dx + cellSize * 0.3,
                  child: Container(
                    width: cellSize * 0.4,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

              // ── SELECTED: subtle animated ring (less prominent) ──
              if (selectedPos != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 380),
                  curve: const Cubic(0.32, 0.72, 0, 1),
                  top: selectedPos.dy,
                  left: selectedPos.dx,
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(cellSize * 0.34),
                      border: Border.all(
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.18),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),

              // ── Day grid ──
              Wrap(
                spacing: gridGap,
                runSpacing: gridGap,
                children: days.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;

                  final isToday = i == todayIndex;
                  final isSelected = i == selectedIndex && selectedIndex != todayIndex;
                  final isWeekend = i % 7 >= 5;

                  final dayShifts = d.isCurrent
                      ? shifts.where((s) =>
                          s.date.year == month.year &&
                          s.date.month == month.month &&
                          s.date.day == d.day).toList()
                      : <ShiftEntry>[];

                  final dayPay = dayShifts.fold(0, (sum, s) => sum + s.totalPay);

                  Color color;
                  if (isToday) {
                    // Today is always accent-colored (prominent)
                    color = accent;
                  } else if (isSelected) {
                    // Selected date — slightly brighter than normal
                    color = textColor;
                  } else if (isWeekend && d.isCurrent) {
                    color = (isDark ? WoniColors.coralDark : WoniColors.coral).withValues(alpha: 0.55);
                  } else {
                    color = d.isCurrent ? textColor : (isDark ? const Color(0xFF1E3450) : const Color(0xFFC8D8E8));
                  }

                  final hasShift = dayShifts.isNotEmpty;
                  final shiftColor = hasShift ? _presetColor(dayShifts.first) : null;
                  final cellRadius = BorderRadius.circular(cellSize * 0.3);
                  final isHighlighted = (isToday || isSelected) && hasShift;

                  return GestureDetector(
                    onTapUp: d.isCurrent
                        ? (details) {
                            // Calculate cell rect in global coordinates
                            final box = context.findRenderObject() as RenderBox;
                            final gridGlobalPos = box.localToGlobal(Offset.zero);
                            final col = i % gridCols;
                            final row = i ~/ gridCols;
                            final cellLeft = gridGlobalPos.dx + col * (cellSize + gridGap);
                            final cellTop = gridGlobalPos.dy + row * (cellSize + gridGap);
                            final cellRect = Rect.fromLTWH(cellLeft, cellTop, cellSize, cellSize);
                            onDayTap(
                              DateTime(month.year, month.month, d.day),
                              cellRect,
                            );
                          }
                        : null,
                    child: ClipRRect(
                      borderRadius: cellRadius,
                      child: Container(
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          // Glass-lens style for shift cells (brighter when selected/today)
                          color: hasShift
                              ? shiftColor!.withValues(alpha: isHighlighted ? 0.35 : 0.15)
                              : Colors.transparent,
                          borderRadius: cellRadius,
                          border: hasShift
                              ? Border.all(
                                  color: shiftColor!.withValues(alpha: isHighlighted ? 0.7 : 0.25),
                                  width: isHighlighted ? 1.8 : 0.5,
                                )
                              : null,
                          boxShadow: hasShift
                              ? [
                                  BoxShadow(
                                    color: shiftColor!.withValues(alpha: isHighlighted ? 0.25 : 0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // iOS-style glare overlay for shift cells
                            if (hasShift)
                              Positioned.fill(
                                child: WoniGlare(isDark: isDark),
                              ),
                            Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${d.day}',
                              style: WoniTextStyles.body.copyWith(
                                color: color,
                                fontWeight: isToday ? FontWeight.w700 : (isSelected ? FontWeight.w600 : FontWeight.w500),
                                fontSize: (cellSize * 0.30).clamp(11.0, 20.0),
                                height: 1.0,
                              ),
                            ),
                            if (dayShifts.isNotEmpty && dayPay > 0)
                              Padding(
                                padding: EdgeInsets.only(top: cellSize * 0.05),
                                child: Text(
                                  fmtKRW(dayPay),
                                  style: WoniTextStyles.bodySecondary.copyWith(
                                    color: (isDark ? WoniColors.greenDark : WoniColors.green),
                                    fontSize: (cellSize * 0.22).clamp(8.0, 13.0),
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                          ],
                        ),
                      ]),
                    ),
                  ));
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Glass indicator widget with shimmer ──────────────────────────────────────

class _GlassIndicator extends StatelessWidget {
  const _GlassIndicator({
    required this.size,
    required this.isDark,
    required this.shimmerKey,
  });

  final double size;
  final bool isDark;
  final int shimmerKey;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.34;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.9),
            blurRadius: 0,
            offset: const Offset(0, 0.5),
            blurStyle: BlurStyle.inner,
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _ShimmerOverlay(key: ValueKey(shimmerKey), isDark: isDark),
      ),
    );
  }
}

// ── Shimmer animation overlay ────────────────────────────────────────────────

class _ShimmerOverlay extends StatefulWidget {
  const _ShimmerOverlay({super.key, required this.isDark});
  final bool isDark;

  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final opacity = t < 0.2 ? t / 0.2 : (1 - t) / 0.8;

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((-1 + 2 * t) * 80, 0),
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-5 / 360),
              child: Container(
                width: 40,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      (widget.isDark ? Colors.white : Colors.white).withValues(
                          alpha: widget.isDark ? 0.12 : 0.7),
                      (widget.isDark ? Colors.white : Colors.white).withValues(
                          alpha: widget.isDark ? 0.18 : 0.95),
                      (widget.isDark ? Colors.white : Colors.white).withValues(
                          alpha: widget.isDark ? 0.12 : 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Weekday Row ──────────────────────────────────────────────────────────────

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: S.weekdays.asMap().entries.map((e) {
        final isWeekend = e.key >= 5;
        return Expanded(
          child: Center(
            child: Text(
              e.value,
              style: WoniTextStyles.bodySecondary.copyWith(
                color: isWeekend
                    ? (isDark
                        ? WoniColors.coralDark.withValues(alpha: 0.4)
                        : WoniColors.coral.withValues(alpha: 0.4))
                    : (isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.02,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Day data ─────────────────────────────────────────────────────────────────

class _DayData {
  const _DayData({required this.day, required this.isCurrent});
  final int day;
  final bool isCurrent;
}

// ── Mini Stat ────────────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = AppStateScope.of(context).themeMode == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: WoniTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w800)),
        Text(label, style: WoniTextStyles.bodySecondary.copyWith(
          color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
          fontSize: 10,
        )),
      ],
    );
  }
}

// _GlarePainter removed — replaced by WoniGlare (iOS-style perimeter highlights)
