import 'package:flutter/material.dart';

// Brand palette; swipe colors stay fixed across themes.
abstract final class AppColors {
  static const primary = Color(0xFF6C5CE7);
  static const primaryDeep = Color(0xFF4B3BC9);
  static const delete = Color(0xFFFF4D5E);
  static const keep = Color(0xFF22C55E);
  static const premium = Color(0xFFF5B700);

  static const lightBackground = Color(0xFFF7F7FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF14141F);
  static const lightMuted = Color(0xFF6B6B80);
  static const lightBorder = Color(0xFFE6E6EF);

  static const darkBackground = Color(0xFF0E0E14);
  static const darkSurface = Color(0xFF1A1A24);
  static const darkText = Color(0xFFF4F4F8);
  static const darkMuted = Color(0xFF9A9AB0);
  static const darkBorder = Color(0xFF2A2A38);
}
