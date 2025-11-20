// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _de = {
  "app": {
    "title": "Dare U"
  },
  "common": {
    "cancel": "Abbrechen",
    "done": "Fertig",
    "add": "Hinzufügen",
    "submit": "Absenden",
    "create": "Erstellen",
    "delete": "Löschen",
    "edit": "Bearbeiten",
    "save": "Speichern",
    "search": "Suchen",
    "yes": "Ja",
    "no": "Nein"
  },
  "auth": {
    "signIn": "Anmelden",
    "signOut": "Abmelden",
    "createAccount": "Konto erstellen",
    "alreadyHaveAccount": "Hast du bereits ein Konto?",
    "dontHaveAccount": "Hast du noch kein Konto?",
    "loginWithGoogle": "Mit Google fortfahren",
    "loginWithApple": "Mit Apple fortfahren",
    "loggedOutSuccessfully": "Erfolgreich abgemeldet",
    "accountCreatedSuccessfully": "Konto erfolgreich erstellt!",
    "authenticationFailed": "Authentifizierung fehlgeschlagen. Bitte versuche es erneut.",
    "fields": {
      "fullName": "Vollständiger Name",
      "enterFullName": "Gib deinen vollständigen Namen ein",
      "email": "E-Mail",
      "enterEmail": "Gib deine E-Mail ein",
      "password": "Passwort",
      "enterPassword": "Gib dein Passwort ein"
    }
  },
  "navigation": {
    "search": "Suchen",
    "challenges": "Challenges",
    "profile": "Profil"
  },
  "onboarding": {
    "welcomeTo": "Willkommen bei\nDare U!",
    "description": "Verändere dein Leben eine Challenge nach der anderen. Erstelle deine erste persönliche Challenge, um deinen Fortschritt zu verfolgen und deine Reise zu dokumentieren.",
    "chooseFocus": "Wähle deinen Fokus",
    "startJourney": "Challenge erstellen"
  },
  "goals": {
    "categories": {
      "health": {
        "name": "Gesünder werden",
        "description": "Fokus auf Ernährung, Schlaf und Wohlbefinden"
      },
      "social": {
        "name": "Soziale Fähigkeiten verbessern",
        "description": "Baue Verbindungen und Kommunikationsfähigkeiten auf"
      },
      "intelligence": {
        "name": "Intelligenter werden",
        "description": "Lerne neue Dinge und erweitere dein Wissen"
      },
      "fitness": {
        "name": "Körperlich fit werden",
        "description": "Baue Kraft und Ausdauer auf"
      },
      "creativity": {
        "name": "Kreativität steigern",
        "description": "Drücke dich aus und denke über den Tellerrand hinaus"
      },
      "productivity": {
        "name": "Produktivität steigern",
        "description": "Erledige mehr und manage deine Zeit besser"
      },
      "mindfulness": {
        "name": "Achtsamkeit praktizieren",
        "description": "Sei präsent und reduziere Stress"
      },
      "custom": {
        "name": "Eigenes Ziel",
        "description": "Definiere deinen eigenen Weg zur Verbesserung"
      }
    },
    "describeCustomGoal": "Beschreibe dein eigenes Ziel..."
  },
  "challenges": {
    "title": "Challenges",
    "noChallengesYet": "Noch keine Challenges",
    "createFirstChallenge": "Erstelle deine erste Challenge, um deine Reise zu beginnen!",
    "createChallenge": "Challenge erstellen",
    "createNewChallenge": "Neue Challenge erstellen",
    "createGroup": "Gruppen erstellen",
    "personal": "Persönlich",
    "group": "Gruppe",
    "member": "{count, plural, =1{1 Mitglied} other{{count} Mitglieder}}",
    "messages": "Nachrichten",
    "groupCreated": "Gruppe \"{name}\" erstellt!",
    "create": {
      "title": "Challenge erstellen",
      "chooseThumbnail": "Vorschaubild wählen",
      "changeThumbnail": "Vorschaubild ändern",
      "category": "Kategorie",
      "categoryLabel": "Zielkategorie",
      "selectCategory": "Wähle eine Kategorie für deine Challenge",
      "titleLabel": "Titel",
      "enterGroupName": "Gruppennamen eingeben",
      "enterChallengeName": "Challenge-Namen eingeben",
      "descriptionLabel": "Beschreibung",
      "whatIsGroupAbout": "Worum geht es in dieser Gruppe?",
      "members": "Mitglieder",
      "addMembers": "Mitglieder hinzufügen",
      "noMembersAdded": "Noch keine Mitglieder hinzugefügt",
      "pleaseEnterTitle": "Bitte gib einen Titel ein",
      "pleaseSelectCategory": "Bitte wähle eine Kategorie"
    }
  },
  "chat": {
    "title": "Challenge",
    "startDocumenting": "Beginne zu dokumentieren!",
    "shareUpdates": "Teile Updates, Bilder und verfolge deinen Fortschritt",
    "shareAnUpdate": "Teile ein Update...",
    "addProgress": "Fortschritt hinzufügen",
    "readyToImprove": "Bereit, dich zu verbessern?",
    "journeyWillAppearHere": "Deine Challenge-Reise wird hier erscheinen"
  },
  "progress": {
    "submitProgress": "Fortschritt einreichen",
    "addNote": "Füge eine Notiz über deinen Fortschritt hinzu...",
    "describeWhatYouDid": "Beschreibe, was du getan hast...",
    "attachments": "Anhänge",
    "addProof": "Nachweis hinzufügen (optional)",
    "pleaseAddNoteOrAttach": "Bitte füge eine Notiz hinzu oder hänge eine Datei an",
    "types": {
      "image": "Bild",
      "video": "Video",
      "file": "Datei"
    }
  },
  "search": {
    "title": "Suchen",
    "searchUsers": "Benutzer suchen...",
    "noUsersFound": "Keine Benutzer gefunden",
    "tryDifferentSearch": "Versuche einen anderen Suchbegriff"
  },
  "profile": {
    "title": "Profil",
    "stats": {
      "goals": "Ziele",
      "challenges": "Challenges",
      "followers": "Follower"
    },
    "menu": {
      "achievements": "Erfolge",
      "viewAccomplishments": "Sieh dir deine Erfolge an",
      "statistics": "Statistiken",
      "trackProgress": "Verfolge deinen Fortschritt",
      "notifications": "Benachrichtigungen",
      "manageAlerts": "Verwalte deine Benachrichtigungen",
      "settings": "Einstellungen",
      "appPreferences": "App-Einstellungen"
    }
  },
  "settings": {
    "title": "Einstellungen",
    "appearance": "Aussehen",
    "selectTheme": "Wähle den Theme-Modus",
    "theme": {
      "light": {
        "name": "Heller Modus",
        "description": "Helle und klare Oberfläche"
      },
      "dark": {
        "name": "Dunkler Modus",
        "description": "Angenehm für die Augen bei Nacht"
      },
      "system": {
        "name": "Systemstandard",
        "description": "Folgt den Geräteeinstellungen"
      }
    },
    "language": "Sprache",
    "selectLanguage": "Sprache auswählen",
    "languages": {
      "english": {
        "name": "Englisch",
        "subtitle": "English language"
      },
      "german": {
        "name": "Deutsch",
        "subtitle": "Deutsche Sprache"
      }
    },
    "about": "Über",
    "version": "Version",
    "builtWith": "Erstellt mit",
    "flutterMaterial": "Flutter & Material Design 3"
  },
  "empty": {
    "noData": "Keine Daten verfügbar"
  }
};
static const Map<String,dynamic> _en = {
  "app": {
    "title": "Dare U"
  },
  "common": {
    "cancel": "Cancel",
    "done": "Done",
    "add": "Add",
    "submit": "Submit",
    "create": "Create",
    "delete": "Delete",
    "edit": "Edit",
    "save": "Save",
    "search": "Search",
    "yes": "Yes",
    "no": "No"
  },
  "auth": {
    "signIn": "Sign In",
    "signOut": "Sign Out",
    "createAccount": "Create Account",
    "alreadyHaveAccount": "Already have an account?",
    "dontHaveAccount": "Don't have an account yet?",
    "loginWithGoogle": "Continue with Google",
    "loginWithApple": "Continue with Apple",
    "loggedOutSuccessfully": "Logged out successfully",
    "accountCreatedSuccessfully": "Account created successfully!",
    "authenticationFailed": "Authentication failed. Please try again.",
    "fields": {
      "fullName": "Full Name",
      "enterFullName": "Enter your full name",
      "email": "Email",
      "enterEmail": "Enter your email",
      "password": "Password",
      "enterPassword": "Enter your password"
    }
  },
  "navigation": {
    "search": "Search",
    "challenges": "Challenges",
    "profile": "Profile"
  },
  "onboarding": {
    "welcomeTo": "Welcome to\nDare U!",
    "description": "Transform your life one challenge at a time. Create your first personal challenge to track your progress and document your journey.",
    "chooseFocus": "Choose your focus",
    "startJourney": "Create Challenge"
  },
  "goals": {
    "categories": {
      "health": {
        "name": "Become Healthier",
        "description": "Focus on nutrition, sleep, and wellness"
      },
      "social": {
        "name": "Improve Social Skills",
        "description": "Build connections and communication skills"
      },
      "intelligence": {
        "name": "Become More Intelligent",
        "description": "Learn new things and expand knowledge"
      },
      "fitness": {
        "name": "Get Physically Fit",
        "description": "Build strength and endurance"
      },
      "creativity": {
        "name": "Boost Creativity",
        "description": "Express yourself and think outside the box"
      },
      "productivity": {
        "name": "Increase Productivity",
        "description": "Get more done and manage time better"
      },
      "mindfulness": {
        "name": "Practice Mindfulness",
        "description": "Be present and reduce stress"
      },
      "custom": {
        "name": "Custom Goal",
        "description": "Define your own path to improvement"
      }
    },
    "describeCustomGoal": "Describe your custom goal..."
  },
  "challenges": {
    "title": "Challenges",
    "noChallengesYet": "No challenges yet",
    "createFirstChallenge": "Create your first challenge to start your journey!",
    "createChallenge": "Create Challenge",
    "createNewChallenge": "Create New Challenge",
    "createGroup": "Create Group",
    "personal": "Personal",
    "group": "Group",
    "member": "{count, plural, =1{1 member} other{{count} members}}",
    "messages": "messages",
    "groupCreated": "Group \"{name}\" created!",
    "create": {
      "title": "Create Challenge",
      "chooseThumbnail": "Choose Thumbnail",
      "changeThumbnail": "Change Thumbnail",
      "category": "Category",
      "categoryLabel": "Goal Category",
      "selectCategory": "Select a category for your challenge",
      "titleLabel": "Title",
      "enterGroupName": "Enter group name",
      "enterChallengeName": "Enter challenge name",
      "descriptionLabel": "Description",
      "whatIsGroupAbout": "What is this group about?",
      "members": "Members",
      "addMembers": "Add Members",
      "noMembersAdded": "No members added yet",
      "pleaseEnterTitle": "Please enter a title",
      "pleaseSelectCategory": "Please select a category"
    }
  },
  "chat": {
    "title": "Challenge",
    "startDocumenting": "Start documenting!",
    "shareUpdates": "Share updates, images, and track your progress",
    "shareAnUpdate": "Share an update...",
    "addProgress": "Add Progress",
    "readyToImprove": "Ready to improve yourself?",
    "journeyWillAppearHere": "Your challenge journey will appear here"
  },
  "progress": {
    "submitProgress": "Submit Progress",
    "addNote": "Add a note about your progress...",
    "describeWhatYouDid": "Describe what you did...",
    "attachments": "Attachments",
    "addProof": "Add proof (optional)",
    "pleaseAddNoteOrAttach": "Please add a note or attach a file",
    "types": {
      "image": "Image",
      "video": "Video",
      "file": "File"
    }
  },
  "search": {
    "title": "Search",
    "searchUsers": "Search users...",
    "noUsersFound": "No users found",
    "tryDifferentSearch": "Try a different search term"
  },
  "profile": {
    "title": "Profile",
    "stats": {
      "goals": "Goals",
      "challenges": "Challenges",
      "followers": "Followers"
    },
    "menu": {
      "achievements": "Achievements",
      "viewAccomplishments": "View your accomplishments",
      "statistics": "Statistics",
      "trackProgress": "Track your progress",
      "notifications": "Notifications",
      "manageAlerts": "Manage your alerts",
      "settings": "Settings",
      "appPreferences": "App preferences"
    }
  },
  "settings": {
    "title": "Settings",
    "appearance": "Appearance",
    "selectTheme": "Select theme mode",
    "theme": {
      "light": {
        "name": "Light Mode",
        "description": "Bright and clear interface"
      },
      "dark": {
        "name": "Dark Mode",
        "description": "Easy on the eyes at night"
      },
      "system": {
        "name": "System Default",
        "description": "Follows your device settings"
      }
    },
    "language": "Language",
    "selectLanguage": "Select language",
    "languages": {
      "english": {
        "name": "English",
        "subtitle": "English language"
      },
      "german": {
        "name": "German",
        "subtitle": "Deutsche Sprache"
      }
    },
    "about": "About",
    "version": "Version",
    "builtWith": "Built with",
    "flutterMaterial": "Flutter & Material Design 3"
  },
  "empty": {
    "noData": "No data available"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": _de, "en": _en};
}
