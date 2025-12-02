import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ActivityChart extends StatelessWidget {
  final Map<String, int> weeklyCompleted;
  final Map<String, int> weeklyTotal;

  const ActivityChart({
    super.key,
    required this.weeklyCompleted,
    required this.weeklyTotal,
  });

  double calculatePercentage(int completed, int total) {
    if (total == 0) return 0.0;
    return completed / total;
  }

  @override
  Widget build(BuildContext context) {
    final days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

    // Hitung nilai tertinggi untuk scaling bar chart
    final List<double> percentValues =
        days.map((day) {
          final completed = weeklyCompleted[day] ?? 0;
          final total = weeklyTotal[day] ?? 0;
          return calculatePercentage(completed, total);
        }).toList();

    final double maxValue =
        percentValues.isEmpty
            ? 1.0
            : percentValues.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: AppColors.backgroundGrayLight,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  days.map((day) {
                    final completed = weeklyCompleted[day] ?? 0;
                    final total = weeklyTotal[day] ?? 0;

                    final percentage = calculatePercentage(completed, total);

                    // Tinggi bar chart
                    final double barHeight =
                        (percentage * 140).clamp(0, 140).toDouble();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(percentage * 100).toStringAsFixed(0)}%',
                          style: AppTextStyles.dayLabel.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 28,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: AppColors.chartGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Label Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (day) => Text(
                        day,
                        style: AppTextStyles.dayLabel.copyWith(fontSize: 12),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
