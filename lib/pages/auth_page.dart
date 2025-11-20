import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> _handleEmailAuth() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    if (!_isLoginMode && _nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await appState.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _showSnackBar('Successfully logged in!');
      } else {
        await appState.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
        _showSnackBar('Account created successfully!');
      }

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isGoogleLoading = true);

    try {
      await appState.signInWithGoogle();
      _showSnackBar('Signed in with Google!');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isAppleLoading = true);

    try {
      await appState.signInWithApple();
      _showSnackBar('Signed in with Apple!');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
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
}
