import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/enums/auth_provider_enum.dart';

class SocialLoginButton extends StatelessWidget {
  final AuthProviderEnum provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isGoogle = provider == AuthProviderEnum.google;
    final bool isApple = provider == AuthProviderEnum.apple;

    Color backgroundColor;
    Color textColor;
    IconData icon;

    if (isGoogle) {
      backgroundColor = AppColors.white;
      textColor = AppColors.black87;
      icon = AppIcons.google;
    } else if (isApple) {
      backgroundColor = AppColors.black;
      textColor = AppColors.white;
      icon = AppIcons.apple;
    } else {
      backgroundColor = theme.colorScheme.surface;
      textColor = theme.colorScheme.onSurface;
      icon = AppIcons.login;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.all(AppSizes.spacing16),
          elevation: AppSizes.elevationLow,
          shadowColor: AppColors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: BorderSide(
              color: isGoogle
                  ? theme.dividerColor.withValues(alpha: AppOpacity.medium)
                  : AppColors.transparent,
              width: AppSizes.borderThin,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              FaIcon(icon, size: AppSizes.iconMedium, color: textColor),
            const SizedBox(width: AppSizes.spacing12),
            Text(
              'auth.continueWith'.tr(
                namedArgs: {'provider': provider.displayName},
              ),
              style: AppTextStyles.baseSemiBold.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
