import 'package:flutter/material.dart';

import 'app_colors.dart';

// Semantic colors (iOS naming) resolved per brightness.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.fill,
    required this.label,
    required this.secondaryLabel,
    required this.separator,
    required this.accent,
    required this.delete,
    required this.keep,
    required this.premium,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color fill;
  final Color label;
  final Color secondaryLabel;
  final Color separator;
  final Color accent;
  final Color delete;
  final Color keep;
  final Color premium;
  final Color shadow;

  // Kept for older call sites.
  Color get muted => secondaryLabel;
  Color get border => separator;

  static const light = AppPalette(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    fill: AppColors.lightFill,
    label: AppColors.lightLabel,
    secondaryLabel: AppColors.lightSecondaryLabel,
    separator: AppColors.lightSeparator,
    accent: AppColors.accentLight,
    delete: AppColors.deleteLight,
    keep: AppColors.keepLight,
    premium: AppColors.premiumLight,
    shadow: Color(0x14000000),
  );

  static const dark = AppPalette(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    fill: AppColors.darkFill,
    label: AppColors.darkLabel,
    secondaryLabel: AppColors.darkSecondaryLabel,
    separator: AppColors.darkSeparator,
    accent: AppColors.accentDark,
    delete: AppColors.deleteDark,
    keep: AppColors.keepDark,
    premium: AppColors.premiumDark,
    shadow: Color(0x00000000),
  );

  List<BoxShadow> get softShadow => [
    BoxShadow(color: shadow, blurRadius: 24, offset: const Offset(0, 8)),
  ];

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? fill,
    Color? label,
    Color? secondaryLabel,
    Color? separator,
    Color? accent,
    Color? delete,
    Color? keep,
    Color? premium,
    Color? shadow,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      fill: fill ?? this.fill,
      label: label ?? this.label,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      separator: separator ?? this.separator,
      accent: accent ?? this.accent,
      delete: delete ?? this.delete,
      keep: keep ?? this.keep,
      premium: premium ?? this.premium,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      fill: mix(fill, other.fill),
      label: mix(label, other.label),
      secondaryLabel: mix(secondaryLabel, other.secondaryLabel),
      separator: mix(separator, other.separator),
      accent: mix(accent, other.accent),
      delete: mix(delete, other.delete),
      keep: mix(keep, other.keep),
      premium: mix(premium, other.premium),
      shadow: mix(shadow, other.shadow),
    );
  }
}
