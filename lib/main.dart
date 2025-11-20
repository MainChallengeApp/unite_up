import 'package:dare_u/pages/home_page.dart';
import 'package:dare_u/pages/onboarding_page.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/providers/theme_provider.dart';
import 'package:dare_u/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Dare U',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    // Show onboarding if user hasn't completed it yet and has no goals
    if (!appState.hasCompletedOnboarding || !appState.hasGoals) {
      return const OnboardingPage();
    }

    // Otherwise show the main home page with bottom navigation
    return const HomePage();
  }
}
