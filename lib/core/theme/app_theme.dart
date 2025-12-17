import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

// ThemeExtension to carry glass-related tokens through ThemeData.extensions
@immutable
class GlassTokens extends ThemeExtension<GlassTokens> {
  final double blurSigma;
  final Color borderColor;
  final double borderOpacity;
  final Color backgroundTint;

  const GlassTokens({
    required this.blurSigma,
    required this.borderColor,
    required this.borderOpacity,
    required this.backgroundTint,
  });

  @override
  GlassTokens copyWith({double? blurSigma, Color? borderColor, double? borderOpacity, Color? backgroundTint}) {
    return GlassTokens(
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      backgroundTint: backgroundTint ?? this.backgroundTint,
    );
  }

  @override
  GlassTokens lerp(ThemeExtension<GlassTokens>? other, double t) {
    if (other is! GlassTokens) return this;
    return GlassTokens(
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t) ?? blurSigma,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderOpacity: lerpDouble(borderOpacity, other.borderOpacity, t) ?? borderOpacity,
      backgroundTint: Color.lerp(backgroundTint, other.backgroundTint, t) ?? backgroundTint,
    );
  }
}

// Small helper for lerping doubles used above
double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  final na = a?.toDouble() ?? 0.0;
  final nb = b?.toDouble() ?? 0.0;
  return na + (nb - na) * t;
}

class AppTheme {
  static const double _corner12 = 12.0;
  static const double _corner16 = 16.0;

  // Spacing tokens (use these across widgets)
  static const double sp4 = 4;
  static const double sp8 = 8;
  static const double sp12 = 12;
  static const double sp16 = 16;
  static const double sp24 = 24;

  // ───────────────────────── LIGHT THEME ─────────────────────────
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentOrange,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.neutral90,
    );

    final baseText = GoogleFonts.interTextTheme();
    final textTheme = baseText.copyWith(
      displaySmall: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800),
      headlineSmall: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: baseText.bodySmall?.copyWith(fontSize: 13),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Input style
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),

      // Card
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.all(12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_corner16)))),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
          textStyle: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Chips & dividers
      chipTheme: ChipThemeData(shape: const StadiumBorder(), side: const BorderSide(color: AppColors.border), labelStyle: textTheme.bodySmall),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),

      // Extensions - glass tokens
      extensions: const <ThemeExtension<dynamic>>[
        GlassTokens(
          blurSigma: 10.0,
          borderColor: AppColors.neutral40,
          borderOpacity: 0.06,
          backgroundTint: AppColors.glassTintSoftBlue,
        ),
      ],
    );
  }

  // ───────────────────────── DARK THEME ─────────────────────────
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentOrange,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: const Color(0xFF0F1720),
      onSurface: Colors.white,
    );

    final baseText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    final textTheme = baseText.copyWith(
      displaySmall: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800),
      headlineSmall: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: baseText.bodySmall?.copyWith(fontSize: 13),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: BorderSide(color: colorScheme.outline)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: BorderSide(color: colorScheme.outline.withOpacity(.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_corner12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface.withOpacity(0.28),
        margin: const EdgeInsets.all(12),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_corner16))),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
          textStyle: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          side: BorderSide(color: colorScheme.outline.withOpacity(.18)),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        backgroundColor: colorScheme.surface.withOpacity(0.32),
        labelStyle: textTheme.bodySmall?.copyWith(color: Colors.white70),
      ),

      dividerTheme: DividerThemeData(color: colorScheme.outline.withOpacity(.18), thickness: 1),

      extensions: const <ThemeExtension<dynamic>>[
        GlassTokens(
          blurSigma: 14.0,
          borderColor: AppColors.neutral40,
          borderOpacity: 0.10,
          backgroundTint: AppColors.glassTintDark,
        ),
      ],
    );
  }
}