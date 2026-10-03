import 'package:flutter/material.dart';

// Calm, Apple-inspired palette. One accent; red/green only for decisions.
abstract final class AppColors {
  static const accentLight = Color(0xFF2F6BFF);
  static const accentDark = Color(0xFF4C82FF);

  static const deleteLight = Color(0xFFFF3B30);
  static const deleteDark = Color(0xFFFF453A);
  static const keepLight = Color(0xFF34C759);
  static const keepDark = Color(0xFF30D158);
  static const premiumLight = Color(0xFFFF9500);
  static const premiumDark = Color(0xFFFF9F0A);

  static const lightBackground = Color(0xFFF2F2F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightFill = Color(0xFFE9E9EE);
  static const lightLabel = Color(0xFF1D1D1F);
  static const lightSecondaryLabel = Color(0xFF6E6E73);
  static const lightSeparator = Color(0xFFE5E5EA);

  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkFill = Color(0xFF2C2C2E);
  static const darkLabel = Color(0xFFF5F5F7);
  static const darkSecondaryLabel = Color(0xFF98989D);
  static const darkSeparator = Color(0xFF38383A);

  // Category icon tiles, iOS Settings style.
  static const tileBlue = Color(0xFF0A84FF);
  static const tileOrange = Color(0xFFFF9F0A);
  static const tileRed = Color(0xFFFF375F);
  static const tilePurple = Color(0xFFBF5AF2);
}
