import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static const fontFamily = 'Inter';

  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: p.accent,
          brightness: brightness,
        ).copyWith(
          primary: p.cta,
          onPrimary: p.onCta,
          error: p.delete,
          surface: p.surface,
          onSurface: p.label,
          onSurfaceVariant: p.secondaryLabel,
          outline: p.border,
          outlineVariant: p.border,
        );
    const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.15,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: _textTheme(p),
      scaffoldBackgroundColor: p.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: p.fill,
      dividerColor: p.border,
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      extensions: [p],
      // iOS-style navigation on both platforms.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.label,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(color: p.label),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.cta,
          foregroundColor: p.onCta,
          disabledBackgroundColor: p.track,
          disabledForegroundColor: p.tertiaryLabel,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.secondaryLabel,
          textStyle: buttonText.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.background,
        showDragHandle: true,
        dragHandleColor: p.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.label,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: p.background,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: const StadiumBorder(),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.label),
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: p.label),
    );
  }

  // Scale taken from the Stitch design.
  static TextTheme _textTheme(AppPalette p) {
    TextStyle style(
      double size,
      FontWeight weight,
      double tracking, {
      double? height,
      Color? color,
    }) => TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: tracking,
      height: height,
      color: color ?? p.label,
    );

    return TextTheme(
      // Big light numerals, e.g. "1.2 GB".
      displayLarge: style(48, FontWeight.w300, -1.2, height: 1),
      displayMedium: style(40, FontWeight.w300, -1, height: 1.1),
      headlineLarge: style(24, FontWeight.w700, -0.6, height: 1.33),
      headlineMedium: style(26, FontWeight.w600, -0.65, height: 1.23),
      headlineSmall: style(22, FontWeight.w600, -0.5, height: 1.27),
      titleLarge: style(20, FontWeight.w600, -0.4, height: 1.3),
      titleMedium: style(17, FontWeight.w600, -0.26, height: 1.25),
      titleSmall: style(14, FontWeight.w600, -0.2, height: 1.5),
      bodyLarge: style(15, FontWeight.w400, -0.15, height: 1.45),
      bodyMedium: style(14, FontWeight.w500, -0.1, height: 1.43),
      bodySmall: style(
        12,
        FontWeight.w400,
        0,
        height: 1.33,
        color: p.secondaryLabel,
      ),
      labelLarge: style(15, FontWeight.w600, -0.15),
      labelMedium: style(
        12,
        FontWeight.w500,
        0,
        height: 1.33,
        color: p.secondaryLabel,
      ),
      // Section headers: uppercase, tracked.
      labelSmall: style(
        12,
        FontWeight.w600,
        0.6,
        height: 1.33,
        color: p.secondaryLabel,
      ),
    );
  }
}
