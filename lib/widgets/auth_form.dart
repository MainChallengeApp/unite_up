import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/enums/auth_provider_enum.dart';
import 'package:unite_up/widgets/custom_text_field.dart';
import 'package:unite_up/widgets/social_login_button.dart';

class AuthForm extends StatefulWidget {
  final bool isLoginMode;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;

  const AuthForm({
    super.key,
    required this.isLoginMode,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onToggleMode,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isPasswordVisible = false;

  @override
  void didUpdateWidget(AuthForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset password visibility when switching between login and signup modes
    if (oldWidget.isLoginMode != widget.isLoginMode) {
      setState(() {
        _isPasswordVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSizes.spacing32),
          _buildTitle(),
          const SizedBox(height: AppSizes.spacing32),
          _buildSocialLoginButtons(),
          const SizedBox(height: AppSizes.spacing16),
          _buildDivider(),
          const SizedBox(height: AppSizes.spacing16),
          if (!widget.isLoginMode) ...[
            _buildNameField(),
            const SizedBox(height: AppSizes.spacing16),
          ],
          _buildEmailField(),
          const SizedBox(height: AppSizes.spacing16),
          _buildPasswordField(),
          const SizedBox(height: AppSizes.spacing24),
          _buildSubmitButton(),
          const SizedBox(height: AppSizes.spacing24),
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: widget.nameController,
      labelText: 'auth.fields.fullName'.tr(),
      hintText: 'auth.fields.enterFullName'.tr(),
      icon: AppIcons.personOutline,
      textCapitalization: TextCapitalization.words,
      isRemoveTextVisible: true,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: widget.emailController,
      labelText: 'auth.fields.email'.tr(),
      hintText: 'auth.fields.enterEmail'.tr(),
      icon: AppIcons.email,
      keyboardType: TextInputType.emailAddress,
      isRemoveTextVisible: true,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: widget.passwordController,
      labelText: 'auth.fields.password'.tr(),
      hintText: 'auth.fields.enterPassword'.tr(),
      icon: AppIcons.lock,
      obscureText: !_isPasswordVisible,
      suffixIcon: _isPasswordVisible
          ? AppIcons.visibilityOff
          : AppIcons.visibility,
      onSuffixIconPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      alwaysShowSuffixIcon: true,
    );
  }

  Widget _buildSubmitButton() {
    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: AppSizes.size52,
        child: FilledButton(
          onPressed: widget.isLoading ? null : widget.onSubmit,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  widget.isLoginMode
                      ? 'auth.signIn'.tr()
                      : 'auth.createAccount'.tr(),
                  style: const TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
          child: Text('or', style: TextStyle(fontSize: AppSizes.fontMedium)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        if (widget.onGoogleSignIn != null)
          SocialLoginButton(
            provider: AuthProviderEnum.google,
            onPressed: widget.onGoogleSignIn!,
            isLoading: widget.isGoogleLoading,
          ),
        const SizedBox(height: AppSizes.spacing12),
        if (widget.onAppleSignIn != null)
          SocialLoginButton(
            provider: AuthProviderEnum.apple,
            onPressed: widget.onAppleSignIn!,
            isLoading: widget.isAppleLoading,
          ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Builder(
      builder: (context) => TextButton(
        onPressed: widget.onToggleMode,
        child: Text(
          widget.isLoginMode
              ? 'auth.dontHaveAccount'.tr()
              : 'auth.alreadyHaveAccount'.tr(),
        ),
      ),
    );
  }

  _buildTitle() {
    return Center(
      child: Text(
        widget.isLoginMode
            ? 'auth.welcomeBack'.tr()
            : 'auth.createYourNewAccount'.tr(),
        style: const TextStyle(
          fontSize: AppSizes.fontHuge,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
