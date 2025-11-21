import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class UploadSelectionSheet extends StatelessWidget {
  const UploadSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLarge),
          topRight: Radius.circular(AppSizes.radiusLarge),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(alpha: AppOpacity.semiTransparent),
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
                ),
              ),
              const SizedBox(height: AppSizes.spacing24),
              _buildUploadOption(
                context: context,
                icon: AppIcons.image,
                label: 'chat.uploadImage'.tr(),
                color: theme.colorScheme.primary,
                onTap: () {
                  Navigator.pop(context, 'image');
                },
              ),
              const SizedBox(height: AppSizes.spacing12),
              _buildUploadOption(
                context: context,
                icon: AppIcons.video,
                label: 'chat.uploadVideo'.tr(),
                color: theme.colorScheme.secondary,
                onTap: () {
                  Navigator.pop(context, 'video');
                },
              ),
              const SizedBox(height: AppSizes.spacing12),
              _buildUploadOption(
                context: context,
                icon: AppIcons.audio,
                label: 'chat.uploadAudio'.tr(),
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context, 'audio');
                },
              ),
              const SizedBox(height: AppSizes.spacing12),
              _buildUploadOption(
                context: context,
                icon: AppIcons.file,
                label: 'chat.uploadFile'.tr(),
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context, 'file');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          child: Row(
            children: [
              Container(
                width: AppSizes.containerSmall,
                height: AppSizes.containerSmall,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: AppOpacity.light),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppSizes.iconMedium,
                  color: color,
                ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w500,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

