import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class ChangeEmailDialog extends StatefulWidget {
  final String currentEmail;

  const ChangeEmailDialog({super.key, required this.currentEmail});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  late TextEditingController _emailController;

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('settings.changeEmail.title'.tr()),
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
          'settings.changeEmail.description'.tr(),
          style: AppTextStyles.baseMedium,
        ),
        const SizedBox(height: AppSizes.spacing16),
        CustomTextField(
          controller: _emailController,
          labelText: 'settings.changeEmail.newEmail'.tr(),
          hintText: 'settings.changeEmail.newEmailHint'.tr(),
          icon: AppIcons.email,
          keyboardType: TextInputType.emailAddress,
          isRemoveTextVisible: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _changeEmail(),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          AppIcons.markEmailUnread,
          size: AppSizes.iconHuge,
          color: AppColors.green,
        ),
        const SizedBox(height: AppSizes.spacing16),
        Text(
          'settings.changeEmail.emailSent'.tr(),
          style: AppTextStyles.baseLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spacing8),
        Text(
          'settings.changeEmail.checkInbox'.tr(
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
        onPressed: _isLoading ? null : _changeEmail,
        child: _isLoading
            ? SizedBox(
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text('settings.changeEmail.sendConfirmation'.tr()),
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

  Future<void> _changeEmail() async {
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty) {
      _showSnackBar('settings.changeEmail.enterEmail'.tr());
      return;
    }

    if (newEmail == widget.currentEmail) {
      _showSnackBar('settings.changeEmail.sameEmail'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Provider.of<UsersProvider>(
        context,
        listen: false,
      ).updateEmail(newEmail);
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

