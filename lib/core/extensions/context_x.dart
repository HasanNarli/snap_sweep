import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../utils/format_bytes.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  String get localeTag => Localizations.localeOf(this).toLanguageTag();

  String formatSize(int bytes) => formatBytes(bytes, localeTag);

  void showComingSoon() {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }
}
