import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streakdemo/core/database/models/user_streak.dart';
import 'package:streakdemo/core/database/repositories/user_streak_repository.dart';

part 'streak_event.dart';
part 'streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final UserStreakRepository userStreakRepository;

  StreakBloc({required this.userStreakRepository}) : super(StreakInitial()) {
    on<LoadStreak>(_onLoadStreak);
    on<UpdateStreak>(_onUpdateStreak);
  }

  Future<void> _onLoadStreak(
    LoadStreak event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());
    try {
      final streak = await userStreakRepository.getUserStreak();
      final hasReward = (streak?.streakCount ?? 0) > 0 && (streak!.streakCount % 7 == 0);
      emit(StreakLoaded(streak: streak, hasReward: hasReward));
    } catch (e) {
      emit(StreakError(message: e.toString()));
    }
  }

  Future<void> _onUpdateStreak(
    UpdateStreak event,
    Emitter<StreakState> emit,
  ) async {
    try {
      UserStreak? currentStreak = await userStreakRepository.getUserStreak();
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      if (currentStreak == null) {
        // First time accessing, start a new streak
        currentStreak = UserStreak(id: 1, lastAccessed: today, streakCount: 1);
        await userStreakRepository.insertUserStreak(currentStreak);
      } else {
        DateTime lastAccessedDay = DateTime(
          currentStreak.lastAccessed.year,
          currentStreak.lastAccessed.month,
          currentStreak.lastAccessed.day,
        );

        if (today.difference(lastAccessedDay).inDays == 1) {
          // Continue streak
          currentStreak = currentStreak.copyWith(
            lastAccessed: today,
            streakCount: currentStreak.streakCount + 1,
          );
          await userStreakRepository.updateUserStreak(currentStreak);
        } else if (today.difference(lastAccessedDay).inDays > 1) {
          // Reset streak
          currentStreak = currentStreak.copyWith(
            lastAccessed: today,
            streakCount: 1,
          );
          await userStreakRepository.updateUserStreak(currentStreak);
        } else {
          // Already accessed today, do nothing
        }
      }
      final hasReward = (currentStreak?.streakCount ?? 0) > 0 && (currentStreak!.streakCount % 7 == 0);
      emit(StreakLoaded(streak: currentStreak, hasReward: hasReward));
    } catch (e) {
      emit(StreakError(message: e.toString()));
    }
  }

  Future<void> _onClaimReward(
    ClaimReward event,
    Emitter<StreakState> emit,
  ) async {
    try {
      UserStreak? currentStreak = await userStreakRepository.getUserStreak();
      if (currentStreak != null && currentStreak.streakCount % 7 == 0) {
        // Reward claimed, reset hasReward flag (or implement reward logic)
        // For now, we'll just reload the streak without changing the streak count
        // as the reward is based on reaching a multiple of 7.
        // In a real app, you might grant a reward and then update the streak
        // to reflect that the reward for this milestone has been claimed.
        emit(StreakLoaded(streak: currentStreak, hasReward: false));
      } else {
        emit(StreakLoaded(streak: currentStreak, hasReward: false));
      }
    } catch (e) {
      emit(StreakError(message: e.toString()));
    }
  }
}
