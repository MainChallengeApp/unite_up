import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class QuickUpdateProgressDialog extends StatefulWidget {
  final GoalModel goal;

  const QuickUpdateProgressDialog({super.key, required this.goal});

  @override
  State<QuickUpdateProgressDialog> createState() =>
      _QuickUpdateProgressDialogState();
}

class _QuickUpdateProgressDialogState extends State<QuickUpdateProgressDialog> {
  late TextEditingController _progressController;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _progressController = TextEditingController(
      text: widget.goal.currentValue.toString(),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(AppIcons.stats, color: _theme.colorScheme.primary),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Text(
              'goals.updateProgress'.tr(),
              style: AppTextStyles.largeSemiBold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.goal.title, style: AppTextStyles.mediumSemiBold),
          const SizedBox(height: AppSizes.spacing16),
          TextField(
            controller: _progressController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'goals.currentValue'.tr(),
              suffixText: widget.goal.unit,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                AppIcons.flag,
                color: _theme.colorScheme.primary,
              ),
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSizes.spacing12),
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing12),
            decoration: BoxDecoration(
              color: _theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'goals.target'.tr(),
                  style: AppTextStyles.smallSecondary(context),
                ),
                Text(
                  '${_formatValue(widget.goal.endValue)} ${widget.goal.unit ?? ""}',
                  style: AppTextStyles.mediumSemiBold.copyWith(
                    color: _theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: _updateProgress,
          style: FilledButton.styleFrom(
            backgroundColor: _theme.colorScheme.primary,
          ),
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }

  void _updateProgress() {
    final newValue = double.tryParse(_progressController.text);
    if (newValue != null) {
      HapticFeedback.mediumImpact();
      final updatedGoal = widget.goal.copyWith(currentValue: newValue);
      Provider.of<AppStateProvider>(
        context,
        listen: false,
      ).updateGoal(
        updatedGoal,
        createEvent: true,
        isProgressUpdate: true,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('goals.progressUpdated'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}

