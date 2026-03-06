import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/features/finance/presentation/widgets/calendar_tab.dart';
import 'package:woni/features/finance/presentation/widgets/expenses_tab.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  late PageController _pageCtrl;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goToTab(int index) {
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final inactiveColor = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    final tabLabels = [S.tabFinance, S.expenses];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header with tab buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(WoniSpacing.lg, 12, WoniSpacing.lg, 8),
              child: Row(
                children: [
                  // Tab buttons
                  for (int i = 0; i < tabLabels.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _goToTab(i),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: WoniTextStyles.heading1.copyWith(
                          color: _tab == i ? textColor : textColor2.withValues(alpha: 0.4),
                          fontSize: _tab == i ? 24 : 20,
                        ),
                        child: Text(tabLabels[i]),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── PageView ──
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _tab = i),
                children: const [
                  CalendarTab(),
                  ExpensesTab(),
                ],
              ),
            ),

            // ── Bottom page indicator ──
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (i) {
                  final isActive = i == _tab;
                  return GestureDetector(
                    onTap: () => _goToTab(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? accent : inactiveColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
