import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/empty_state.dart';
import 'package:unite_up/widgets/user_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'search.title'.tr(), showBackButton: false),
        body: _buildSearchView(),
      ),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
    } else if (query.length >= 2) {
      _performSearch(query);
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);

    try {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final results = await usersProvider.searchUsers(query);

      // Fetch follow status for all results
      final resultsWithFollowStatus = await _populateFollowStatus(results);

      if (mounted) {
        setState(() {
          _searchResults = resultsWithFollowStatus;
          _hasSearched = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasSearched = true;
        });
      }
    }
  }

  Future<List<UserModel>> _populateFollowStatus(List<UserModel> users) async {
    if (users.isEmpty) return users;

    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUserId = usersProvider.currentUser?.id;

    if (currentUserId == null) return users;

    final otherUsers = users.where((u) => u.id != currentUserId).toList();
    final userIds = otherUsers.map((u) => u.id).toList();

    if (userIds.isEmpty) return users;

    final followStatus = await usersProvider.getFollowStatusBatch(userIds);

    return users.map((user) {
      if (user.id == currentUserId) return user;
      return user.copyWith(isFollowing: followStatus[user.id] ?? false);
    }).toList();
  }

  Future<void> _toggleFollow(UserModel user) async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final isCurrentlyFollowing = user.isFollowing;

    // Optimistically update UI
    setState(() {
      final index = _searchResults.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _searchResults[index] = user.copyWith(
          isFollowing: !isCurrentlyFollowing,
        );
      }
    });

    try {
      if (isCurrentlyFollowing) {
        await usersProvider.unfollow(user.id);
      } else {
        await usersProvider.follow(user.id);
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          final index = _searchResults.indexWhere((u) => u.id == user.id);
          if (index != -1) {
            _searchResults[index] = user.copyWith(
              isFollowing: isCurrentlyFollowing,
            );
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'common.error'.tr()}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.spacing16,
            right: AppSizes.spacing16,
            bottom: AppSizes.spacing16,
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search.searchUsers'.tr(),
              prefixIcon: Icon(
                AppIcons.search,
                color: _theme.iconTheme.color?.withValues(
                  alpha: AppOpacity.mostlyOpaque,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(AppIcons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: _theme.brightness == Brightness.dark
                  ? _theme.cardColor
                  : _theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide.none,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _performSearch(value.trim());
              }
            },
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return EmptyState(
        icon: AppIcons.search,
        title: 'search.startSearching'.tr(),
        subtitle: 'search.enterAtLeast2Chars'.tr(),
      );
    }

    if (_searchResults.isEmpty) {
      return EmptyState(
        icon: AppIcons.searchOff,
        title: 'search.noUsersFound'.tr(),
        subtitle: 'search.tryDifferentSearch'.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return UserModelCard(
          user: user,
          onFollowToggle: () => _toggleFollow(user),
        );
      },
    );
  }
}
