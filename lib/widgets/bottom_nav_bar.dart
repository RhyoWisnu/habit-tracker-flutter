import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.28,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25525B).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -14),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.bar_chart, 'Stats', 1),
          _buildNavItem(Icons.add_circle, 'Add', 2),
          _buildNavItem(Icons.person, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColors.primaryPurpleDark 
                  : AppColors.textPrimary,
              size: 26.5,
            ),
          ],
        ),
      ),
    );
  }
}





