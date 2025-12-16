import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.subtitle, this.onMore, this.moreLabel, super.key});
  final String title;
  final String? subtitle;
  final VoidCallback? onMore;
  final String? moreLabel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.14),
            borderRadius: BorderRadius.circular(6),
          ),
          margin: const EdgeInsets.only(right: 10),
        ),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.2)),
            if (subtitle != null) const SizedBox(height: 4),
            if (subtitle != null)
              Text(subtitle!, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ]),
        ),

        if (onMore != null)
          TextButton.icon(
            onPressed: onMore,
            icon: Icon(Icons.arrow_forward_ios, size: 12, color: cs.primary),
            label: Text(moreLabel ?? 'More', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            style: TextButton.styleFrom(
              backgroundColor: cs.primary.withOpacity(0.06),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              visualDensity: VisualDensity.compact,
              minimumSize: Size.zero,
            ),
          ),
      ],
    );
  }
}
