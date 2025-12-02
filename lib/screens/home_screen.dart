import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/habit_card.dart';
import '../widgets/activity_chart.dart';
import 'stats_screen.dart';
import 'add_habit_screen.dart';
import 'profile_screen.dart';
import '../models/habit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitProvider>(context, listen: false).loadHabits();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurpleDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: [
                  _buildHomeContent(),
                  const StatsScreen(),
                  AddHabitScreen(
                    onHabitAdded: () {
                      Provider.of<HabitProvider>(
                        context,
                        listen: false,
                      ).loadHabits();
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  const ProfileScreen(),
                ],
              ),
            ),

            BottomNavBar(currentIndex: _currentIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // Page Title
          Center(child: Text("Home", style: AppTextStyles.pageTitle)),

          const SizedBox(height: 35),

          Text("Activity Progress", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 15),

          Consumer<HabitProvider>(
            builder: (context, habitProvider, _) {
              final now = DateTime.now();
              final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

              // Siapkan map kosong sesuai format ActivityChart
              final weeklyCompleted = {
                'sun': 0,
                'mon': 0,
                'tue': 0,
                'wed': 0,
                'thu': 0,
                'fri': 0,
                'sat': 0,
              };

              final weeklyTotal = {
                'sun': 0,
                'mon': 0,
                'tue': 0,
                'wed': 0,
                'thu': 0,
                'fri': 0,
                'sat': 0,
              };

              // Hitung total target dan completed habits
              for (var habit in habitProvider.habits) {
                for (var dateStr in habit.completedDates) {
                  final dateParts = dateStr.split('-').map(int.parse).toList();
                  final date = DateTime(
                    dateParts[0],
                    dateParts[1],
                    dateParts[2],
                  );

                  if (date.isAfter(
                    startOfWeek.subtract(const Duration(days: 1)),
                  )) {
                    final day =
                        [
                          'sun',
                          'mon',
                          'tue',
                          'wed',
                          'thu',
                          'fri',
                          'sat',
                        ][date.weekday % 7];
                    weeklyCompleted[day] = weeklyCompleted[day]! + 1;
                  }
                }

                // Total habit per hari (misal dianggap 1 setiap habit per hari)
                for (var day in weeklyTotal.keys) {
                  weeklyTotal[day] = weeklyTotal[day]! + 1;
                }
              }

              return ActivityChart(
                weeklyCompleted: weeklyCompleted,
                weeklyTotal: weeklyTotal,
              );
            },
          ),

          const SizedBox(height: 30),

          // UPCOMING HABITS
          Text("Upcoming Habits", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),

          Consumer<HabitProvider>(
            builder: (context, habitProvider, _) {
              final upcomingHabits =
                  habitProvider.habits
                      .where((h) => !_isCompletedToday(h))
                      .toList();

              if (upcomingHabits.isEmpty) return const SizedBox.shrink();

              // 🔥 ROTATING COLORS
              final List<Color> habitColors = [
                AppColors.habitYellow,
                AppColors.habitOrange,
                AppColors.habitPurple,
              ];

              return Column(
                children: List.generate(upcomingHabits.length, (index) {
                  final habit = upcomingHabits[index];
                  final rotatedColor =
                      habitColors[index % habitColors.length]; // color cycle

                  return HabitCard(
                    habit: habit,
                    isCompleted: false,
                    onToggle: () {
                      habitProvider.toggleHabitCompletion(
                        habit.id,
                        DateTime.now(),
                      );
                    },
                    cardColor: rotatedColor,
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 30),

          // COMPLETED HABITS
          Text("Completed", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),

          Consumer<HabitProvider>(
            builder: (context, habitProvider, _) {
              final completedHabits =
                  habitProvider.habits
                      .where((h) => _isCompletedToday(h))
                      .toList();

              if (completedHabits.isEmpty) return const SizedBox.shrink();

              return Column(
                children:
                    completedHabits.map((habit) {
                      return HabitCard(
                        habit: habit,
                        isCompleted: true,
                        onToggle: () {
                          habitProvider.toggleHabitCompletion(
                            habit.id,
                            DateTime.now(),
                          );
                        },
                        cardColor: AppColors.habitGray, // Always gray when done
                      );
                    }).toList(),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  bool _isCompletedToday(Habit habit) {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    return habit.completedDates.contains(dateKey);
  }
}
