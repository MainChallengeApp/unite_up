import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/app_state_provider.dart';
import '../widgets/goal_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  GoalCategory? _selectedCategory;
  final TextEditingController _customGoalController = TextEditingController();

  @override
  void dispose() {
    _customGoalController.dispose();
    super.dispose();
  }

  void _handleGoalSelection() {
    if (_selectedCategory == null) return;

    final goal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _selectedCategory!,
      customName: _selectedCategory == GoalCategory.custom
          ? _customGoalController.text.trim()
          : null,
      createdAt: DateTime.now(),
    );

    Provider.of<AppStateProvider>(context, listen: false).setGoal(goal);
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to\nDare U!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Transform your life one challenge at a time. Select your goal to get started with daily personalized challenges.',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.iconTheme.color?.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Choose your goal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.iconTheme.color?.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...GoalCategory.values.map((category) {
                      return GoalCard(
                        category: category,
                        isSelected: _selectedCategory == category,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                        customController: category == GoalCategory.custom
                            ? _customGoalController
                            : null,
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withOpacity(0.1),
                    width: 1,
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
                            (_selectedCategory != GoalCategory.custom ||
                                _customGoalController.text.trim().isNotEmpty)
                        ? _handleGoalSelection
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Start Your Journey',
                      style: TextStyle(
                        fontSize: 16,
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
