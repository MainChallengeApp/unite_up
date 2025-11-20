import 'package:dare_u/enums/auth_provider_enum.dart';
import 'package:dare_u/widgets/social_login_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          _buildSocialLoginButtons(),
          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 16),
          if (!isLoginMode) ...[_buildNameField(), const SizedBox(height: 16)],
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildSubmitButton(Theme.of(context)),
          const SizedBox(height: 24),
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Builder(
      builder: (context) => TextField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'auth.fields.fullName'.tr(),
          hintText: 'auth.fields.enterFullName'.tr(),
          prefixIcon: const Icon(Icons.person_outline_rounded),
        ),
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  Widget _buildEmailField() {
    return Builder(
      builder: (context) => TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'auth.fields.email'.tr(),
          hintText: 'auth.fields.enterEmail'.tr(),
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Builder(
      builder: (context) => TextField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'auth.fields.password'.tr(),
          hintText: 'auth.fields.enterPassword'.tr(),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: isLoading ? null : onSubmit,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  isLoginMode ? 'auth.signIn'.tr() : 'auth.createAccount'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(fontSize: 14)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        if (onGoogleSignIn != null)
          SocialLoginButton(
            provider: AuthProviderEnum.google,
            onPressed: onGoogleSignIn!,
            isLoading: isGoogleLoading,
          ),
        const SizedBox(height: 12),
        if (onAppleSignIn != null)
          SocialLoginButton(
            provider: AuthProviderEnum.apple,
            onPressed: onAppleSignIn!,
            isLoading: isAppleLoading,
          ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Builder(
      builder: (context) => TextButton(
        onPressed: onToggleMode,
        child: Text(
          isLoginMode
              ? 'auth.dontHaveAccount'.tr()
              : 'auth.alreadyHaveAccount'.tr(),
        ),
      ),
    );
  }
}
