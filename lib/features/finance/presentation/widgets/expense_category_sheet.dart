import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

class ExpenseCategorySheet extends StatefulWidget {
  const ExpenseCategorySheet({super.key, this.isFixed = false, this.existingCategory});
  final bool isFixed;
  final ExpenseCategory? existingCategory;

  /// Show for creating a new category
  static Future<void> show(BuildContext context, {bool isFixed = false}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ExpenseCategorySheet(isFixed: isFixed),
    );
  }

  /// Show for editing an existing category
  static Future<void> showEdit(BuildContext context, {required ExpenseCategory category}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ExpenseCategorySheet(
        isFixed: category.isFixed,
        existingCategory: category,
      ),
    );
  }

  @override
  State<ExpenseCategorySheet> createState() => _ExpenseCategorySheetState();
}

class _ExpenseCategorySheetState extends State<ExpenseCategorySheet> {
  final _nameCtrl = TextEditingController();
  String _emoji = '📁';
  final List<String> _subcategories = [];
  final _subCtrl = TextEditingController();
  bool _hasFixedAmount = false;
  final _fixedAmountCtrl = TextEditingController();

  bool get _isEditing => widget.existingCategory != null;

  static const _emojis = ['🍽', '🚇', '🛍', '💊', '🏠', '💡', '❤️', '💼', '📦', '🎮', '☕', '🎬', '✈️', '📱', '🎵', '📚'];

  @override
  void initState() {
    super.initState();
    final cat = widget.existingCategory;
    if (cat != null) {
      _nameCtrl.text = cat.name;
      _emoji = cat.emoji;
      _subcategories.addAll(cat.subcategories.map((s) => s.name));
      _hasFixedAmount = cat.fixedAmount != null && cat.fixedAmount! > 0;
      if (_hasFixedAmount) {
        _fixedAmountCtrl.text = '${cat.fixedAmount}';
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _subCtrl.dispose();
    _fixedAmountCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final state = AppStateScope.read(context);
    final fixedAmt = _hasFixedAmount ? (int.tryParse(_fixedAmountCtrl.text.trim()) ?? 0) : null;
    final subs = _subcategories
        .map((s) => ExpenseSubcategory(id: 'sub_${state.nextId()}', name: s, korName: s))
        .toList();

    if (_isEditing) {
      final updated = widget.existingCategory!.copyWith(
        name: name,
        emoji: _emoji,
        color: widget.existingCategory?.color ?? WoniColors.blue,
        korName: name,
        fixedAmount: _hasFixedAmount ? (fixedAmt ?? 0) : null,
        clearFixedAmount: !_hasFixedAmount,
        subcategories: subs,
      );
      state.updateExpenseCategory(updated);
    } else {
      state.addExpenseCategory(ExpenseCategory(
        id: 'cat_${state.nextId()}',
        name: name,
        emoji: _emoji,
        color: WoniColors.blue,
        korName: name,
        isFixed: widget.isFixed,
        fixedAmount: _hasFixedAmount ? (fixedAmt ?? 0) : null,
        subcategories: subs,
      ));
    }
    Navigator.pop(context);
  }

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
            Text(
              _isEditing ? S.configureCat : S.addCategory,
              style: WoniTextStyles.heading2.copyWith(color: textColor),
            ),
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

            // ── Fixed amount toggle ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: WoniRadius.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                        color: _hasFixedAmount ? WoniColors.blue : textColor3,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          S.fixedAmountLabel,
                          style: WoniTextStyles.body.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        height: 26,
                        child: Switch(
                          value: _hasFixedAmount,
                          onChanged: (v) => setState(() => _hasFixedAmount = v),
                          activeColor: WoniColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S.fixedAmountDesc,
                    style: WoniTextStyles.bodySecondary.copyWith(
                      color: textColor3,
                      fontSize: 11,
                    ),
                  ),
                  if (_hasFixedAmount) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _fixedAmountCtrl,
                      keyboardType: TextInputType.number,
                      style: WoniTextStyles.body.copyWith(color: textColor),
                      decoration: InputDecoration(
                        hintText: '300000',
                        hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
                        suffixText: '₩',
                        suffixStyle: WoniTextStyles.body.copyWith(color: textColor3),
                        filled: true,
                        fillColor: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ],
                ],
              ),
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
                  icon: Icon(Icons.add_circle_rounded, color: WoniColors.blue, size: 22),
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

            // Delete button (only in edit mode)
            if (_isEditing) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    AppStateScope.read(context).removeExpenseCategory(widget.existingCategory!.id);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline, size: 14, color: WoniColors.coral.withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Text(
                          S.deleteCategory,
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: WoniColors.coral.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
