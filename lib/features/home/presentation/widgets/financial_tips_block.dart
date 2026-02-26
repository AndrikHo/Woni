import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';

class FinancialTipsBlock extends StatefulWidget {
  const FinancialTipsBlock({super.key});

  @override
  State<FinancialTipsBlock> createState() => _FinancialTipsBlockState();
}

class _FinancialTipsBlockState extends State<FinancialTipsBlock> {
  int _tipIndex = 0;

  static const _tips = [
    {'ru': 'Откладывайте 10% от каждой зарплаты — даже маленькие суммы накапливаются.', 'ko': '급여의 10%를 저축하세요 — 작은 금액도 쌓입니다.', 'en': 'Save 10% of every paycheck — small amounts add up.'},
    {'ru': 'Записывайте расходы сразу — так вы не забудете мелкие траты.', 'ko': '지출을 바로 기록하세요 — 작은 지출도 놓치지 마세요.', 'en': 'Record expenses immediately — don\'t miss small purchases.'},
    {'ru': 'Проверьте, получаете ли вы 주휴수당 — это ваше право при 15+ часах/неделю.', 'ko': '주휴수당을 받고 있는지 확인하세요 — 주 15시간 이상 근무 시 권리입니다.', 'en': 'Check if you receive weekly holiday pay — it\'s your right if you work 15+ hours/week.'},
    {'ru': 'Установите лимит на шопинг — отслеживайте категорию каждую неделю.', 'ko': '쇼핑 한도를 설정하세요 — 매주 카테고리를 추적하세요.', 'en': 'Set a shopping limit — track the category each week.'},
    {'ru': 'Ночные смены оплачиваются x1.5 — убедитесь, что ваш работодатель платит правильно.', 'ko': '야간 근무는 1.5배 — 고용주가 정확히 지급하는지 확인하세요.', 'en': 'Night shifts pay x1.5 — make sure your employer pays correctly.'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.themeMode == ThemeMode.dark;
    final tip = _tips[_tipIndex % _tips.length];
    final text = tip[S.locale.name] ?? tip['en']!;

    return WoniCard(
      color: isDark ? WoniColors.darkSurface : WoniColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                S.financialTips,
                style: WoniTextStyles.caption.copyWith(
                  color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: WoniTextStyles.body.copyWith(
              color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => setState(() => _tipIndex++),
              child: Text(
                '${S.nextTip} →',
                style: WoniTextStyles.body.copyWith(color: WoniColors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
