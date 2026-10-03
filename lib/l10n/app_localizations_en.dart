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
  String get continueAction => 'Continue';

  @override
  String get welcomeTitle => 'Welcome to SnapSweep';

  @override
  String get onboardingSwipeTitle => 'Swipe to clean';

  @override
  String get onboardingSwipeBody =>
      'Left to delete, right to keep. Your gallery, sorted in minutes.';

  @override
  String get onboardingReviewTitle => 'Nothing lost by mistake';

  @override
  String get onboardingReviewBody =>
      'Review your picks before anything is deleted, and undo any swipe.';

  @override
  String get onboardingPrivacyTitle => 'Private by design';

  @override
  String get onboardingPrivacyBody =>
      'Your photos never leave your phone. No uploads, no servers.';

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
  String get homeSwipesLeftToday => 'left today';

  @override
  String get homeStartSwiping => 'Start swiping';

  @override
  String get homeSpaceFreed => 'Space freed';

  @override
  String get homePhotosCleaned => 'Photos cleaned';

  @override
  String get homeSmartCleanup => 'Smart cleanup';

  @override
  String get categoryScreenshots => 'Screenshots';

  @override
  String get categoryVideos => 'Videos';

  @override
  String get categoryScreenRecordings => 'Screen recordings';

  @override
  String get categoryDateRange => 'Date range';

  @override
  String get pro => 'PRO';

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
  String get swipeFinish => 'Finish';

  @override
  String get swipeDelete => 'Delete';

  @override
  String get swipeKeep => 'Keep';

  @override
  String get swipeUndo => 'Undo';

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
  String get reviewTitle => 'Review';

  @override
  String get reviewEmpty => 'Nothing marked for deletion';

  @override
  String reviewSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get reviewHint => 'Tap a photo to keep it.';

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
}
