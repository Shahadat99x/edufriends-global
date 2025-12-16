import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'hero_card.dart';
import 'featured_programs.dart';
import 'popular_destinations.dart';
import 'sections.dart';
import 'shared_widgets.dart';
import 'home_data.dart';

import '../../common_widgets/main_scaffold.dart';
import '../../common_widgets/web/app_webview.dart';
import '../../common_widgets/glass_container.dart';

import '../../common_widgets/features/universities/universities_screen.dart';

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctr;
  late final Animation<double> heroAnim;
  late final Animation<double> infoAnim;
  late final Animation<double> carouselAnim;
  late final Animation<double> quickActionsAnim;
  late final Animation<double> featuredAnim;
  late final Animation<double> profileAnim;
  late final Animation<double> testimonialAnim;
  late final Animation<double> faqAnim;

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    // staggered intervals for entrance
    heroAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.00, 0.18, curve: Curves.easeOut));
    infoAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.10, 0.28, curve: Curves.easeOut));
    carouselAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.20, 0.40, curve: Curves.easeOut));
    quickActionsAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.30, 0.50, curve: Curves.easeOut));
    featuredAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.40, 0.68, curve: Curves.easeOut));
    profileAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.60, 0.80, curve: Curves.easeOut));
    testimonialAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.72, 0.88, curve: Curves.easeOut));
    faqAnim = CurvedAnimation(parent: _ctr, curve: const Interval(0.80, 1.00, curve: Curves.easeOut));

    // play animation after first frame so layout exists
    WidgetsBinding.instance.addPostFrameCallback((_) => _ctr.forward());
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  void _goToUniversities() {
    final state = MainScaffold.maybeOf(context);
    if (state != null) {
      // adjust tab index if needed
      state.setIndex(2);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UniversitiesScreen()));
    }
  }

  // Small helper to compose animated entry with fade + slight slide
  Widget _buildStagger({required Animation<double> anim, required Widget child, double dy = 10}) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, dy / 100), end: Offset.zero).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    final bool isCompact = w < 340;
    final bool isSmall = w < 380;
    final bool isTablet = w >= 600;

    final double contentMaxWidth = isTablet ? 880 : 640;
    final double hPad = isCompact ? 12 : 16;
    final double carouselHeight = isCompact ? 130 : (isSmall ? 142 : 164);
    final double viewport = isCompact ? 0.86 : (isSmall ? 0.80 : 0.74);
    final int programsCrossAxis = isTablet ? 3 : (w >= 600 ? 2 : 1);

    return ScrollConfiguration(
      behavior: _NoScrollbarBehavior(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 28),
            children: [
              // HERO (animated)
              _buildStagger(
                anim: heroAnim,
                dy: 12,
                child: HeroCard(onFindProgramsTap: _goToUniversities),
              ),

              const SizedBox(height: 16),

              // Info strip (chips)
              _buildStagger(anim: infoAnim, dy: 8, child: const InfoStrip()),

              const SizedBox(height: 18),

              // Popular Destinations
              _buildStagger(
                anim: carouselAnim,
                dy: 8,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SectionHeader(title: 'Popular Destinations'),
                  const SizedBox(height: 10),
                  PopularDestinationsAutoList(
                    height: carouselHeight,
                    fraction: viewport,
                    spacing: 12,
                    period: const Duration(seconds: 3),
                    contentMaxWidth: contentMaxWidth,
                    onCardTap: (c) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppWebView(title: c.name, initialUrl: c.url))),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              // Quick Actions
              _buildStagger(anim: quickActionsAnim, dy: 8, child: Column(children: [
                const SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 8),
                GlassContainer(
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(14),
                  blur: 10,
                  child: QuickActionsRow(onAssessment: _goToUniversities, onContact: () {
                    final state = MainScaffold.maybeOf(context);
                    if (state != null) state.setIndex(4);
                  }),
                ),
              ])),

              const SizedBox(height: 20),

              // Featured Programs (animated)
              _buildStagger(
                anim: featuredAnim,
                dy: 10,
                child: Column(children: [
                  const SectionHeader(title: 'Featured Programs', subtitle: 'Top picks curated by EduFriends advisors'),
                  const SizedBox(height: 10),
                  FeaturedProgramsGrid(
                    programs: samplePrograms,
                    crossAxisCount: programsCrossAxis,
                    onProgramTap: (p) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(
                      appBar: AppBar(title: Text(p.title)),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.university, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(p.cityCountry),
                          const SizedBox(height: 12),
                          Text('Tuition: ${p.tuition}'),
                          const SizedBox(height: 6),
                          Text('Duration: ${p.duration}'),
                          const SizedBox(height: 6),
                          Text('Discipline: ${p.discipline}'),
                          const SizedBox(height: 18),
                          FilledButton(onPressed: () {}, child: const Text('Apply / Enquire')),
                        ]),
                      ),
                    ))),
                  ),
                ]),
              ),

              const SizedBox(height: 22),

              // Profile Evaluation (animated)
              _buildStagger(anim: profileAnim, dy: 8, child: ProfileEvaluationCard(formUrl: '<YOUR_GOOGLE_FORM_URL>')),

              const SizedBox(height: 18),

              // Student Stories
              _buildStagger(anim: testimonialAnim, dy: 8, child: Column(children: [
                const SectionHeader(title: 'Student Stories'),
                const SizedBox(height: 10),
                const TestimonialTeaser(),
              ])),

              const SizedBox(height: 26),

              // FAQ
              _buildStagger(anim: faqAnim, dy: 8, child: Column(children: [
                const SectionHeader(title: 'FAQs', subtitle: 'Answers to common questions'),
                const SizedBox(height: 10),
                const FAQSection(),
              ])),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
