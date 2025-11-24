import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/widgets/app_card_container.dart';

class SettingsCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isFirst;
  final bool isLast;
  final Color? titleColor;
  final Color? backgroundColor;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isFirst = false,
    this.isLast = false,
    this.titleColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitleColor =
        titleColor ??
        (theme.brightness == Brightness.dark
            ? AppColors.white
            : AppColors.darkSurface);

    return AppCardContainer(
      backgroundColor: backgroundColor,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isFirst
                ? const Radius.circular(AppSizes.radiusLarge)
                : Radius.zero,
            bottom: isLast
                ? const Radius.circular(AppSizes.radiusLarge)
                : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                icon,
                const SizedBox(width: AppSizes.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.largeSemiBold.copyWith(
                          color: effectiveTitleColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSizes.spacing2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.regularSecondary(context),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
