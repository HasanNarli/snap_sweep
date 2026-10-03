import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SnapSweep'**
  String get appTitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @privacyFootnote.
  ///
  /// In en, this message translates to:
  /// **'Photos never leave your device'**
  String get privacyFootnote;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear space.\nKeep memories.'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review forgotten photos with a quick swipe.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingTriageTitle.
  ///
  /// In en, this message translates to:
  /// **'Effortless triage'**
  String get onboardingTriageTitle;

  /// No description provided for @onboardingTriageBody.
  ///
  /// In en, this message translates to:
  /// **'Swipe right to keep, left to clear'**
  String get onboardingTriageBody;

  /// No description provided for @onboardingUndoTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing lost by mistake'**
  String get onboardingUndoTitle;

  /// No description provided for @onboardingUndoBody.
  ///
  /// In en, this message translates to:
  /// **'Review your picks and undo any swipe'**
  String get onboardingUndoBody;

  /// No description provided for @onboardingStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant storage recovery'**
  String get onboardingStorageTitle;

  /// No description provided for @onboardingStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Watch reclaimed space tally up as you go'**
  String get onboardingStorageBody;

  /// No description provided for @onboardingAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow Photo Access'**
  String get onboardingAllow;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your photos'**
  String get permissionTitle;

  /// No description provided for @permissionBody.
  ///
  /// In en, this message translates to:
  /// **'SnapSweep needs gallery access to show your photos. They never leave your phone.'**
  String get permissionBody;

  /// No description provided for @permissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get permissionAllow;

  /// No description provided for @limitedAccessBody.
  ///
  /// In en, this message translates to:
  /// **'SnapSweep can only see the photos you selected.'**
  String get limitedAccessBody;

  /// No description provided for @limitedAccessAction.
  ///
  /// In en, this message translates to:
  /// **'Allow all'**
  String get limitedAccessAction;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeStorageReclaimed.
  ///
  /// In en, this message translates to:
  /// **'Storage reclaimed'**
  String get homeStorageReclaimed;

  /// No description provided for @homeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'+{size} this week'**
  String homeThisWeek(String size);

  /// No description provided for @homeCleaned.
  ///
  /// In en, this message translates to:
  /// **'Cleaned'**
  String get homeCleaned;

  /// No description provided for @homeCleanedValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String homeCleanedValue(int count);

  /// No description provided for @homeSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get homeSessions;

  /// No description provided for @homeAverageSize.
  ///
  /// In en, this message translates to:
  /// **'Avg. size'**
  String get homeAverageSize;

  /// No description provided for @homeDailySession.
  ///
  /// In en, this message translates to:
  /// **'Daily session'**
  String get homeDailySession;

  /// No description provided for @homeResetsIn.
  ///
  /// In en, this message translates to:
  /// **'Resets in {hours}h {minutes}m'**
  String homeResetsIn(int hours, int minutes);

  /// No description provided for @homeReviewsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews available today'**
  String homeReviewsAvailable(int count);

  /// No description provided for @homeStartCleaning.
  ///
  /// In en, this message translates to:
  /// **'Start cleaning'**
  String get homeStartCleaning;

  /// No description provided for @homeBatchOf.
  ///
  /// In en, this message translates to:
  /// **'Batch of {count}'**
  String homeBatchOf(int count);

  /// No description provided for @homeGetMore.
  ///
  /// In en, this message translates to:
  /// **'Get more'**
  String get homeGetMore;

  /// No description provided for @homeSmartCategories.
  ///
  /// In en, this message translates to:
  /// **'Smart categories'**
  String get homeSmartCategories;

  /// No description provided for @outOfSwipesTitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s it for today'**
  String get outOfSwipesTitle;

  /// No description provided for @outOfSwipesBody.
  ///
  /// In en, this message translates to:
  /// **'Your free reviews reset in {hours}h {minutes}m. Want to keep going?'**
  String outOfSwipesBody(int hours, int minutes);

  /// No description provided for @outOfSwipesWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad for +{count}'**
  String outOfSwipesWatchAd(int count);

  /// No description provided for @outOfSwipesGoPro.
  ///
  /// In en, this message translates to:
  /// **'Go unlimited with Pro'**
  String get outOfSwipesGoPro;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @proCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited cleaning'**
  String get proCardTitle;

  /// No description provided for @proCardBody.
  ///
  /// In en, this message translates to:
  /// **'Remove the daily limit and unlock smart categories.'**
  String get proCardBody;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @categoryScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get categoryScreenshots;

  /// No description provided for @categoryScreenshotsHint.
  ///
  /// In en, this message translates to:
  /// **'Receipts, memes and old chats'**
  String get categoryScreenshotsHint;

  /// No description provided for @categoryVideos.
  ///
  /// In en, this message translates to:
  /// **'Large videos'**
  String get categoryVideos;

  /// No description provided for @categoryVideosHint.
  ///
  /// In en, this message translates to:
  /// **'The biggest space hogs'**
  String get categoryVideosHint;

  /// No description provided for @categoryScreenRecordings.
  ///
  /// In en, this message translates to:
  /// **'Screen recordings'**
  String get categoryScreenRecordings;

  /// No description provided for @categoryScreenRecordingsHint.
  ///
  /// In en, this message translates to:
  /// **'Forgotten recordings'**
  String get categoryScreenRecordingsHint;

  /// No description provided for @categoryDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get categoryDateRange;

  /// No description provided for @categoryDateRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Clean up a month or a trip'**
  String get categoryDateRangeHint;

  /// No description provided for @categoryDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates & similar'**
  String get categoryDuplicates;

  /// No description provided for @categoryDuplicatesHint.
  ///
  /// In en, this message translates to:
  /// **'Twin shots and bursts'**
  String get categoryDuplicatesHint;

  /// No description provided for @categoryBlurry.
  ///
  /// In en, this message translates to:
  /// **'Blurry photos'**
  String get categoryBlurry;

  /// No description provided for @categoryBlurryHint.
  ///
  /// In en, this message translates to:
  /// **'Out of focus and motion blur'**
  String get categoryBlurryHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestore;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsRate.
  ///
  /// In en, this message translates to:
  /// **'Rate SnapSweep'**
  String get settingsRate;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContact;

  /// No description provided for @swipeCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String swipeCounter(int current, int total);

  /// No description provided for @swipeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s photos'**
  String get swipeSubtitle;

  /// No description provided for @swipeFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get swipeFinish;

  /// No description provided for @swipeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swipeDelete;

  /// No description provided for @swipeKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get swipeKeep;

  /// No description provided for @swipeUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get swipeUndo;

  /// No description provided for @swipeMarkedToast.
  ///
  /// In en, this message translates to:
  /// **'Marked • {size}'**
  String swipeMarkedToast(String size);

  /// No description provided for @swipeNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos found in your gallery'**
  String get swipeNoPhotos;

  /// No description provided for @swipeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your photos'**
  String get swipeLoadError;

  /// No description provided for @swipeDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get swipeDoneTitle;

  /// No description provided for @swipeMarkedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{You kept every photo.} =1{1 photo marked for deletion.} other{{count} photos marked for deletion.}}'**
  String swipeMarkedCount(int count);

  /// No description provided for @swipeReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Review {count}'**
  String swipeReviewAction(int count);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review deletions'**
  String get reviewTitle;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing marked for deletion'**
  String get reviewEmpty;

  /// No description provided for @reviewSelectedOf.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} selected'**
  String reviewSelectedOf(int selected, int total);

  /// No description provided for @reviewPhotosSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo selected} other{{count} photos selected}}'**
  String reviewPhotosSelected(int count);

  /// No description provided for @reviewMarkedSize.
  ///
  /// In en, this message translates to:
  /// **'{size} marked to purge'**
  String reviewMarkedSize(String size);

  /// No description provided for @reviewSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get reviewSelectAll;

  /// No description provided for @reviewDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get reviewDeselectAll;

  /// No description provided for @reviewKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get reviewKept;

  /// No description provided for @reviewTrashNotePrefix.
  ///
  /// In en, this message translates to:
  /// **'Photos go to your gallery\'s '**
  String get reviewTrashNotePrefix;

  /// No description provided for @reviewTrashNoteBold.
  ///
  /// In en, this message translates to:
  /// **'Recently Deleted'**
  String get reviewTrashNoteBold;

  /// No description provided for @reviewTrashNoteSuffix.
  ///
  /// In en, this message translates to:
  /// **'. You usually have 30 days to recover them.'**
  String get reviewTrashNoteSuffix;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Tap any photo to deselect or protect it'**
  String get reviewHint;

  /// No description provided for @reviewDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 photo} other{Delete {count} photos}}'**
  String reviewDeleteAction(int count);

  /// No description provided for @reviewKeepAll.
  ///
  /// In en, this message translates to:
  /// **'Keep all'**
  String get reviewKeepAll;

  /// No description provided for @reviewNothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Nothing selected'**
  String get reviewNothingSelected;

  /// No description provided for @reviewDeleteCancelled.
  ///
  /// In en, this message translates to:
  /// **'Nothing was deleted.'**
  String get reviewDeleteCancelled;

  /// No description provided for @reviewDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the photos. Please try again.'**
  String get reviewDeleteFailed;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice and clean'**
  String get resultTitle;

  /// No description provided for @resultFreed.
  ///
  /// In en, this message translates to:
  /// **'of space freed'**
  String get resultFreed;

  /// No description provided for @resultDeletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo deleted} other{{count} photos deleted}}'**
  String resultDeletedCount(int count);

  /// No description provided for @resultRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Changed your mind? Deleted photos can usually be restored from your gallery\'s trash for 30 days.'**
  String get resultRestoreHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
