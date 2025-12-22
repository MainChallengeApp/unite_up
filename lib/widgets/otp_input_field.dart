import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unite_up/core/constants/app_constants.dart';

/// A widget for entering OTP (One-Time Password) verification codes.
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
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: AppSizes.containerSmall,
          height: AppSizes.containerMedium,
          margin: EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: AppTextStyles.xxLargeSemiBold,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: AppSizes.borderThick,
                ),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _onDigitChanged(index, value),
          ),
        );
      }),
    );
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus and check completion
        _focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field on delete
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _notifyChanges();
  }

  void _notifyChanges() {
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);

    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }
}

