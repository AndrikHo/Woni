import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/features/home/presentation/widgets/financial_tips_block.dart';
import 'package:woni/features/home/presentation/widgets/planner_block.dart';
import 'package:woni/features/home/presentation/widgets/quick_ai_block.dart';

class BlockContainer extends StatelessWidget {
  const BlockContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final visibleBlocks = state.dashboardBlocks.where((b) => b.isVisible).toList();
    final isDark = state.themeMode == ThemeMode.dark;

    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.lg, vertical: WoniSpacing.sm),
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Material(
            elevation: 8 * animation.value,
            borderRadius: WoniRadius.lg,
            color: Colors.transparent,
            shadowColor: Colors.black26,
            child: child,
          ),
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex >= visibleBlocks.length || newIndex > visibleBlocks.length) return;
        final fullOld = state.dashboardBlocks.indexOf(visibleBlocks[oldIndex]);
        final fullNew = newIndex >= visibleBlocks.length
            ? state.dashboardBlocks.indexOf(visibleBlocks.last) + 1
            : state.dashboardBlocks.indexOf(visibleBlocks[newIndex]);
        AppStateScope.read(context).reorderBlocks(fullOld, fullNew);
      },
      itemCount: visibleBlocks.length,
      itemBuilder: (context, index) {
        final block = visibleBlocks[index];
        return _BlockWrapper(
          key: ValueKey(block.id),
          blockId: block.id,
          isDark: isDark,
          index: index,
          child: switch (block.type) {
            BlockType.financialTips => const FinancialTipsBlock(),
            BlockType.quickAI => const QuickAIBlock(),
            BlockType.planner => const PlannerBlock(),
          },
        );
      },
    );
  }
}

class _BlockWrapper extends StatelessWidget {
  const _BlockWrapper({
    required super.key,
    required this.blockId,
    required this.isDark,
    required this.index,
    required this.child,
  });
  final String blockId;
  final bool isDark;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final handleColor = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    return Padding(
      padding: const EdgeInsets.only(bottom: WoniSpacing.sm),
      child: Stack(
        children: [
          // ── Block content (long-press drag still works on mobile) ──
          ReorderableDelayedDragStartListener(
            index: index,
            child: child,
          ),
          // ── Close button (top-right) ──
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => AppStateScope.read(context).toggleBlockVisibility(blockId),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: handleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
