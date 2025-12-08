import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/pages/home_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/challenges_provider.dart';
import 'package:unite_up/providers/theme_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/services/env_service.dart';
import 'package:unite_up/services/supabase_service.dart';
import 'package:unite_up/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await EnvService.initialize();
  await SupabaseService.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UsersProvider()),
          ChangeNotifierProvider(create: (_) => ChallengesProvider()),
          ChangeNotifierProxyProvider2<
            UsersProvider,
            ChallengesProvider,
            AppStateProvider
          >(
            create: (_) => AppStateProvider(),
            update: (_, usersProvider, challengesProvider, appState) =>
                appState!
                  ..updateUsersProvider(usersProvider)
                  ..updateChallengesProvider(challengesProvider),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'UniteUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const HomePage(),
    );
  }
}
