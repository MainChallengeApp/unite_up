import 'package:dare_u/enums/goal_category_enum.dart';
import 'package:dare_u/models/challenge_chat_model.dart';
import 'package:dare_u/models/user_model.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/services/user_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  GoalCategoryEnum _selectedCategory = GoalCategoryEnum.health;
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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('challenges.create.chooseThumbnail'.tr()),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableEmojis.map((emoji) {
            return InkWell(
              onTap: () {
                setState(() => _selectedEmoji = emoji);
                Navigator.pop(context);
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: emoji == _selectedEmoji
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: emoji == _selectedEmoji
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
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

  void _createChallenge() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('challenges.create.pleaseEnterTitle'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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

    appState.addChallenge(challenge);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('challenges.challengeCreated'.tr(namedArgs: {'name': challenge.name})),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'challenges.createNewChallenge'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: _showEmojiPicker,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _selectedEmoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _showEmojiPicker,
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: Text('challenges.create.changeThumbnail'.tr()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'challenges.create.category'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<GoalCategoryEnum>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? theme.cardColor
                    : theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: GoalCategoryEnum.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Builder(
                    builder: (context) => Row(
                      children: [
                        Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(category.displayName(context)),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              'challenges.create.titleLabel'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'challenges.create.enterChallengeName'.tr(),
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
            const SizedBox(height: 24),
            Text(
              'challenges.create.descriptionLabel'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'challenges.create.whatIsGroupAbout'.tr(),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? theme.cardColor
                    : theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'challenges.create.members'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showMembersPicker,
                  icon: const Icon(Icons.person_add_rounded, size: 16),
                  label: Text('common.add'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedMembers.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? theme.cardColor
                      : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'challenges.create.noMembersAdded'.tr(),
                    style: TextStyle(
                      color: theme.iconTheme.color?.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              ..._selectedMembers.map(
                (member) => _buildMemberChip(member, theme),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _createChallenge,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'challenges.createChallenge'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.cardColor
            : theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Text(member.name[0], style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  member.username,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
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
