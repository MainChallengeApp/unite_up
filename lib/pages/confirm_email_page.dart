import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/otp_input_field.dart';

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  bool _isVerifying = false;
  bool _isResending = false;
  String _otpCode = '';
  int _resendCooldown = 0;

  late final _userProvider = Provider.of<UsersProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = _userProvider.currentSupabaseUser?.email ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'auth.confirmEmail'.tr(),
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.spacing32),
              _buildEmailIcon(theme),
              const SizedBox(height: AppSizes.spacing24),
              _buildTitle(),
              const SizedBox(height: AppSizes.spacing12),
              _buildSubtitle(email),
              const SizedBox(height: AppSizes.spacing32),
              OtpInputField(
                length: 6,
                onCompleted: _handleOtpCompleted,
                onChanged: (value) => setState(() => _otpCode = value),
              ),
              const SizedBox(height: AppSizes.spacing32),
              _buildVerifyButton(),
              const SizedBox(height: AppSizes.spacing24),
              _buildResendSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailIcon(ThemeData theme) {
    return Container(
      width: AppSizes.containerHuge,
      height: AppSizes.containerHuge,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          AppIcons.markEmailUnread,
          size: AppSizes.iconHuge,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'auth.verifyYourEmail'.tr(),
      style: AppTextStyles.baseHuge.copyWith(fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String email) {
    return Text(
      'auth.verificationCodeSent'.tr(namedArgs: {'email': email}),
      style: AppTextStyles.baseMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.size52,
      child: FilledButton(
        onPressed: _otpCode.length == 6 && !_isVerifying
            ? () => _handleOtpCompleted(_otpCode)
            : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
        child: _isVerifying
            ? const SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text('auth.verifyEmail'.tr(), style: AppTextStyles.largeSemiBold),
      ),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          'auth.didntReceiveCode'.tr(),
          style: AppTextStyles.baseMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.spacing8),
        _resendCooldown > 0
            ? Text(
                'auth.resendCodeIn'.tr(
                  namedArgs: {'seconds': _resendCooldown.toString()},
                ),
                style: AppTextStyles.baseMedium.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : TextButton(
                onPressed: _isResending ? null : _handleResendOtp,
                child: _isResending
                    ? const SizedBox(
                        width: AppSizes.iconMedium,
                        height: AppSizes.iconMedium,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('auth.resendCode'.tr()),
              ),
      ],
    );
  }

  Future<void> _handleOtpCompleted(String otp) async {
    final email = _userProvider.currentSupabaseUser?.email;
    if (email == null || email.isEmpty) {
      _showSnackBar('auth.emailNotFound'.tr());
      return;
    }

    setState(() => _isVerifying = true);

    try {
      await _userProvider.verifyEmailOtp(email: email, token: otp);
      if (mounted) {
        _showSnackBar('auth.emailVerifiedSuccess'.tr());
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _handleResendOtp() async {
    final email = _userProvider.currentSupabaseUser?.email;
    if (email == null || email.isEmpty) {
      _showSnackBar('auth.emailNotFound'.tr());
      return;
    }

    setState(() => _isResending = true);

    try {
      await _userProvider.resendSignupOtp(email);
      _showSnackBar('auth.codeSentAgain'.tr());
      _startResendCooldown();
    } catch (e) {
      _showSnackBar('${'common.error'.tr()}: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _startResendCooldown() {
    const cooldownSeconds = 60;
    setState(() => _resendCooldown = cooldownSeconds);

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() => _resendCooldown--);
      return _resendCooldown > 0;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
