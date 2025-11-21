import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/enums/goal_category_enum.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/goal_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  GoalCategoryEnum? _selectedCategory;
  final TextEditingController _customGoalController = TextEditingController();

  @override
  void dispose() {
    _customGoalController.dispose();
    super.dispose();
  }

  void _handleChallengeCreation() {
    if (_selectedCategory == null) return;

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final currentUserId = appState.currentUser?.id ?? 'user-1';

    final challengeName = _selectedCategory == GoalCategoryEnum.custom
        ? _customGoalController.text.trim()
        : _selectedCategory!.displayName(context);

    final challenge = ChallengeChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: challengeName,
      description: _selectedCategory!.description(context),
      category: _selectedCategory!,
      emoji: _selectedCategory!.emoji,
      memberIds: [currentUserId],
      creatorId: currentUserId,
      createdAt: DateTime.now(),
    );

    appState.addChallenge(challenge);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacing20),
                    Text(
                      'onboarding.welcomeTo'.tr(),
                      style: TextStyle(
                        fontSize: AppSizes.fontHuge,
                        fontWeight: FontWeight.bold,
                        height: AppSizes.lineHeightTight,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    Text(
                      'onboarding.description'.tr(),
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.almostOpaque,
                        ),
                        height: AppSizes.lineHeightNormal,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing40),
                    Text(
                      'onboarding.chooseFocus'.tr(),
                      style: TextStyle(
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w600,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.mostlyOpaque,
                        ),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    ...GoalCategoryEnum.values.map((category) {
                      return GoalCard(
                        category: category,
                        isSelected: _selectedCategory == category,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                        customController: category == GoalCategoryEnum.custom
                            ? _customGoalController
                            : null,
                        onChangedTextField: category == GoalCategoryEnum.custom
                            ? (value) => setState(
                                () => _customGoalController.text = value,
                              )
                            : null,
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withValues(
                      alpha: AppOpacity.light,
                    ),
                    width: AppSizes.borderThin,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _selectedCategory != null &&
                            (_selectedCategory != GoalCategoryEnum.custom ||
                                _customGoalController.text.trim().isNotEmpty)
                        ? _handleChallengeCreation
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                      ),
                      elevation: AppSizes.elevationNone,
                    ),
                    child: Text(
                      'onboarding.startJourney'.tr(),
                      style: const TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
