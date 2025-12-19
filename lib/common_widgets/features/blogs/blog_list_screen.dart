import 'package:flutter/material.dart';
import 'package:edufriends_global/core/utils/launchers.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t  = Theme.of(context).textTheme;

    return SafeArea(
      top: false, // MainScaffold already draws the app bar with your logo
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          // Hero card – gradient + glass icon + title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withOpacity(.10),
                  cs.secondary.withOpacity(.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withOpacity(.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlassIcon(
                  icon: Icons.menu_book_rounded,
                  color: cs.primary,
                ),
                const SizedBox(height: 14),
                Text(
                  'Blogs — Coming soon',
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'We’re preparing high-quality posts on countries, TRP/visa steps, '
                  'university selection, budgets, and real student stories.',
                  style: t.bodyMedium,
                ),
                const SizedBox(height: 16),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TopicChip('TRP & Visa'),
                    _TopicChip('Country Guides'),
                    _TopicChip('Budgets & Jobs'),
                    _TopicChip('IELTS & Documents'),
                    _TopicChip('Student Stories'),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ FIX: Row -> Wrap so the second button moves below on small widths
                Wrap(
                  spacing: 10,     // horizontal gap
                  runSpacing: 10,  // vertical gap when wrapping
                  children: [
                    SizedBox(
                      height: 44,
                      child: FilledButton.icon(
                        onPressed: () =>
                            openWhatsApp('48571577245', text: 'Notify me when blogs launch'),
                        icon: const Icon(Icons.notifications_active_rounded),
                        label: const Text('Notify me on WhatsApp'),
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            openEmail('info@edufriendsglobal.com',
                                subject: 'Blog updates subscription'),
                        icon: const Icon(Icons.mail_rounded),
                        label: const Text('Email me updates'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Roadmap / value section
          Text('What you’ll get', style: t.titleMedium),
          const SizedBox(height: 10),
          const _PointTile(
            icon: Icons.auto_awesome_rounded,
            title: 'Actionable, student-friendly guides',
            subtitle:
                'Step-by-step checklists you can follow without confusion.',
          ),
          const _PointTile(
            icon: Icons.language_rounded,
            title: 'Country comparisons that matter',
            subtitle:
                'Costs, TRP paths, part-time jobs, and program examples.',
          ),
          const _PointTile(
            icon: Icons.verified_user_rounded,
            title: 'Requirements kept up-to-date',
            subtitle:
                'We’ll track policy changes and keep the info current.',
          ),

          const SizedBox(height: 16),
          // Subtle footer note
          Center(
            child: Text(
              'First posts planned for: Lithuania • Romania • Baltics',
              style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/* --- small UI bits --- */

class _GlassIcon extends StatelessWidget {
  const _GlassIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.20)),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withOpacity(.20)),
      ),
      child: Text(text),
    );
  }
}

class _PointTile extends StatelessWidget {
  const _PointTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t  = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withOpacity(.18)),
            ),
            child: Icon(icon, size: 20, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
