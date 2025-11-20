// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dare U';

  @override
  String get welcomeTo => 'Willkommen bei\nDare U!';

  @override
  String get onboardingDescription =>
      'Verändere dein Leben eine Herausforderung nach der anderen. Erstelle deine erste persönliche Challenge, um deinen Fortschritt zu verfolgen und deine Reise zu dokumentieren.';

  @override
  String get chooseFocus => 'Wähle deinen Fokus';

  @override
  String get createChallenge => 'Challenge erstellen';

  @override
  String get startYourJourney => 'Starte deine Reise';

  @override
  String get challenges => 'Challenges';

  @override
  String get search => 'Suchen';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get noChallengesYet => 'Noch keine Challenges';

  @override
  String get createFirstChallenge =>
      'Erstelle deine erste Challenge, um zu beginnen!';

  @override
  String get personal => 'Persönlich';

  @override
  String get group => 'Gruppe';

  @override
  String get members => 'Mitglieder';

  @override
  String get messages => 'Nachrichten';

  @override
  String member(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mitglieder',
      one: 'Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get createNewChallenge => 'Challenge erstellen';

  @override
  String get chooseThumbnail => 'Vorschaubild wählen';

  @override
  String get changeThumbnail => 'Vorschaubild ändern';

  @override
  String get category => 'Kategorie';

  @override
  String get title => 'Titel';

  @override
  String get description => 'Beschreibung';

  @override
  String get enterGroupName => 'Gruppennamen eingeben';

  @override
  String get enterChallengeName => 'Challenge-Namen eingeben';

  @override
  String get whatIsGroupAbout => 'Worum geht es in dieser Gruppe?';

  @override
  String get whatToAchieve => 'Was möchtest du erreichen?';

  @override
  String get addMembers => 'Hinzufügen';

  @override
  String get noMembersAdded => 'Noch keine Mitglieder hinzugefügt';

  @override
  String get createPersonalChallenge => 'Persönliche Challenge erstellen';

  @override
  String get createGroupChallenge => 'Gruppen-Challenge erstellen';

  @override
  String get pleaseEnterTitle => 'Bitte gib einen Titel ein';

  @override
  String challengeCreated(String name) {
    return 'Challenge \"$name\" erstellt!';
  }

  @override
  String groupChallengeCreated(String name) {
    return 'Gruppen-Challenge \"$name\" erstellt!';
  }

  @override
  String personalChallengeCreated(String name) {
    return 'Persönliche Challenge \"$name\" erstellt!';
  }

  @override
  String get startDocumenting => 'Beginne zu dokumentieren!';

  @override
  String get shareUpdates =>
      'Teile Updates, Bilder und verfolge deinen Fortschritt';

  @override
  String get shareAnUpdate => 'Teile ein Update...';

  @override
  String get addProgress => 'Fortschritt hinzufügen';

  @override
  String get searchUsers => 'Benutzer suchen...';

  @override
  String get noUsersFound => 'Keine Benutzer gefunden';

  @override
  String get tryDifferentSearch => 'Versuche einen anderen Suchbegriff';

  @override
  String get follow => 'Folgen';

  @override
  String get following => 'Folge ich';

  @override
  String get followers => 'Follower';

  @override
  String get goals => 'Ziele';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String continueWith(String provider) {
    return 'Weiter mit $provider';
  }

  @override
  String get orContinueWith => 'Oder weiter mit';

  @override
  String get name => 'Name';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get enterName => 'Gib deinen Namen ein';

  @override
  String get enterEmail => 'Gib deine E-Mail ein';

  @override
  String get enterPassword => 'Gib dein Passwort ein';

  @override
  String get alreadyHaveAccount => 'Hast du bereits ein Konto?';

  @override
  String get dontHaveAccount => 'Hast du noch kein Konto?';

  @override
  String get successfullyLoggedIn => 'Erfolgreich angemeldet!';

  @override
  String get accountCreatedSuccessfully => 'Konto erfolgreich erstellt!';

  @override
  String authenticationFailed(String error) {
    return 'Authentifizierung fehlgeschlagen: $error';
  }

  @override
  String get loggedOutSuccessfully => 'Erfolgreich abgemeldet';

  @override
  String get achievements => 'Erfolge';

  @override
  String get viewAccomplishments => 'Sieh dir deine Erfolge an';

  @override
  String get statistics => 'Statistiken';

  @override
  String get trackProgress => 'Verfolge deinen Fortschritt';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get manageAlerts => 'Verwalte deine Benachrichtigungen';

  @override
  String get appPreferences => 'App-Einstellungen';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get selectTheme => 'Design-Modus wählen';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get submitProgress => 'Fortschritt einreichen';

  @override
  String get addNote => 'Füge eine Notiz über deinen Fortschritt hinzu...';

  @override
  String get attachments => 'Anhänge';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get addVideo => 'Video hinzufügen';

  @override
  String get addFile => 'Datei hinzufügen';

  @override
  String get submit => 'Einreichen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get becomeHealthier => 'Gesünder werden';

  @override
  String get focusOnNutrition => 'Fokus auf Ernährung, Schlaf und Wellness';

  @override
  String get improveSocialSkills => 'Soziale Fähigkeiten verbessern';

  @override
  String get buildConnections =>
      'Verbindungen und Kommunikationsfähigkeiten aufbauen';

  @override
  String get becomeMoreIntelligent => 'Intelligenter werden';

  @override
  String get learnNewThings => 'Lerne neue Dinge und erweitere dein Wissen';

  @override
  String get getPhysicallyFit => 'Körperlich fit werden';

  @override
  String get buildStrength => 'Kraft und Ausdauer aufbauen';

  @override
  String get boostCreativity => 'Kreativität steigern';

  @override
  String get expressYourself =>
      'Drücke dich aus und denke über den Tellerrand hinaus';

  @override
  String get increaseProductivity => 'Produktivität steigern';

  @override
  String get getMoreDone => 'Mehr erledigen und Zeit besser verwalten';

  @override
  String get practiceMindfulness => 'Achtsamkeit praktizieren';

  @override
  String get bePresent => 'Sei präsent und reduziere Stress';

  @override
  String get customGoal => 'Eigenes Ziel';

  @override
  String get defineOwnPath => 'Definiere deinen eigenen Weg zur Verbesserung';
}
