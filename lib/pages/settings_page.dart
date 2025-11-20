import 'package:dare_u/providers/theme_provider.dart';
import 'package:dare_u/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings.title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.fontXLarge),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        children: [
          _buildSectionTitle('settings.appearance'.tr(), theme),
          const SizedBox(height: AppSizes.spacing12),
          _buildThemeCard(context, themeProvider, theme),
          const SizedBox(height: AppSizes.spacing32),
          _buildSectionTitle('settings.language'.tr(), theme),
          const SizedBox(height: AppSizes.spacing12),
          _buildLanguageCard(context, theme),
          const SizedBox(height: AppSizes.spacing32),
          _buildSectionTitle('settings.about'.tr(), theme),
          const SizedBox(height: AppSizes.spacing12),
          _buildInfoCard(
            context,
            icon: Icons.info_outline_rounded,
            title: 'settings.version'.tr(),
            subtitle: '1.0.0',
            theme: theme,
          ),
          const SizedBox(height: AppSizes.spacing12),
          _buildInfoCard(
            context,
            icon: Icons.code_rounded,
            title: 'settings.builtWith'.tr(),
            subtitle: 'settings.flutterMaterial'.tr(),
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontRegular,
          fontWeight: FontWeight.w600,
          color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildThemeOption(
            context,
            icon: Icons.light_mode_rounded,
            title: 'settings.theme.light.name'.tr(),
            subtitle: 'settings.theme.light.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.light,
            onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            theme: theme,
            isFirst: true,
          ),
          Divider(
            height: AppSizes.dividerHeight,            thickness: 1,
            color: theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildThemeOption(
            context,
            icon: Icons.dark_mode_rounded,
            title: 'settings.theme.dark.name'.tr(),
            subtitle: 'settings.theme.dark.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.dark,
            onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
            theme: theme,
          ),
          Divider(
            height: AppSizes.dividerHeight,            thickness: 1,
            color: theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildThemeOption(
            context,
            icon: Icons.brightness_auto_rounded,
            title: 'settings.theme.system.name'.tr(),
            subtitle: 'settings.theme.system.description'.tr(),
            isSelected: themeProvider.themeMode == ThemeMode.system,
            onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            theme: theme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, ThemeData theme) {
    final currentLocale = context.locale;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            flag: '🇺🇸',
            title: 'settings.languages.english.name'.tr(),
            subtitle: 'settings.languages.english.subtitle'.tr(),
            isSelected: currentLocale.languageCode == 'en',
            onTap: () => context.setLocale(const Locale('en')),
            theme: theme,
            isFirst: true,
          ),
          Divider(
            height: AppSizes.dividerHeight,            thickness: 1,
            color: theme.dividerColor.withValues(alpha: AppOpacity.light),
          ),
          _buildLanguageOption(
            context,
            flag: '🇩🇪',
            title: 'settings.languages.german.name'.tr(),
            subtitle: 'settings.languages.german.subtitle'.tr(),
            isSelected: currentLocale.languageCode == 'de',
            onTap: () => context.setLocale(const Locale('de')),
            theme: theme,
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
    required ThemeData theme,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
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
              Container(
                width: AppSizes.containerSmall,
                height: AppSizes.containerSmall,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
                      : theme.colorScheme.primary.withValues(alpha: AppOpacity.veryLight),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
                  size: AppSizes.iconLarge,
                ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppSizes.fontRegular,
                        color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: theme.iconTheme.color?.withValues(alpha: AppOpacity.medium),
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
    required ThemeData theme,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
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
              Container(
                width: AppSizes.containerSmall,
                height: AppSizes.containerSmall,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
                      : theme.colorScheme.primary.withValues(alpha: AppOpacity.veryLight),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: AppSizes.iconLarge),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppSizes.fontRegular,
                        color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: theme.iconTheme.color?.withValues(alpha: AppOpacity.medium),
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
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.containerSmall,
            height: AppSizes.containerSmall,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: AppSizes.iconLarge,
            ),
          ),
          const SizedBox(width: AppSizes.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppSizes.fontRegular,
                    color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
