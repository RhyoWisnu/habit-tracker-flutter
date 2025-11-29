import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  final VoidCallback? onHabitAdded;
  
  const AddHabitScreen({super.key, this.onHabitAdded});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _titleController = TextEditingController();
  String _selectedIcon = '💧';
  String _selectedColor = '#FF9966';
  String _selectedFrequency = 'daily';

  final List<Map<String, dynamic>> _availableHabits = [
    {'title': 'Drinking water', 'icon': '💧', 'color': '#FF9966'},
    {'title': 'Water Plant', 'icon': '🌿', 'color': '#9466FF'},
    {'title': 'Walking', 'icon': '🏃🏻‍♀️', 'color': '#7472FF'},
    {'title': 'Cycling', 'icon': '🚴', 'color': '#F2E66A'},
    {'title': 'Sleep', 'icon': '😴', 'color': '#F2F2F2'},
    {'title': 'Read books', 'icon': '📖', 'color': '#FF9966'},
    {'title': 'Journal', 'icon': '📕', 'color': '#9466FF'},
    {'title': 'Meditate', 'icon': '🧘🏻‍♀️', 'color': '#F2E66A'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addHabit() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit title')),
      );
      return;
    }

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '', // Will be set by provider
      title: _titleController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      frequency: _selectedFrequency,
      targetDays: 7,
      completedDays: 0,
      completedDates: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await habitProvider.addHabit(habit);
    if (success && mounted) {
      // If callback is provided, use it to navigate to home
      if (widget.onHabitAdded != null) {
        widget.onHabitAdded!();
      } else {
        // Otherwise, try to pop if navigated separately
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit added successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(habitProvider.errorMessage ?? 'Failed to add habit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurpleDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Back button
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 62, right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // If callback exists, use it to go back to home
                        if (widget.onHabitAdded != null) {
                          widget.onHabitAdded!();
                        } else if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Add Habits',
                      style: AppTextStyles.pageTitle,
                    ),
                  ],
                ),
              ),
              
              // Habit selection grid
              Padding(
                padding: const EdgeInsets.all(36),
                child: Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: _availableHabits.map((habitData) {
                    final isSelected = _selectedIcon == habitData['icon'] &&
                        _selectedColor == habitData['color'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = habitData['icon'];
                          _selectedColor = habitData['color'];
                          _titleController.text = habitData['title'];
                        });
                      },
                      child: Container(
                        width: 162,
                        height: 235,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrayLighter,
                          borderRadius: BorderRadius.circular(22),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryPurpleDark,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              habitData['icon'],
                              style: AppTextStyles.airbnbCerealBold(
                                40,
                                AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              habitData['title'],
                              style: AppTextStyles.rubikRegular(
                                20,
                                AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Custom habit input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Or create custom habit',
                      style: AppTextStyles.rubikMedium(16, AppColors.textWhite),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 63,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGray,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: AppTextStyles.inputLabel.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter habit name',
                          hintStyle: AppTextStyles.inputLabel,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Add button
                    SizedBox(
                      width: double.infinity,
                      height: 63,
                      child: ElevatedButton(
                        onPressed: _addHabit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: Text(
                          'ADD HABIT',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}



