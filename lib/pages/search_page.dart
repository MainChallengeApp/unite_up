import 'package:dare_u/models/user_model.dart';
import 'package:dare_u/pages/auth_page.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/services/user_service.dart';
import 'package:dare_u/widgets/empty_state.dart';
import 'package:dare_u/widgets/user_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _filteredUserModels = [];
  final List<UserModel> _allUserModels = UserModelService.getMockUserModels();

  @override
  void initState() {
    super.initState();
    _filteredUserModels = _allUserModels;
    _searchController.addListener(_filterUserModels);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUserModels);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUserModels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUserModels = query.isEmpty
          ? _allUserModels
          : _allUserModels
              .where((user) =>
                  user.name.toLowerCase().contains(query) ||
                  user.username.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'search.title'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          body: appState.isAuthenticated
              ? _buildSearchView(Theme.of(context))
              : const AuthPage(),
        );
      },
    );
  }

  Widget _buildSearchView(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search.searchUsers'.tr(),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.iconTheme.color?.withValues(alpha: 0.6),
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
              ? EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'search.noUsersFound'.tr(),
                  subtitle: 'search.tryDifferentSearch'.tr(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredUserModels.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUserModels[index];
                    return UserModelCard(
                      user: user,
                      onFollowToggle: () {},
                    );
                  },
                ),
        ),
      ],
    );
  }
}
