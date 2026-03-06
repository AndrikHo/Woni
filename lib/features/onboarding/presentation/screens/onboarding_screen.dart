import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/theme/woni_widgets.dart';
import 'package:woni/woni_shell.dart';

// ─── ONBOARDING DATA ───────────────────────────────────────────────────────

class _OnboardStep {
  const _OnboardStep({
    required this.icon,
    required this.color,
  });
  final IconData icon;
  final Color color;
}

final _steps = [
  _OnboardStep(icon: Icons.language_outlined,  color: WoniColors.violet),
  _OnboardStep(icon: Icons.work_outline,       color: WoniColors.green),
  _OnboardStep(icon: Icons.auto_awesome_outlined, color: WoniColors.coral),
];

// ─── MAIN SCREEN ───────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  // Step 1: language
  String _lang = 'ru';

  // Step 2: salary
  String _salaryMode = 'hourly';
  final _salaryCtrl = TextEditingController(text: '10030');

  // Step 3: first tx
  final _txCtrl = TextEditingController();
  bool _txSubmitted = false;

  void _next() {
    if (_page < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const WoniShell(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _setLanguage(String code) {
    setState(() => _lang = code);
    final locale = switch (code) {
      'ko' => AppLocale.ko,
      'en' => AppLocale.en,
      _ => AppLocale.ru,
    };
    AppStateScope.read(context).setLocale(locale);
  }

  @override
  void dispose() {
    _controller.dispose();
    _salaryCtrl.dispose();
    _txCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;

    final titles = [S.ob2Title, S.ob3Title, S.ob4Title];
    final subs   = [S.ob2Sub, S.ob3Sub, S.ob4Sub];

    return Scaffold(
      backgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: dots only (no skip)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) {
                  final isActive = i == _page;
                  final isPast  = i < _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isActive ? 20 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? accent
                          : isPast
                              ? accent.withOpacity(0.3)
                              : (isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2),
                      borderRadius: WoniRadius.full,
                    ),
                  );
                }),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (_, i) => _StepContent(
                  step: _steps[i],
                  isActive: i == _page,
                  title: titles[i],
                  subtitle: subs[i],
                  child: _buildStepBody(i, isDark),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: WoniButton(
                  key: ValueKey(_page),
                  label: _page == _steps.length - 1
                      ? S.onboardStart
                      : S.onboardContinue,
                  onTap: _next,
                  fullWidth: true,
                  variant: WoniButtonVariant.gradient,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBody(int step, bool isDark) {
    switch (step) {
      case 0:
        return _Step1Language(
          selected: _lang,
          onChanged: _setLanguage,
          isDark: isDark,
        );
      case 1:
        return _Step2Salary(
          mode: _salaryMode,
          ctrl: _salaryCtrl,
          onModeChanged: (m) => setState(() => _salaryMode = m),
          isDark: isDark,
        );
      case 2:
        return _Step3FirstTx(
          ctrl: _txCtrl,
          submitted: _txSubmitted,
          onSubmit: () => setState(() => _txSubmitted = true),
          isDark: isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── STEP WRAPPER ──────────────────────────────────────────────────────────

class _StepContent extends StatefulWidget {
  const _StepContent({
    required this.step,
    required this.isActive,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final _OnboardStep step;
  final bool isActive;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  State<_StepContent> createState() => _StepContentState();
}

class _StepContentState extends State<_StepContent> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 20, end: 0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    if (widget.isActive) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_StepContent old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: child,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: widget.step.color.withOpacity(isDark ? 0.12 : 0.08),
                borderRadius: WoniRadius.xl,
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.step.icon,
                size: 28,
                color: widget.step.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: WoniTextStyles.heading1,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              widget.subtitle,
              style: WoniTextStyles.body.copyWith(
                color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
                height: 1.6,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 28),
            widget.child,
          ],
        ),
      ),
    );
  }
}

// ─── STEP 1: Language ──────────────────────────────────────────────────────

class _Step1Language extends StatelessWidget {
  const _Step1Language({required this.selected, required this.onChanged, required this.isDark});
  final String selected;
  final void Function(String) onChanged;
  final bool isDark;

  static const _langs = [
    ('ru', '\ud83c\uddf7\ud83c\uddfa', 'Русский', 'Russian'),
    ('ko', '\ud83c\uddf0\ud83c\uddf7', '한국어', 'Korean'),
    ('en', '\ud83c\uddfa\ud83c\uddf8', 'English', 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;

    return Column(
      children: _langs.map((l) {
        final (code, flag, name, sub) = l;
        final isActive = selected == code;
        return GestureDetector(
          onTap: () => onChanged(code),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(WoniSpacing.md),
            decoration: BoxDecoration(
              color: isActive
                  ? accent.withOpacity(isDark ? 0.12 : 0.06)
                  : (isDark ? WoniColors.darkSurface : WoniColors.lightSurface),
              borderRadius: WoniRadius.xl,
              border: Border.all(
                color: isActive ? accent.withOpacity(0.4) : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: WoniTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Text(sub, style: WoniTextStyles.bodySecondary.copyWith(
                        color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
                      )),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? accent : Colors.transparent,
                    border: Border.all(
                      color: isActive ? accent : (isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                      width: 2,
                    ),
                  ),
                  child: isActive
                      ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── STEP 2: Salary Setup ──────────────────────────────────────────────────

class _Step2Salary extends StatelessWidget {
  const _Step2Salary({
    required this.mode,
    required this.ctrl,
    required this.onModeChanged,
    required this.isDark,
  });
  final String mode;
  final TextEditingController ctrl;
  final void Function(String) onModeChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accentGreen = isDark ? WoniColors.greenDark : WoniColors.green;

    final modes = [
      ('hourly',  Icons.schedule_outlined, S.obHourly),
      ('monthly', Icons.calendar_today_outlined, S.obMonthly),
      ('manual',  Icons.edit_outlined, S.obManual),
    ];

    return Column(
      children: [
        // Mode selector
        Row(
          children: modes.map((m) {
            final (code, icon, label) = m;
            final isActive = mode == code;
            return Expanded(
              child: GestureDetector(
                onTap: () => onModeChanged(code),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(right: code == 'manual' ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? accentGreen.withOpacity(isDark ? 0.12 : 0.06)
                        : (isDark ? WoniColors.darkSurface : WoniColors.lightSurface),
                    borderRadius: WoniRadius.xl,
                    border: Border.all(
                      color: isActive ? accentGreen.withOpacity(0.4) : (isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(icon, size: 20, color: isActive ? accentGreen : (isDark ? WoniColors.darkText3 : WoniColors.lightText3)),
                      const SizedBox(height: 4),
                      Text(label, style: WoniTextStyles.bodySecondary.copyWith(
                        color: isActive ? accentGreen : (isDark ? WoniColors.darkText2 : WoniColors.lightText2),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        if (mode == 'hourly') ...[
          WoniCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.hourlyRate,
                  style: WoniTextStyles.caption.copyWith(
                    color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  style: WoniTextStyles.heading2.copyWith(color: accentGreen),
                  decoration: InputDecoration(
                    suffix: Text('\u20a9/h', style: WoniTextStyles.body.copyWith(color: isDark ? WoniColors.darkText2 : WoniColors.lightText2)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.06),
                    borderRadius: WoniRadius.lg,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 14, color: accentGreen),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          S.obMinWageHint,
                          style: WoniTextStyles.caption.copyWith(color: accentGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _JuyeokRow(isDark: isDark),
              ],
            ),
          ),
        ] else if (mode == 'monthly') ...[
          WoniCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.salary, style: WoniTextStyles.caption.copyWith(color: isDark ? WoniColors.darkText3 : WoniColors.lightText3)),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  style: WoniTextStyles.heading2.copyWith(color: accentGreen),
                  decoration: InputDecoration(
                    hintText: '2,500,000',
                    hintStyle: WoniTextStyles.heading2.copyWith(color: isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                    suffix: Text('\u20a9', style: WoniTextStyles.body.copyWith(color: isDark ? WoniColors.darkText2 : WoniColors.lightText2)),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          WoniCard(
            child: Row(
              children: [
                Icon(Icons.edit_outlined, color: isDark ? WoniColors.blueDark : WoniColors.blue, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    S.obManualHint,
                    style: WoniTextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _JuyeokRow extends StatefulWidget {
  const _JuyeokRow({required this.isDark});
  final bool isDark;

  @override
  State<_JuyeokRow> createState() => _JuyeokRowState();
}

class _JuyeokRowState extends State<_JuyeokRow> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final accentGreen = widget.isDark ? WoniColors.greenDark : WoniColors.green;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.obJuyeokCalc, style: WoniTextStyles.body),
              Text('\u226515h/week \u2192 +1 day pay', style: WoniTextStyles.caption.copyWith(
                color: widget.isDark ? WoniColors.darkText2 : WoniColors.lightText2)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _enabled = !_enabled),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42, height: 24,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _enabled ? accentGreen : (widget.isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2),
              borderRadius: WoniRadius.full,
              border: Border.all(color: widget.isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
            ),
            child: Align(
              alignment: _enabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18, height: 18,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── STEP 3: First Transaction ─────────────────────────────────────────────

class _Step3FirstTx extends StatelessWidget {
  const _Step3FirstTx({
    required this.ctrl,
    required this.submitted,
    required this.onSubmit,
    required this.isDark,
  });
  final TextEditingController ctrl;
  final bool submitted;
  final VoidCallback onSubmit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? WoniColors.blueDark : WoniColors.blue;
    final accentGreen = isDark ? WoniColors.greenDark : WoniColors.green;

    return Column(
      children: [
        if (!submitted) ...[
          WoniCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.obTryNow,
                  style: WoniTextStyles.caption.copyWith(color: isDark ? WoniColors.darkText3 : WoniColors.lightText3),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: WoniSpacing.md, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
                    borderRadius: WoniRadius.full,
                    border: Border.all(color: accent.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          style: WoniTextStyles.body,
                          decoration: InputDecoration(
                            hintText: S.aiPlaceholder,
                            hintStyle: WoniTextStyles.body.copyWith(
                              color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => onSubmit(),
                        ),
                      ),
                      GestureDetector(
                        onTap: onSubmit,
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.obExamples,
            style: WoniTextStyles.caption.copyWith(color: isDark ? WoniColors.darkText2 : WoniColors.lightText2),
          ),
          const SizedBox(height: 6),
          ...['4500 \ucee4\ud53c \uc5b4\uc81c', '\ud3b8\uc758\uc810 8200', '\u043c\u0435\u0442\u0440\u043e 1450'].map((ex) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () => ctrl.text = ex,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.06),
                      borderRadius: WoniRadius.full,
                    ),
                    child: Text(
                      '"$ex"',
                      style: WoniTextStyles.body.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )),
        ] else ...[
          WoniCard(
            child: Column(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.check_rounded, color: accentGreen, size: 28),
                ),
                const SizedBox(height: 12),
                Text(S.obAiUnderstood, style: WoniTextStyles.heading2.copyWith(color: accentGreen)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(WoniSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? WoniColors.darkSurface2 : WoniColors.lightSurface2,
                    borderRadius: WoniRadius.xl,
                    border: Border.all(color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.coffee_outlined, size: 24, color: isDark ? WoniColors.darkText2 : WoniColors.lightText2),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\ucee4\ud53c', style: WoniTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('${S.catFood} \u00b7 ${S.relToday}', style: WoniTextStyles.bodySecondary.copyWith(
                              color: isDark ? WoniColors.darkText2 : WoniColors.lightText2,
                            )),
                          ],
                        ),
                      ),
                      Text('-4,500\u20a9', style: WoniTextStyles.amount.copyWith(
                        color: isDark ? WoniColors.coralDark : WoniColors.coral,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
