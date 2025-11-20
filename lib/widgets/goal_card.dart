import 'package:dare_u/enums/goal_category_enum.dart';
import 'package:dare_u/core/constants/app_constants.dart';
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
      padding: const EdgeInsets.only(bottom: AppSizes.spacing12),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: _buildDecoration(theme),
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: _buildCardContent(theme, context),
            ),
            if (isCustom && isSelected && customController != null) ...[
              const SizedBox(height: AppSizes.spacing16),
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
          ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      border: Border.all(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        width: AppSizes.borderThick,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: AppOpacity.veryLight),
          blurRadius: AppSizes.blurMedium,
          offset: AppSizes.shadowOffsetSmall,
        ),
      ],
    );
  }

  Widget _buildCardContent(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        _buildIcon(theme),
        const SizedBox(width: AppSizes.spacing16),
        Expanded(child: _buildText(theme, context)),
        _buildCheckIcon(theme),
      ],
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: AppSizes.containerMedium,
      height: AppSizes.containerMedium,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: AppOpacity.subtle)
            : theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      alignment: Alignment.center,
      child: Text(category.emoji, style: const TextStyle(fontSize: AppSizes.emojiLarge)),
    );
  }

  Widget _buildText(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.displayName(context),
          style: TextStyle(
            fontSize: AppSizes.fontLarge,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: AppSizes.spacing4),
        Text(
          category.description(context),
          style: TextStyle(
            fontSize: AppSizes.fontRegular,
            color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckIcon(ThemeData theme) {
    return Icon(
      isSelected ? AppIcons.checkCircleOutline : AppIcons.circle,
      color: isSelected
          ? theme.colorScheme.primary
          : theme.iconTheme.color?.withValues(alpha: AppOpacity.medium),
      size: AppSizes.iconLarge,
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
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
