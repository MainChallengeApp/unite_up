import 'package:dare_u/enums/auth_provider_enum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButton extends StatelessWidget {
  final AuthProviderEnum provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isGoogle = provider == AuthProviderEnum.google;
    final bool isApple = provider == AuthProviderEnum.apple;

    Color backgroundColor;
    Color textColor;
    IconData icon;

    if (isGoogle) {
      backgroundColor = Colors.white;
      textColor = Colors.black87;
      icon = FontAwesomeIcons.google;
    } else if (isApple) {
      backgroundColor = Colors.black;
      textColor = Colors.white;
      icon = FontAwesomeIcons.apple;
    } else {
      backgroundColor = theme.colorScheme.surface;
      textColor = theme.colorScheme.onSurface;
      icon = Icons.login;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isGoogle
                  ? theme.dividerColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              FaIcon(icon, size: 20, color: textColor),
            const SizedBox(width: 12),
            Text(
              'Continue with ${provider.displayName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
