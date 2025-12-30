import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('auth.forgotPassword.title'.tr()),
      content: _emailSent ? _buildSuccessContent() : _buildFormContent(),
      actions: _emailSent ? _buildSuccessActions() : _buildFormActions(),
    );
  }

  Widget _buildFormContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.forgotPassword.description'.tr(),
          style: AppTextStyles.baseMedium,
        ),
        SizedBox(height: AppSizes.spacing16),
        CustomTextField(
          controller: _emailController,
          labelText: 'auth.fields.email'.tr(),
          hintText: 'auth.fields.enterEmail'.tr(),
          icon: AppIcons.email,
          keyboardType: TextInputType.emailAddress,
          isRemoveTextVisible: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _sendResetEmail(),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: AppSizes.iconHuge,
          color: Colors.green,
        ),
        SizedBox(height: AppSizes.spacing16),
        Text(
          'auth.forgotPassword.emailSent'.tr(),
          style: AppTextStyles.baseLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacing8),
        Text(
          'auth.forgotPassword.checkInbox'.tr(
            namedArgs: {'email': _emailController.text.trim()},
          ),
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
        onPressed: _isLoading ? null : _sendResetEmail,
        child: _isLoading
            ? SizedBox(
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text('auth.forgotPassword.sendLink'.tr()),
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

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('auth.forgotPassword.enterEmail'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Provider.of<UsersProvider>(
        context,
        listen: false,
      ).sendPasswordResetEmail(email);
      setState(() => _emailSent = true);
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
