import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'challenges_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0;
        }

        final theme = Theme.of(context);

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
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
              unselectedItemColor: theme.iconTheme.color?.withValues(alpha: AppOpacity.semiTransparent),
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
}
