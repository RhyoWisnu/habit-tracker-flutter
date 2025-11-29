import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/habit.dart';
import '../widgets/habit_card_stats.dart';
import 'edit_habit_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurpleDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(left: 200, top: 62),
                child: Text(
                  'Habits',
                  style: AppTextStyles.pageTitle,
                ),
              ),

              // Habits Grid
              Padding(
                padding: const EdgeInsets.all(36),
                child: Consumer<HabitProvider>(
                  builder: (context, habitProvider, _) {
                    if (habitProvider.habits.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            'No habits yet. Add one to get started!',
                            style: AppTextStyles.rubikRegular(16, AppColors.textWhite),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: habitProvider.habits.map((habit) {
                        return HabitCardStats(
                          habit: habit,
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditHabitScreen(habit: habit),
                              ),
                            ).then((_) {
                              habitProvider.loadHabits();
                            });
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, habit, habitProvider);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Habit habit,
    HabitProvider habitProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Habit',
            style: AppTextStyles.rubikBold(18, AppColors.textPrimary),
          ),
          content: Text(
            'Are you sure you want to delete "${habit.title}"?',
            style: AppTextStyles.rubikRegular(14, AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.rubikMedium(14, AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await habitProvider.deleteHabit(habit.id);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Habit deleted successfully!')),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        habitProvider.errorMessage ?? 'Failed to delete habit',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Delete',
                style: AppTextStyles.rubikMedium(14, Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}




