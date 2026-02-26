import 'package:flutter/material.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/state/app_state.dart';

/// Shows AI-parsed transaction proposals for user confirmation.
class AIConfirmationSheet extends StatefulWidget {
  const AIConfirmationSheet({super.key, required this.rawText});

  final String rawText;

  /// Parse text and show confirmation sheet. Returns true if confirmed.
  static Future<bool?> show(BuildContext context, String text) async {
    final items = AIParser.parse(text);
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인식된 금액이 없습니다', style: WoniTextStyles.body.copyWith(color: Colors.white)),
          backgroundColor: WoniColors.coral,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: WoniRadius.md),
        ),
      );
      return false;
    }

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AIConfirmationSheet(rawText: text),
    );
  }

  @override
  State<AIConfirmationSheet> createState() => _AIConfirmationSheetState();
}

class _AIConfirmationSheetState extends State<AIConfirmationSheet> {
  late List<AIParsedItem> _items;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _simulateParsing();
  }

  Future<void> _simulateParsing() async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _items = AIParser.parse(widget.rawText);
      _loading = false;
    });
  }

  void _confirm() {
    final state = AppStateScope.read(context);
    for (final item in _items) {
      final meta = kCategories[item.category] ?? kCategories['other']!;
      state.addTransaction(Transaction(
        id: state.nextId(),
        title: item.note,
        category: item.category,
        amount: item.amount,
        type: item.type,
        occurredAt: item.date,
        source: TransactionSource.ai,
        emoji: meta.emoji,
      ));
    }
    Navigator.of(context).pop(true);
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
    if (_items.isEmpty) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final subColor = isDark ? WoniColors.darkText2 : WoniColors.lightText2;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

          // Header
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: WoniColors.blue.withOpacity(0.12),
                  borderRadius: WoniRadius.sm,
                ),
                alignment: Alignment.center,
                child: const Text('🤖', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI 분석 결과', style: WoniTextStyles.heading2.copyWith(color: textColor)),
                    Text(
                      '"${widget.rawText}"',
                      style: WoniTextStyles.bodySecondary.copyWith(color: subColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Loading or items
          if (_loading) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: const AlwaysStoppedAnimation(WoniColors.blue),
              ),
            ),
            const SizedBox(height: 10),
            Text('분석 중...', style: WoniTextStyles.body.copyWith(color: subColor)),
            const SizedBox(height: 20),
          ] else ...[
            ...List.generate(_items.length, (i) {
              final item = _items[i];
              final meta = kCategories[item.category] ?? kCategories['other']!;
              return _ParsedItemCard(
                item: item,
                meta: meta,
                isDark: isDark,
                onRemove: () => _removeItem(i),
                onCategoryChange: (cat) => setState(() => item.category = cat),
              );
            }),
            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: WoniButton(
                    label: '취소',
                    onTap: () => Navigator.of(context).pop(false),
                    variant: WoniButtonVariant.ghost,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: WoniButton(
                    label: '확인 (${_items.length}건)',
                    onTap: _confirm,
                    variant: WoniButtonVariant.success,
                    icon: Icons.check_rounded,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ParsedItemCard extends StatelessWidget {
  const _ParsedItemCard({
    required this.item,
    required this.meta,
    required this.isDark,
    required this.onRemove,
    required this.onCategoryChange,
  });

  final AIParsedItem item;
  final CategoryMeta meta;
  final bool isDark;
  final VoidCallback onRemove;
  final void Function(String) onCategoryChange;

  @override
  Widget build(BuildContext context) {
    final subColor = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final fieldBg = isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2;
    final amountColor = item.type == TransactionType.income ? WoniColors.green : WoniColors.coral;
    final sign = item.type == TransactionType.income ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: WoniRadius.md,
        border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: meta.color.withOpacity(0.1),
                  borderRadius: WoniRadius.md,
                ),
                alignment: Alignment.center,
                child: Text(meta.emoji, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.note, style: WoniTextStyles.body),
                    Text(
                      '${meta.korName} · ${relDate(item.date)} · ${(item.confidence * 100).toInt()}%',
                      style: WoniTextStyles.bodySecondary.copyWith(color: subColor),
                    ),
                  ],
                ),
              ),
              Text(
                '$sign${fmtKRWFull(item.amount)}₩',
                style: WoniTextStyles.amount.copyWith(color: amountColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Category quick-change + remove
          Row(
            children: [
              // Category chips (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: kCategories.entries.take(5).map((e) {
                      final active = e.key == item.category;
                      return GestureDetector(
                        onTap: () => onCategoryChange(e.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: active ? e.value.color.withOpacity(0.12) : Colors.transparent,
                            borderRadius: WoniRadius.full,
                            border: Border.all(
                              color: active
                                  ? e.value.color.withOpacity(0.3)
                                  : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                            ),
                          ),
                          child: Text(
                            '${e.value.emoji} ${e.value.korName}',
                            style: WoniTextStyles.bodySecondary.copyWith(
                              color: active ? e.value.color : subColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: WoniColors.coral.withOpacity(0.1),
                    borderRadius: WoniRadius.sm,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close_rounded, size: 14, color: WoniColors.coral),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
