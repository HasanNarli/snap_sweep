import 'package:flutter/material.dart';

import 'app_colors.dart';

// Semantic colors resolved per brightness. Never hard-code colors in widgets.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.border,
    required this.fill,
    required this.track,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.accent,
    required this.accentSoft,
    required this.delete,
    required this.keep,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color border;
  final Color fill;
  final Color track;
  final Color label;
  final Color secondaryLabel;
  final Color tertiaryLabel;
  final Color accent;
  final Color accentSoft;
  final Color delete;
  final Color keep;
  final bool isDark;

  // Primary buttons are ink on light, inverted on dark.
  Color get cta => label;
  Color get onCta => background;

  static const light = AppPalette(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    border: AppColors.lightBorder,
    fill: AppColors.lightFill,
    track: AppColors.lightTrack,
    label: AppColors.lightLabel,
    secondaryLabel: AppColors.lightSecondaryLabel,
    tertiaryLabel: AppColors.lightTertiaryLabel,
    accent: AppColors.lightAccent,
    accentSoft: AppColors.lightAccentSoft,
    delete: AppColors.delete,
    keep: AppColors.keep,
    isDark: false,
  );

  static const dark = AppPalette(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    border: AppColors.darkBorder,
    fill: AppColors.darkFill,
    track: AppColors.darkTrack,
    label: AppColors.darkLabel,
    secondaryLabel: AppColors.darkSecondaryLabel,
    tertiaryLabel: AppColors.darkTertiaryLabel,
    accent: AppColors.darkAccent,
    accentSoft: AppColors.darkAccentSoft,
    delete: AppColors.delete,
    keep: AppColors.keep,
    isDark: true,
  );

  // Barely-there card shadow; borders do the separation.
  List<BoxShadow> get cardShadow => isDark
      ? const []
      : const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ];

  List<BoxShadow> get buttonShadow => isDark
      ? const []
      : const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ];

  // Overlays on photos look the same in light and dark.
  Color get onPhoto => AppColors.onPhoto;
  Color get onPhotoSecondary => AppColors.onPhotoSecondary;
  Color get onPhotoTertiary => AppColors.onPhotoTertiary;
  Color get photoGlass => AppColors.photoGlass;
  Color get photoGlassBorder => AppColors.photoGlassBorder;
  Color get photoGlassSubtle => AppColors.photoGlassSubtle;
  Color get photoGlassSubtleBorder => AppColors.photoGlassSubtleBorder;
  Color get photoGlassLight => AppColors.photoGlassLight;
  Color get onPhotoGlassLight => AppColors.lightLabel;
  Color get photoDim => AppColors.photoDim;
  Color get photoOutline => AppColors.photoOutline;

  // Content on solid delete/keep fills and on the decision badge.
  Color get onSolid => AppColors.onSolid;
  Color get badge => AppColors.onSolid;

  Color get toast => AppColors.toast;
  Color get onToast => AppColors.onSolid;

  // Soft top/bottom scrim so overlays stay readable on any photo.
  LinearGradient get photoScrim => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.photoScrimTop,
      Color(0x00000000),
      AppColors.photoScrimBottom,
    ],
  );

  List<BoxShadow> get photoCardShadow => const [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 40,
      spreadRadius: -10,
      offset: Offset(0, 14),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ];

  List<BoxShadow> get badgeShadow => const [
    BoxShadow(color: Color(0x33000000), blurRadius: 24),
  ];

  // Floating action bar; flat in dark.
  List<BoxShadow> get floatingShadow => isDark
      ? const []
      : const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ];

  BoxDecoration card({double radius = 16}) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: border),
    boxShadow: cardShadow,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? fill,
    Color? track,
    Color? label,
    Color? secondaryLabel,
    Color? tertiaryLabel,
    Color? accent,
    Color? accentSoft,
    Color? delete,
    Color? keep,
    bool? isDark,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      fill: fill ?? this.fill,
      track: track ?? this.track,
      label: label ?? this.label,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      delete: delete ?? this.delete,
      keep: keep ?? this.keep,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      border: mix(border, other.border),
      fill: mix(fill, other.fill),
      track: mix(track, other.track),
      label: mix(label, other.label),
      secondaryLabel: mix(secondaryLabel, other.secondaryLabel),
      tertiaryLabel: mix(tertiaryLabel, other.tertiaryLabel),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      delete: mix(delete, other.delete),
      keep: mix(keep, other.keep),
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
