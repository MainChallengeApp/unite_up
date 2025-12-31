import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/core/utils/decimal_input_formatter.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class UpdateGoalProgressDialog extends StatefulWidget {
  const UpdateGoalProgressDialog({super.key});

  @override
  State<UpdateGoalProgressDialog> createState() =>
      _UpdateGoalProgressDialogState();
}

class _UpdateGoalProgressDialogState extends State<UpdateGoalProgressDialog> {
  GoalModel? _selectedGoal;
  final _progressController = TextEditingController();

  ThemeData get _theme => Theme.of(context);

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final currentUserId = appState.currentUser?.id ?? 'user-1';

    // Get user's goals
    final userGoals =
        appState.currentChallenge?.goals
            .where((g) => g.userId == currentUserId)
            .toList() ??
        [];

    return AlertDialog(
      title: Text('goals.updateProgress'.tr()),
      content: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            if (userGoals.isEmpty) ...[
              Text(
                'goals.noGoalsToUpdate'.tr(),
                style: AppTextStyles.secondaryText(context),
              ),
            ] else ...[
              Text(
                'goals.selectGoalToUpdate'.tr(),
                style: AppTextStyles.mediumWeight,
              ),
              const SizedBox(height: AppSizes.spacing12),
              ...userGoals.map((goal) => _buildGoalOption(goal)),
              if (_selectedGoal != null) ...[
                const SizedBox(height: AppSizes.spacing16),
                TextField(
                  controller: _progressController,
                  decoration: InputDecoration(
                    labelText: 'goals.newValue'.tr(),
                    hintText: '${_selectedGoal!.currentValue}',
                    suffixText: _selectedGoal!.unit ?? '',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [DecimalInputFormatter()],
                  autofocus: true,
                ),
                const SizedBox(height: AppSizes.spacing8),
                Text(
                  '${'goals.current'.tr()}: ${_selectedGoal!.currentValue.toStringAsFixed(_selectedGoal!.currentValue.truncateToDouble() == _selectedGoal!.currentValue ? 0 : 1)} ${_selectedGoal!.unit ?? ""} / ${_selectedGoal!.endValue.toStringAsFixed(_selectedGoal!.endValue.truncateToDouble() == _selectedGoal!.endValue ? 0 : 1)} ${_selectedGoal!.unit ?? ""}',
                  style: AppTextStyles.smallSecondary(context),
                ),
              ],
            ],
          ],
        ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        if (userGoals.isNotEmpty)
          FilledButton(
            onPressed: _updateProgress,
            child: Text('common.save'.tr()),
          ),
      ],
    );
  }

  void _updateProgress() {
    if (_selectedGoal == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('goals.selectGoal'.tr())));
      return;
    }

    final newValue = double.tryParse(_progressController.text);
    if (newValue == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('goals.enterValidValue'.tr())));
      return;
    }

    final updatedGoal = _selectedGoal!.copyWith(currentValue: newValue);
    Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).updateGoal(
      updatedGoal,
      createEvent: true,
      isProgressUpdate: true,
    );
    Navigator.pop(context);
  }

  Widget _buildGoalOption(GoalModel goal) {
    final isSelected = _selectedGoal?.id == goal.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGoal = goal;
            _progressController.text = goal.currentValue.toString();
          });
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing12),
          decoration: BoxDecoration(
            color: isSelected
                ? _theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
                : _theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? _theme.colorScheme.primary
                  : _theme.dividerColor.withValues(alpha: AppOpacity.light),
              width: isSelected ? AppSizes.borderMedium : AppSizes.borderThin,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: AppTextStyles.mediumSemiBold.copyWith(
                        color: isSelected ? _theme.colorScheme.primary : null,
                      ),
                    ),
                  ),
                  Text(
                    '${goal.progressPercentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.mediumSemiBold.copyWith(
                      color: isSelected
                          ? _theme.colorScheme.primary
                          : _theme.iconTheme.color?.withValues(
                              alpha: AppOpacity.mostlyOpaque,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                '${goal.currentValue.toStringAsFixed(goal.currentValue.truncateToDouble() == goal.currentValue ? 0 : 1)} / ${goal.endValue.toStringAsFixed(goal.endValue.truncateToDouble() == goal.endValue ? 0 : 1)} ${goal.unit ?? ""}',
                style: AppTextStyles.smallSecondary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

