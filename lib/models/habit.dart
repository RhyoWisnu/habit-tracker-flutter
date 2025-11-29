class Habit {
  final String id;
  final String userId;
  final String title;
  final String icon;
  final String color;
  final String frequency; // 'daily', 'weekly', 'custom'
  final int targetDays;
  final int completedDays;
  final List<String> completedDates;
  final DateTime createdAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.targetDays,
    required this.completedDays,
    required this.completedDates,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progress {
    if (targetDays == 0) return 0.0;
    return (completedDays / targetDays).clamp(0.0, 1.0);
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String? ?? '💧',
      color: json['color'] as String? ?? '#FF9966',
      frequency: json['frequency'] as String? ?? 'daily',
      targetDays: json['target_days'] as int? ?? 7,
      completedDays: json['completed_days'] as int? ?? 0,
      completedDates: (json['completed_dates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'icon': icon,
      'color': color,
      'frequency': frequency,
      'target_days': targetDays,
      'completed_days': completedDays,
      'completed_dates': completedDates,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? icon,
    String? color,
    String? frequency,
    int? targetDays,
    int? completedDays,
    List<String>? completedDates,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      targetDays: targetDays ?? this.targetDays,
      completedDays: completedDays ?? this.completedDays,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}





