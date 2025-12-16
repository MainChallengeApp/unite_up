import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_text_styles.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';

class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(title: 'profile.title'.tr(), showBackButton: true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'auth.confirmEmail'.tr()}:\n${userProvider.currentSupabaseUser?.email ?? ''}',
              style: AppTextStyles.baseXXLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
