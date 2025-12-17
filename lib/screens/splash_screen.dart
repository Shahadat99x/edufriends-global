import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _pulseAnimation;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Logo animations (1000ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Text animations (800ms, delayed)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Pulsing indicator (loops continuously)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mq = MediaQuery.of(context);
      final disableAnimations = mq.disableAnimations || mq.accessibleNavigation;

      if (disableAnimations) {
        // Reduced motion: skip animations
        _logoController.value = 1.0;
        _textController.value = 1.0;
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          if (!mounted) return;
          _onAnimationComplete();
        });
      } else {
        // Normal flow: staggered animations
        _logoController.forward().then((_) {
          if (!mounted) return;
          _textController.forward();
        });

        // Navigate after total duration
        Future.delayed(widget.duration).then((_) {
          if (!mounted) return;
          _onAnimationComplete();
        });
      }
    });
  }

  Future<void> _onAnimationComplete() async {
    if (_navigated) return;
    _navigated = true;

    String nextRoute = '/main';
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool('completedOnboarding') ?? false;
      nextRoute = completed ? '/main' : '/onboarding';
    } catch (e) {
      nextRoute = '/onboarding';
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;

    // Brand colors
    const brandBlue = Color(0xFF0056B3);
    const brandOrange = Color(0xFFFF6F3C);

    // Premium gradient backgrounds
    const lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFDFEFF), // Very light blue-white
        Color(0xFFF7FAFF), // Soft pale blue
        Color(0xFFF1F7FF), // Light sky blue
        Color(0xFFEBF3FF), // Gentle blue
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF0A1929), // Deep navy
        const Color(0xFF0D1B2A), // Dark blue-black
        Colors.grey.shade900,
        Colors.black,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    // Status bar style
    final overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
        : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Premium gradient background
            Container(
              decoration: BoxDecoration(
                gradient: isDark ? darkGradient : lightGradient,
              ),
            ),

            // Decorative glowing orbs (brand colors)
            Positioned(
              left: -100,
              top: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? brandBlue : brandBlue.withOpacity(0.15))
                          .withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -80,
              bottom: -100,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? brandOrange : brandOrange.withOpacity(0.12))
                          .withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Subtle backdrop blur for depth
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),

            // Center content with staggered animations
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo container with adaptive mark
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Hero(
                        tag: 'edufriends-logo',
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.03),
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.95),
                                      Colors.white.withOpacity(0.85),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.5)
                                    : brandBlue.withOpacity(0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 12),
                                spreadRadius: -5,
                              ),
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          // Adaptive logo mark: edufriends_mark.svg or edufriends_mark_dark.svg
                          child: SvgPicture.asset(
                            isDark
                                ? 'assets/images/brand/edufriends_mark_dark.svg'
                                : 'assets/images/brand/edufriends_mark.svg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            semanticsLabel: 'EduFriends logo',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Animated wordmark
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: SvgPicture.asset(
                        isDark
                            ? 'assets/images/brand/edufriends_logo_dark.svg'
                            : 'assets/images/brand/edufriends_logo_light.svg',
                        height: 42,
                        width: 280,
                        fit: BoxFit.contain,
                        semanticsLabel: 'EduFriends Global',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Animated tagline
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Text(
                        'Dream • Explore • Learn',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Pulsing loading indicator
                  FadeTransition(
                    opacity: _textFade,
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [brandBlue, brandOrange],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: brandBlue.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
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
