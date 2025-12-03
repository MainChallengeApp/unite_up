import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class DeleteGoalDialog extends StatelessWidget {
  final GoalModel goal;

  const DeleteGoalDialog({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('goals.deleteGoal'.tr()),
      content: Text(
        'goals.deleteGoalConfirmation'.tr(namedArgs: {'goal': goal.title}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => _deleteGoal(context),
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          child: Text('common.delete'.tr()),
        ),
      ],
    );
  }

  void _deleteGoal(BuildContext context) {
    HapticFeedback.mediumImpact();
    Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).deleteGoal(goal.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('goals.goalDeleted'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

