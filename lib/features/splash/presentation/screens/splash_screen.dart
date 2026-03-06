import 'package:flutter/material.dart';
import 'package:woni/core/l10n/strings.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/features/onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Logo: 0–30%
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  // Tagline 1 "контролируй расходы": 20–50%
  late final Animation<double> _tag1Opacity;
  late final Animation<double> _tag1Slide;

  // Tagline 2 "быстро и просто вместе с Woni": 40–65%
  late final Animation<double> _tag2Opacity;
  late final Animation<double> _tag2Slide;

  // Auth buttons: 60–85%
  late final Animation<double> _authOpacity;
  late final Animation<double> _authSlide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Logo: 0–30%
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.30, curve: Curves.easeOut)),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.30, curve: Curves.easeOut)),
    );

    // Tagline 1: 20–50%
    _tag1Opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.20, 0.50, curve: Curves.easeOut)),
    );
    _tag1Slide = Tween<double>(begin: 16, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.20, 0.50, curve: Curves.easeOut)),
    );

    // Tagline 2: 40–65%
    _tag2Opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.40, 0.65, curve: Curves.easeOut)),
    );
    _tag2Slide = Tween<double>(begin: 16, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.40, 0.65, curve: Curves.easeOut)),
    );

    // Auth buttons: 60–85%
    _authOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.60, 0.85, curve: Curves.easeOut)),
    );
    _authSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.60, 0.85, curve: Curves.easeOut)),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _handleBiometric() {
    // Same as Google for now — placeholder
    _handleGoogleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor1 = isDark ? WoniColors.darkText1 : WoniColors.lightText1;
    final textColor2 = isDark ? WoniColors.darkText2 : WoniColors.lightText2;
    final textColor3 = isDark ? WoniColors.darkText3 : WoniColors.lightText3;

    return Scaffold(
      backgroundColor: isDark ? WoniColors.darkBg : WoniColors.lightBg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo ──
              Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Tagline 1: "контролируй расходы" ──
              Opacity(
                opacity: _tag1Opacity.value,
                child: Transform.translate(
                  offset: Offset(0, _tag1Slide.value),
                  child: Text(
                    S.splashTagline1,
                    style: WoniTextStyles.body.copyWith(
                      color: textColor1,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Tagline 2: "быстро и просто вместе с Woni" ──
              Opacity(
                opacity: _tag2Opacity.value,
                child: Transform.translate(
                  offset: Offset(0, _tag2Slide.value),
                  child: Text(
                    S.splashTagline2,
                    style: WoniTextStyles.body.copyWith(
                      color: textColor1,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // ── Auth buttons ──
              Opacity(
                opacity: _authOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, _authSlide.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Google Sign-In button
                        GestureDetector(
                          onTap: _handleGoogleSignIn,
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? WoniColors.darkSurface : Colors.white,
                              borderRadius: WoniRadius.full,
                              border: Border.all(
                                color: isDark ? WoniColors.darkBorder : WoniColors.lightBorder,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google icon (simple colored G)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? WoniColors.darkText3 : WoniColors.lightText3,
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'G',
                                    style: WoniTextStyles.body.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? WoniColors.darkText1 : WoniColors.lightText1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  S.authGoogleBtn,
                                  style: WoniTextStyles.button.copyWith(
                                    color: textColor1,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // "или" separator
                        Text(
                          S.authOr,
                          style: WoniTextStyles.bodySecondary.copyWith(
                            color: textColor3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Biometric auth button
                        GestureDetector(
                          onTap: _handleBiometric,
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  WoniColors.blue,
                                  const Color(0xFF7B6EF6),
                                ],
                              ),
                              borderRadius: WoniRadius.full,
                              boxShadow: WoniShadows.blue(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fingerprint_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  S.authBiometric,
                                  style: WoniTextStyles.button.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
