import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final Color cardColor;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
    isCompleted ? AppColors.textDark : AppColors.textWhite;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFEFEFEF) : cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // ==== Icon Small Fix ====
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                habit.icon,
                style: const TextStyle(fontSize: 26), // <- FIXED (lebih kecil)
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ==== Text Section ====
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: AppTextStyles.habitTitle.copyWith(color: textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  habit.frequency == 'daily' ? 'Every Day' : habit.frequency,
                  style: AppTextStyles.habitInfo.copyWith(
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // ==== Checkbox ====
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.black : Colors.white,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.black)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
