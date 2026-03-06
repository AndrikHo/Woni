import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/features/finance/presentation/widgets/expense_category_sheet.dart';
import 'package:woni/shared/sheets/ai_confirmation_sheet.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});
  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  String? _expandedCat;

  void _showEditIncomeDialog() {
    final state = AppStateScope.read(context);
    final ctrl = TextEditingController(text: '${state.monthIncome}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.editIncome),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(hintText: '0', suffixText: '₩'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              state.setManualIncome(null); // reset to auto
              Navigator.pop(context);
            },
            child: Text('Auto'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.cancel)),
          TextButton(
            onPressed: () {
              final amt = int.tryParse(ctrl.text) ?? 0;
              if (amt >= 0) state.setManualIncome(amt);
              Navigator.pop(context);
            },
            child: Text(S.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    final fixedCats = state.expenseCategories.where((c) => c.isFixed).toList();
    final variableCats = state.expenseCategories.where((c) => !c.isFixed).toList();

    return Column(
      children: [
        // ── Income / Expense summary ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg, vertical: 8),
          child: Row(
            children: [
              _SumBlock(
                label: S.income,
                value: state.monthIncome,
                positive: true,
                isDark: isDark,
                onTap: _showEditIncomeDialog,
                isEditable: true,
                isManual: state.manualIncome != null,
              ),
              const SizedBox(width: 8),
              _SumBlock(label: S.expense, value: state.monthExpense, positive: false, isDark: isDark),
            ],
          ),
        ),

        // ── Total (income - expense) ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: WoniRadius.sm,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.totalPay,
                  style: WoniTextStyles.body.copyWith(
                    color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${fmtKRWFull((state.monthIncome - state.monthExpense).abs())}₩',
                  style: WoniTextStyles.heading2.copyWith(
                    color: state.monthIncome >= state.monthExpense
                        ? (isDark ? WoniColors.greenDark : WoniColors.green)
                        : (isDark ? WoniColors.coralDark : WoniColors.coral),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),

        // ── Category sections ─────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Mandatory expenses ────────────────────────────────
                _SectionHeader(label: S.mandatoryExp, isDark: isDark),
                const SizedBox(height: 8),
                for (final cat in fixedCats)
                  _CategoryAccordion(
                    category: cat,
                    transactions: state.transactions.where((t) => t.category == cat.id).toList(),
                    isExpanded: _expandedCat == cat.id,
                    isDark: isDark,
                    onTap: () => setState(() => _expandedCat = _expandedCat == cat.id ? null : cat.id),
                    onRemoveTx: (id) => AppStateScope.read(context).removeTransaction(id),
                    onConfigure: () => ExpenseCategorySheet.showEdit(context, category: cat),
                  ),
                _AddCategoryButton(isDark: isDark, isFixed: true),
                const SizedBox(height: WoniSpacing.lg),

                // ── Optional expenses ─────────────────────────────────
                _SectionHeader(label: S.optionalExp, isDark: isDark),
                const SizedBox(height: 8),
                for (final cat in variableCats)
                  _CategoryAccordion(
                    category: cat,
                    transactions: state.transactions.where((t) => t.category == cat.id).toList(),
                    isExpanded: _expandedCat == cat.id,
                    isDark: isDark,
                    onTap: () => setState(() => _expandedCat = _expandedCat == cat.id ? null : cat.id),
                    onRemoveTx: (id) => AppStateScope.read(context).removeTransaction(id),
                    onConfigure: () => ExpenseCategorySheet.showEdit(context, category: cat),
                  ),
                _AddCategoryButton(isDark: isDark, isFixed: false),
                const SizedBox(height: WoniSpacing.xxxl),
              ],
            ),
          ),
        ),

        // AI bar at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(WoniSpacing.lg, 4, WoniSpacing.lg, 8),
          child: WoniAIBar(
            onSubmit: (text) => AIConfirmationSheet.show(context, text),
            onCamera: () {},
          ),
        ),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        label.toUpperCase(),
        style: WoniTextStyles.caption.copyWith(
          color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Sum Block (Income / Expense) ──────────────────────────────────────────────

class _SumBlock extends StatelessWidget {
  const _SumBlock({
    required this.label,
    required this.value,
    required this.positive,
    required this.isDark,
    this.onTap,
    this.isEditable = false,
    this.isManual = false,
  });
  final String label;
  final int value;
  final bool positive;
  final bool isDark;
  final VoidCallback? onTap;
  final bool isEditable;
  final bool isManual;

  @override
  Widget build(BuildContext context) {
    final color = positive ? WoniColors.green : WoniColors.coral;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
            borderRadius: WoniRadius.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(label, style: WoniTextStyles.bodySecondary.copyWith(
                    color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                  )),
                  if (isEditable) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isManual ? Icons.edit_rounded : Icons.auto_fix_high_rounded,
                      size: 12,
                      color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${positive ? '+' : '-'}${fmtKRWFull(value)}₩',
                style: WoniTextStyles.heading2.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Add Category Button ───────────────────────────────────────────────────────

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({required this.isDark, required this.isFixed});
  final bool isDark;
  final bool isFixed;

  @override
  Widget build(BuildContext context) {
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => ExpenseCategorySheet.show(context, isFixed: isFixed),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
            borderRadius: WoniRadius.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 16, color: textColor3),
              const SizedBox(width: 6),
              Text(S.addCategory, style: WoniTextStyles.bodySecondary.copyWith(color: textColor3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Accordion ────────────────────────────────────────────────────────

class _CategoryAccordion extends StatelessWidget {
  const _CategoryAccordion({
    required this.category,
    required this.transactions,
    required this.isExpanded,
    required this.isDark,
    required this.onTap,
    required this.onRemoveTx,
    required this.onConfigure,
  });

  final ExpenseCategory category;
  final List<Transaction> transactions;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onTap;
  final ValueChanged<String> onRemoveTx;
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    final txTotal = transactions.fold(0, (sum, t) => sum + t.amount);
    final displayTotal = (category.fixedAmount != null && category.fixedAmount! > 0)
        ? category.fixedAmount!
        : txTotal;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final hasFixed = category.fixedAmount != null && category.fixedAmount! > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        borderRadius: WoniRadius.sm,
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: WoniRadius.sm,
          ),
          child: Column(
            children: [
              // Header row
              GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(category.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category.name, style: WoniTextStyles.body.copyWith(color: textColor)),
                            if (hasFixed)
                              Row(
                                children: [
                                  Icon(Icons.lock_outline_rounded, size: 10, color: textColor3),
                                  const SizedBox(width: 3),
                                  Text(
                                    S.fixedAmountLabel,
                                    style: WoniTextStyles.bodySecondary.copyWith(
                                      color: textColor3,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (displayTotal > 0)
                        Text(
                          '${fmtKRWFull(displayTotal)}₩',
                          style: WoniTextStyles.body.copyWith(color: textColor2),
                        ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.chevron_right, size: 18, color: textColor2),
                      ),
                    ],
                  ),
                ),
              ),
              // Subcategory chips (shown when expanded)
              if (isExpanded && category.subcategories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 4, 12, 8),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: category.subcategories.map((sub) =>
                      WoniChip(label: sub.name, variant: WoniChipVariant.neutral),
                    ).toList(),
                  ),
                ),
              // Expanded content — transactions (only if NOT a fixed-amount-only category)
              if (isExpanded && transactions.isNotEmpty)
                ...transactions.map((tx) => Dismissible(
                      key: ValueKey(tx.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => onRemoveTx(tx.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: WoniColors.coral.withValues(alpha: 0.15),
                        child: const Icon(Icons.delete_outline, color: WoniColors.coral, size: 18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(48, 0, 12, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx.title, style: WoniTextStyles.body.copyWith(color: textColor, fontSize: 13)),
                                  Text(
                                    S.relDaysAgo(DateTime.now().difference(tx.occurredAt).inDays == 0
                                        ? 0 : DateTime.now().difference(tx.occurredAt).inDays),
                                    style: WoniTextStyles.bodySecondary.copyWith(color: textColor2, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${tx.type == TransactionType.income ? '+' : '-'}${fmtKRWFull(tx.amount)}₩',
                              style: WoniTextStyles.body.copyWith(
                                color: tx.type == TransactionType.income ? WoniColors.green : WoniColors.coral,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              // Configure category (when expanded)
              if (isExpanded)
                GestureDetector(
                  onTap: onConfigure,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(48, 4, 12, 10),
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined, size: 14, color: WoniColors.blue.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          S.configure,
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: WoniColors.blue.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
