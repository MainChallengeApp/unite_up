import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/core/constants/app_sizes.dart';
import 'package:unite_up/core/constants/app_text_styles.dart';
import 'package:unite_up/services/supabase_service.dart';

class EmailConfirmedSuccessfullyPage extends StatefulWidget {
  final String? tokenHash;
  final String? type;

  const EmailConfirmedSuccessfullyPage({
    super.key,
    this.tokenHash,
    this.type,
  });

  @override
  State<EmailConfirmedSuccessfullyPage> createState() =>
      _EmailConfirmedSuccessfullyPageState();
}

class _EmailConfirmedSuccessfullyPageState
    extends State<EmailConfirmedSuccessfullyPage> {
  bool _isLoading = true;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    final tokenHash = widget.tokenHash;
    final type = widget.type;

    if (tokenHash == null || tokenHash.isEmpty) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _errorMessage = 'auth.invalidConfirmationLink'.tr();
      });
      return;
    }

    try {
      final response = await SupabaseService.client.auth.verifyOTP(
        tokenHash: tokenHash,
        type: _getOtpType(type),
      );

      if (response.session != null) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
          _errorMessage = 'auth.emailConfirmationFailed'.tr();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _errorMessage = e.toString();
      });
    }
  }

  OtpType _getOtpType(String? type) {
    switch (type) {
      case 'signup':
        return OtpType.signup;
      case 'recovery':
        return OtpType.recovery;
      case 'email_change':
        return OtpType.emailChange;
      case 'email':
      default:
        return OtpType.email;
    }
  }

  void _navigateToHome() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: AppSizes.spacing16),
          Text(
            'auth.verifyingEmail'.tr(),
            style: AppTextStyles.baseLarge,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (_isSuccess) {
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
            'auth.emailConfirmedSuccessfully'.tr(),
            style: AppTextStyles.baseXXLarge,
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
          'auth.emailConfirmationFailed'.tr(),
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
}
