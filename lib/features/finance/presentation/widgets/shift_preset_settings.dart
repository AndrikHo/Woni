import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';

// ─── Preset List Sheet (overview) ────────────────────────────────────────────

class ShiftPresetSettings extends StatelessWidget {
  const ShiftPresetSettings({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ShiftPresetSettings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(WoniSpacing.lg, WoniSpacing.lg, WoniSpacing.lg, WoniSpacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 36, height: 4, decoration: BoxDecoration(color: textColor3, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: WoniSpacing.lg),
          Text(S.presetSettings, style: WoniTextStyles.heading2.copyWith(color: textColor)),
          const SizedBox(height: WoniSpacing.lg),
          for (final preset in state.shiftPresets)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ShiftPresetEditor.show(context, preset: preset);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
                    borderRadius: WoniRadius.sm,
                    border: Border(left: BorderSide(color: preset.color, width: 3)),
                  ),
                  child: Row(
                    children: [
                      Text(preset.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(preset.name, style: WoniTextStyles.body.copyWith(color: textColor)),
                            const SizedBox(height: 2),
                            Text(
                              '${_timeStr(preset.defaultStart)}–${_timeStr(preset.defaultEnd)} · ${fmtKRWFull(preset.hourlyRate)}₩/${S.hoursWorked}',
                              style: WoniTextStyles.bodySecondary.copyWith(color: textColor2, fontSize: 11),
                            ),
                            if (preset.fixedDailyAmount != null)
                              Text(
                                '${S.fixedDailyAmt}: ${fmtKRWFull(preset.fixedDailyAmount!)}₩',
                                style: WoniTextStyles.bodySecondary.copyWith(color: WoniColors.green, fontSize: 11),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: WoniColors.coral.withValues(alpha: 0.6), size: 20),
                        onPressed: () => AppStateScope.read(context).removePreset(preset.id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ShiftPresetEditor.show(context);
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(S.newPreset),
            ),
          ),
        ],
      ),
    );
  }

  static String _timeStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ─── Preset Editor Sheet ─────────────────────────────────────────────────────

class ShiftPresetEditor extends StatefulWidget {
  const ShiftPresetEditor({super.key, this.preset});
  final ShiftPreset? preset;

  static Future<void> show(BuildContext context, {ShiftPreset? preset}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShiftPresetEditor(preset: preset),
    );
  }

  @override
  State<ShiftPresetEditor> createState() => _ShiftPresetEditorState();
}

class _ShiftPresetEditorState extends State<ShiftPresetEditor> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _rateCtrl;
  late final TextEditingController _overtimeCtrl;
  late final TextEditingController _nightMultCtrl;
  late final TextEditingController _fixedAmtCtrl;
  late final TextEditingController _breakCtrl;

  late String _emoji;
  late Color _color;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late TimeOfDay _nightStart;
  late TimeOfDay _nightEnd;
  late ShiftType _shiftType;

  bool get _isEdit => widget.preset != null;

  static const _emojis = [
    '🌅', '🌙', '⏰', '🏢', '🏪', '☕', '🍽', '🔧', '💼', '🚗',
    '📦', '🎭', '🏥', '🎓', '🛒', '⚡', '🌃', '🌆', '🌇', '🏠',
    '🍕', '🛠', '📱', '🎯', '🧑‍💻', '🏋️', '🎵', '📐', '🚀', '🔬',
  ];

  static const _colors = [
    Color(0xFF4F8EF7), Color(0xFF34C579), Color(0xFFFF6B6B), Color(0xFF7B6EF6),
    Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF06B6D4), Color(0xFF8B5CF6),
    Color(0xFFF97316), Color(0xFF14B8A6), Color(0xFFEF4444), Color(0xFF6366F1),
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.preset;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _rateCtrl = TextEditingController(text: '${p?.hourlyRate ?? ShiftCalculator.defaultHourlyRate}');
    _overtimeCtrl = TextEditingController(text: '${p?.overtimeMultiplier ?? 1.5}');
    _nightMultCtrl = TextEditingController(text: '${p?.nightMultiplier ?? 0.5}');
    _fixedAmtCtrl = TextEditingController(text: p?.fixedDailyAmount != null ? '${p!.fixedDailyAmount}' : '');
    _breakCtrl = TextEditingController(text: '${p?.breakMinutes ?? 60}');
    _emoji = p?.emoji ?? '🌅';
    _color = p?.color ?? const Color(0xFF4F8EF7);
    _start = p?.defaultStart ?? const TimeOfDay(hour: 9, minute: 0);
    _end = p?.defaultEnd ?? const TimeOfDay(hour: 18, minute: 0);
    _nightStart = p?.nightBonusStart ?? const TimeOfDay(hour: 22, minute: 0);
    _nightEnd = p?.nightBonusEnd ?? const TimeOfDay(hour: 6, minute: 0);
    _shiftType = p?.shiftType ?? ShiftType.regular;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateCtrl.dispose();
    _overtimeCtrl.dispose();
    _nightMultCtrl.dispose();
    _fixedAmtCtrl.dispose();
    _breakCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final state = AppStateScope.read(context);

    final fixedText = _fixedAmtCtrl.text.trim();
    final fixedAmt = fixedText.isNotEmpty ? int.tryParse(fixedText) : null;

    final preset = ShiftPreset(
      id: widget.preset?.id ?? 'preset_${state.nextId()}',
      name: name,
      emoji: _emoji,
      color: _color,
      defaultStart: _start,
      defaultEnd: _end,
      shiftType: _shiftType,
      breakMinutes: int.tryParse(_breakCtrl.text) ?? 60,
      hourlyRate: int.tryParse(_rateCtrl.text) ?? ShiftCalculator.defaultHourlyRate,
      overtimeMultiplier: double.tryParse(_overtimeCtrl.text) ?? 1.5,
      nightBonusStart: _nightStart,
      nightBonusEnd: _nightEnd,
      nightMultiplier: double.tryParse(_nightMultCtrl.text) ?? 0.5,
      fixedDailyAmount: fixedAmt,
    );

    if (_isEdit) {
      state.updatePreset(preset);
    } else {
      state.addPreset(preset);
    }
    Navigator.pop(context);
  }

  Future<void> _pickTime(TimeOfDay initial, ValueChanged<TimeOfDay> onPick) async {
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t != null) setState(() => onPick(t));
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface2 = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: WoniSpacing.lg),
            child: Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: textColor3, borderRadius: BorderRadius.circular(2))),
            ),
          ),
          const SizedBox(height: WoniSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isEdit ? S.editPreset : S.newPreset,
                    style: WoniTextStyles.heading2.copyWith(color: textColor),
                  ),
                ),
                TextButton(
                  onPressed: _save,
                  child: Text(S.save, style: WoniTextStyles.body.copyWith(color: WoniColors.blue, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Scrollable form
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(WoniSpacing.lg, 0, WoniSpacing.lg, MediaQuery.of(context).viewInsets.bottom + WoniSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Emoji picker ─────────────────────────────────────
                  Text(S.presetIcon, style: WoniTextStyles.caption.copyWith(color: textColor3, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _emojis.map((e) => GestureDetector(
                      onTap: () => setState(() => _emoji = e),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _emoji == e ? WoniColors.blue.withValues(alpha: 0.15) : surface2,
                          borderRadius: BorderRadius.circular(8),
                          border: _emoji == e ? Border.all(color: WoniColors.blue, width: 2) : null,
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 20)),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Color picker ──────────────────────────────────────
                  Text(S.selectColor, style: WoniTextStyles.caption.copyWith(color: textColor3, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _colors.map((c) => GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: _color == c ? Border.all(color: Colors.white, width: 2.5) : null,
                          boxShadow: _color == c ? [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 6)] : null,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Name ──────────────────────────────────────────────
                  _FieldLabel(S.presetName, textColor3),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _nameCtrl, isDark: isDark, hint: 'Дневная'),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Work hours ─────────────────────────────────────────
                  _FieldLabel(S.workHours, textColor3),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _TimeButton(label: _fmt(_start), onTap: () => _pickTime(_start, (t) => _start = t), isDark: isDark)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('—', style: WoniTextStyles.body.copyWith(color: textColor2)),
                      ),
                      Expanded(child: _TimeButton(label: _fmt(_end), onTap: () => _pickTime(_end, (t) => _end = t), isDark: isDark)),
                    ],
                  ),
                  const SizedBox(height: WoniSpacing.md),

                  // Break minutes
                  _FieldLabel('${S.breakTime} (${S.minutes})', textColor3),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _breakCtrl, isDark: isDark, hint: '60', keyboardType: TextInputType.number, width: 80),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Hourly rate ────────────────────────────────────────
                  _FieldLabel(S.minWageKR, textColor3),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _rateCtrl, isDark: isDark, hint: '10030', keyboardType: TextInputType.number, suffix: '₩'),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Overtime multiplier ────────────────────────────────
                  _FieldLabel(S.overtimeRate, textColor3),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _overtimeCtrl, isDark: isDark, hint: '1.5', keyboardType: const TextInputType.numberWithOptions(decimal: true), suffix: '×'),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Night shift hours ──────────────────────────────────
                  _FieldLabel(S.nightShiftHrs, textColor3),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _TimeButton(label: '${S.from} ${_fmt(_nightStart)}', onTap: () => _pickTime(_nightStart, (t) => _nightStart = t), isDark: isDark)),
                      const SizedBox(width: 8),
                      Expanded(child: _TimeButton(label: '${S.to} ${_fmt(_nightEnd)}', onTap: () => _pickTime(_nightEnd, (t) => _nightEnd = t), isDark: isDark)),
                    ],
                  ),
                  const SizedBox(height: WoniSpacing.md),

                  // Night multiplier
                  _FieldLabel(S.nightRate, textColor3),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _nightMultCtrl, isDark: isDark, hint: '0.5', keyboardType: const TextInputType.numberWithOptions(decimal: true), suffix: '×'),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Shift type ─────────────────────────────────────────
                  _FieldLabel(S.shiftType, textColor3),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ShiftType.values.map((t) {
                      final selected = _shiftType == t;
                      return GestureDetector(
                        onTap: () => setState(() => _shiftType = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected ? shiftTypeColor(t).withValues(alpha: 0.15) : surface2,
                            borderRadius: BorderRadius.circular(8),
                            border: selected ? Border.all(color: shiftTypeColor(t), width: 1.5) : null,
                          ),
                          child: Text(
                            _shiftTypeName(t),
                            style: WoniTextStyles.bodySecondary.copyWith(
                              color: selected ? shiftTypeColor(t) : textColor2,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: WoniSpacing.lg),

                  // ── Fixed daily amount ─────────────────────────────────
                  _FieldLabel(S.fixedDailyAmt, textColor3),
                  const SizedBox(height: 4),
                  Text(S.fixedAmtHint, style: WoniTextStyles.bodySecondary.copyWith(color: textColor3, fontSize: 10)),
                  const SizedBox(height: 6),
                  _StyledTextField(controller: _fixedAmtCtrl, isDark: isDark, hint: '', keyboardType: TextInputType.number, suffix: '₩'),
                  const SizedBox(height: WoniSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shiftTypeName(ShiftType t) => switch (t) {
    ShiftType.regular         => S.shiftRegular,
    ShiftType.night           => S.shiftNight,
    ShiftType.holiday         => S.shiftHoliday,
    ShiftType.overtime        => S.shiftOvertime,
    ShiftType.weekendOvertime => S.shiftWeekendOT,
  };
}

// ─── Styled widgets ──────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: WoniTextStyles.caption.copyWith(color: color, letterSpacing: 0.5, fontWeight: FontWeight.w600),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.isDark,
    this.hint = '',
    this.keyboardType,
    this.suffix,
    this.width,
  });
  final TextEditingController controller;
  final bool isDark;
  final String hint;
  final TextInputType? keyboardType;
  final String? suffix;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface2 = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;

    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: WoniTextStyles.body.copyWith(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
          suffixText: suffix,
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
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.onTap, required this.isDark});
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label, style: WoniTextStyles.body.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
