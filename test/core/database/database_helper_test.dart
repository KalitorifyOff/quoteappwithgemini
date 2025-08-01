import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/models/user_streak.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseHelper', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      await DatabaseHelper.resetForTesting();
      dbHelper = DatabaseHelper();
      await dbHelper.database; // Initialize the database
    });

    tearDown(() async {
      // No need to close here, resetForTesting handles it
    });

    test('insertQuote and getQuotes', () async {
      final quote = Quote(content: 'Test Quote', author: 'Test Author');
      final id = await dbHelper.insertQuote(quote);
      expect(id, isNotNull);

      final quotes = await dbHelper.getQuotes();
      expect(quotes.length, 1);
      expect(quotes.first.content, 'Test Quote');
    });

    test('updateQuote', () async {
      final quote = Quote(content: 'Test Quote', author: 'Test Author');
      final id = await dbHelper.insertQuote(quote);

      final updatedQuote = quote.copyWith(id: id, content: 'Updated Quote');
      final rowsAffected = await dbHelper.updateQuote(updatedQuote);
      expect(rowsAffected, 1);

      final quotes = await dbHelper.getQuotes();
      expect(quotes.first.content, 'Updated Quote');
    });

    test('deleteQuote', () async {
      final quote = Quote(content: 'Test Quote', author: 'Test Author');
      final id = await dbHelper.insertQuote(quote);

      final rowsAffected = await dbHelper.deleteQuote(id);
      expect(rowsAffected, 1);

      final quotes = await dbHelper.getQuotes();
      expect(quotes.length, 0);
    });

    test('insertCategory and getCategories', () async {
      final category = Category(name: 'Test Category');
      final id = await dbHelper.insertCategory(category);
      expect(id, isNotNull);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 1);
      expect(categories.first.name, 'Test Category');
    });

    test('updateCategory', () async {
      final category = Category(name: 'Test Category');
      final id = await dbHelper.insertCategory(category);

      final updatedCategory = category.copyWith(id: id, name: 'Updated Category');
      final rowsAffected = await dbHelper.updateCategory(updatedCategory);
      expect(rowsAffected, 1);

      final categories = await dbHelper.getCategories();
      expect(categories.first.name, 'Updated Category');
    });

    test('deleteCategory', () async {
      final category = Category(name: 'Test Category');
      final id = await dbHelper.insertCategory(category);

      final rowsAffected = await dbHelper.deleteCategory(id);
      expect(rowsAffected, 1);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 0);
    });

    test('insertUserStreak and getUserStreak', () async {
      final userStreak = UserStreak(id: 1, lastAccessed: DateTime.now(), streakCount: 1);
      final id = await dbHelper.insertUserStreak(userStreak);
      expect(id, isNotNull);

      final retrievedStreak = await dbHelper.getUserStreak();
      expect(retrievedStreak, isNotNull);
      expect(retrievedStreak!.streakCount, 1);
    });

    test('updateUserStreak', () async {
      final userStreak = UserStreak(id: 1, lastAccessed: DateTime.now(), streakCount: 1);
      await dbHelper.insertUserStreak(userStreak);

      final updatedStreak = userStreak.copyWith(streakCount: 5);
      final rowsAffected = await dbHelper.updateUserStreak(updatedStreak);
      expect(rowsAffected, 1);

      final retrievedStreak = await dbHelper.getUserStreak();
      expect(retrievedStreak!.streakCount, 5);
    });
  });
}
