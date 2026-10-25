// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SnapSweep';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get backToHome => 'Back to home';

  @override
  String get retry => 'Try again';

  @override
  String get close => 'Close';

  @override
  String get notNow => 'Not Now';

  @override
  String get privacyFootnote => 'Photos never leave your device';

  @override
  String get onboardingTitle => 'Clear space.\nKeep memories.';

  @override
  String get onboardingSubtitle =>
      'Review forgotten photos with a quick swipe.';

  @override
  String get onboardingTriageTitle => 'Effortless triage';

  @override
  String get onboardingTriageBody => 'Swipe right to keep, left to clear';

  @override
  String get onboardingUndoTitle => 'Nothing lost by mistake';

  @override
  String get onboardingUndoBody => 'Review your picks and undo any swipe';

  @override
  String get onboardingStorageTitle => 'Instant storage recovery';

  @override
  String get onboardingStorageBody =>
      'Watch reclaimed space tally up as you go';

  @override
  String get onboardingAllow => 'Allow Photo Access';

  @override
  String get permissionTitle => 'Allow access to your photos';

  @override
  String get permissionBody =>
      'SnapSweep needs gallery access to show your photos. They never leave your phone.';

  @override
  String get permissionAllow => 'Allow access';

  @override
  String get limitedAccessBody =>
      'SnapSweep can only see the photos you selected.';

  @override
  String get limitedAccessAction => 'Allow all';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeStorageReclaimed => 'Storage reclaimed';

  @override
  String homeThisWeek(String size) {
    return '+$size this week';
  }

  @override
  String get homeCleaned => 'Cleaned';

  @override
  String homeCleanedValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get homeSessions => 'Sessions';

  @override
  String get homeAverageSize => 'Avg. size';

  @override
  String get homeDailySession => 'Daily session';

  @override
  String homeResetsIn(int hours, int minutes) {
    return 'Resets in ${hours}h ${minutes}m';
  }

  @override
  String homeReviewsAvailable(int count) {
    return '$count reviews available today';
  }

  @override
  String get homeStartCleaning => 'Start cleaning';

  @override
  String homeBatchOf(int count) {
    return 'Batch of $count';
  }

  @override
  String get homeGetMore => 'Get more';

  @override
  String get homeSmartCategories => 'Smart categories';

  @override
  String get outOfSwipesTitle => 'That\'s it for today';

  @override
  String outOfSwipesBody(int hours, int minutes) {
    return 'Your free reviews reset in ${hours}h ${minutes}m. Want to keep going?';
  }

  @override
  String outOfSwipesWatchAd(int count) {
    return 'Watch an ad for +$count';
  }

  @override
  String get outOfSwipesGoPro => 'Go unlimited with Pro';

  @override
  String get pro => 'Pro';

  @override
  String get soon => 'Soon';

  @override
  String get proCardTitle => 'Unlimited cleaning';

  @override
  String get proCardBody =>
      'Remove the daily limit and unlock smart categories.';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get categoryScreenshots => 'Screenshots';

  @override
  String get categoryScreenshotsHint => 'Receipts, memes and old chats';

  @override
  String get categoryVideos => 'Large videos';

  @override
  String get categoryVideosHint => 'The biggest space hogs';

  @override
  String get categoryScreenRecordings => 'Screen recordings';

  @override
  String get categoryScreenRecordingsHint => 'Forgotten recordings';

  @override
  String get categoryDateRange => 'Date range';

  @override
  String get categoryDateRangeHint => 'Clean up a month or a trip';

  @override
  String get categoryDuplicates => 'Duplicates & similar';

  @override
  String get categoryDuplicatesHint => 'Twin shots and bursts';

  @override
  String get categoryBlurry => 'Blurry photos';

  @override
  String get categoryBlurryHint => 'Out of focus and motion blur';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsRestore => 'Restore purchases';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsRate => 'Rate SnapSweep';

  @override
  String get settingsContact => 'Contact us';

  @override
  String swipeCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String get swipeSubtitle => 'Today\'s photos';

  @override
  String get swipeFinish => 'Finish';

  @override
  String get swipeDelete => 'Delete';

  @override
  String get swipeKeep => 'Keep';

  @override
  String get swipeUndo => 'Undo';

  @override
  String swipeMarkedToast(String size) {
    return 'Marked • $size';
  }

  @override
  String get swipeNoPhotos => 'No photos found in your gallery';

  @override
  String get swipeLoadError => 'Couldn\'t load your photos';

  @override
  String get swipeDoneTitle => 'All done';

  @override
  String swipeMarkedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos marked for deletion.',
      one: '1 photo marked for deletion.',
      zero: 'You kept every photo.',
    );
    return '$_temp0';
  }

  @override
  String swipeReviewAction(int count) {
    return 'Review $count';
  }

  @override
  String get reviewTitle => 'Review deletions';

  @override
  String get reviewEmpty => 'Nothing marked for deletion';

  @override
  String reviewSelectedOf(int selected, int total) {
    return '$selected of $total selected';
  }

  @override
  String reviewPhotosSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos selected',
      one: '1 photo selected',
    );
    return '$_temp0';
  }

  @override
  String reviewMarkedSize(String size) {
    return '$size marked to purge';
  }

  @override
  String get reviewSelectAll => 'Select all';

  @override
  String get reviewDeselectAll => 'Deselect all';

  @override
  String get reviewKept => 'Kept';

  @override
  String get reviewTrashNotePrefix => 'Photos go to your gallery\'s ';

  @override
  String get reviewTrashNoteBold => 'Recently Deleted';

  @override
  String get reviewTrashNoteSuffix =>
      '. You usually have 30 days to recover them.';

  @override
  String get reviewHint => 'Tap any photo to deselect or protect it';

  @override
  String reviewDeleteAction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count photos',
      one: 'Delete 1 photo',
    );
    return '$_temp0';
  }

  @override
  String get reviewKeepAll => 'Keep all';

  @override
  String get reviewNothingSelected => 'Nothing selected';

  @override
  String get reviewDeleteCancelled => 'Nothing was deleted.';

  @override
  String get reviewDeleteFailed =>
      'Couldn\'t delete the photos. Please try again.';

  @override
  String get resultTitle => 'Nice and clean';

  @override
  String get resultFreed => 'of space freed';

  @override
  String resultDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos deleted',
      one: '1 photo deleted',
    );
    return '$_temp0';
  }

  @override
  String get resultRestoreHint =>
      'Changed your mind? Deleted photos can usually be restored from your gallery\'s trash for 30 days.';

  @override
  String categorySummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 • $size';
  }

  @override
  String categoryLargeVideosSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos',
      one: '1 video',
    );
    return '$_temp0 over 50 MB • $size';
  }

  @override
  String get swipeCategoryEmpty => 'Nothing to clean here';

  @override
  String get paywallTitle => 'SnapSweep Pro';

  @override
  String get paywallSubtitle =>
      'Clean as much as you like. Everything still stays on your phone.';

  @override
  String get paywallUnlimited => 'Unlimited cleaning';

  @override
  String get paywallUnlimitedHint => 'No daily limit';

  @override
  String get paywallCategories => 'Smart categories';

  @override
  String get paywallCategoriesHint => 'Screenshots, videos, recordings, dates';

  @override
  String get paywallNoAds => 'No ads';

  @override
  String get paywallNoAdsHint => 'You\'ll never be asked to watch one';

  @override
  String get planYearly => 'Yearly';

  @override
  String get planYearlyHint => 'Billed once a year';

  @override
  String planPerMonth(String price) {
    return '$price per month, billed yearly';
  }

  @override
  String get planLifetime => 'Lifetime';

  @override
  String get planLifetimeHint => 'Pay once, keep it forever';

  @override
  String get paywallContinue => 'Continue';

  @override
  String get paywallRenewNote =>
      'Renews every year until you cancel in your store account settings.';

  @override
  String get paywallLifetimeNote => 'A one-time purchase. No subscription.';

  @override
  String get paywallUnavailable => 'Purchases aren\'t available right now.';

  @override
  String get purchaseWelcome => 'Welcome to Pro';

  @override
  String get purchaseFailed =>
      'The purchase didn\'t go through. Please try again.';

  @override
  String get restoreNone => 'No earlier purchase was found.';

  @override
  String get restoreDone => 'Your purchase is restored';

  @override
  String get homeUnlimited => 'Unlimited reviews with Pro';
}
