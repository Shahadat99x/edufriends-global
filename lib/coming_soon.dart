import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({
    super.key,
    required this.title,
    this.subtitle =
        "We’re preparing great content here. Check back soon!",
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t  = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Illustration-ish card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.primary.withOpacity(.08)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.hourglass_empty_rounded,
                              size: 56, color: cs.primary),
                          const SizedBox(height: 12),
                          Text('Coming soon',
                              style: t.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: t.titleMedium?.copyWith(
                              letterSpacing: .2,
                              color: cs.onSurface.withOpacity(.85),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(subtitle,
                              textAlign: TextAlign.center,
                              style: t.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              )),
                        ],
                      ),
                    ),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: actions,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
