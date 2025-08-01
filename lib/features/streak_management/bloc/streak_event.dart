part of 'streak_bloc.dart';

abstract class StreakEvent extends Equatable {
  const StreakEvent();

  @override
  List<Object> get props => [];
}

class LoadStreak extends StreakEvent {}

class UpdateStreak extends StreakEvent {}

class ClaimReward extends StreakEvent {}
