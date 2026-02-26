import 'package:flutter/material.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/state/app_state.dart';

/// Bottom sheet for adding a work shift.
class AddShiftSheet extends StatefulWidget {
  const AddShiftSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddShiftSheet(),
    );
  }

  @override
  State<AddShiftSheet> createState() => _AddShiftSheetState();
}

class _AddShiftSheetState extends State<AddShiftSheet> {
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 18, minute: 0);
  int _breakMin = 60;
  ShiftType _shiftType = ShiftType.regular;
  bool _hasJuyeok = false;

  ({int basePay, int bonusPay, double hours}) get _calc =>
      ShiftCalculator.calculate(
        start: _start,
        end: _end,
        type: _shiftType,
        breakMinutes: _breakMin,
      );

  void _save() {
    final calc = _calc;
    if (calc.hours <= 0) return;

    final state = AppStateScope.read(context);
    state.addShift(ShiftEntry(
      id: 'sh_${state.nextId()}',
      date: _date,
      startTime: _start,
      endTime: _end,
      type: _shiftType,
      basePay: calc.basePay,
      bonusPay: calc.bonusPay,
      breakMinutes: _breakMin,
      hasJuyeok: _hasJuyeok,
    ));
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
        } else {
          _end = picked;
        }
        // Auto-detect shift type
        _shiftType = ShiftCalculator.detectType(_start, _end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final subColor = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final fieldBg = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;
    final calc = _calc;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: subColor.withOpacity(0.3),
                  borderRadius: WoniRadius.full,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('근무 추가', style: WoniTextStyles.heading2.copyWith(color: textColor)),
            const SizedBox(height: 16),

            // Date row
            _PickerRow(
              icon: Icons.calendar_today_rounded,
              label: '날짜',
              value: '${_date.year}-${pad2(_date.month)}-${pad2(_date.day)}',
              isDark: isDark,
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),

            // Start / End time
            Row(
              children: [
                Expanded(
                  child: _PickerRow(
                    icon: Icons.play_arrow_rounded,
                    label: '시작',
                    value: '${pad2(_start.hour)}:${pad2(_start.minute)}',
                    isDark: isDark,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PickerRow(
                    icon: Icons.stop_rounded,
                    label: '종료',
                    value: '${pad2(_end.hour)}:${pad2(_end.minute)}',
                    isDark: isDark,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Break minutes
            _PickerRow(
              icon: Icons.coffee_rounded,
              label: '휴식',
              value: '$_breakMin분',
              isDark: isDark,
              onTap: () {
                // Cycle through common break times
                setState(() {
                  _breakMin = switch (_breakMin) {
                    0  => 30,
                    30 => 60,
                    60 => 90,
                    _  => 0,
                  };
                });
              },
            ),
            const SizedBox(height: 14),

            // Shift type chips
            Text('근무 유형', style: WoniTextStyles.caption.copyWith(color: subColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ShiftType.values.map((t) {
                final active = t == _shiftType;
                final color = shiftTypeColor(t);
                return GestureDetector(
                  onTap: () => setState(() => _shiftType = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? color.withOpacity(0.12) : fieldBg,
                      borderRadius: WoniRadius.full,
                      border: Border.all(
                        color: active ? color.withOpacity(0.4) : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                      ),
                    ),
                    child: Text(
                      shiftTypeLabel(t),
                      style: WoniTextStyles.bodySecondary.copyWith(
                        color: active ? color : subColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // Juyeok toggle
            GestureDetector(
              onTap: () => setState(() => _hasJuyeok = !_hasJuyeok),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _hasJuyeok ? WoniColors.green.withOpacity(0.08) : fieldBg,
                  borderRadius: WoniRadius.md,
                  border: Border.all(
                    color: _hasJuyeok ? WoniColors.green.withOpacity(0.3) : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasJuyeok ? Icons.check_circle_rounded : Icons.circle_outlined,
                      size: 18,
                      color: _hasJuyeok ? WoniColors.green : subColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '주휴수당 적용',
                      style: WoniTextStyles.body.copyWith(
                        color: _hasJuyeok ? WoniColors.green : subColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Pay preview
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WoniColors.green.withOpacity(0.06),
                    WoniColors.blue.withOpacity(0.06),
                  ],
                ),
                borderRadius: WoniRadius.md,
                border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('근무 시간', style: WoniTextStyles.bodySecondary.copyWith(color: subColor)),
                      Text('${calc.hours.toStringAsFixed(1)}시간', style: WoniTextStyles.body.copyWith(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('기본급', style: WoniTextStyles.bodySecondary.copyWith(color: subColor)),
                      Text('${fmtKRWFull(calc.basePay)}₩', style: WoniTextStyles.body.copyWith(color: textColor)),
                    ],
                  ),
                  if (calc.bonusPay > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('수당', style: WoniTextStyles.bodySecondary.copyWith(color: subColor)),
                        Text('+${fmtKRWFull(calc.bonusPay)}₩', style: WoniTextStyles.body.copyWith(color: WoniColors.green)),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('예상 급여', style: WoniTextStyles.body.copyWith(color: textColor, fontWeight: FontWeight.w800)),
                      Text(
                        '${fmtKRWFull(calc.basePay + calc.bonusPay)}₩',
                        style: WoniTextStyles.heading2.copyWith(color: WoniColors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            WoniButton(
              label: '저장하기',
              onTap: calc.hours > 0 ? _save : null,
              fullWidth: true,
              variant: WoniButtonVariant.success,
              icon: Icons.check_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fieldBg = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final subColor = isDark ? WoniColors.darkText2 : WoniColors.lightText2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: fieldBg, borderRadius: WoniRadius.md),
        child: Row(
          children: [
            Icon(icon, size: 16, color: WoniColors.blue),
            const SizedBox(width: 8),
            Text(label, style: WoniTextStyles.bodySecondary.copyWith(color: subColor)),
            const Spacer(),
            Text(value, style: WoniTextStyles.body.copyWith(color: textColor)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 16, color: subColor),
          ],
        ),
      ),
    );
  }
}
