import 'package:flutter/material.dart';

class CountryChip extends StatelessWidget {
  const CountryChip({
    super.key,
    required this.label,
    this.flagAsset,
    this.onTap,
  });

  final String label;
  final String? flagAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.primary.withOpacity(.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FlagCircle(asset: flagAsset),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _FlagCircle extends StatelessWidget {
  const _FlagCircle({this.asset});
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: asset == null
          ? const Icon(Icons.public, size: 18)
          : Image.asset(
              asset!,
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.public, size: 18),
            ),
    );
  }
}
