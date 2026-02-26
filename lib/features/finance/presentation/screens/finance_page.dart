import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/features/finance/presentation/widgets/calendar_tab.dart';
import 'package:woni/features/finance/presentation/widgets/expenses_tab.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;

    return Scaffold(
      backgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(WoniSpacing.lg, 12, WoniSpacing.lg, 8),
              child: Row(
                children: [
                  Text(S.tabFinance, style: WoniTextStyles.heading1.copyWith(color: textColor)),
                  const Spacer(),
                  WoniScopeToggle(
                    labels: [S.calendar, S.expenses],
                    selected: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _tab == 0
                    ? const CalendarTab(key: ValueKey('calendar'))
                    : const ExpensesTab(key: ValueKey('expenses')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
