import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/app_themes.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/features/account/presentation/widgets/theme_picker_sheet.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final border = isDark ? WoniColors.darkBorder : WoniColors.lightBorder;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(WoniSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(S.tabAccount, style: WoniTextStyles.heading1.copyWith(color: textColor)),
              const SizedBox(height: WoniSpacing.xl),

              // ── Profile card ──
              WoniCard(
                color: bg,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: WoniColors.blue,
                      child: Text('A', style: WoniTextStyles.heading1.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(width: WoniSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Александр', style: WoniTextStyles.heading2.copyWith(color: textColor)),
                          const SizedBox(height: 2),
                          Text('user@woni.app', style: WoniTextStyles.bodySecondary.copyWith(color: textColor2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: WoniSpacing.lg),

              // ── Stats ──
              WoniCard(
                color: bg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: S.transactions, value: '${state.transactions.length}', color: WoniColors.blue),
                    _StatItem(label: S.shifts, value: '${state.shifts.length}', color: WoniColors.green),
                    _StatItem(label: S.balance, value: '${fmtKRW(state.monthBalance.abs())}₩', color: state.monthBalance >= 0 ? WoniColors.green : WoniColors.coral),
                  ],
                ),
              ),
              const SizedBox(height: WoniSpacing.xxl),
              // ── Language ──
              _SectionTitle(S.language),
              const SizedBox(height: WoniSpacing.sm),
              SizedBox(
                height: 38,
                child: WoniScopeToggle(
                  selected: AppLocale.values.indexOf(state.locale),
                  onChanged: (i) => AppStateScope.read(context).setLocale(AppLocale.values[i]),
                  labels: const ['Русский', '한국어', 'English'],
                ),
              ),
              const SizedBox(height: WoniSpacing.xxl),

              // ── Theme ──
              _SectionTitle(S.themes),
              const SizedBox(height: WoniSpacing.sm),
              GestureDetector(
                onTap: () => ThemePickerSheet.show(context),
                child: WoniCard(
                  color: bg,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Preview strip of current theme
                      ClipRRect(
                        borderRadius: WoniRadius.sm,
                        child: SizedBox(
                          width: 80,
                          height: 28,
                          child: Row(
                            children: WoniColors.current.previewColors
                                .map((c) => Expanded(child: Container(color: c)))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          WoniColors.current.name,
                          style: WoniTextStyles.body.copyWith(color: textColor),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: textColor2, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: WoniSpacing.xxl),

              // ── Settings ──
              _SectionTitle(S.settings),
              const SizedBox(height: WoniSpacing.sm),
              WoniCard(
                color: bg,
                child: Column(
                  children: [
                    // Dark mode
                    _SettingRow(
                      icon: Icons.dark_mode_rounded,
                      label: S.darkMode,
                      textColor: textColor,
                      trailing: GestureDetector(
                        onTap: () => AppStateScope.read(context).toggleTheme(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 28,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: isDark ? WoniColors.blue : border,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: border),
                    // Notifications
                    _SettingRow(
                      icon: Icons.notifications_rounded,
                      label: S.notifications,
                      textColor: textColor,
                      trailing: Icon(Icons.chevron_right, color: textColor2, size: 20),
                    ),
                    Divider(height: 1, color: border),
                    // Salary settings
                    _SettingRow(
                      icon: Icons.attach_money_rounded,
                      label: S.salarySettings,
                      textColor: textColor,
                      trailing: Text('10,030₩/h', style: WoniTextStyles.bodySecondary.copyWith(color: textColor2)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: WoniSpacing.xxl),

              // ── Balance carry-over ──
              _SectionTitle(S.carryOver),
              const SizedBox(height: WoniSpacing.sm),
              WoniCard(
                color: bg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sync_rounded, size: 20, color: WoniColors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(S.carryOver, style: WoniTextStyles.body.copyWith(color: textColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Mode selector
                    SizedBox(
                      height: 38,
                      child: WoniScopeToggle(
                        selected: CarryOverMode.values.indexOf(state.carryOverMode),
                        onChanged: (i) => AppStateScope.read(context)
                            .setCarryOverMode(CarryOverMode.values[i]),
                        labels: [S.carryOverAuto, S.carryOverManual, S.carryOverBilling],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      switch (state.carryOverMode) {
                        CarryOverMode.auto => S.carryOverDesc,
                        CarryOverMode.manual => S.carryOverManualDesc,
                        CarryOverMode.byBillingDate => S.carryOverBillingDesc,
                      },
                      style: WoniTextStyles.bodySecondary.copyWith(
                        color: textColor2,
                        fontSize: 11,
                      ),
                    ),
                    // Manual mode: transfer button
                    if (state.carryOverMode == CarryOverMode.manual) ...[
                      const SizedBox(height: 12),
                      WoniButton(
                        label: '${S.transferBalance} (${fmtKRWFull(state.monthBalance)}₩)',
                        onTap: () => AppStateScope.read(context).triggerManualCarryOver(),
                        small: true,
                        variant: WoniButtonVariant.ghost,
                      ),
                    ],
                    // Billing date mode: day picker
                    if (state.carryOverMode == CarryOverMode.byBillingDate) ...[
                      const SizedBox(height: 12),
                      Divider(height: 1, color: border),
                      const SizedBox(height: 12),
                      _SettingRow(
                        icon: Icons.calendar_today_rounded,
                        label: S.billingDay,
                        textColor: textColor,
                        trailing: _BillingDayPicker(
                          currentDay: state.billingDay,
                          textColor: textColor,
                          textColor2: textColor2,
                          isDark: isDark,
                          onChanged: (day) => AppStateScope.read(context).setBillingDay(day),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: WoniSpacing.xxl),
              // ── Danger zone ──
              Center(
                child: WoniButton(
                  label: S.resetData,
                  variant: WoniButtonVariant.danger,
                  onTap: () => _confirmReset(context),
                ),
              ),
              const SizedBox(height: WoniSpacing.lg),
              Center(
                child: Text('Woni v1.0.0', style: WoniTextStyles.bodySecondary.copyWith(color: textColor2)),
              ),
              const SizedBox(height: WoniSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.resetData),
        content: Text(S.confirmReset),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.no)),
          TextButton(
            onPressed: () {
              AppStateScope.read(context).resetAll();
              Navigator.pop(context);
            },
            child: Text(S.yes, style: const TextStyle(color: WoniColors.coral)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    final isDark = AppStateScope.of(context).themeMode == ThemeMode.dark;
    return Text(
      title.toUpperCase(),
      style: WoniTextStyles.caption.copyWith(
        color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.icon, required this.label, required this.textColor, required this.trailing});
  final IconData icon;
  final String label;
  final Color textColor;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: WoniColors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: WoniTextStyles.body.copyWith(color: textColor))),
          trailing,
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = AppStateScope.of(context).themeMode == ThemeMode.dark;
    return Column(
      children: [
        Text(value, style: WoniTextStyles.heading2.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: WoniTextStyles.bodySecondary.copyWith(
          color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
        )),
      ],
    );
  }
}

class _BillingDayPicker extends StatelessWidget {
  const _BillingDayPicker({
    required this.currentDay,
    required this.textColor,
    required this.textColor2,
    required this.isDark,
    required this.onChanged,
  });

  final int currentDay;
  final Color textColor;
  final Color textColor2;
  final bool isDark;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDayPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
          borderRadius: WoniRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$currentDay',
              style: WoniTextStyles.body.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.unfold_more, size: 16, color: textColor2),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(BuildContext context) {
    final bg = isDark ? WoniColors.darkSurface : WoniColors.lightSurface;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(WoniSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: textColor2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: WoniSpacing.lg),
            Text(
              S.billingDay,
              style: WoniTextStyles.heading2.copyWith(color: textColor),
            ),
            const SizedBox(height: WoniSpacing.lg),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(31, (i) {
                final day = i + 1;
                final isSelected = day == currentDay;
                return GestureDetector(
                  onTap: () {
                    onChanged(day);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? WoniColors.blue.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: WoniColors.blue, width: 2)
                          : null,
                    ),
                    child: Text(
                      '$day',
                      style: WoniTextStyles.body.copyWith(
                        color: isSelected ? WoniColors.blue : textColor,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: WoniSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
