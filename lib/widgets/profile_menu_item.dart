import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/widgets/app_card_container.dart';
import 'package:flutter/material.dart';

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

    return AppCardContainer(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                Container(
                  width: AppSizes.containerSmall,
                  height: AppSizes.containerSmall,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(
                      alpha: AppOpacity.light,
                    ),
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
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.mostlyOpaque,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  AppIcons.arrowForward,
                  size: AppSizes.iconSmall,
                  color: theme.iconTheme.color?.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
