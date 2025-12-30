import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/dialogs/change_email_dialog.dart';
import 'package:unite_up/dialogs/delete_user_dialog.dart';
import 'package:unite_up/dialogs/edit_user_dialog.dart';
import 'package:unite_up/providers/theme_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/app_card_container.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/settings_card.dart';
import 'package:unite_up/widgets/settings_emoji_container.dart';
import 'package:unite_up/widgets/settings_icon_container.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeData get _theme => Theme.of(context);
  late final _usersProvider = Provider.of<UsersProvider>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'settings.title'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        children: [
          _buildSectionTitle('settings.appearance'.tr()),
          const SizedBox(height: AppSizes.spacing12),
          _buildThemeCard(context, themeProvider),
          const SizedBox(height: AppSizes.spacing32),
          _buildSectionTitle('settings.language'.tr()),
          const SizedBox(height: AppSizes.spacing12),
          _buildLanguageCard(context),
          const SizedBox(height: AppSizes.spacing32),
          _buildSectionTitle('settings.about'.tr()),
          const SizedBox(height: AppSizes.spacing12),
          _buildInfoCard(
            context,
            icon: AppIcons.info,
            title: 'settings.version'.tr(),
            subtitle: '1.0.0',
          ),
          const SizedBox(height: AppSizes.spacing32),
          _buildSectionTitle('settings.account.title'.tr()),
          const SizedBox(height: AppSizes.spacing12),
          _buildAccountCard(),
          const SizedBox(height: AppSizes.spacing24),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _usersProvider.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.loggedOutSuccessfully'.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Pop back to profile which will show auth page
        Navigator.pop(context);
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
    }
  }

  Widget _buildLogoutButton() {
    return SettingsCard(
      icon: SettingsIconContainer(icon: AppIcons.logout),
      title: 'auth.signOut'.tr(),
      onTap: _handleLogout,
      trailing: Icon(AppIcons.arrowForward, size: AppSizes.iconMedium),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SettingsCard(
      icon: SettingsIconContainer(
        icon: AppIcons.delete,
        color: _theme.colorScheme.error,
      ),
      titleColor: _theme.colorScheme.error,
      title: 'settings.account.deleteAccount'.tr(),
      onTap: _handleDeleteAccount,
      trailing: Icon(
        AppIcons.arrowForward,
        size: AppSizes.iconMedium,
        color: _theme.colorScheme.error,
      ),
      isLast: true,
    );
  }

  Future<void> _handleDeleteAccount() async {
    showDialog(context: context, builder: (context) => DeleteUserDialog());
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
      child: Text(
        title,
        style: AppTextStyles.regularSemiBold.copyWith(
          color: _theme.iconTheme.color?.withValues(
            alpha: AppOpacity.mostlyOpaque,
          ),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProvider) {
    return AppCardContainer(
      child: Column(
        children: [
          _buildThemeOption(
            context,
            icon: AppIcons.lightMode,
            title: 'settings.theme.light.name'.tr(),
            subtitle: 'settings.theme.light.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.light,
            onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            isFirst: true,
          ),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildThemeOption(
            context,
            icon: AppIcons.darkMode,
            title: 'settings.theme.dark.name'.tr(),
            subtitle: 'settings.theme.dark.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.dark,
            onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
          ),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildThemeOption(
            context,
            icon: AppIcons.autoMode,
            title: 'settings.theme.system.name'.tr(),
            subtitle: 'settings.theme.system.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.system,
            onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    final currentLocale = context.locale;

    return AppCardContainer(
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            flag: '🇺🇸',
            title: 'settings.languages.english.name'.tr(),
            subtitle: 'settings.languages.english.subtitle'.tr(),
            isSelected: currentLocale.languageCode == 'en',
            onTap: () => context.setLocale(const Locale('en')),
            isFirst: true,
          ),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildLanguageOption(
            context,
            flag: '🇩🇪',
            title: 'settings.languages.german.name'.tr(),
            subtitle: 'settings.languages.german.subtitle'.tr(),
            isSelected: currentLocale.languageCode == 'de',
            onTap: () => context.setLocale(const Locale('de')),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          child: Row(
            children: [
              SettingsIconContainer(
                icon: icon,
                color: isSelected
                    ? _theme.colorScheme.primary
                    : _theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.mostlyOpaque,
                          ) ??
                          _theme.colorScheme.primary,
                backgroundColor: isSelected
                    ? _theme.colorScheme.primary.withValues(
                        alpha: AppOpacity.light,
                      )
                    : _theme.colorScheme.primary.withValues(
                        alpha: AppOpacity.veryLight,
                      ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.largeSemiBoldPrimary(context),
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      subtitle,
                      style: AppTextStyles.regularSecondary(context),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  AppIcons.checkCircle,
                  color: _theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                )
              else
                Icon(
                  AppIcons.circle,
                  color: _theme.iconTheme.color?.withValues(
                    alpha: AppOpacity.medium,
                  ),
                  size: AppSizes.iconLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String flag,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          child: Row(
            children: [
              SettingsEmojiContainer(
                emoji: flag,
                backgroundColor: isSelected
                    ? _theme.colorScheme.primary.withValues(
                        alpha: AppOpacity.light,
                      )
                    : _theme.colorScheme.primary.withValues(
                        alpha: AppOpacity.veryLight,
                      ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.largeSemiBoldPrimary(context),
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      subtitle,
                      style: AppTextStyles.regularSecondary(context),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  AppIcons.checkCircle,
                  color: _theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                )
              else
                Icon(
                  AppIcons.circle,
                  color: _theme.iconTheme.color?.withValues(
                    alpha: AppOpacity.medium,
                  ),
                  size: AppSizes.iconLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SettingsCard(
      icon: SettingsIconContainer(
        icon: icon,
        color: _theme.colorScheme.primary,
        backgroundColor: _theme.colorScheme.primary.withValues(
          alpha: AppOpacity.light,
        ),
      ),
      title: title,
      subtitle: subtitle,
    );
  }

  Widget _buildAccountCard() {
    return AppCardContainer(
      child: Column(
        children: [
          _buildEditProfileButton(),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildChangeEmailButton(),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildLogoutButton(),
          Divider(
            height: AppSizes.dividerHeight,
            thickness: 1,
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildDeleteAccountButton(),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return SettingsCard(
      icon: SettingsIconContainer(icon: AppIcons.edit),
      title: 'settings.account.editProfile'.tr(),
      onTap: _handleEditProfile,
      trailing: Icon(AppIcons.arrowForward, size: AppSizes.iconMedium),
      isFirst: true,
    );
  }

  Widget _buildChangeEmailButton() {
    return SettingsCard(
      icon: SettingsIconContainer(icon: AppIcons.email),
      title: 'settings.account.changeEmail'.tr(),
      onTap: _handleChangeEmail,
      trailing: Icon(AppIcons.arrowForward, size: AppSizes.iconMedium),
    );
  }

  void _handleEditProfile() {
    final currentUser = _usersProvider.currentUser;
    if (currentUser != null) {
      showDialog(
        context: context,
        builder: (context) => EditUserDialog(user: currentUser),
      );
    }
  }

  void _handleChangeEmail() {
    final currentEmail = _usersProvider.currentUserEmail;
    if (currentEmail != null) {
      showDialog(
        context: context,
        builder: (context) => ChangeEmailDialog(currentEmail: currentEmail),
      );
    }
  }
}
