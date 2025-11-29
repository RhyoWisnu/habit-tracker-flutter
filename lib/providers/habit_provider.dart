import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHabits() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('habits')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _habits = (response as List)
          .map((json) => Habit.fromJson(json))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addHabit(Habit habit) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('habits')
          .insert({
            'user_id': userId,
            'title': habit.title,
            'icon': habit.icon,
            'color': habit.color,
            'frequency': habit.frequency,
            'target_days': habit.targetDays,
            'completed_days': habit.completedDays,
          })
          .select()
          .single();

      _habits.insert(0, Habit.fromJson(response));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateHabit(Habit habit) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase
          .from('habits')
          .update(habit.toJson())
          .eq('id', habit.id)
          .select()
          .single();

      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = Habit.fromJson(response);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteHabit(String habitId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _supabase.from('habits').delete().eq('id', habitId);

      _habits.removeWhere((h) => h.id == habitId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleHabitCompletion(String habitId, DateTime date) async {
    try {
      final habit = _habits.firstWhere((h) => h.id == habitId);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      
      // Check if already completed for this date
      final isCompleted = habit.completedDates.contains(dateKey);
      
      final updatedDates = List<String>.from(habit.completedDates);
      if (isCompleted) {
        updatedDates.remove(dateKey);
      } else {
        updatedDates.add(dateKey);
      }

      final updatedHabit = habit.copyWith(
        completedDates: updatedDates,
        completedDays: updatedDates.length,
        updatedAt: DateTime.now(),
      );

      return await updateHabit(updatedHabit);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}



