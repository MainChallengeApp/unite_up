import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/user_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _allUsers = UserService.getMockUsers();
    _filteredUsers = _allUsers;
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = query.isEmpty
          ? _allUsers
          : _allUsers
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(query) ||
                      user.username.toLowerCase().contains(query) ||
                      (user.bio?.toLowerCase().contains(query) ?? false),
                )
                .toList();
    });
  }

  void _toggleFollow(User user) {
    setState(() {
      _updateUser(user);
    });
  }

  void _updateUser(User user) {
    final index = _filteredUsers.indexWhere((u) => u.id == user.id);
    if (index == -1) return;

    final updatedUser = user.copyWith(
      isFollowing: !user.isFollowing,
      followersCount: user.isFollowing
          ? user.followersCount - 1
          : user.followersCount + 1,
    );

    _filteredUsers[index] = updatedUser;

    final allIndex = _allUsers.indexWhere((u) => u.id == user.id);
    if (allIndex != -1) {
      _allUsers[allIndex] = updatedUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.iconTheme.color?.withOpacity(0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? theme.cardColor
                    : theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No users found',
                    subtitle: 'Try a different search term',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return UserCard(
                        user: user,
                        onFollowToggle: () => _toggleFollow(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
