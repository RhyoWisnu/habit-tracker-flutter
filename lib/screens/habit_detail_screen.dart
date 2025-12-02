import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final int completedDays = 4; // contoh dummy
    final int remainingDays = 2;
    final int overdueDays = 1;

    final int total = completedDays + remainingDays + overdueDays;
    final int score = ((completedDays / total) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
        title: Text("Habits", style: AppTextStyles.pageTitle),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildScoreChart(score),

            const SizedBox(height: 25),

            Text(
              "Habits Progress",
              style: AppTextStyles.rubikBold(18, AppColors.textPrimary),
            ),

            const SizedBox(height: 12),

            _buildProgressCard(completedDays),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChart(int score) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Completed",
                style: AppTextStyles.rubikRegular(14, Colors.red),
              ),
              Text(
                "Remaining",
                style: AppTextStyles.rubikRegular(14, Colors.yellow),
              ),
              Text(
                "Overdue",
                style: AppTextStyles.rubikRegular(14, Colors.black),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 14,
                backgroundColor: Colors.grey.shade200,
                color: AppColors.primaryPurple,
              ),
            ),
            Text(
              "$score%",
              style: AppTextStyles.rubikBold(22, AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(int completedDays) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.walkingGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(habit.icon, style: const TextStyle(fontSize: 38)),
                  const SizedBox(width: 10),
                  Text(
                    habit.title,
                    style: AppTextStyles.rubikBold(20, AppColors.textWhite),
                  ),
                ],
              ),
              Text(
                "$completedDays Days",
                style: AppTextStyles.rubikRegular(16, AppColors.textWhite),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              bool done = i < completedDays;
              return Column(
                children: [
                  Icon(
                    done ? Icons.check_circle : Icons.circle_outlined,
                    size: 25,
                    color: AppColors.textWhite,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][i],
                    style: AppTextStyles.rubikRegular(12, AppColors.textWhite),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
