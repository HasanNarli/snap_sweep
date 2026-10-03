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
          primary: p.accent,
          onPrimary: Colors.white,
          error: p.delete,
          surface: p.surface,
          onSurface: p.label,
          onSurfaceVariant: p.secondaryLabel,
          outline: p.separator,
          outlineVariant: p.separator,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: _textTheme(p),
      scaffoldBackgroundColor: p.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: p.fill.withValues(alpha: 0.5),
      dividerColor: p.separator,
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
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: p.label,
          letterSpacing: -0.4,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: p.fill,
          disabledForegroundColor: p.secondaryLabel,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accent,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.4,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.background,
        showDragHandle: true,
        dragHandleColor: p.separator,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.label,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: p.background,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        shape: const StadiumBorder(),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: p.accent),
    );
  }

  // Apple-like scale: tight tracking on large sizes, relaxed on body.
  static TextTheme _textTheme(AppPalette p) {
    TextStyle style(double size, FontWeight weight, double tracking) =>
        TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: tracking,
          color: p.label,
          height: 1.2,
        );

    return TextTheme(
      displayLarge: style(56, FontWeight.w700, -1.6),
      displayMedium: style(44, FontWeight.w700, -1.2),
      headlineLarge: style(34, FontWeight.w700, -0.8),
      headlineMedium: style(28, FontWeight.w700, -0.6),
      headlineSmall: style(24, FontWeight.w600, -0.5),
      titleLarge: style(20, FontWeight.w600, -0.4),
      titleMedium: style(17, FontWeight.w600, -0.4),
      titleSmall: style(15, FontWeight.w600, -0.2),
      bodyLarge: style(17, FontWeight.w400, -0.4),
      bodyMedium: style(15, FontWeight.w400, -0.2),
      bodySmall: style(
        13,
        FontWeight.w400,
        -0.1,
      ).copyWith(color: p.secondaryLabel),
      labelLarge: style(17, FontWeight.w600, -0.4),
      labelMedium: style(13, FontWeight.w600, 0),
      labelSmall: style(
        11,
        FontWeight.w600,
        0.6,
      ).copyWith(color: p.secondaryLabel),
    );
  }
}
