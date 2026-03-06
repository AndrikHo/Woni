import 'dart:ui';
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
  int _filter = 0; // 0=today, 1=week, 2=all
  final _ctrl = TextEditingController();
  bool _showInput = false;
  String? _editingId;
  final _editCtrl = TextEditingController();

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
    setState(() => _showInput = false);
  }

  void _handlePeriodChange(int i) {
    if (i == _filter) return;
    setState(() {
      _filter = i;
      _showInput = false;
      _editingId = null;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _editCtrl.dispose();
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
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final success = isDark ? WoniColors.greenDark : WoniColors.green;

    final doneCount = items.where((t) => t.isDone).length;
    final progress = items.isNotEmpty ? doneCount / items.length : 0.0;

    return WoniCard(
      color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 36, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.planner,
                        style: WoniTextStyles.heading2.copyWith(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$doneCount ${S.outOf} ${items.length} ${S.completed}',
                        style: WoniTextStyles.bodySecondary.copyWith(
                          color: textColor2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Progress bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: const Cubic(0.34, 1, 0.64, 1),
                  decoration: BoxDecoration(
                    color: success,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),

          // ── Period tabs ──
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 18, right: 36),
            child: WoniScopeToggle(
              selected: _filter,
              onChanged: _handlePeriodChange,
              labels: [S.today, S.thisWeek, S.all],
            ),
          ),

          // ── Hint ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Center(
              child: Text(
                '\u2190 ${S.swipeHint} \u00b7 \u2982 ${S.dragHint}',
                style: WoniTextStyles.bodySecondary.copyWith(
                  color: textColor3,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          // ── Task list (reorderable) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
            child: items.isEmpty && !_showInput
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        S.noTasks,
                        style: WoniTextStyles.body.copyWith(color: textColor3),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Reorderable task list
                      if (items.isNotEmpty)
                        SizedBox(
                          // Each row ~52px + 2px margin ≈ 54px
                          height: items.length * 54.0,
                          child: ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            buildDefaultDragHandles: false,
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, _) {
                                  final scale = lerpDouble(1.0, 1.03, animation.value) ?? 1.0;
                                  return Transform.scale(
                                    scale: scale,
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 4 * animation.value,
                                      borderRadius: BorderRadius.circular(12),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            },
                            itemCount: items.length,
                            onReorder: (oldIndex, newIndex) {
                              // Find real indices in unfiltered plannerItems
                              final allItems = state.plannerItems;
                              final oldItem = items[oldIndex];
                              if (newIndex > oldIndex) newIndex--;
                              final newItem = items[newIndex.clamp(0, items.length - 1)];
                              final realOld = allItems.indexWhere((p) => p.id == oldItem.id);
                              final realNew = allItems.indexWhere((p) => p.id == newItem.id);
                              if (realOld != -1 && realNew != -1) {
                                AppStateScope.read(context).reorderPlannerItems(realOld, realNew);
                              }
                            },
                            itemBuilder: (context, index) {
                              final item = items[index];

                              if (_editingId == item.id) {
                                return _EditRow(
                                  key: ValueKey(item.id),
                                  isDark: isDark,
                                  accent: accent,
                                  textColor: textColor,
                                  textColor3: textColor3,
                                  controller: _editCtrl,
                                  onSave: () {
                                    if (_editCtrl.text.trim().isNotEmpty) {
                                      AppStateScope.read(context)
                                          .editPlannerItem(item.id, _editCtrl.text.trim());
                                    }
                                    setState(() => _editingId = null);
                                  },
                                  onCancel: () => setState(() => _editingId = null),
                                );
                              }

                              return _SwipeTaskRow(
                                key: ValueKey(item.id),
                                item: item,
                                index: index,
                                isDark: isDark,
                                accent: accent,
                                success: success,
                                textColor: textColor,
                                textColor3: textColor3,
                                onToggle: () => AppStateScope.read(context).togglePlannerItem(item.id),
                                onStar: () => AppStateScope.read(context).starPlannerItem(item.id),
                                onEdit: () {
                                  setState(() {
                                    _editingId = item.id;
                                    _editCtrl.text = item.text;
                                  });
                                },
                                onDelete: () => AppStateScope.read(context).removePlannerItem(item.id),
                              );
                            },
                          ),
                        ),

                      // New task input
                      if (_showInput)
                        _NewTaskInput(
                          isDark: isDark,
                          accent: accent,
                          textColor: textColor,
                          textColor3: textColor3,
                          controller: _ctrl,
                          onSubmit: _add,
                          onCancel: () => setState(() {
                            _showInput = false;
                            _ctrl.clear();
                          }),
                        ),
                    ],
                  ),
          ),

          // ── Add task button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: GestureDetector(
              onTap: () => setState(() {
                _showInput = !_showInput;
                _editingId = null;
              }),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.06),
                  borderRadius: WoniRadius.md,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.2),
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 16, color: accent),
                    const SizedBox(width: 8),
                    Text(
                      S.addTask,
                      style: WoniTextStyles.body.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Swipe-to-reveal task row ─────────────────────────────────────────────────

class _SwipeTaskRow extends StatefulWidget {
  const _SwipeTaskRow({
    super.key,
    required this.item,
    required this.index,
    required this.isDark,
    required this.accent,
    required this.success,
    required this.textColor,
    required this.textColor3,
    required this.onToggle,
    required this.onStar,
    required this.onEdit,
    required this.onDelete,
  });

  final PlannerItem item;
  final int index;
  final bool isDark;
  final Color accent;
  final Color success;
  final Color textColor;
  final Color textColor3;
  final VoidCallback onToggle;
  final VoidCallback onStar;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeTaskRow> createState() => _SwipeTaskRowState();
}

class _SwipeTaskRowState extends State<_SwipeTaskRow> {
  double _offset = 0;
  bool _swiped = false;
  bool _swiping = false;
  double _startX = 0;

  static const _actionW = 144.0;

  void _onHorizontalDragStart(DragStartDetails d) {
    _startX = d.localPosition.dx;
    _swiping = true;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    if (!_swiping) return;
    setState(() {
      _offset = (_startX - d.localPosition.dx).clamp(0.0, _actionW);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails d) {
    _swiping = false;
    setState(() {
      if (_offset > _actionW * 0.35) {
        _offset = _actionW;
        _swiped = true;
      } else {
        _offset = 0;
        _swiped = false;
      }
    });
  }

  void _close() {
    setState(() {
      _offset = 0;
      _swiped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final item = widget.item;
    final starColor = isDark ? const Color(0xFFFFAB40) : const Color(0xFFD48A15);
    final handleColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.2);

    // Task bg: solid when swiping (to hide actions behind), semi-transparent when idle
    final taskBg = _offset > 0
        ? (isDark ? WoniColors.darkSurface2 : const Color(0xFFE8F0F8))
        : (isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.4));

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          // ── Action buttons (behind) ──
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: _actionW,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: _offset > 0 ? 0 : 200),
              opacity: _offset > 0 ? 1 : 0,
              child: Row(
                children: [
                  // Delete
                  _ActionBtn(
                    color: isDark
                        ? WoniColors.coralDark.withValues(alpha: 0.15)
                        : WoniColors.coral.withValues(alpha: 0.1),
                    iconColor: isDark ? WoniColors.coralDark : WoniColors.coral,
                    icon: Icons.delete_outline,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    onTap: () { widget.onDelete(); _close(); },
                  ),
                  // Star
                  _ActionBtn(
                    color: isDark
                        ? starColor.withValues(alpha: 0.15)
                        : starColor.withValues(alpha: 0.1),
                    iconColor: starColor,
                    icon: item.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                    onTap: () { widget.onStar(); _close(); },
                  ),
                  // Edit
                  _ActionBtn(
                    color: isDark
                        ? widget.accent.withValues(alpha: 0.15)
                        : widget.accent.withValues(alpha: 0.1),
                    iconColor: widget.accent,
                    icon: Icons.edit_outlined,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    onTap: () { widget.onEdit(); _close(); },
                  ),
                ],
              ),
            ),
          ),

          // ── Content (swipeable) ──
          GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onTap: _swiped ? _close : null,
            child: AnimatedContainer(
              duration: Duration(milliseconds: _swiping ? 0 : 300),
              curve: const Cubic(0.32, 0.72, 0, 1),
              transform: Matrix4.translationValues(-_offset, 0, 0),
              padding: const EdgeInsets.fromLTRB(4, 10, 8, 10),
              decoration: BoxDecoration(
                color: taskBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Grip handle (6-dot pattern) — drag start listener for reorder
                  ReorderableDragStartListener(
                    index: widget.index,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Opacity(
                        opacity: 0.35,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _Dot(color: handleColor),
                                const SizedBox(width: 3),
                                _Dot(color: handleColor),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _Dot(color: handleColor),
                                const SizedBox(width: 3),
                                _Dot(color: handleColor),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _Dot(color: handleColor),
                                const SizedBox(width: 3),
                                _Dot(color: handleColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Toggle switch (iOS style)
                  _ToggleSwitch(
                    checked: item.isDone,
                    onChanged: widget.onToggle,
                    accentColor: widget.success,
                  ),
                  const SizedBox(width: 10),

                  // Star indicator
                  if (item.isStarred)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.star_rounded, size: 14, color: starColor),
                    ),

                  // Text
                  Expanded(
                    child: Text(
                      item.text,
                      style: WoniTextStyles.body.copyWith(
                        fontWeight: item.isStarred ? FontWeight.w600 : FontWeight.w500,
                        color: item.isDone
                            ? widget.textColor3
                            : (item.isStarred ? starColor : widget.textColor),
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action button ────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.borderRadius,
  });

  final Color color;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }
}

// ── Toggle switch (iOS style) ────────────────────────────────────────────────

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    required this.checked,
    required this.onChanged,
    required this.accentColor,
  });

  final bool checked;
  final VoidCallback onChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: checked ? accentColor : Colors.grey.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: const Cubic(0.34, 1.56, 0.64, 1), // Bouncy spring
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Small dot widget ─────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Edit row ─────────────────────────────────────────────────────────────────

class _EditRow extends StatelessWidget {
  const _EditRow({
    super.key,
    required this.isDark,
    required this.accent,
    required this.textColor,
    required this.textColor3,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  final bool isDark;
  final Color accent;
  final Color textColor;
  final Color textColor3;
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? accent.withValues(alpha: 0.06)
            : accent.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? accent.withValues(alpha: 0.2)
              : accent.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: WoniTextStyles.body.copyWith(color: textColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
              ),
              onSubmitted: (_) => onSave(),
            ),
          ),
          GestureDetector(
            onTap: onSave,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: WoniRadius.sm,
              ),
              child: const Text(
                '\u2713',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── New task input row ───────────────────────────────────────────────────────

class _NewTaskInput extends StatelessWidget {
  const _NewTaskInput({
    required this.isDark,
    required this.accent,
    required this.textColor,
    required this.textColor3,
    required this.controller,
    required this.onSubmit,
    required this.onCancel,
  });

  final bool isDark;
  final Color accent;
  final Color textColor;
  final Color textColor3;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: textColor3,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: WoniTextStyles.body.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: '${S.newTask}...',
                hintStyle: WoniTextStyles.body.copyWith(color: textColor3),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          GestureDetector(
            onTap: onSubmit,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                '\u21b5',
                style: TextStyle(
                  color: accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
