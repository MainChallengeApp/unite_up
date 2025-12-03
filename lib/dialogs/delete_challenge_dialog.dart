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
    return AlertDialog(
      title: Text('challenges.delete'.tr()),
      content: Text('challenges.deleteConfirmation'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => _deleteChallenge(context),
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          child: Text('common.delete'.tr()),
        ),
      ],
    );
  }

  void _deleteChallenge(BuildContext context) {
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

