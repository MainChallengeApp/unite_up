import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_text_styles.dart';

class EmailConfirmedSuccessfullyPage extends StatelessWidget {
  const EmailConfirmedSuccessfullyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'auth.emailConfirmedSuccessfully'.tr(),
              style: AppTextStyles.baseXXLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
