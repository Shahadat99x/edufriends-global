import 'dart:ui';
import 'package:flutter/material.dart';


import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double? blur; 
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur,
    this.color,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<GlassTokens>();

  
    final double blurSigma = blur ?? glass?.blurSigma ?? 10.0;

 
    final Color baseBackground = glass?.backgroundTint ?? cs.surface;
    final Color bgTint = (color ?? baseBackground).withOpacity(0.62);


    final Color baseBorderColor = glass?.borderColor ?? AppColors.neutral40;
    final double borderOpacity = glass?.borderOpacity ?? 0.06;
    final Color computedBorderColor = baseBorderColor.withOpacity(borderOpacity);


    final Color shadowColor = Colors.black.withOpacity(0.06);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgTint,
            borderRadius: borderRadius,
            border: border ?? Border.all(color: computedBorderColor),
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
          ),
          child: child,
        ),
      ),
    );
  }
}
