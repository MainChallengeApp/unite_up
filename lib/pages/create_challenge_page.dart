import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/enums/goal_category_enum.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/pages/chat_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class CreateChallengePage extends StatefulWidget {
  final ChallengeChatModel? challenge;

  const CreateChallengePage({super.key, this.challenge});

  bool get isEditMode => challenge != null;

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<UserModel> _selectedMembers = [];
  late String _selectedEmoji;
  final GoalCategoryEnum _selectedCategory = GoalCategoryEnum.health;
  bool _isSaving = false;

  bool get _isEditMode => widget.challenge != null;

  ThemeData get _theme => Theme.of(context);

  final List<String> _availableEmojis = [
    '🎯',
    '💪',
    '🏃',
    '📚',
    '🎨',
    '🧘',
    '🌱',
    '⚡',
    '🔥',
    '✨',
    '🎉',
    '🌟',
    '🏆',
    '💎',
    '🚀',
    '⭐',
  ];

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.challenge?.emoji ?? '🎯';

    if (_isEditMode) {
      _titleController.text = widget.challenge!.name;
      _descriptionController.text = widget.challenge!.description ?? '';
      _initializeSelectedMembers();
    }
  }

  Future<void> _initializeSelectedMembers() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUserId =
        appState.currentUser?.id ?? AppStateProvider.anonymousUserId;

    // Fetch members from database (excluding current user)
    for (final memberId in widget.challenge!.memberIds) {
      if (memberId != currentUserId) {
        final user = await usersProvider.getUserById(memberId);
        if (user != null && mounted) {
          setState(() => _selectedMembers.add(user));
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isAuthenticated = appState.isAuthenticated;
    final currentUserId =
        appState.currentUser?.id ?? AppStateProvider.anonymousUserId;
    final isCreator =
        !_isEditMode || widget.challenge!.creatorId == currentUserId;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEditMode
              ? 'challenges.edit'.tr()
              : 'challenges.createNewChallenge'.tr(),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.spacing32),
              _buildEmojiSelector(),
              const SizedBox(height: AppSizes.spacing32),
              _buildTitleField(),
              const SizedBox(height: AppSizes.spacing16),
              _buildDescriptionField(),
              if (isAuthenticated && isCreator) _buildMembersSection(),
              const SizedBox(height: AppSizes.spacing32),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiSelector() {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: _showEmojiPicker,
            borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
            child: Container(
              width: AppSizes.containerHuge,
              height: AppSizes.containerHuge,
              decoration: BoxDecoration(
                color: _theme.colorScheme.primary.withValues(
                  alpha: AppOpacity.light,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                border: Border.all(
                  color: _theme.dividerColor.withValues(
                    alpha: AppOpacity.medium,
                  ),
                  width: AppSizes.borderThick,
                ),
              ),
              child: Center(
                child: Text(_selectedEmoji, style: AppTextStyles.emojiHuge),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          TextButton.icon(
            onPressed: _showEmojiPicker,
            icon: const Icon(AppIcons.edit, size: AppSizes.iconSmall),
            label: Text('challenges.create.changeThumbnail'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return CustomTextField(
      controller: _titleController,
      labelText: 'challenges.create.titleLabel'.tr(),
      hintText: 'challenges.create.enterChallengeName'.tr(),
      icon: AppIcons.edit,
      maxLength: AppTextLimits.challengeTitleMaxLength,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        _descriptionFocusNode.requestFocus();
      },
      isRemoveTextVisible: true,
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      focusNode: _descriptionFocusNode,
      labelText: 'challenges.create.descriptionLabel'.tr(),
      hintText: 'challenges.create.whatIsGroupAbout'.tr(),
      icon: AppIcons.description,
      maxLines: 3,
      maxLength: AppTextLimits.challengeDescriptionMaxLength,
      textInputAction: TextInputAction.newline,
      isRemoveTextVisible: true,
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.spacing24),
        _buildMembersHeader(),
        const SizedBox(height: AppSizes.spacing8),
        if (_selectedMembers.isEmpty)
          _buildEmptyMembersPlaceholder()
        else
          ..._selectedMembers.map((member) => _buildMemberChip(member)),
      ],
    );
  }

  Widget _buildMembersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'challenges.create.members'.tr(),
          style: AppTextStyles.mediumSemiBoldPrimary(context),
        ),
        TextButton.icon(
          onPressed: _showMembersPicker,
          icon: const Icon(AppIcons.personAdd, size: AppSizes.iconSmall),
          label: Text('common.add'.tr()),
        ),
      ],
    );
  }

  Widget _buildEmptyMembersPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      decoration: BoxDecoration(
        color: _theme.brightness == Brightness.dark
            ? _theme.cardColor
            : _theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Center(
        child: Text(
          'challenges.create.noMembersAdded'.tr(),
          style: AppTextStyles.hintText(context),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _isSaving ? null : _saveChallenge,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: AppSizes.iconMedium,
                width: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                _isEditMode
                    ? 'common.save'.tr()
                    : 'challenges.createChallenge'.tr(),
                style: AppTextStyles.largeSemiBold,
              ),
      ),
    );
  }

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('challenges.create.chooseThumbnail'.tr()),
        content: Wrap(
          spacing: AppSizes.spacing12,
          runSpacing: AppSizes.spacing12,
          children: _availableEmojis.map((emoji) {
            return InkWell(
              onTap: () {
                setState(() => _selectedEmoji = emoji);
                Navigator.pop(context);
              },
              child: Container(
                width: AppSizes.containerMedium,
                height: AppSizes.containerMedium,
                decoration: BoxDecoration(
                  color: emoji == _selectedEmoji
                      ? _theme.colorScheme.primary.withValues(
                          alpha: AppOpacity.subtle,
                        )
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: emoji == _selectedEmoji
                        ? _theme.colorScheme.primary
                        : AppColors.transparent,
                    width: AppSizes.borderThick,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: AppTextStyles.emojiXLarge),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showMembersPicker() {
    showDialog(
      context: context,
      builder: (dialogContext) => _MemberSearchDialog(
        selectedMembers: _selectedMembers,
        onMembersChanged: (members) {
          setState(() {
            _selectedMembers.clear();
            _selectedMembers.addAll(members);
          });
        },
      ),
    );
  }

  Future<void> _saveChallenge() async {
    if (_isSaving) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('challenges.create.pleaseEnterTitle'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_titleController.text.trim().length >
        AppTextLimits.challengeTitleMaxLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('challenges.create.titleTooLong'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final currentUserId =
          appState.currentUser?.id ?? AppStateProvider.anonymousUserId;

      final memberIds = <String>[];
      memberIds.add(currentUserId);
      memberIds.addAll(_selectedMembers.map((m) => m.id));

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_isEditMode) {
        // Update existing challenge
        final updatedChallenge = widget.challenge!.copyWith(
          name: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          emoji: _selectedEmoji,
          memberIds: memberIds,
        );
        await appState.updateChallenge(updatedChallenge);

        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        // Create new challenge
        final challenge = ChallengeChatModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          category: _selectedCategory,
          emoji: _selectedEmoji,
          memberIds: memberIds,
          creatorId: currentUserId,
          createdAt: DateTime.now(),
        );

        await appState.addChallenge(challenge);

        // Check for errors
        if (appState.challengesError != null && mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appState.challengesError!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.red,
            ),
          );
          return;
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('challenges.create.error'.tr()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  Widget _buildMemberChip(UserModel member) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing8,
      ),
      decoration: BoxDecoration(
        color: _theme.brightness == Brightness.dark
            ? _theme.cardColor
            : _theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.spacing16,
            child: Text(member.name[0], style: AppTextStyles.baseMedium),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: AppTextStyles.mediumWeight.copyWith(
                    color: _theme.brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.darkSurface,
                  ),
                ),
                Text(
                  '@${member.username}',
                  style: AppTextStyles.smallSecondary(context),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(AppIcons.close, size: AppSizes.iconMedium),
            onPressed: () {
              setState(() {
                _selectedMembers.remove(member);
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Dialog for searching and selecting members.
class _MemberSearchDialog extends StatefulWidget {
  final List<UserModel> selectedMembers;
  final ValueChanged<List<UserModel>> onMembersChanged;

  const _MemberSearchDialog({
    required this.selectedMembers,
    required this.onMembersChanged,
  });

  @override
  State<_MemberSearchDialog> createState() => _MemberSearchDialogState();
}

class _MemberSearchDialogState extends State<_MemberSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _followers = [];
  List<UserModel> _filteredFollowers = [];
  late List<UserModel> _selected;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedMembers);
    _loadFollowers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowers() async {
    try {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final currentUserId = usersProvider.currentUser?.id;

      if (currentUserId != null) {
        final followers = await usersProvider.getFollowers(currentUserId);

        if (mounted) {
          setState(() {
            _followers = followers;
            _filteredFollowers = followers;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterFollowers(String query) {
    if (query.isEmpty) {
      setState(() => _filteredFollowers = _followers);
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredFollowers = _followers.where((user) {
        final name = user.name.toLowerCase();
        final username = user.username.toLowerCase();
        return name.contains(lowerQuery) || username.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('challenges.create.addMembers'.tr()),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'search.searchUsers'.tr(),
                prefixIcon: const Icon(AppIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              onChanged: _filterFollowers,
            ),
            const SizedBox(height: AppSizes.spacing16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _followers.isEmpty
                      ? Center(
                          child: Text(
                            'profile.noFollowers'.tr(),
                            style: AppTextStyles.secondaryText(context),
                          ),
                        )
                      : _filteredFollowers.isEmpty
                          ? Center(
                              child: Text(
                                'search.noUsersFound'.tr(),
                                style: AppTextStyles.secondaryText(context),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredFollowers.length,
                              itemBuilder: (context, index) {
                                final user = _filteredFollowers[index];
                                final isSelected = _selected.any(
                                  (u) => u.id == user.id,
                                );

                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selected.add(user);
                                      } else {
                                        _selected.removeWhere(
                                          (u) => u.id == user.id,
                                        );
                                      }
                                    });
                                  },
                                  title: Text(user.name),
                                  subtitle: Text('@${user.username}'),
                                  secondary: CircleAvatar(
                                    child: Text(user.name[0]),
                                  ),
                                );
                              },
                            ),
            ),
            if (_selected.isNotEmpty) ...[
              const Divider(),
              Wrap(
                spacing: AppSizes.spacing8,
                children: _selected
                    .map(
                      (user) => Chip(
                        label: Text(user.name),
                        onDeleted: () {
                          setState(() {
                            _selected.removeWhere((u) => u.id == user.id);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () {
            widget.onMembersChanged(_selected);
            Navigator.pop(context);
          },
          child: Text('common.done'.tr()),
        ),
      ],
    );
  }
}
