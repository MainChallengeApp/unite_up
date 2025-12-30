import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_text_field.dart';

class EditUserDialog extends StatefulWidget {
  final UserModel user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _displayNameController;
  late TextEditingController _usernameController;
  // late TextEditingController _bioController;

  bool _isLoading = false;
  String? _usernameError;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.user.displayName ?? '',
    );
    _usernameController = TextEditingController(text: widget.user.username);
    // _bioController = TextEditingController(text: widget.user.bio ?? '');

    // Listen for username changes to enforce lowercase and valid characters
    _usernameController.addListener(_formatUsername);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_formatUsername);
    _displayNameController.dispose();
    _usernameController.dispose();
    // _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(AppIcons.edit, color: _theme.colorScheme.primary),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Text(
              'settings.editProfile.title'.tr(),
              style: AppTextStyles.largeSemiBold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: AppSizes.dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDisplayNameField(),
              const SizedBox(height: AppSizes.spacing16),
              _buildUsernameField(),
              if (_usernameError != null) ...[
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  _usernameError!,
                  style: AppTextStyles.baseSmall.copyWith(
                    color: _theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.spacing16),
              // _buildBioField(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveProfile,
          style: FilledButton.styleFrom(
            backgroundColor: _theme.colorScheme.primary,
          ),
          child: _isLoading
              ? SizedBox(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _theme.colorScheme.onPrimary,
                  ),
                )
              : Text('common.save'.tr()),
        ),
      ],
    );
  }

  Widget _buildDisplayNameField() {
    return CustomTextField(
      controller: _displayNameController,
      labelText: 'settings.editProfile.displayName'.tr(),
      hintText: 'settings.editProfile.displayNameHint'.tr(),
      icon: AppIcons.person,
      textCapitalization: TextCapitalization.words,
      maxLength: AppTextLimits.displayNameMaxLength,
      isRemoveTextVisible: true,
    );
  }

  Widget _buildUsernameField() {
    return CustomTextField(
      controller: _usernameController,
      labelText: 'settings.editProfile.username'.tr(),
      hintText: 'settings.editProfile.usernameHint'.tr(),
      icon: AppIcons.alternateEmail,
      maxLength: AppTextLimits.usernameMaxLength,
      isRemoveTextVisible: true,
    );
  }

  // Widget _buildBioField() {
  //   return CustomTextField(
  //     controller: _bioController,
  //     labelText: 'settings.editProfile.bio'.tr(),
  //     hintText: 'settings.editProfile.bioHint'.tr(),
  //     maxLines: 3,
  //     maxLength: AppTextLimits.bioMaxLength,
  //     isRemoveTextVisible: true,
  //   );
  // }

  void _formatUsername() {
    final text = _usernameController.text;
    // Only allow lowercase alphanumeric and underscores
    final formatted = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

    if (text != formatted) {
      _usernameController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Clear error when user types
    if (_usernameError != null) {
      setState(() {
        _usernameError = null;
      });
    }
  }

  Future<void> _saveProfile() async {
    final displayName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    // final bio = _bioController.text.trim();

    // Validate username (required)
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('settings.editProfile.usernameRequired'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _usernameError = null;
    });

    try {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);

      // Check username availability if changed
      if (username != widget.user.username) {
        final isAvailable = await usersProvider.isUsernameAvailable(username);
        if (!isAvailable) {
          setState(() {
            _usernameError = 'settings.editProfile.usernameTaken'.tr();
            _isLoading = false;
          });
          return;
        }
      }

      HapticFeedback.mediumImpact();

      await usersProvider.updateProfile(
        displayName: displayName.isEmpty ? null : displayName,
        username: username,
        // bio: bio.isEmpty ? null : bio,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('settings.editProfile.success'.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'common.error'.tr()}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
