import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/empty_state.dart';
import 'package:unite_up/widgets/user_card.dart';

enum UserListType { followers, following }

class UserListPage extends StatefulWidget {
  final String userId;
  final UserListType listType;

  const UserListPage({super.key, required this.userId, required this.listType});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserModel> _users = [];
  bool _isLoading = true;

  UsersProvider get _usersProvider =>
      Provider.of<UsersProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.listType == UserListType.followers
        ? 'profile.stats.followers'.tr()
        : 'profile.following'.tr();

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: _buildBody(),
    );
  }

  Future<void> _loadUsers() async {
    try {
      final List<UserModel> users;
      if (widget.listType == UserListType.followers) {
        users = await _usersProvider.getFollowers(widget.userId);
      } else {
        users = await _usersProvider.getFollowing(widget.userId);
      }

      final usersWithFollowStatus = await _populateFollowStatus(users);

      if (mounted) {
        setState(() {
          _users = usersWithFollowStatus;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<UserModel>> _populateFollowStatus(List<UserModel> users) async {
    if (users.isEmpty) return users;

    final currentUserId = _usersProvider.currentUser?.id;
    if (currentUserId == null) return users;

    final userIds = users.map((u) => u.id).toList();
    final followStatus = await _usersProvider.getFollowStatusBatch(userIds);

    return users.map((user) {
      return user.copyWith(isFollowing: followStatus[user.id] ?? false);
    }).toList();
  }

  Future<void> _toggleFollow(UserModel user) async {
    final isCurrentlyFollowing = user.isFollowing;

    setState(() {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user.copyWith(isFollowing: !isCurrentlyFollowing);
      }
    });

    try {
      if (isCurrentlyFollowing) {
        await _usersProvider.unfollow(user.id);
      } else {
        await _usersProvider.follow(user.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          final index = _users.indexWhere((u) => u.id == user.id);
          if (index != -1) {
            _users[index] = user.copyWith(isFollowing: isCurrentlyFollowing);
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      final emptyTitle = widget.listType == UserListType.followers
          ? 'profile.noFollowers'.tr()
          : 'profile.noFollowing'.tr();

      return EmptyState(
        icon: AppIcons.personOutline,
        title: emptyTitle,
        subtitle: '',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return UserModelCard(
          user: user,
          onFollowToggle: () => _toggleFollow(user),
        );
      },
    );
  }
}
