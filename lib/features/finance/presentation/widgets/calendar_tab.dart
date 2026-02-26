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

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  List<ShiftEntry> _monthShifts(List<ShiftEntry> all) =>
      all.where((s) => s.date.year == _month.year && s.date.month == _month.month).toList();

  void _showPresetPopup(BuildContext context, DateTime date, Offset tapPos) {
    _presetOverlay?.remove();
    final state = AppStateScope.read(context);
    final isDark = state.themeMode == ThemeMode.dark;

    _presetOverlay = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          GestureDetector(
            onTap: () { _presetOverlay?.remove(); _presetOverlay = null; },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: tapPos.dx - 60,
            top: tapPos.dy + 10,
            child: Material(
              elevation: 8,
              borderRadius: WoniRadius.md,
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
                            Text(preset.emoji, style: const TextStyle(fontSize: 22)),
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
      ),
    );
    Overlay.of(context).insert(_presetOverlay!);
  }

  void _assignShift(DateTime date, ShiftPreset preset) {
    if (preset.fixedDailyAmount != null) {
      // Fixed amount → auto-add shift
      _addShiftEntry(date, preset, preset.fixedDailyAmount!, 0);
      return;
    }
    // No fixed amount → calculate suggestion, show dialog
    final calc = ShiftCalculator.calculate(
      start: preset.defaultStart,
      end: preset.defaultEnd,
      type: preset.shiftType,
      breakMinutes: preset.breakMinutes,
      hourlyRate: preset.hourlyRate,
    );
    _showAmountDialog(date, preset, calc.basePay + calc.bonusPay);
  }

  void _addShiftEntry(DateTime date, ShiftPreset preset, int basePay, int bonusPay) {
    final state = AppStateScope.read(context);
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

  void _showAmountDialog(DateTime date, ShiftPreset preset, int suggestion) {
    final ctrl = TextEditingController(text: suggestion > 0 ? '$suggestion' : '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${preset.emoji} ${S.enterAmount}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '0 ₩',
            suffixText: '₩',
            helperText: suggestion > 0 ? '≈ ${fmtKRWFull(suggestion)}₩' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.cancel)),
          TextButton(
            onPressed: () {
              final amt = int.tryParse(ctrl.text) ?? 0;
              if (amt > 0) {
                _addShiftEntry(date, preset, amt, 0);
              }
              Navigator.pop(context);
            },
            child: Text(S.save),
          ),
        ],
      ),
    );
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
    final totalPay = monthShifts.fold(0, (sum, s) => sum + s.totalPay);
    final totalBase = monthShifts.fold(0, (sum, s) => sum + s.basePay);
    final totalBonus = monthShifts.fold(0, (sum, s) => sum + s.bonusPay);

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
                  '${fmtKRWFull(totalPay)}₩',
                  style: WoniTextStyles.amountLarge.copyWith(color: WoniColors.green),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MiniStat(label: S.basePay, value: '${fmtKRW(totalBase)}₩', color: WoniColors.blue),
                    const SizedBox(width: 16),
                    _MiniStat(label: S.bonusPay, value: '${fmtKRW(totalBonus)}₩', color: WoniColors.violet),
                    const SizedBox(width: 16),
                    _MiniStat(label: S.shiftsCount, value: '${monthShifts.length}', color: textColor2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: WoniSpacing.lg),

          // ── Month nav + settings ──────────────────────────────────
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

          // ── Weekday headers ────────────────────────────────────────
          _WeekdayRow(isDark: isDark),
          const SizedBox(height: 4),

          // ── Calendar grid ──────────────────────────────────────────
          _CalendarGrid(
            month: _month,
            shifts: state.shifts,
            selectedDate: _selectedDate,
            isDark: isDark,
            onDayTap: (date, tapPos) {
              setState(() => _selectedDate = date);
              _showPresetPopup(context, date, tapPos);
            },
          ),
          const SizedBox(height: WoniSpacing.lg),

          // ── Preset icons strip ─────────────────────────────────────
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
                    onTap: () => ShiftPresetSettings.show(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: preset.color.withValues(alpha: 0.12),
                        borderRadius: WoniRadius.sm,
                      ),
                      child: Center(
                        child: Text(preset.emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  ),
                // Add preset button
                GestureDetector(
                  onTap: () => ShiftPresetSettings.show(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
                      borderRadius: WoniRadius.sm,
                      border: Border.all(
                        color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(Icons.add_rounded, size: 22, color: textColor3),
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

// ── Weekday Row ──────────────────────────────────────────────────────────────

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: S.weekdays.map((d) => Expanded(
        child: Center(
          child: Text(
            d,
            style: WoniTextStyles.bodySecondary.copyWith(
              color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
              fontSize: 11,
            ),
          ),
        ),
      )).toList(),
    );
  }
}

// ── Calendar Grid ────────────────────────────────────────────────────────────

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.shifts,
    required this.selectedDate,
    required this.isDark,
    required this.onDayTap,
  });

  final DateTime month;
  final List<ShiftEntry> shifts;
  final DateTime? selectedDate;
  final bool isDark;
  final void Function(DateTime date, Offset tapPosition) onDayTap;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startOffset = (firstDay.weekday - 1) % 7;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final now = DateTime.now();
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final dayNum = cellIndex - startOffset + 1;

            if (dayNum < 1 || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 54));
            }

            final date = DateTime(month.year, month.month, dayNum);
            final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
            final isSelected = selectedDate != null &&
                date.year == selectedDate!.year &&
                date.month == selectedDate!.month &&
                date.day == selectedDate!.day;

            final dayShifts = shifts.where((s) =>
                s.date.year == date.year &&
                s.date.month == date.month &&
                s.date.day == date.day).toList();

            final dayPay = dayShifts.fold(0, (sum, s) => sum + s.totalPay);

            return Expanded(
              child: GestureDetector(
                onTapUp: (details) => onDayTap(date, details.globalPosition),
                child: Container(
                  height: 54,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? WoniColors.blue.withValues(alpha: 0.15)
                        : isToday
                            ? WoniColors.blue.withValues(alpha: 0.06)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday ? Border.all(color: WoniColors.blue.withValues(alpha: 0.3), width: 1) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: WoniTextStyles.body.copyWith(
                          color: isSelected ? WoniColors.blue : (col >= 5 ? WoniColors.coral.withValues(alpha: 0.7) : textColor),
                          fontWeight: isToday ? FontWeight.w900 : FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      if (dayShifts.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dayShifts.take(3).map((s) => Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 1, left: 1, right: 1),
                            decoration: BoxDecoration(
                              color: shiftTypeColor(s.type),
                              shape: BoxShape.circle,
                            ),
                          )).toList(),
                        ),
                        Text(
                          '${fmtKRW(dayPay)}',
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: WoniColors.green,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
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
