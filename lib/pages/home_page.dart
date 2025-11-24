import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/providers/app_state_provider.dart';

import 'challenges_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  bool _wasAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final isAuthenticated = appState.isAuthenticated;

        final pages = isAuthenticated
            ? const [SearchPage(), ChallengesPage(), ProfilePage()]
            : const [ChallengesPage(), ProfilePage()];

        final navItems = isAuthenticated
            ? [
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.search),
                  activeIcon: const Icon(AppIcons.search),
                  label: 'navigation.search'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.flagOutline),
                  activeIcon: const Icon(AppIcons.flag),
                  label: 'navigation.challenges'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.personOutline),
                  activeIcon: const Icon(AppIcons.person),
                  label: 'navigation.profile'.tr(),
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.flagOutline),
                  activeIcon: const Icon(AppIcons.flag),
                  label: 'navigation.challenges'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.personOutline),
                  activeIcon: const Icon(AppIcons.person),
                  label: 'navigation.profile'.tr(),
                ),
              ];

        // Handle authentication state change
        if (isAuthenticated != _wasAuthenticated) {
          if (isAuthenticated && _selectedIndex == 1) {
            // User just logged in and was on profile tab (index 1 in non-auth mode)
            // Profile is now at index 2 in auth mode
            _selectedIndex = 2;
          } else if (!isAuthenticated && _selectedIndex == 2) {
            // User just logged out and was on profile tab (index 2 in auth mode)
            // Profile is now at index 1 in non-auth mode
            _selectedIndex = 1;
          }
          _wasAuthenticated = isAuthenticated;
        }

        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0;
        }

        final theme = Theme.of(context);

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: pages),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppOpacity.light),
                  blurRadius: AppSizes.blurMedium,
                  offset: AppSizes.shadowOffsetUp,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E293B)
                  : Colors.white,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.iconTheme.color?.withValues(
                alpha: AppOpacity.semiTransparent,
              ),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: AppSizes.elevationNone,
              items: navItems,
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
