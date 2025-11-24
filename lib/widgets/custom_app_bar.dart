import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(AppIcons.arrowBack),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      automaticallyImplyLeading: false,
      title:
          titleWidget ??
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.fontXLarge,
            ),
          ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
