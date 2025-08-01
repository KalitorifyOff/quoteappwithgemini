import 'package:equatable/equatable.dart';

class UserStreak extends Equatable {
  final int id;
  final DateTime lastAccessed;
  final int streakCount;

  const UserStreak({
    required this.id,
    required this.lastAccessed,
    required this.streakCount,
  });

  @override
  List<Object?> get props => [id, lastAccessed, streakCount];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last_accessed': lastAccessed.toIso8601String(),
      'streak_count': streakCount,
    };
  }

  factory UserStreak.fromMap(Map<String, dynamic> map) {
    return UserStreak(
      id: map['id'],
      lastAccessed: DateTime.parse(map['last_accessed']),
      streakCount: map['streak_count'],
    );
  }

  UserStreak copyWith({
    int? id,
    DateTime? lastAccessed,
    int? streakCount,
  }) {
    return UserStreak(
      id: id ?? this.id,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      streakCount: streakCount ?? this.streakCount,
    );
  }
}
