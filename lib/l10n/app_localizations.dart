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

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

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

  /// No description provided for @onboardingSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe to clean'**
  String get onboardingSwipeTitle;

  /// No description provided for @onboardingSwipeBody.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to delete, right to keep. Clean up your gallery in minutes.'**
  String get onboardingSwipeBody;

  /// No description provided for @onboardingReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing gets lost by mistake'**
  String get onboardingReviewTitle;

  /// No description provided for @onboardingReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Review your picks before anything is deleted. Undo any swipe, anytime.'**
  String get onboardingReviewBody;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your photos never leave your phone. No uploads, no servers.'**
  String get onboardingPrivacyBody;

  /// No description provided for @onboardingAllowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow gallery access'**
  String get onboardingAllowAccess;

  /// No description provided for @homeTodaySwipes.
  ///
  /// In en, this message translates to:
  /// **'Today\'s swipes'**
  String get homeTodaySwipes;

  /// No description provided for @homeSwipesLeft.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} left'**
  String homeSwipesLeft(int remaining, int total);

  /// No description provided for @homeStartSwiping.
  ///
  /// In en, this message translates to:
  /// **'Start swiping'**
  String get homeStartSwiping;

  /// No description provided for @homeSpaceFreed.
  ///
  /// In en, this message translates to:
  /// **'Space freed'**
  String get homeSpaceFreed;

  /// No description provided for @homePhotosCleaned.
  ///
  /// In en, this message translates to:
  /// **'Photos cleaned'**
  String get homePhotosCleaned;

  /// No description provided for @homeSmartCleanup.
  ///
  /// In en, this message translates to:
  /// **'Smart cleanup'**
  String get homeSmartCleanup;

  /// No description provided for @categoryScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get categoryScreenshots;

  /// No description provided for @categoryVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get categoryVideos;

  /// No description provided for @categoryScreenRecordings.
  ///
  /// In en, this message translates to:
  /// **'Screen recordings'**
  String get categoryScreenRecordings;

  /// No description provided for @categoryDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get categoryDateRange;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pro;

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

  /// No description provided for @swipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s photos'**
  String get swipeTitle;

  /// No description provided for @swipeFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get swipeFinish;

  /// No description provided for @swipePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your photos will appear here'**
  String get swipePlaceholder;

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

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing marked for deletion'**
  String get reviewEmpty;
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
