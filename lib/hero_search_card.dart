import 'package:flutter/material.dart';

class HeroSearchCard extends StatelessWidget {
  const HeroSearchCard({super.key, this.onSearchTap, this.onCtaTap});
  final VoidCallback? onSearchTap;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return Material(
      color: Colors.transparent, 
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent, 
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon on the left
            Icon(Icons.school, size: 40, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plan your study journey', style: titleStyle),
                  const SizedBox(height: 4),
                  Text('Explore countries, universities and programs.', style: bodyStyle),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: onSearchTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cs.surface.withOpacity(0.08), // subtle fill
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.primary.withOpacity(.06)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: cs.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Find your study destination',
                              style: bodyStyle?.copyWith(color: cs.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: onCtaTap,
                    child: const Text('Start Assessment'),
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
