import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class EditChallengeDialog extends StatefulWidget {
  final ChallengeChatModel challenge;

  const EditChallengeDialog({super.key, required this.challenge});

  @override
  State<EditChallengeDialog> createState() => _EditChallengeDialogState();
}

class _EditChallengeDialogState extends State<EditChallengeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.challenge.name);
    _descriptionController = TextEditingController(
      text: widget.challenge.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('challenges.edit'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'challenges.create.titleLabel'.tr(),
              hintText: 'challenges.create.enterChallengeName'.tr(),
              icon: AppIcons.edit,
              isRemoveTextVisible: true,
            ),
            const SizedBox(height: AppSizes.spacing16),
            CustomTextField(
              controller: _descriptionController,
              labelText: 'challenges.create.descriptionLabel'.tr(),
              hintText: 'challenges.create.whatIsGroupAbout'.tr(),
              icon: AppIcons.description,
              maxLines: 3,
              isRemoveTextVisible: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: _saveChallenge,
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }

  void _saveChallenge() {
    if (_nameController.text.trim().isNotEmpty) {
      final updatedChallenge = widget.challenge.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      Provider.of<AppStateProvider>(
        context,
        listen: false,
      ).updateChallenge(updatedChallenge);
      Navigator.pop(context);
    }
  }
}
