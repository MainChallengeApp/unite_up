import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/services/user_service.dart';
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
  List<UserModel> _filteredUserModels = [];
  final List<UserModel> _allUserModels = UserModelService.getMockUserModels();

  ThemeData get _theme => Theme.of(context);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'search.title'.tr(), showBackButton: false),
      body: _buildSearchView(),
    );
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
                      user.username.toLowerCase().contains(query),
                )
                .toList();
    });
  }

  void _toggleFollow(UserModel user) {
    setState(() {
      final index = _allUserModels.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _allUserModels[index] = _allUserModels[index].copyWith(
          isFollowing: !_allUserModels[index].isFollowing,
        );
      }
      _filterUserModels();
    });
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
          ),
        ),
        Expanded(
          child: _filteredUserModels.isEmpty
              ? EmptyState(
                  icon: AppIcons.searchOff,
                  title: 'search.noUsersFound'.tr(),
                  subtitle: 'search.tryDifferentSearch'.tr(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing16,
                  ),
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
    );
  }
}
