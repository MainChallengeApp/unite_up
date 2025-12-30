import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/dialogs/forgot_password_dialog.dart';
import 'package:unite_up/pages/confirm_email_page.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoginMode = false;
  bool _isLoading = false;
  // TODO: Re-enable when Google/Apple login is configured
  // bool _isGoogleLoading = false;
  // bool _isAppleLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late final _userProvider = Provider.of<UsersProvider>(context, listen: false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      isLoginMode: _isLoginMode,
      nameController: _usernameController,
      emailController: _emailController,
      passwordController: _passwordController,
      onSubmit: _handleEmailAuth,
      onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
      // TODO: Re-enable when Google/Apple login is configured
      // onGoogleSignIn: _handleGoogleSignIn,
      // onAppleSignIn: _handleAppleSignIn,
      onForgotPassword: _handleForgotPassword,
      isLoading: _isLoading,
      // isGoogleLoading: _isGoogleLoading,
      // isAppleLoading: _isAppleLoading,
    );
  }

  Future<void> _handleEmailAuth() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('auth.pleaseFillAllFields'.tr());
      return;
    }

    final username = _usernameController.text.trim();

    if (!_isLoginMode && username.isEmpty) {
      _showSnackBar('auth.pleaseEnterUsername'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _userProvider.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _showSnackBar('auth.loginSuccess'.tr());
        // Trigger iOS/Android password manager to save credentials
        // Must be called while fields still have values
        TextInput.finishAutofillContext(shouldSave: true);
      } else {
        // Check if username is available
        final isAvailable = await _userProvider.isUsernameAvailable(username);
        if (!isAvailable) {
          _showSnackBar('auth.usernameTaken'.tr());
          setState(() => _isLoading = false);
          return;
        }

        await _userProvider.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: username,
        );
        _showSnackBar('auth.accountCreatedSuccess'.tr());
        // Trigger iOS/Android password manager to save credentials
        // Must be called while fields still have values
        TextInput.finishAutofillContext(shouldSave: true);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConfirmEmailPage()),
          );
        }
      }

      // Clear fields after autofill context is finished
      _emailController.clear();
      _passwordController.clear();
      _usernameController.clear();
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // TODO: Re-enable when Google/Apple login is configured
  // Future<void> _handleGoogleSignIn() async {
  //   setState(() => _isGoogleLoading = true);
  //
  //   try {
  //     await _userProvider.signInWithGoogle();
  //     _showSnackBar('auth.signedInWithGoogle'.tr());
  //   } catch (e) {
  //     _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
  //   } finally {
  //     if (mounted) setState(() => _isGoogleLoading = false);
  //   }
  // }
  //
  // Future<void> _handleAppleSignIn() async {
  //   setState(() => _isAppleLoading = true);
  //
  //   try {
  //     await _userProvider.signInWithApple();
  //     _showSnackBar('auth.signedInWithApple'.tr());
  //   } catch (e) {
  //     _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
  //   } finally {
  //     if (mounted) setState(() => _isAppleLoading = false);
  //   }
  // }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => const ForgotPasswordDialog(),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
