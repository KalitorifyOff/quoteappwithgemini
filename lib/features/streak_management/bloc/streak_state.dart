part of 'streak_bloc.dart';

abstract class StreakState extends Equatable {
  const StreakState();

  @override
  List<Object?> get props => [];
}

class StreakInitial extends StreakState {}

class StreakLoading extends StreakState {}

class StreakLoaded extends StreakState {
  final UserStreak? streak;
  final bool hasReward;

  const StreakLoaded({this.streak, this.hasReward = false});

  @override
  List<Object?> get props => [streak, hasReward];
}

class StreakError extends StreakState {
  final String message;

  const StreakError({required this.message});

  @override
  List<Object> get props => [message];
}
