import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class DeleteChallengeDialog extends StatelessWidget {
  final ChallengeChatModel challenge;
  final int popCount;

  const DeleteChallengeDialog({
    super.key,
    required this.challenge,
    this.popCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final isCreator = challenge.creatorId == appState.currentUser?.id;

    final title =
        isCreator ? 'challenges.delete'.tr() : 'challenges.leave'.tr();
    final content = isCreator
        ? 'challenges.deleteConfirmation'.tr()
        : 'challenges.leaveConfirmation'.tr();
    final buttonText =
        isCreator ? 'common.delete'.tr() : 'common.leave'.tr();

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => _deleteOrLeaveChallenge(context),
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          child: Text(buttonText),
        ),
      ],
    );
  }

  void _deleteOrLeaveChallenge(BuildContext context) {
    Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).deleteChallenge(challenge.id);

    // Pop multiple times to close dialog, group details, and chat page
    for (var i = 0; i < popCount; i++) {
      Navigator.pop(context);
    }
  }
}

