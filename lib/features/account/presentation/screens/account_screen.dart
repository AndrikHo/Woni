import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

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
      backgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
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
              WoniCard(
                color: bg,
                padding: const EdgeInsets.all(WoniSpacing.sm),
                child: Row(
                  children: [
                    for (final loc in AppLocale.values) ...[
                      if (loc != AppLocale.values.first) const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => AppStateScope.read(context).setLocale(loc),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: state.locale == loc ? WoniColors.blue : Colors.transparent,
                              borderRadius: WoniRadius.sm,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              loc == AppLocale.ru ? 'Русский' : loc == AppLocale.ko ? '한국어' : 'English',
                              style: WoniTextStyles.body.copyWith(
                                color: state.locale == loc ? Colors.white : textColor2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
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
