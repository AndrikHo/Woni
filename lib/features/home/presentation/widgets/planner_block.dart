import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

class PlannerBlock extends StatefulWidget {
  const PlannerBlock({super.key});

  @override
  State<PlannerBlock> createState() => _PlannerBlockState();
}

class _PlannerBlockState extends State<PlannerBlock> {
  int _filter = 0;
  final _ctrl = TextEditingController();

  List<PlannerItem> _filtered(List<PlannerItem> all) {
    final now = DateTime.now();
    return switch (_filter) {
      0 => all.where((p) => _sameDay(p.createdAt, now)).toList(),
      1 => all.where((p) => now.difference(p.createdAt).inDays < 7).toList(),
      _ => all,
    };
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _add() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    AppStateScope.read(context).addPlannerItem(text);
    _ctrl.clear();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final items = _filtered(state.plannerItems);
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;
    final surface = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;

    return WoniCard(
      color: surface,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                const Text('📋', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(S.planner, style: WoniTextStyles.heading2.copyWith(color: textColor)),
                const Spacer(),
                _FilterChips(
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                  isDark: isDark,
                ),
              ],
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _add(),
                    style: WoniTextStyles.body.copyWith(color: textColor),
                    decoration: InputDecoration(
                      hintText: S.addTask,
                      hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _add,
                  icon: const Icon(Icons.add_circle_rounded, color: WoniColors.blue),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),
          // Items
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text(S.noTasks, style: WoniTextStyles.bodySecondary.copyWith(color: textColor3)),
            )
          else
            ...items.map((item) => Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => AppStateScope.read(context).removePlannerItem(item.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: WoniColors.coral.withValues(alpha: 0.15),
                    child: const Icon(Icons.delete_outline, color: WoniColors.coral, size: 20),
                  ),
                  child: InkWell(
                    onTap: () => AppStateScope.read(context).togglePlannerItem(item.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            item.isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                            size: 20,
                            color: item.isDone ? WoniColors.green : textColor3,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.text,
                              style: WoniTextStyles.body.copyWith(
                                color: item.isDone ? textColor3 : textColor,
                                decoration: item.isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onChanged, required this.isDark});
  final int selected;
  final ValueChanged<int> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labels = [S.today, S.thisWeek, S.all];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++)
          GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selected == i
                    ? WoniColors.blue.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: WoniRadius.sm,
              ),
              child: Text(
                labels[i],
                style: WoniTextStyles.bodySecondary.copyWith(
                  color: selected == i ? WoniColors.blue : (isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                  fontWeight: selected == i ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
