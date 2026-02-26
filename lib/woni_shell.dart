import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/features/home/presentation/screens/home_screen.dart';
import 'package:woni/features/finance/presentation/screens/finance_page.dart';
import 'package:woni/features/account/presentation/screens/account_screen.dart';

class WoniShell extends StatefulWidget {
  const WoniShell({super.key});

  @override
  State<WoniShell> createState() => _WoniShellState();
}

class _WoniShellState extends State<WoniShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    FinancePage(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: _WoniNavBar(
          selectedIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _WoniNavBar extends StatelessWidget {
  const _WoniNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = [
      _NavItem(icon: Icons.home_rounded, label: S.tabHome),
      _NavItem(icon: Icons.account_balance_wallet_rounded, label: S.tabFinance),
      _NavItem(icon: Icons.person_rounded, label: S.tabAccount),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
        border: Border(
          top: BorderSide(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: items.asMap().entries.map((e) {
              final isActive = e.key == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        child: Icon(
                          e.value.icon,
                          size: isActive ? 24 : 22,
                          color: isActive
                              ? WoniColors.blue
                              : (isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 4 : 0,
                        height: isActive ? 4 : 0,
                        decoration: const BoxDecoration(
                          color: WoniColors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
