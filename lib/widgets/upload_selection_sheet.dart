import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/widgets/custom_bottom_sheet.dart';

class UploadSelectionSheet extends StatelessWidget {
  const UploadSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomBottomSheet(
      options: [
        BottomSheetOption(
          icon: AppIcons.add,
          label: 'goals.createGoal'.tr(),
          color: theme.colorScheme.primary,
          onTap: () {
            Navigator.pop(context, 'create_goal');
          },
        ),
        BottomSheetOption(
          icon: AppIcons.flag,
          label: 'goals.updateProgress'.tr(),
          color: AppColors.purple,
          onTap: () {
            Navigator.pop(context, 'goal_progress');
          },
        ),
        // BottomSheetOption(
        //   icon: AppIcons.image,
        //   label: 'chat.uploadImage'.tr(),
        //   color: theme.colorScheme.secondary,
        //   onTap: () {
        //     Navigator.pop(context, 'image');
        //   },
        // ),
        // BottomSheetOption(
        //   icon: AppIcons.video,
        //   label: 'chat.uploadVideo'.tr(),
        //   color: theme.colorScheme.secondary,
        //   onTap: () {
        //     Navigator.pop(context, 'video');
        //   },
        // ),
        // BottomSheetOption(
        //   icon: AppIcons.audio,
        //   label: 'chat.uploadAudio'.tr(),
        //   color: AppColors.orange,
        //   onTap: () {
        //     Navigator.pop(context, 'audio');
        //   },
        // ),
        // BottomSheetOption(
        //   icon: AppIcons.file,
        //   label: 'chat.uploadFile'.tr(),
        //   color: AppColors.green,
        //   onTap: () {
        //     Navigator.pop(context, 'file');
        //   },
        // ),
      ],
    );
  }
}
