import 'package:flutter/material.dart';

// Warm editorial palette from the Stitch design (light) and its dark twin.
abstract final class AppColors {
  static const lightBackground = Color(0xFFF9F8F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFEBE6DF);
  static const lightFill = Color(0xFFF4F1EB);
  static const lightTrack = Color(0xFFEFECE6);
  static const lightLabel = Color(0xFF1A1A1A);
  static const lightSecondaryLabel = Color(0xFF7A756D);
  static const lightTertiaryLabel = Color(0xFF9E9991);
  static const lightAccent = Color(0xFF8A5A36);
  static const lightAccentSoft = Color(0xFFF3EDE5);

  static const darkBackground = Color(0xFF141311);
  static const darkSurface = Color(0xFF1E1C19);
  static const darkBorder = Color(0xFF2E2B27);
  static const darkFill = Color(0xFF2A2723);
  static const darkTrack = Color(0xFF2E2B27);
  static const darkLabel = Color(0xFFF2EFE9);
  static const darkSecondaryLabel = Color(0xFFA39E95);
  static const darkTertiaryLabel = Color(0xFF77726A);
  static const darkAccent = Color(0xFFD9A77E);
  static const darkAccentSoft = Color(0xFF33291F);

  static const delete = Color(0xFFE03838);
  static const keep = Color(0xFF10B981);

  // Theme-independent overlays drawn on top of photos.
  static const onPhoto = Color(0xF2FFFFFF);
  static const onPhotoSecondary = Color(0xCCFFFFFF);
  static const onPhotoTertiary = Color(0x66FFFFFF);
  static const onSolid = Color(0xFFFFFFFF);
  static const photoGlass = Color(0x66000000);
  static const photoGlassBorder = Color(0x26FFFFFF);
  static const photoGlassSubtle = Color(0x4D000000);
  static const photoGlassSubtleBorder = Color(0x99FFFFFF);
  static const photoGlassLight = Color(0xD9FFFFFF);
  static const photoDim = Color(0x26000000);
  static const photoScrimTop = Color(0x40000000);
  static const photoScrimBottom = Color(0x66000000);
  static const photoOutline = Color(0x0F000000);
  static const toast = Color(0xCC000000);
}
