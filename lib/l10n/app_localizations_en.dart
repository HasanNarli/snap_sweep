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
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get backToHome => 'Back to home';

  @override
  String get onboardingSwipeTitle => 'Swipe to clean';

  @override
  String get onboardingSwipeBody =>
      'Swipe left to delete, right to keep. Clean up your gallery in minutes.';

  @override
  String get onboardingReviewTitle => 'Nothing gets lost by mistake';

  @override
  String get onboardingReviewBody =>
      'Review your picks before anything is deleted. Undo any swipe, anytime.';

  @override
  String get onboardingPrivacyTitle => 'Private by design';

  @override
  String get onboardingPrivacyBody =>
      'Your photos never leave your phone. No uploads, no servers.';

  @override
  String get onboardingAllowAccess => 'Allow gallery access';

  @override
  String get homeTodaySwipes => 'Today\'s swipes';

  @override
  String homeSwipesLeft(int remaining, int total) {
    return '$remaining of $total left';
  }

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
  String get swipeTitle => 'Today\'s photos';

  @override
  String get swipeFinish => 'Finish';

  @override
  String get swipePlaceholder => 'Your photos will appear here';

  @override
  String get swipeDelete => 'Delete';

  @override
  String get swipeKeep => 'Keep';

  @override
  String get swipeUndo => 'Undo';

  @override
  String get reviewTitle => 'Review';

  @override
  String get reviewEmpty => 'Nothing marked for deletion';
}
