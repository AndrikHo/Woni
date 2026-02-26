import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';

class BlockAddSheet extends StatelessWidget {
  const BlockAddSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const BlockAddSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    final allTypes = BlockType.values;

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
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: textColor3,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: WoniSpacing.lg),
          Text(S.addBlock, style: WoniTextStyles.heading2.copyWith(color: textColor)),
          const SizedBox(height: WoniSpacing.lg),
          for (final type in allTypes)
            _BlockOption(
              type: type,
              isVisible: state.dashboardBlocks.any((b) => b.type == type && b.isVisible),
              isDark: isDark,
              onTap: () {
                AppStateScope.read(context).addBlock(type);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

class _BlockOption extends StatelessWidget {
  const _BlockOption({required this.type, required this.isVisible, required this.isDark, required this.onTap});
  final BlockType type;
  final bool isVisible;
  final bool isDark;
  final VoidCallback onTap;

  String get _emoji => switch (type) {
        BlockType.financialTips => '💡',
        BlockType.quickAI => '🤖',
        BlockType.planner => '📋',
      };

  String get _label => switch (type) {
        BlockType.financialTips => S.financialTips,
        BlockType.quickAI => S.quickAI,
        BlockType.planner => S.planner,
      };

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    return GestureDetector(
      onTap: isVisible ? null : onTap,
      child: Opacity(
        opacity: isVisible ? 0.4 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(_emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _label,
                  style: WoniTextStyles.body.copyWith(color: textColor),
                ),
              ),
              if (isVisible)
                Text('✓', style: WoniTextStyles.body.copyWith(color: textColor3))
              else
                const Icon(Icons.add_rounded, color: WoniColors.blue, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
