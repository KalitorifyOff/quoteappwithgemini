import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/models/user_streak.dart';

class UserStreakRepository {
  final DatabaseHelper _dbHelper;

  UserStreakRepository(this._dbHelper);

  Future<int> insertUserStreak(UserStreak userStreak) async {
    return await _dbHelper.insertUserStreak(userStreak);
  }

  Future<UserStreak?> getUserStreak() async {
    return await _dbHelper.getUserStreak();
  }

  Future<int> updateUserStreak(UserStreak userStreak) async {
    return await _dbHelper.updateUserStreak(userStreak);
  }
}
