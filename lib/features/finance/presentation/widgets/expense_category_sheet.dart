import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

class ExpenseCategorySheet extends StatefulWidget {
  const ExpenseCategorySheet({super.key, this.isFixed = false});
  final bool isFixed;

  static Future<void> show(BuildContext context, {bool isFixed = false}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ExpenseCategorySheet(isFixed: isFixed),
    );
  }

  @override
  State<ExpenseCategorySheet> createState() => _ExpenseCategorySheetState();
}

class _ExpenseCategorySheetState extends State<ExpenseCategorySheet> {
  final _nameCtrl = TextEditingController();
  String _emoji = '📁';
  Color _color = WoniColors.blue;
  final List<String> _subcategories = [];
  final _subCtrl = TextEditingController();

  static const _emojis = ['🍽', '🚇', '🛍', '💊', '🏠', '💡', '❤️', '💼', '📦', '🎮', '☕', '🎬', '✈️', '📱', '🎵', '📚'];
  static const _colors = [
    Color(0xFF4F8EF7), Color(0xFF34C579), Color(0xFFFF6B6B), Color(0xFF7B6EF6),
    Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF06B6D4), Color(0xFF8B5CF6),
    Color(0xFFF97316), Color(0xFF14B8A6), Color(0xFFEF4444), Color(0xFF6366F1),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final state = AppStateScope.read(context);
    state.addExpenseCategory(ExpenseCategory(
      id: 'cat_${state.nextId()}',
      name: name,
      emoji: _emoji,
      color: _color,
      korName: name,
      isFixed: widget.isFixed,
      subcategories: _subcategories
          .map((s) => ExpenseSubcategory(id: 'sub_${state.nextId()}', name: s, korName: s))
          .toList(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(WoniSpacing.lg, WoniSpacing.lg, WoniSpacing.lg,
          MediaQuery.of(context).viewInsets.bottom + WoniSpacing.xxxl),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: textColor3, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: WoniSpacing.lg),
            Text(S.addCategory, style: WoniTextStyles.heading2.copyWith(color: textColor)),
            const SizedBox(height: WoniSpacing.lg),

            // Name
            TextField(
              controller: _nameCtrl,
              style: WoniTextStyles.body.copyWith(color: textColor),
              decoration: InputDecoration(
                labelText: S.categoryName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: WoniSpacing.lg),

            // Emoji picker
            Text(S.selectEmoji, style: WoniTextStyles.caption.copyWith(color: textColor3)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojis.map((e) => GestureDetector(
                onTap: () => setState(() => _emoji = e),
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _emoji == e ? WoniColors.blue.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: _emoji == e ? Border.all(color: WoniColors.blue, width: 2) : null,
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 20)),
                ),
              )).toList(),
            ),
            const SizedBox(height: WoniSpacing.lg),

            // Color picker
            Text(S.selectColor, style: WoniTextStyles.caption.copyWith(color: textColor3)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((c) => GestureDetector(
                onTap: () => setState(() => _color = c),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: _color == c ? Border.all(color: Colors.white, width: 3) : null,
                    boxShadow: _color == c ? [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 8)] : null,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: WoniSpacing.lg),

            // Subcategories
            Text(S.subcategories, style: WoniTextStyles.caption.copyWith(color: textColor3)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subCtrl,
                    style: WoniTextStyles.body.copyWith(color: textColor),
                    decoration: InputDecoration(
                      hintText: S.addSubcategory,
                      hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_rounded, color: WoniColors.blue, size: 22),
                  onPressed: () {
                    final txt = _subCtrl.text.trim();
                    if (txt.isNotEmpty) {
                      setState(() => _subcategories.add(txt));
                      _subCtrl.clear();
                    }
                  },
                ),
              ],
            ),
            if (_subcategories.isNotEmpty)
              Wrap(
                spacing: 6,
                children: _subcategories.asMap().entries.map((e) => Chip(
                  label: Text(e.value),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => setState(() => _subcategories.removeAt(e.key)),
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            const SizedBox(height: WoniSpacing.xxl),

            // Save
            SizedBox(
              width: double.infinity,
              child: WoniButton(
                label: S.save,
                onTap: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
