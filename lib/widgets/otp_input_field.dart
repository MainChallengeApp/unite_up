import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unite_up/core/constants/app_constants.dart';

/// A widget for entering OTP (One-Time Password) verification codes.
/// Supports both typing individual digits and pasting the full code.
class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boxWidth = AppSizes.containerSmall;
    final totalWidth = (boxWidth + AppSizes.spacing4 * 2) * widget.length;

    return SizedBox(
      width: totalWidth,
      height: AppSizes.containerMedium,
      child: Stack(
        children: [
          // Visible digit boxes (behind)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final hasValue = index < _controller.text.length;
              final isActive =
                  _focusNode.hasFocus && index == _controller.text.length;

              return AnimatedContainer(
                duration: AppDurations.animationFast,
                width: boxWidth,
                height: AppSizes.containerMedium,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: isActive
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: AppSizes.borderThick,
                  ),
                ),
                child: Center(
                  child: Text(
                    hasValue ? _controller.text[index] : '',
                    style: AppTextStyles.xxLargeSemiBold,
                  ),
                ),
              );
            }),
          ),
          // Invisible TextField on top for input and paste support
          Positioned.fill(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              autofocus: false,
              enableSuggestions: false,
              autocorrect: false,
              showCursor: false,
              style: const TextStyle(color: Colors.transparent),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                fillColor: Colors.transparent,
                filled: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              onChanged: _onTextChanged,
            ),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String value) {
    setState(() {});

    widget.onChanged?.call(value);

    if (value.length == widget.length) {
      _focusNode.unfocus();
      widget.onCompleted(value);
    }
  }
}
