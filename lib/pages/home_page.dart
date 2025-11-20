import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dare_u/providers/app_state_provider.dart';
import 'challenges_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Start with first available page

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

        // Build pages list based on authentication
        final pages = isAuthenticated
            ? const [SearchPage(), ChallengesPage(), ProfilePage()]
            : const [ChallengesPage(), ProfilePage()];

        // Build navigation items based on authentication
        final navItems = isAuthenticated
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  activeIcon: Icon(Icons.search_rounded),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flag_outlined),
                  activeIcon: Icon(Icons.flag_rounded),
                  label: 'Challenges',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.flag_outlined),
                  activeIcon: Icon(Icons.flag_rounded),
                  label: 'Challenges',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ];

        // Ensure selected index is valid for current number of pages
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
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
              unselectedItemColor: theme.iconTheme.color?.withOpacity(0.5),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              items: navItems,
            ),
          ),
        );
      },
    );
  }
}

