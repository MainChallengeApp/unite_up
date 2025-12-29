import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/core/constants/app_sizes.dart';
import 'package:unite_up/core/constants/app_text_styles.dart';
import 'package:unite_up/core/constants/app_icons.dart';
import 'package:unite_up/services/supabase_service.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? tokenHash;
  final String? type;

  const ResetPasswordPage({
    super.key,
    this.tokenHash,
    this.type,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isVerifying = true;
  bool _isVerified = false;
  bool _isUpdating = false;
  bool _isSuccess = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyRecoveryToken();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isVerifying) {
      return _buildLoadingState();
    }

    if (!_isVerified) {
      return _buildErrorState();
    }

    if (_isSuccess) {
      return _buildSuccessState();
    }

    return _buildPasswordForm();
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        SizedBox(height: AppSizes.spacing16),
        Text(
          'auth.resetPassword.verifying'.tr(),
          style: AppTextStyles.baseLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline,
          size: AppSizes.iconHuge,
          color: Colors.red,
        ),
        SizedBox(height: AppSizes.spacing16),
        Text(
          'auth.resetPassword.invalidLink'.tr(),
          style: AppTextStyles.baseXXLarge,
          textAlign: TextAlign.center,
        ),
        if (_errorMessage != null) ...[
          SizedBox(height: AppSizes.spacing8),
          Text(
            _errorMessage!,
            style: AppTextStyles.baseSmall,
            textAlign: TextAlign.center,
          ),
        ],
        SizedBox(height: AppSizes.spacing24),
        ElevatedButton(
          onPressed: _navigateToHome,
          child: Text('common.backToHome'.tr()),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: AppSizes.iconHuge,
          color: Colors.green,
        ),
        SizedBox(height: AppSizes.spacing16),
        Text(
          'auth.resetPassword.success'.tr(),
          style: AppTextStyles.baseXXLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacing8),
        Text(
          'auth.resetPassword.successDescription'.tr(),
          style: AppTextStyles.baseMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacing24),
        ElevatedButton(
          onPressed: _navigateToHome,
          child: Text('common.continue'.tr()),
        ),
      ],
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.lock_reset_outlined,
          size: AppSizes.iconHuge,
          color: Colors.blue,
        ),
        SizedBox(height: AppSizes.spacing16),
        Text(
          'auth.resetPassword.title'.tr(),
          style: AppTextStyles.baseXXLarge.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacing8),
        Text(
          'auth.resetPassword.description'.tr(),
          style: AppTextStyles.baseMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacing32),
        CustomTextField(
          controller: _passwordController,
          labelText: 'auth.resetPassword.newPassword'.tr(),
          hintText: 'auth.resetPassword.enterNewPassword'.tr(),
          icon: AppIcons.lock,
          obscureText: !_isPasswordVisible,
          suffixIcon:
              _isPasswordVisible ? AppIcons.visibilityOff : AppIcons.visibility,
          onSuffixIconPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
          alwaysShowSuffixIcon: true,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSizes.spacing16),
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'auth.resetPassword.confirmPassword'.tr(),
          hintText: 'auth.resetPassword.confirmNewPassword'.tr(),
          icon: AppIcons.lock,
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: _isConfirmPasswordVisible
              ? AppIcons.visibilityOff
              : AppIcons.visibility,
          onSuffixIconPressed: () {
            setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
          },
          alwaysShowSuffixIcon: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _updatePassword(),
        ),
        SizedBox(height: AppSizes.spacing24),
        FilledButton(
          onPressed: _isUpdating ? null : _updatePassword,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, AppSizes.size52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),
          child: _isUpdating
              ? const SizedBox(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('auth.resetPassword.updatePassword'.tr()),
        ),
      ],
    );
  }

  Future<void> _verifyRecoveryToken() async {
    final tokenHash = widget.tokenHash;
    final type = widget.type;

    if (tokenHash == null || tokenHash.isEmpty || type != 'recovery') {
      setState(() {
        _isVerifying = false;
        _isVerified = false;
        _errorMessage = 'auth.resetPassword.invalidLink'.tr();
      });
      return;
    }

    try {
      final response = await SupabaseService.client.auth.verifyOTP(
        tokenHash: tokenHash,
        type: OtpType.recovery,
      );

      if (response.session != null) {
        setState(() {
          _isVerifying = false;
          _isVerified = true;
        });
      } else {
        setState(() {
          _isVerifying = false;
          _isVerified = false;
          _errorMessage = 'auth.resetPassword.linkExpired'.tr();
        });
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _isVerified = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _updatePassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('auth.resetPassword.fillAllFields'.tr());
      return;
    }

    if (password.length < 6) {
      _showSnackBar('auth.resetPassword.passwordTooShort'.tr());
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('auth.resetPassword.passwordsDoNotMatch'.tr());
      return;
    }

    setState(() => _isUpdating = true);

    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: password),
      );
      setState(() => _isSuccess = true);
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _navigateToHome() {
    context.go('/');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

