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

  ThemeData get _theme => Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final pages = _getPages(appState.isAuthenticated);
        final navItems = _getNavigationItems(appState.isAuthenticated);

        _handleAuthStateChange(appState.isAuthenticated, pages.length);

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: pages),
          bottomNavigationBar: _buildBottomNavigationBar(navItems),
        );
      },
    );
  }

  List<Widget> _getPages(bool isAuthenticated) {
    return isAuthenticated
        ? const [SearchPage(), ChallengesPage(), ProfilePage()]
        : const [ChallengesPage(), ProfilePage()];
  }

  List<BottomNavigationBarItem> _getNavigationItems(bool isAuthenticated) {
    if (isAuthenticated) {
      return [
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
      ];
    }

    return [
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
  }

  void _handleAuthStateChange(bool isAuthenticated, int pagesLength) {
    if (isAuthenticated != _wasAuthenticated) {
      if (isAuthenticated && _selectedIndex == 1) {
        _selectedIndex = 2;
      } else if (!isAuthenticated && _selectedIndex == 2) {
        _selectedIndex = 1;
      }
      _wasAuthenticated = isAuthenticated;
    }

    if (_selectedIndex >= pagesLength) {
      _selectedIndex = 0;
    }
  }

  Widget _buildBottomNavigationBar(List<BottomNavigationBarItem> navItems) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: AppOpacity.light),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetUp,
          ),
        ],
      ),
      child: Theme(
        data: _theme.copyWith(highlightColor: Colors.transparent),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: _theme.brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.white,
          selectedItemColor: _theme.colorScheme.primary,
          unselectedItemColor: _theme.iconTheme.color?.withValues(
            alpha: AppOpacity.semiTransparent,
          ),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: AppSizes.elevationNone,
          items: navItems,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
