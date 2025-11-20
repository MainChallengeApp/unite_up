// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dare U';

  @override
  String get welcomeTo => 'Welcome to\nDare U!';

  @override
  String get onboardingDescription =>
      'Transform your life one challenge at a time. Create your first personal challenge to track your progress and document your journey.';

  @override
  String get chooseFocus => 'Choose your focus';

  @override
  String get createChallenge => 'Create Challenge';

  @override
  String get startYourJourney => 'Start Your Journey';

  @override
  String get challenges => 'Challenges';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get noChallengesYet => 'No challenges yet';

  @override
  String get createFirstChallenge =>
      'Create your first challenge to start your journey!';

  @override
  String get personal => 'Personal';

  @override
  String get group => 'Group';

  @override
  String get members => 'Members';

  @override
  String get messages => 'messages';

  @override
  String member(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'members',
      one: 'member',
    );
    return '$_temp0';
  }

  @override
  String get createNewChallenge => 'Create Challenge';

  @override
  String get chooseThumbnail => 'Choose Thumbnail';

  @override
  String get changeThumbnail => 'Change Thumbnail';

  @override
  String get category => 'Category';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get enterGroupName => 'Enter group name';

  @override
  String get enterChallengeName => 'Enter challenge name';

  @override
  String get whatIsGroupAbout => 'What is this group about?';

  @override
  String get whatToAchieve => 'What do you want to achieve?';

  @override
  String get addMembers => 'Add';

  @override
  String get noMembersAdded => 'No members added yet';

  @override
  String get createPersonalChallenge => 'Create Personal Challenge';

  @override
  String get createGroupChallenge => 'Create Group Challenge';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String challengeCreated(String name) {
    return 'Challenge \"$name\" created!';
  }

  @override
  String groupChallengeCreated(String name) {
    return 'Group challenge \"$name\" created!';
  }

  @override
  String personalChallengeCreated(String name) {
    return 'Personal challenge \"$name\" created!';
  }

  @override
  String get startDocumenting => 'Start documenting!';

  @override
  String get shareUpdates => 'Share updates, images, and track your progress';

  @override
  String get shareAnUpdate => 'Share an update...';

  @override
  String get addProgress => 'Add Progress';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get goals => 'Goals';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String continueWith(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get successfullyLoggedIn => 'Successfully logged in!';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String authenticationFailed(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get achievements => 'Achievements';

  @override
  String get viewAccomplishments => 'View your accomplishments';

  @override
  String get statistics => 'Statistics';

  @override
  String get trackProgress => 'Track your progress';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageAlerts => 'Manage your alerts';

  @override
  String get appPreferences => 'App preferences';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get selectTheme => 'Select theme mode';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get submitProgress => 'Submit Progress';

  @override
  String get addNote => 'Add a note about your progress...';

  @override
  String get attachments => 'Attachments';

  @override
  String get addImage => 'Add Image';

  @override
  String get addVideo => 'Add Video';

  @override
  String get addFile => 'Add File';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get becomeHealthier => 'Become Healthier';

  @override
  String get focusOnNutrition => 'Focus on nutrition, sleep, and wellness';

  @override
  String get improveSocialSkills => 'Improve Social Skills';

  @override
  String get buildConnections => 'Build connections and communication skills';

  @override
  String get becomeMoreIntelligent => 'Become More Intelligent';

  @override
  String get learnNewThings => 'Learn new things and expand knowledge';

  @override
  String get getPhysicallyFit => 'Get Physically Fit';

  @override
  String get buildStrength => 'Build strength and endurance';

  @override
  String get boostCreativity => 'Boost Creativity';

  @override
  String get expressYourself => 'Express yourself and think outside the box';

  @override
  String get increaseProductivity => 'Increase Productivity';

  @override
  String get getMoreDone => 'Get more done and manage time better';

  @override
  String get practiceMindfulness => 'Practice Mindfulness';

  @override
  String get bePresent => 'Be present and reduce stress';

  @override
  String get customGoal => 'Custom Goal';

  @override
  String get defineOwnPath => 'Define your own path to improvement';
}
