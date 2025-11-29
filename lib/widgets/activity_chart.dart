import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ActivityChart extends StatelessWidget {
  final Map<String, double> weeklyData;

  const ActivityChart({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final maxValue = weeklyData.values.isEmpty 
        ? 1.0 
        : weeklyData.values.reduce((a, b) => a > b ? a : b);
    
    return Container(
      width: 379.79,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.backgroundGrayLight,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Chart bars
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final value = weeklyData[day.toLowerCase()] ?? 0.0;
                final height = maxValue > 0 ? (value / maxValue) * 139.47 : 0.0;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 26.08,
                      height: height.clamp(0.0, 139.47),
                      decoration: BoxDecoration(
                        gradient: AppColors.chartGradient,
                        borderRadius: BorderRadius.circular(8.35),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              }).toList(),
            ),
          ),
          
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: days.map((day) {
              final isToday = day == 'Tue'; // You can make this dynamic
              return Text(
                day,
                style: AppTextStyles.dayLabel.copyWith(
                  fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}





