import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HabitCardStats extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const HabitCardStats({
    super.key,
    required this.habit,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 162,
        height: 235,
        decoration: BoxDecoration(
          color: AppColors.backgroundGrayLighter,
          borderRadius: BorderRadius.circular(22),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Gradient (optional for specific colors)
              if (habit.color == '#7472FF')
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.walkingGradient,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),

              // CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ICON CENTERED
                    Text(
                      habit.icon,
                      style: AppTextStyles.airbnbCerealBold(52, AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // TITLE
                    Text(
                      habit.title,
                      style: AppTextStyles.rubikRegular(
                        20,
                        AppColors.textPrimary,
                      ).copyWith(height: 1.4),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // THREE DOT MENU
              Positioned(
                top: 12,
                right: 12,
                child: PopupMenuButton<String>(
                  icon: SizedBox(
                    width: 22.5,
                    height: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dot(),
                        const SizedBox(width: 2.75),
                        _dot(),
                        const SizedBox(width: 2.75),
                        _dot(),
                      ],
                    ),
                  ),
                  offset: const Offset(0, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: AppColors.textWhite,
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) onEdit!();
                    if (value == 'delete' && onDelete != null) onDelete!();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 18, color: AppColors.textPrimary),
                          const SizedBox(width: 8),
                          Text('Edit',
                              style: AppTextStyles.rubikRegular(14, AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('Delete',
                              style: AppTextStyles.rubikRegular(14, Colors.red)),
                        ],
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

  // DOT BUILDER FOR 3-DOT MENU
  Widget _dot() {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
      ),
    );
  }
}
