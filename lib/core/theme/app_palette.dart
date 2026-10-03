import 'package:flutter/material.dart';

import 'app_colors.dart';

// App-specific colors that Material's ColorScheme doesn't cover.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.delete,
    required this.keep,
    required this.premium,
    required this.muted,
    required this.border,
  });

  final Color delete;
  final Color keep;
  final Color premium;
  final Color muted;
  final Color border;

  static const light = AppPalette(
    delete: AppColors.delete,
    keep: AppColors.keep,
    premium: AppColors.premium,
    muted: AppColors.lightMuted,
    border: AppColors.lightBorder,
  );

  static const dark = AppPalette(
    delete: AppColors.delete,
    keep: AppColors.keep,
    premium: AppColors.premium,
    muted: AppColors.darkMuted,
    border: AppColors.darkBorder,
  );

  @override
  AppPalette copyWith({
    Color? delete,
    Color? keep,
    Color? premium,
    Color? muted,
    Color? border,
  }) {
    return AppPalette(
      delete: delete ?? this.delete,
      keep: keep ?? this.keep,
      premium: premium ?? this.premium,
      muted: muted ?? this.muted,
      border: border ?? this.border,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      delete: Color.lerp(delete, other.delete, t)!,
      keep: Color.lerp(keep, other.keep, t)!,
      premium: Color.lerp(premium, other.premium, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
