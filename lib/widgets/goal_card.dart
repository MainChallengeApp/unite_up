import 'package:dare_u/enums/goal_category_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final GoalCategoryEnum category;
  final bool isSelected;
  final VoidCallback onTap;
  final TextEditingController? customController;

  const GoalCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.customController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCustom = category == GoalCategoryEnum.custom;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _buildDecoration(theme),
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: _buildCardContent(theme, context),
            ),
            if (isCustom && isSelected && customController != null) ...[
              const SizedBox(height: 16),
              _buildCustomInput(theme),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(ThemeData theme) {
    return BoxDecoration(
      color: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildCardContent(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        _buildIcon(theme),
        const SizedBox(width: 16),
        Expanded(child: _buildText(theme, context)),
        _buildCheckIcon(theme),
      ],
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(category.emoji, style: const TextStyle(fontSize: 28)),
    );
  }

  Widget _buildText(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.displayName(context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          category.description(context),
          style: TextStyle(
            fontSize: 13,
            color: theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckIcon(ThemeData theme) {
    return Icon(
      isSelected ? Icons.check_circle : Icons.circle_outlined,
      color: isSelected
          ? theme.colorScheme.primary
          : theme.iconTheme.color?.withValues(alpha: 0.3),
      size: 24,
    );
  }

  Widget _buildCustomInput(ThemeData theme) {
    return TextField(
      controller: customController,
      decoration: InputDecoration(
        hintText: 'goals.describeCustomGoal'.tr(),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
