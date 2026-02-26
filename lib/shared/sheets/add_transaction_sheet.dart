import 'package:flutter/material.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/state/app_state.dart';

/// Bottom sheet for manually adding a transaction.
class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String _category = 'food';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final amount = int.tryParse(_amountCtrl.text.replaceAll(',', ''));
    if (amount == null || amount <= 0) return;

    final state = AppStateScope.read(context);
    final meta = kCategories[_category]!;
    state.addTransaction(Transaction(
      id: state.nextId(),
      title: _noteCtrl.text.isEmpty ? meta.korName : _noteCtrl.text,
      category: _category,
      amount: amount,
      type: _type,
      occurredAt: _date,
      source: TransactionSource.manual,
      emoji: meta.emoji,
    ));

    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final subColor = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final fieldBg = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;

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

            // Title
            Text('거래 추가', style: WoniTextStyles.heading2.copyWith(color: textColor)),
            const SizedBox(height: 16),

            // Type toggle
            Row(
              children: [
                _TypeChip(
                  label: '지출',
                  active: _type == TransactionType.expense,
                  color: WoniColors.coral,
                  onTap: () => setState(() => _type = TransactionType.expense),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  label: '수입',
                  active: _type == TransactionType.income,
                  color: WoniColors.green,
                  onTap: () => setState(() => _type = TransactionType.income),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount field
            Text('금액', style: WoniTextStyles.caption.copyWith(color: subColor)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: fieldBg, borderRadius: WoniRadius.md),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                style: WoniTextStyles.heading1.copyWith(color: textColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: WoniTextStyles.heading1.copyWith(color: subColor.withOpacity(0.3)),
                  suffixText: '₩',
                  suffixStyle: WoniTextStyles.heading2.copyWith(color: subColor),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Note field
            Text('메모', style: WoniTextStyles.caption.copyWith(color: subColor)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: fieldBg, borderRadius: WoniRadius.md),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: _noteCtrl,
                style: WoniTextStyles.body.copyWith(color: textColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '스타벅스 커피...',
                  hintStyle: WoniTextStyles.body.copyWith(color: subColor.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Category selector
            Text('카테고리', style: WoniTextStyles.caption.copyWith(color: subColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: kCategories.entries.map((e) {
                final isActive = e.key == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? e.value.color.withOpacity(0.15)
                          : fieldBg,
                      borderRadius: WoniRadius.full,
                      border: Border.all(
                        color: isActive
                            ? e.value.color.withOpacity(0.4)
                            : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.value.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          e.value.korName,
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: isActive ? e.value.color : subColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Date picker
            Text('날짜', style: WoniTextStyles.caption.copyWith(color: subColor)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: fieldBg, borderRadius: WoniRadius.md),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: WoniColors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${_date.year}-${pad2(_date.month)}-${pad2(_date.day)}',
                      style: WoniTextStyles.body.copyWith(color: textColor),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded, size: 18, color: subColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            WoniButton(
              label: '저장하기',
              onTap: _save,
              fullWidth: true,
              variant: _type == TransactionType.income
                  ? WoniButtonVariant.success
                  : WoniButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: WoniRadius.full,
          border: Border.all(color: active ? color : color.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: WoniTextStyles.body.copyWith(
            color: active ? color : color.withOpacity(0.5),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
