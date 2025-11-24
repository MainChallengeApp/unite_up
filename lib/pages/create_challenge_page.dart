import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/enums/goal_category_enum.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/pages/chat_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/services/user_service.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key});

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<UserModel> _selectedMembers = [];
  final List<UserModel> _availableUsers = [];
  String _selectedEmoji = '🎯';
  final GoalCategoryEnum _selectedCategory = GoalCategoryEnum.health;
  bool _isCreating = false;
  int _titleCharCount = 0;
  int _descriptionCharCount = 0;
  static const int _maxTitleLength = 50;
  static const int _maxDescriptionLength = 200;
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
  ];

  @override
  void initState() {
    super.initState();
    _availableUsers.addAll(UserModelService.getMockUserModels());
    _titleController.addListener(_updateTitleCount);
    _descriptionController.addListener(_updateDescriptionCount);
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateTitleCount);
    _descriptionController.removeListener(_updateDescriptionCount);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTitleCount() {
    setState(() {
      _titleCharCount = _titleController.text.length;
    });
  }

  void _updateDescriptionCount() {
    setState(() {
      _descriptionCharCount = _descriptionController.text.length;
    });
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
                      ? Theme.of(context).colorScheme.primary.withValues(
                          alpha: AppOpacity.subtle,
                        )
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: emoji == _selectedEmoji
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: AppSizes.borderThick,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: AppSizes.emojiXLarge),
                ),
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
      builder: (context) => AlertDialog(
        title: Text('challenges.create.addMembers'.tr()),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableUsers.length,
            itemBuilder: (context, index) {
              final user = _availableUsers[index];
              final isSelected = _selectedMembers.contains(user);

              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedMembers.add(user);
                    } else {
                      _selectedMembers.remove(user);
                    }
                  });
                  Navigator.pop(context);
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    _showMembersPicker,
                  );
                },
                title: Text(user.name),
                subtitle: Text(user.username),
                secondary: CircleAvatar(child: Text(user.name[0])),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.done'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _createChallenge() async {
    if (_isCreating) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('challenges.create.pleaseEnterTitle'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.trim().length > _maxTitleLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('challenges.create.titleTooLong'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final currentUserId = appState.currentUser?.id ?? 'user-1';

      final memberIds = <String>[];
      memberIds.add(currentUserId);
      memberIds.addAll(_selectedMembers.map((m) => m.id));

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

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      appState.addChallenge(challenge);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('challenges.create.success'.tr()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to chat page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('challenges.create.error'.tr()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final isAuthenticated = appState.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'challenges.createNewChallenge'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontXLarge,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacing32),
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: _showEmojiPicker,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                    child: Container(
                      width: AppSizes.containerHuge,
                      height: AppSizes.containerHuge,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: AppOpacity.light,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusXLarge,
                        ),
                        border: Border.all(
                          color: theme.dividerColor.withValues(
                            alpha: AppOpacity.medium,
                          ),
                          width: AppSizes.borderThick,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _selectedEmoji,
                          style: const TextStyle(fontSize: AppSizes.emojiHuge),
                        ),
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
            ),
            const SizedBox(height: AppSizes.spacing32),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _titleController,
                  labelText: 'challenges.create.titleLabel'.tr(),
                  hintText: 'challenges.create.enterChallengeName'.tr(),
                  icon: AppIcons.edit,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spacing4,
                    right: AppSizes.spacing4,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$_titleCharCount/$_maxTitleLength',
                      style: TextStyle(
                        fontSize: AppSizes.fontSmall,
                        color: _titleCharCount > _maxTitleLength
                            ? Colors.red
                            : theme.iconTheme.color?.withValues(
                                alpha: AppOpacity.mostlyOpaque,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'challenges.create.descriptionLabel'.tr(),
                  hintText: 'challenges.create.whatIsGroupAbout'.tr(),
                  icon: AppIcons.description,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spacing4,
                    right: AppSizes.spacing4,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$_descriptionCharCount/$_maxDescriptionLength',
                      style: TextStyle(
                        fontSize: AppSizes.fontSmall,
                        color: _descriptionCharCount > _maxDescriptionLength
                            ? Colors.red
                            : theme.iconTheme.color?.withValues(
                                alpha: AppOpacity.mostlyOpaque,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isAuthenticated) ...[
              const SizedBox(height: AppSizes.spacing24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'challenges.create.members'.tr(),
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      fontWeight: FontWeight.w600,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showMembersPicker,
                    icon: const Icon(
                      AppIcons.personAdd,
                      size: AppSizes.iconSmall,
                    ),
                    label: Text('common.add'.tr()),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing8),
              if (_selectedMembers.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing24),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? theme.cardColor
                        : theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Center(
                    child: Text(
                      'challenges.create.noMembersAdded'.tr(),
                      style: TextStyle(
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.semiTransparent,
                        ),
                      ),
                    ),
                  ),
                )
              else
                ..._selectedMembers.map(
                  (member) => _buildMemberChip(member, theme),
                ),
            ],
            const SizedBox(height: AppSizes.spacing32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isCreating ? null : _createChallenge,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spacing16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        height: AppSizes.iconMedium,
                        width: AppSizes.iconMedium,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'challenges.createChallenge'.tr(),
                        style: const TextStyle(
                          fontSize: AppSizes.fontLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberChip(UserModel member, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing8,
      ),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.cardColor
            : theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.spacing16,
            child: Text(
              member.name[0],
              style: const TextStyle(fontSize: AppSizes.fontMedium),
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  member.username,
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: theme.iconTheme.color?.withValues(
                      alpha: AppOpacity.mostlyOpaque,
                    ),
                  ),
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
