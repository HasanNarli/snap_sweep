import '../../l10n/app_localizations.dart';
import 'media_filter.dart';

extension MediaCategoryLabels on MediaCategory {
  String title(AppLocalizations l10n) => switch (this) {
    MediaCategory.screenshots => l10n.categoryScreenshots,
    MediaCategory.largeVideos => l10n.categoryVideos,
    MediaCategory.screenRecordings => l10n.categoryScreenRecordings,
    MediaCategory.dateRange => l10n.categoryDateRange,
  };

  String hint(AppLocalizations l10n) => switch (this) {
    MediaCategory.screenshots => l10n.categoryScreenshotsHint,
    MediaCategory.largeVideos => l10n.categoryVideosHint,
    MediaCategory.screenRecordings => l10n.categoryScreenRecordingsHint,
    MediaCategory.dateRange => l10n.categoryDateRangeHint,
  };
}
