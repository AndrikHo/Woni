import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/shared/sheets/ai_confirmation_sheet.dart';

class QuickAIBlock extends StatelessWidget {
  const QuickAIBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;

    return WoniCard(
      color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.quickAI,
            style: WoniTextStyles.caption.copyWith(
              color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          WoniAIBar(
            onSubmit: (text) => AIConfirmationSheet.show(context, text),
            onCamera: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📷 Receipt scan — coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}
