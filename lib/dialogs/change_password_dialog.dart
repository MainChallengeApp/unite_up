import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/services/supabase_service.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  final String currentEmail;

  const ChangePasswordDialog({super.key, required this.currentEmail});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('settings.changePassword.title'.tr()),
      content: _isSuccess ? _buildSuccessContent() : _buildFormContent(),
      actions: _isSuccess ? _buildSuccessActions() : _buildFormActions(),
    );
  }

  Widget _buildFormContent() {
    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings.changePassword.description'.tr(),
            style: AppTextStyles.baseMedium,
          ),
          const SizedBox(height: AppSizes.spacing16),
          // Hidden email field for password manager to identify the account
          Visibility(
            visible: false,
            child: TextField(
              controller: _emailController,
              readOnly: true,
              autofillHints: const [AutofillHints.username],
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          CustomTextField(
            controller: _passwordController,
            labelText: 'settings.changePassword.newPassword'.tr(),
            hintText: 'settings.changePassword.newPasswordHint'.tr(),
            icon: AppIcons.lock,
            obscureText: !_isPasswordVisible,
            suffixIcon: _isPasswordVisible
                ? AppIcons.visibilityOff
                : AppIcons.visibility,
            onSuffixIconPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
            alwaysShowSuffixIcon: true,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: AppSizes.spacing16),
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'settings.changePassword.confirmPassword'.tr(),
            hintText: 'settings.changePassword.confirmPasswordHint'.tr(),
            icon: AppIcons.lock,
            obscureText: !_isConfirmPasswordVisible,
            suffixIcon: _isConfirmPasswordVisible
                ? AppIcons.visibilityOff
                : AppIcons.visibility,
            onSuffixIconPressed: () {
              setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              );
            },
            alwaysShowSuffixIcon: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _changePassword(),
            autofillHints: const [AutofillHints.newPassword],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          AppIcons.checkCircle,
          size: AppSizes.iconHuge,
          color: AppColors.green,
        ),
        const SizedBox(height: AppSizes.spacing16),
        Text(
          'settings.changePassword.success'.tr(),
          style: AppTextStyles.baseLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spacing8),
        Text(
          'settings.changePassword.successDescription'.tr(),
          style: AppTextStyles.baseSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildFormActions() {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('common.cancel'.tr()),
      ),
      FilledButton(
        onPressed: _isLoading ? null : _changePassword,
        child: _isLoading
            ? SizedBox(
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text('settings.changePassword.update'.tr()),
      ),
    ];
  }

  List<Widget> _buildSuccessActions() {
    return [
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: Text('common.done'.tr()),
      ),
    ];
  }

  Future<void> _changePassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('settings.changePassword.fillAllFields'.tr());
      return;
    }

    if (password.length < 6) {
      _showSnackBar('settings.changePassword.passwordTooShort'.tr());
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('settings.changePassword.passwordsDoNotMatch'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: password),
      );
      // Notify password manager to save the new credentials
      TextInput.finishAutofillContext();
      setState(() => _isSuccess = true);
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
