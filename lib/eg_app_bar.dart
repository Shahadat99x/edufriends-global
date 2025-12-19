import 'package:flutter/material.dart';

class EGAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EGAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  final String title;
  final bool showBack;        
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t  = Theme.of(context).textTheme;

    Widget? leading;
    if (showBack) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withOpacity(.18)),
            ),
            child: const Center(child: Icon(Icons.arrow_back_rounded, size: 22)),
          ),
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      leadingWidth: showBack ? 60 : 0,
      leading: leading,
      title: _AnimatedTitle(title: title, style: t.titleMedium?.copyWith(
        fontWeight: FontWeight.w600, letterSpacing: .2,
      )),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: _AnimatedUnderline(color: cs.primary),
      ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  const _AnimatedTitle({required this.title, required this.style});
  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // Fade + slight slide on first build / route change
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 6),
            child: child,
          ),
        );
      },
      child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
    );
  }
}

class _AnimatedUnderline extends StatelessWidget {
  const _AnimatedUnderline({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Align(
        alignment: Alignment.center,
        child: Container(
          height: 2,
          width: w * 0.28 * v, 
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
