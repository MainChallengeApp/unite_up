import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      isLoginMode: _isLoginMode,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      onSubmit: _handleEmailAuth,
      onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
      onGoogleSignIn: _handleGoogleSignIn,
      onAppleSignIn: _handleAppleSignIn,
      isLoading: _isLoading,
      isGoogleLoading: _isGoogleLoading,
      isAppleLoading: _isAppleLoading,
    );
  }

  Future<void> _handleEmailAuth() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('auth.pleaseFillAllFields'.tr());
      return;
    }

    if (!_isLoginMode && _nameController.text.isEmpty) {
      _showSnackBar('auth.pleaseEnterName'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await usersProvider.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _showSnackBar('auth.loginSuccess'.tr());
      } else {
        await usersProvider.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
        _showSnackBar('auth.accountCreatedSuccess'.tr());
      }

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    setState(() => _isGoogleLoading = true);

    try {
      await usersProvider.signInWithGoogle();
      _showSnackBar('auth.signedInWithGoogle'.tr());
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    setState(() => _isAppleLoading = true);

    try {
      await usersProvider.signInWithApple();
      _showSnackBar('auth.signedInWithApple'.tr());
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
