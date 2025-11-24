import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool alwaysShowSuffixIcon;
  final bool isCounterVisible;
  final bool isRemoveTextVisible;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.alwaysShowSuffixIcon = false,
    this.isCounterVisible = true,
    this.isRemoveTextVisible = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hasText = false;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
      _hasText = widget.controller.text.isNotEmpty;
    } else {
      // Update state in case text changed externally
      final hasText = widget.controller.text.isNotEmpty;
      if (_hasText != hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showClearIcon = widget.isRemoveTextVisible && _hasText;
    final bool showCustomSuffixIcon =
        !showClearIcon &&
        widget.suffixIcon != null &&
        (widget.alwaysShowSuffixIcon || _hasText);
    final bool showSuffixIcon = showClearIcon || showCustomSuffixIcon;

    return TextField(
      controller: widget.controller,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: _theme.brightness == Brightness.dark
            ? _theme.cardColor
            : _theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide.none,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: AppSizes.iconSmall,
              color: _theme.colorScheme.onSurface,
            ),
            const SizedBox(width: AppSizes.spacing8),
            Text(widget.labelText),
          ],
        ),
        floatingLabelStyle: AppTextStyles.baseBase.copyWith(
          color: _theme.colorScheme.onSurface,
        ),
        alignLabelWithHint: true,
        suffixIcon: showSuffixIcon
            ? IconButton(
                icon: Icon(
                  showClearIcon ? Icons.clear : widget.suffixIcon,
                  color: _theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: showClearIcon
                    ? _clearText
                    : widget.onSuffixIconPressed,
              )
            : null,
        counterText: widget.isCounterVisible ? null : '',
        counterStyle: AppTextStyles.baseSmall.copyWith(
          color: _theme.iconTheme.color?.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearText() {
    widget.controller.clear();
  }
}
