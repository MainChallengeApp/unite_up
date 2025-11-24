import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class CreateGoalDialog extends StatefulWidget {
  const CreateGoalDialog({super.key});

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  final _titleController = TextEditingController();
  final _startValueController = TextEditingController();
  final _endValueController = TextEditingController();
  final _unitController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  ThemeData get _theme => Theme.of(context);

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
      title: Text('goals.createGoal'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _titleController,
              maxLength: AppTextLimits.goalTitleMaxLength,
              labelText: 'goals.title'.tr(),
              hintText: 'goals.titleHint'.tr(),
              icon: AppIcons.edit,
              isRemoveTextVisible: true,
            ),
            const SizedBox(height: AppSizes.spacing16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startValueController,
                    decoration: InputDecoration(
                      labelText: 'goals.startValue'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: TextField(
                    controller: _endValueController,
                    decoration: InputDecoration(
                      labelText: 'goals.endValue'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
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
                hintText: 'goals.unitHint'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              'goals.dates'.tr(),
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                fontWeight: FontWeight.w600,
                color: _theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.spacing12),
            _buildDateSelector(
              context,
              'goals.startDate'.tr(),
              _startDate,
              _selectStartDate,
            ),
            const SizedBox(height: AppSizes.spacing12),
            _buildDateSelector(
              context,
              'goals.endDate'.tr(),
              _endDate,
              _selectEndDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(onPressed: _createGoal, child: Text('common.create'.tr())),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _createGoal() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('goals.enterTitle'.tr())));
      return;
    }

    final startValue = double.tryParse(_startValueController.text);
    final endValue = double.tryParse(_endValueController.text);

    if (startValue == null || endValue == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('goals.enterValidValues'.tr())));
      return;
    }

    if (startValue == endValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('goals.valuesMustBeDifferent'.tr())),
      );
      return;
    }

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final currentUserId = appState.currentUser?.id ?? 'user-1';

    final goal = GoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUserId,
      title: _titleController.text.trim(),
      startValue: startValue,
      endValue: endValue,
      currentValue: startValue,
      startDate: _startDate,
      endDate: _endDate,
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
    );

    appState.addGoal(goal);
    Navigator.pop(context);
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    DateTime date,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing12),
        decoration: BoxDecoration(
          border: Border.all(color: _theme.dividerColor),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: AppSizes.fontMedium)),
            Row(
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: const TextStyle(
                    fontSize: AppSizes.fontMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),
                const Icon(Icons.calendar_today, size: AppSizes.iconSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
