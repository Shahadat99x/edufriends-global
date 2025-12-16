import 'package:flutter/material.dart';
import '../../common_widgets/glass_container.dart';

class HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onFindProgramsTap;

  const HeroCard({
    super.key,
    this.title = 'Find your pathway abroad',
    this.subtitle = 'Filter curated programs by degree, tuition, language, and intake — every listing vetted by our advisors.',
    required this.onFindProgramsTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final w = MediaQuery.of(context).size.width;
    final bool isSmall = w < 380;
    final double verticalPadding = isSmall ? 14 : 18;

    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: verticalPadding),
      borderRadius: BorderRadius.circular(16),
      blur: 12,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: text.headlineSmall?.copyWith(fontSize: isSmall ? 20 : 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.8), height: 1.4)),
        const SizedBox(height: 18),

        Row(children: [
          Expanded(
            child: FilledButton(
              onPressed: onFindProgramsTap,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              child: const Text('Find Programs'),
            ),
          ),
        ])
      ]),
    );
  }
}
