import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/features/home/presentation/widgets/block_add_sheet.dart';
import 'package:woni/features/home/presentation/widgets/block_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(WoniSpacing.lg, 12, WoniSpacing.lg, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.hello, style: WoniTextStyles.bodySecondary.copyWith(color: textColor2)),
                        const SizedBox(height: 2),
                        Text('Александр', style: WoniTextStyles.heading1.copyWith(color: textColor)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: WoniColors.blue,
                    child: Text('A', style: WoniTextStyles.body.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Block container + floating add button
            Expanded(
              child: Stack(
                children: [
                  const BlockContainer(),
                  Positioned(
                    bottom: WoniSpacing.lg,
                    right: WoniSpacing.lg,
                    child: GestureDetector(
                      onTap: () => BlockAddSheet.show(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [WoniColors.blue, const Color(0xFF7B6EF6)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: WoniShadows.blue(),
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
