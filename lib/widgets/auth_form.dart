import 'package:dare_u/enums/auth_provider_enum.dart';
import 'package:dare_u/widgets/social_login_button.dart';
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          _buildAvatar(theme),
          const SizedBox(height: 32),
          _buildTitle(theme),
          const SizedBox(height: 8),
          _buildSubtitle(theme),
          const SizedBox(height: 40),
          if (onGoogleSignIn != null) ...[
            SocialLoginButton(
              provider: AuthProviderEnum.google,
              onPressed: onGoogleSignIn!,
              isLoading: isGoogleLoading,
            ),
            const SizedBox(height: 12),
          ],
          if (onAppleSignIn != null) ...[
            SocialLoginButton(
              provider: AuthProviderEnum.apple,
              onPressed: onAppleSignIn!,
              isLoading: isAppleLoading,
            ),
            const SizedBox(height: 24),
          ],
          if (onGoogleSignIn != null || onAppleSignIn != null) ...[
            _buildDivider(theme),
            const SizedBox(height: 24),
          ],
          if (!isLoginMode) ...[_buildNameField(), const SizedBox(height: 16)],
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildSubmitButton(theme),
          const SizedBox(height: 16),
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 40,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      isLoginMode ? 'Welcome Back!' : 'Create Account',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: theme.brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Text(
      isLoginMode
          ? 'Sign in to continue your journey'
          : 'Start your improvement journey today',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: theme.iconTheme.color?.withOpacity(0.6),
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(Icons.person_outline_rounded),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(Icons.lock_outline_rounded),
      ),
      obscureText: true,
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isLoginMode ? 'Sign In' : 'Create Account',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: onToggleMode,
      child: Text(
        isLoginMode
            ? 'Don\'t have an account? Sign Up'
            : 'Already have an account? Sign In',
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: theme.iconTheme.color?.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.dividerColor)),
      ],
    );
  }
}
