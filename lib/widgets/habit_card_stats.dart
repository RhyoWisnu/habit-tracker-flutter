import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HabitCardStats extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTrackProgress;
  final VoidCallback? onTap;

  const HabitCardStats({
    super.key,
    required this.habit,
    this.onEdit,
    this.onDelete,
    this.onTrackProgress,
    this.onTap,
  });

  // Helper untuk mengkonversi string hex color ke objek Color
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.primaryPurple; // Fallback color
    }
  }

  // Helper untuk mendapatkan persentase kemajuan
  double _getCompletionPercentage() {
    if (habit.targetDays <= 0) return 0.0;
    return habit.completedDays / habit.targetDays;
  }

  // Helper untuk mendapatkan teks frekuensi yang lebih ramah pengguna
  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Every Day';
      case 'weekly':
        return 'Once a Week';
      case 'monthly':
        return 'Once a Month';
      default:
        return 'Daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showHabitDetailPopup(context),
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
              // Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      habit.icon,
                      style: AppTextStyles.airbnbCerealBold(
                        52,
                        AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      habit.title,
                      style: AppTextStyles.rubikRegular(
                        20,
                        AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // --- POPUP (BOTTOM SHEET) ---

  void _showHabitDetailPopup(BuildContext context) {
    final habitColor = _colorFromHex(habit.color);
    final progressPercentage = _getCompletionPercentage();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.textWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Ikon & Judul ---
                  Center(
                    child: Column(
                      children: [
                        Text(habit.icon, style: const TextStyle(fontSize: 70)),
                        const SizedBox(height: 10),
                        Text(
                          habit.title,
                          style: AppTextStyles.rubikRegular(
                            26,
                            AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // --- Detail Card: Frequency ---
                  _buildDetailCard(
                    icon: Icons.access_time_filled,
                    title: 'Frequency',
                    value: _getFrequencyText(habit.frequency),
                  ),
                  const SizedBox(height: 15),

                  // --- Detail Card: Target ---
                  _buildDetailCard(
                    icon: Icons.calendar_month,
                    title: 'Target',
                    value:
                        '${habit.completedDays} / ${habit.targetDays} Days total',
                  ),
                  const SizedBox(height: 30),

                  // --- Progress Bar ---
                  Text(
                    'Progress',
                    style: AppTextStyles.rubikMedium(18, AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  _buildProgressBar(habitColor, progressPercentage),

                  const SizedBox(height: 40),

                  const SizedBox(height: 12),

                  /// Edit Habit Button (OutlinedButton - Black/Primary)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: _outlineBtnStyle(AppColors.textPrimary),
                      onPressed: () {
                        Navigator.pop(context);
                        if (onEdit != null) onEdit!();
                      },
                      child: const Text("Edit Habit"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Delete Habit Button (OutlinedButton - Red)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: _outlineBtnStyle(Colors.red),
                      onPressed: () {
                        Navigator.pop(context); // Tutup bottom sheet
                        _showDeleteConfirmationDialog(
                          context,
                        ); // Tampilkan pop-up konfirmasi di tengah
                      },
                      child: const Text("Delete Habit"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Close
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- POPUP KONFIRMASI DELETE (AlertDialog di Tengah) ---

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Delete \"${habit.title}\"?",
            style: AppTextStyles.rubikMedium(18, AppColors.textPrimary),
          ),
          content: Text(
            "Are you sure you want to delete this habit? This action cannot be undone.",
            style: AppTextStyles.rubikRegular(16, AppColors.textSecondary),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text(
                "Cancel",
                style: AppTextStyles.rubikMedium(16, AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                if (onDelete != null)
                  onDelete!(); // Lanjutkan dengan aksi delete
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }

  // --- Widget Pembantu Detail ---

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrayLighter,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.rubikRegular(
                    14,
                    AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.rubikMedium(16, AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Color color, double percentage) {
    final int completedDays = habit.completedDays;
    final int targetDays = habit.targetDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completedDays / $targetDays Days',
              style: AppTextStyles.rubikMedium(14, AppColors.textPrimary),
            ),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.rubikMedium(14, AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.backgroundGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  /// BUTTON STYLES

  ButtonStyle _primaryBtnStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }

  ButtonStyle _outlineBtnStyle(Color color) {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: color, width: 1.5),
      foregroundColor: color,
    );
  }
}
