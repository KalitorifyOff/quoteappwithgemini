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
      expect(quotes.length, 6); // 5 initial quotes + 1 new quote
      expect(quotes.last.content, 'Test Quote');
    });

    test('updateQuote', () async {
      // Update one of the initial quotes
      final initialQuotes = await dbHelper.getQuotes();
      final quoteToUpdate = initialQuotes.first;
      final updatedQuote = quoteToUpdate.copyWith(content: 'Updated Quote');
      final rowsAffected = await dbHelper.updateQuote(updatedQuote);
      expect(rowsAffected, 1);

      final quotes = await dbHelper.getQuotes();
      expect(quotes.firstWhere((q) => q.id == quoteToUpdate.id).content, 'Updated Quote');
    });

    test('deleteQuote', () async {
      // Delete one of the initial quotes
      final initialQuotes = await dbHelper.getQuotes();
      final quoteToDelete = initialQuotes.first;
      final rowsAffected = await dbHelper.deleteQuote(quoteToDelete.id!);
      expect(rowsAffected, 1);

      final quotes = await dbHelper.getQuotes();
      expect(quotes.length, 4); // 5 initial quotes - 1 deleted
    });

    test('insertCategory and getCategories', () async {
      final category = Category(name: 'New Test Category');
      final id = await dbHelper.insertCategory(category);
      expect(id, isNotNull);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 5); // 4 initial categories + 1 new category
      expect(categories.last.name, 'New Test Category');
    });

    test('updateCategory', () async {
      // Update one of the initial categories
      final initialCategories = await dbHelper.getCategories();
      final categoryToUpdate = initialCategories.first;
      final updatedCategory = categoryToUpdate.copyWith(name: 'Updated Category');
      final rowsAffected = await dbHelper.updateCategory(updatedCategory);
      expect(rowsAffected, 1);

      final categories = await dbHelper.getCategories();
      expect(categories.firstWhere((c) => c.id == categoryToUpdate.id).name, 'Updated Category');
    });

    test('deleteCategory', () async {
      // Delete one of the initial categories
      final initialCategories = await dbHelper.getCategories();
      final categoryToDelete = initialCategories.first;
      final rowsAffected = await dbHelper.deleteCategory(categoryToDelete.id!);
      expect(rowsAffected, 1);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 3); // 4 initial categories - 1 deleted
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
