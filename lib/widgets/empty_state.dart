import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.containerLarge,
            height: AppSizes.containerLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppSizes.iconXXLarge, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: AppSizes.spacing24),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.fontXXLarge,
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
            ),
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: AppSizes.spacing32),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                elevation: AppSizes.elevationNone,
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
