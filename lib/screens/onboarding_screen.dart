import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _page = 0;
  late AnimationController _fadeController;
  late AnimationController _textCardController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textCardFadeAnimation;
  late Animation<Offset> _textCardSlideAnimation;
  late Animation<double> _textCardScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _textCardController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    
    _textCardFadeAnimation = CurvedAnimation(
      parent: _textCardController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
    
    _textCardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textCardController,
      curve: const Interval(0.15, 0.9, curve: Curves.easeOutCubic),
    ));
    
    _textCardScaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textCardController,
      curve: const Interval(0.15, 0.85, curve: Curves.easeOutCubic),
    ));
    
    _textCardController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _textCardController.dispose();
    super.dispose();
  }

  final List<_OnboardPageData> _pages = const [
    _OnboardPageData(
      title: 'Plan your study journey',
      subtitle:
          'Discover countries, universities, and visa guidance — all in one place.',
      asset: 'assets/images/onboarding/onboarding_1.png',
    ),
    _OnboardPageData(
      title: 'Start your global study journey',
      subtitle:
          'Personalized guidance for programs, universities, TRP & visa — everything you need in one app.',
      asset: 'assets/images/onboarding/onboarding_2.png',
    ),
    _OnboardPageData(
      title: 'Dream. Learn. Explore. Soar.',
      subtitle:
          'Your journey to studying abroad starts here. Explore options and take the first step with EduFriends Global.',
      asset: 'assets/images/onboarding/onboarding_3.png',
    ),
  ];

  bool get _isLastPage => _page == _pages.length - 1;

  Future<void> _completeOnboarding() async {
    await _fadeController.reverse();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completedOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/main');
  }

  void _onSkip() => _completeOnboarding();

  void _onNext(bool reduceMotion) {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      _textCardController.reset();
      _textCardController.forward();
      
      if (reduceMotion) {
        _pageController.jumpToPage(_page + 1);
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  Widget _buildDots(ThemeData theme, bool reduceMotion, Color activeColor) {
    final colorInactive = theme.colorScheme.onSurface.withOpacity(0.15);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (i) {
        final active = i == _page;
        return AnimatedContainer(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? activeColor : colorInactive,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  Widget _gradientButton({
    required VoidCallback onTap,
    required Widget child,
    required Color start,
    required Color end,
    double radius = 16,
    double height = 52,
    double minWidth = 140,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, minHeight: height),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [start, end],
              ),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: end.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: start.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _frostedSkipButton(ThemeData theme, bool reduceMotion) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _onSkip,
        splashColor: theme.colorScheme.onSurface.withOpacity(0.05),
        highlightColor: theme.colorScheme.onSurface.withOpacity(0.03),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.75),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Skip',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // FIXED: Frosted text card that overlays the bottom of the image
  Widget _buildFrostedTextCard(_OnboardPageData page, ThemeData theme) {
    return FadeTransition(
      opacity: _textCardFadeAnimation,
      child: SlideTransition(
        position: _textCardSlideAnimation,
        child: ScaleTransition(
          scale: _textCardScaleAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.92),
                        Colors.white.withOpacity(0.78),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.65),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        page.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          height: 1.25,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        page.subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          height: 1.5,
                          color: const Color(0xFF4A4A4A),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final reduceMotion = mq.disableAnimations || mq.accessibleNavigation;
    final maxWidth = mq.size.width > 720 ? 720.0 : mq.size.width;

    const brandOrange = Color(0xFFFF6F3C);
    const brandBlue = Color(0xFF0056B3);

    final List<Color> startColors = [
      const Color(0xFF5BC7DC),
      const Color(0xFFFF9A63),
      const Color(0xFFFF8E52),
    ];
    final List<Color> endColors = [brandBlue, brandOrange, brandBlue];

    const backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFDFEFF),
        Color(0xFFF7FAFF),
        Color(0xFFF1F7FF),
        Color(0xFFEBF3FF),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    );

    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.dark
        .copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: mq.size.height,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (i) {
                            setState(() => _page = i);
                            _textCardController.reset();
                            _textCardController.forward();
                          },
                          itemBuilder: (context, index) {
                            final p = _pages[index];

                            final String ctaLabel =
                                (index == _pages.length - 1)
                                    ? "Let's Get Started"
                                    : (index == 1 ? 'Continue' : 'Next');
                            final start =
                                startColors[index % startColors.length];
                            final end = endColors[index % endColors.length];

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),

                                  // FIXED: Image with text card overlay at bottom
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Stack(
                                        children: [
                                          // Background image
                                          AspectRatio(
                                            aspectRatio: 9 / 16,
                                            child: AnimatedSwitcher(
                                              duration: reduceMotion
                                                  ? Duration.zero
                                                  : const Duration(
                                                      milliseconds: 400),
                                              switchInCurve: Curves.easeInOut,
                                              child: Image.asset(
                                                p.asset,
                                                key: ValueKey<String>(p.asset),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          // Frosted text card overlaying bottom of image
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 20,
                                            child: _buildFrostedTextCard(p, theme),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Compact dots card
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: _EnhancedFrostCard(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 14,
                                        ),
                                        child: Center(
                                          child: _buildDots(
                                            theme,
                                            reduceMotion,
                                            start,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Buttons
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      24,
                                      0,
                                      24,
                                      math.max(mq.padding.bottom, 16),
                                    ),
                                    child: _isLastPage
                                        ? Center(
                                            child: SizedBox(
                                              width: math.min(
                                                maxWidth * 0.85,
                                                340,
                                              ),
                                              child: _gradientButton(
                                                onTap: () =>
                                                    _onNext(reduceMotion),
                                                start: start,
                                                end: end,
                                                radius: 16,
                                                height: 52,
                                                minWidth: 220,
                                                child: Text(
                                                  ctaLabel,
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.labelLarge
                                                      ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              _frostedSkipButton(
                                                theme,
                                                reduceMotion,
                                              ),
                                              const Expanded(
                                                  child: SizedBox()),
                                              Flexible(
                                                child: SizedBox(
                                                  width: math.min(
                                                    maxWidth * 0.4,
                                                    180,
                                                  ),
                                                  child: _gradientButton(
                                                    onTap: () =>
                                                        _onNext(reduceMotion),
                                                    start: start,
                                                    end: end,
                                                    radius: 16,
                                                    height: 52,
                                                    minWidth: 140,
                                                    child: AnimatedSwitcher(
                                                      duration: reduceMotion
                                                          ? Duration.zero
                                                          : const Duration(
                                                              milliseconds: 250),
                                                      child: Text(
                                                        ctaLabel,
                                                        key: ValueKey<String>(
                                                            ctaLabel),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: theme.textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15,
                                                          letterSpacing: 0.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EnhancedFrostCard extends StatelessWidget {
  final Widget child;
  const _EnhancedFrostCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                blurRadius: 18,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.6),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white.withOpacity(0.95)),
                (isDark
                    ? Colors.white.withOpacity(0.02)
                    : Colors.white.withOpacity(0.75)),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.5,
                        colors: [
                          Colors.white.withOpacity(0.18),
                          Colors.white.withOpacity(0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPageData {
  final String title;
  final String subtitle;
  final String asset;
  const _OnboardPageData({
    required this.title,
    required this.subtitle,
    required this.asset,
  });
}
