import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/pages/email_confirmed_successfully_page.dart';
import 'package:unite_up/pages/home_page.dart';
import 'package:unite_up/pages/waitlist_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/challenges_provider.dart';
import 'package:unite_up/providers/theme_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/services/env_service.dart';
import 'package:unite_up/services/supabase_service.dart';
import 'package:unite_up/theme/app_theme.dart';
import 'package:unite_up/utils/web_utils.dart'
    if (dart.library.io) 'package:unite_up/utils/mobile_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await EnvService.initialize();
  await SupabaseService.initialize();

  configureUrlStrategy();

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
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/waitlist', builder: (context, state) => WaitlistPage()),
      GoRoute(
        path: '/email-confirmed',
        builder: (context, state) {
          print('context $context');
          print('state $state');
          return EmailConfirmedSuccessfullyPage();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'UniteUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: _router,
    );
  }
}
