import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Dare U'**
  String get appTitle;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nDare U!'**
  String get welcomeTo;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Transform your life one challenge at a time. Create your first personal challenge to track your progress and document your journey.'**
  String get onboardingDescription;

  /// No description provided for @chooseFocus.
  ///
  /// In en, this message translates to:
  /// **'Choose your focus'**
  String get chooseFocus;

  /// No description provided for @createChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Challenge'**
  String get createChallenge;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startYourJourney;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @noChallengesYet.
  ///
  /// In en, this message translates to:
  /// **'No challenges yet'**
  String get noChallengesYet;

  /// No description provided for @createFirstChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create your first challenge to start your journey!'**
  String get createFirstChallenge;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get messages;

  /// Member count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{member} other{members}}'**
  String member(int count);

  /// No description provided for @createNewChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Challenge'**
  String get createNewChallenge;

  /// No description provided for @chooseThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Choose Thumbnail'**
  String get chooseThumbnail;

  /// No description provided for @changeThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Change Thumbnail'**
  String get changeThumbnail;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// No description provided for @enterChallengeName.
  ///
  /// In en, this message translates to:
  /// **'Enter challenge name'**
  String get enterChallengeName;

  /// No description provided for @whatIsGroupAbout.
  ///
  /// In en, this message translates to:
  /// **'What is this group about?'**
  String get whatIsGroupAbout;

  /// No description provided for @whatToAchieve.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get whatToAchieve;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addMembers;

  /// No description provided for @noMembersAdded.
  ///
  /// In en, this message translates to:
  /// **'No members added yet'**
  String get noMembersAdded;

  /// No description provided for @createPersonalChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Personal Challenge'**
  String get createPersonalChallenge;

  /// No description provided for @createGroupChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Group Challenge'**
  String get createGroupChallenge;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// Challenge creation success message
  ///
  /// In en, this message translates to:
  /// **'Challenge \"{name}\" created!'**
  String challengeCreated(String name);

  /// Group challenge creation success message
  ///
  /// In en, this message translates to:
  /// **'Group challenge \"{name}\" created!'**
  String groupChallengeCreated(String name);

  /// Personal challenge creation success message
  ///
  /// In en, this message translates to:
  /// **'Personal challenge \"{name}\" created!'**
  String personalChallengeCreated(String name);

  /// No description provided for @startDocumenting.
  ///
  /// In en, this message translates to:
  /// **'Start documenting!'**
  String get startDocumenting;

  /// No description provided for @shareUpdates.
  ///
  /// In en, this message translates to:
  /// **'Share updates, images, and track your progress'**
  String get shareUpdates;

  /// No description provided for @shareAnUpdate.
  ///
  /// In en, this message translates to:
  /// **'Share an update...'**
  String get shareAnUpdate;

  /// No description provided for @addProgress.
  ///
  /// In en, this message translates to:
  /// **'Add Progress'**
  String get addProgress;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Social login button text
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWith(String provider);

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @successfullyLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Successfully logged in!'**
  String get successfullyLoggedIn;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// Authentication error message
  ///
  /// In en, this message translates to:
  /// **'Authentication failed: {error}'**
  String authenticationFailed(String error);

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @viewAccomplishments.
  ///
  /// In en, this message translates to:
  /// **'View your accomplishments'**
  String get viewAccomplishments;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @trackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get trackProgress;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts'**
  String get manageAlerts;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get appPreferences;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select theme mode'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @submitProgress.
  ///
  /// In en, this message translates to:
  /// **'Submit Progress'**
  String get submitProgress;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note about your progress...'**
  String get addNote;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get addFile;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @becomeHealthier.
  ///
  /// In en, this message translates to:
  /// **'Become Healthier'**
  String get becomeHealthier;

  /// No description provided for @focusOnNutrition.
  ///
  /// In en, this message translates to:
  /// **'Focus on nutrition, sleep, and wellness'**
  String get focusOnNutrition;

  /// No description provided for @improveSocialSkills.
  ///
  /// In en, this message translates to:
  /// **'Improve Social Skills'**
  String get improveSocialSkills;

  /// No description provided for @buildConnections.
  ///
  /// In en, this message translates to:
  /// **'Build connections and communication skills'**
  String get buildConnections;

  /// No description provided for @becomeMoreIntelligent.
  ///
  /// In en, this message translates to:
  /// **'Become More Intelligent'**
  String get becomeMoreIntelligent;

  /// No description provided for @learnNewThings.
  ///
  /// In en, this message translates to:
  /// **'Learn new things and expand knowledge'**
  String get learnNewThings;

  /// No description provided for @getPhysicallyFit.
  ///
  /// In en, this message translates to:
  /// **'Get Physically Fit'**
  String get getPhysicallyFit;

  /// No description provided for @buildStrength.
  ///
  /// In en, this message translates to:
  /// **'Build strength and endurance'**
  String get buildStrength;

  /// No description provided for @boostCreativity.
  ///
  /// In en, this message translates to:
  /// **'Boost Creativity'**
  String get boostCreativity;

  /// No description provided for @expressYourself.
  ///
  /// In en, this message translates to:
  /// **'Express yourself and think outside the box'**
  String get expressYourself;

  /// No description provided for @increaseProductivity.
  ///
  /// In en, this message translates to:
  /// **'Increase Productivity'**
  String get increaseProductivity;

  /// No description provided for @getMoreDone.
  ///
  /// In en, this message translates to:
  /// **'Get more done and manage time better'**
  String get getMoreDone;

  /// No description provided for @practiceMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Practice Mindfulness'**
  String get practiceMindfulness;

  /// No description provided for @bePresent.
  ///
  /// In en, this message translates to:
  /// **'Be present and reduce stress'**
  String get bePresent;

  /// No description provided for @customGoal.
  ///
  /// In en, this message translates to:
  /// **'Custom Goal'**
  String get customGoal;

  /// No description provided for @defineOwnPath.
  ///
  /// In en, this message translates to:
  /// **'Define your own path to improvement'**
  String get defineOwnPath;
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
