import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final int? maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? theme.cardColor
            : theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide.none,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSmall,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: AppSizes.spacing8),
            Text(labelText),
          ],
        ),
        floatingLabelStyle: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}

