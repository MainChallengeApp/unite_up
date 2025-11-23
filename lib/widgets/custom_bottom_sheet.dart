import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class BottomSheetOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const BottomSheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final List<BottomSheetOption> options;

  const CustomBottomSheet({super.key, this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXLarge),
          topRight: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.spacing12),
            // Drag handle
            Container(
              width: AppSizes.containerSmall,
              height: AppSizes.spacing4,
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: AppOpacity.medium),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
            const SizedBox(height: AppSizes.spacing24),
            // Optional title
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                ),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: AppSizes.fontXLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing16),
            ],
            // Scrollable options
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...options.map((option) => _buildOption(context, option)),
                    const SizedBox(height: AppSizes.spacing16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, BottomSheetOption option) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing4,
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: InkWell(
          onTap: option.onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing8),
                  decoration: BoxDecoration(
                    color: option.color.withValues(alpha: AppOpacity.light),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color,
                    size: AppSizes.iconMedium,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing16),
                Text(
                  option.label,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w500,
                    color: option.color == Colors.red ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
