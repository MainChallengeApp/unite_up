import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/providers/users_provider.dart';

class DeleteUserDialog extends StatefulWidget {
  const DeleteUserDialog({super.key});

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('settings.account.deleteAccount'.tr()),
      content: Text('settings.account.deleteAccountConfirmation'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => _deleteChallenge(context),
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          child: _isLoading
              ? CircularProgressIndicator(
                  constraints: BoxConstraints.expand(
                    width: AppSizes.iconSmall,
                    height: AppSizes.iconSmall,
                  ),
                )
              : Text('settings.account.deleteAccountConfirmationButton'.tr()),
        ),
      ],
    );
  }

  void _deleteChallenge(BuildContext context) async {
    if (_isLoading) return;
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<UsersProvider>(context, listen: false).deleteAccount();
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('settings.account.success'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Error catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
