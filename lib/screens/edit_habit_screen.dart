import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/habit.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({
    super.key,
    required this.habit,
  });

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _titleController;
  late String _selectedIcon;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.title);
    _selectedIcon = widget.habit.icon;
    _selectedColor = widget.habit.color;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updateHabit() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit title')),
      );
      return;
    }

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final updatedHabit = widget.habit.copyWith(
      title: _titleController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      updatedAt: DateTime.now(),
    );

    final success = await habitProvider.updateHabit(updatedHabit);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit updated successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text(habitProvider.errorMessage ?? 'Failed to update habit')),
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
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textWhite, // Changed to white to be visible on dark purple bg
                        size: 24, // Increased size slightly since container is gone
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Edit Habit',
                      style: AppTextStyles.pageTitle,
                    ),
                  ],
                ),
              ),

              // Form fields
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habit Name',
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

                    // Update button
                    SizedBox(
                      width: double.infinity,
                      height: 63,
                      child: ElevatedButton(
                        onPressed: _updateHabit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: Text(
                          'UPDATE HABIT',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
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
