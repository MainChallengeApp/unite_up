import 'package:flutter/material.dart';
import 'package:dare_u/core/constants/app_constants.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppOpacity.veryLight),
                blurRadius: AppSizes.blurMedium,
                offset: AppSizes.shadowOffsetSmall,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.containerSmall,
                height: AppSizes.containerSmall,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppSizes.fontRegular,
                        color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppSizes.iconSmall,
                color: theme.iconTheme.color?.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

