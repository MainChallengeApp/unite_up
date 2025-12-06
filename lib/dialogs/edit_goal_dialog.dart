import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class EditGoalDialog extends StatefulWidget {
  final GoalModel goal;

  const EditGoalDialog({super.key, required this.goal});

  @override
  State<EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<EditGoalDialog> {
  late TextEditingController _titleController;
  late TextEditingController _startValueController;
  late TextEditingController _endValueController;
  late TextEditingController _unitController;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _startValueController = TextEditingController(
      text: widget.goal.startValue.toString(),
    );
    _endValueController = TextEditingController(
      text: widget.goal.endValue.toString(),
    );
    _unitController = TextEditingController(text: widget.goal.unit ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startValueController.dispose();
    _endValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(AppIcons.edit, color: _theme.colorScheme.primary),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Text(
              'goals.editGoal'.tr(),
              style: AppTextStyles.largeSemiBold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: AppSizes.dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'goals.goalTitle'.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spacing16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startValueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'goals.startValue'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing12),
                  Expanded(
                    child: TextField(
                      controller: _endValueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'goals.endValue'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing16),
              TextField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'goals.unit'.tr(),
                  border: const OutlineInputBorder(),
                  hintText: 'goals.unitHint'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: _saveGoal,
          style: FilledButton.styleFrom(
            backgroundColor: _theme.colorScheme.primary,
          ),
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }

  void _saveGoal() {
    final title = _titleController.text.trim();
    final startValue = double.tryParse(_startValueController.text);
    final endValue = double.tryParse(_endValueController.text);

    if (title.isNotEmpty && startValue != null && endValue != null) {
      HapticFeedback.mediumImpact();
      final updatedGoal = widget.goal.copyWith(
        title: title,
        startValue: startValue,
        endValue: endValue,
        unit: _unitController.text.trim().isEmpty
            ? null
            : _unitController.text.trim(),
      );
      Provider.of<AppStateProvider>(
        context,
        listen: false,
      ).updateGoal(updatedGoal, createEvent: true, isProgressUpdate: false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('goals.goalUpdated'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
