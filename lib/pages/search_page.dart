import 'package:flutter/material.dart';

import 'package:dare_u/models/user_model.dart';
import 'package:dare_u/services/user_service.dart';
import 'package:dare_u/widgets/empty_state.dart';
import 'package:dare_u/widgets/user_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allUserModels = [];
  List<UserModel> _filteredUserModels = [];

  @override
  void initState() {
    super.initState();
    _allUserModels = UserModelService.getMockUserModels();
    _filteredUserModels = _allUserModels;
    _searchController.addListener(_filterUserModels);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUserModels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUserModels = query.isEmpty
          ? _allUserModels
          : _allUserModels
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(query) ||
                      user.username.toLowerCase().contains(query) ||
                      (user.bio?.toLowerCase().contains(query) ?? false),
                )
                .toList();
    });
  }

  void _toggleFollow(UserModel user) {
    setState(() {
      _updateUserModel(user);
    });
  }

  void _updateUserModel(UserModel user) {
    final index = _filteredUserModels.indexWhere((u) => u.id == user.id);
    if (index == -1) return;

    final updatedUserModel = user.copyWith(
      isFollowing: !user.isFollowing,
      followersCount: user.isFollowing
          ? user.followersCount - 1
          : user.followersCount + 1,
    );

    _filteredUserModels[index] = updatedUserModel;

    final allIndex = _allUserModels.indexWhere((u) => u.id == user.id);
    if (allIndex != -1) {
      _allUserModels[allIndex] = updatedUserModel;
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
            child: _filteredUserModels.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No users found',
                    subtitle: 'Try a different search term',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUserModels.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUserModels[index];
                      return UserModelCard(
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
