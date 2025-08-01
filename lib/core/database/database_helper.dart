import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/models/user_streak.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quote_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE quotes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        category_id INTEGER,
        is_favorite INTEGER DEFAULT 0,
        is_user_created INTEGER DEFAULT 0
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        is_user_created INTEGER DEFAULT 0
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE user_streak(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        last_accessed TEXT NOT NULL,
        streak_count INTEGER DEFAULT 0
      )
      ''',
    );
  }

  // Quote operations
  Future<int> insertQuote(Quote quote) async {
    final db = await database;
    return await db.insert('quotes', quote.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Quote>> getQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('quotes');
    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]);
    });
  }

  Future<int> updateQuote(Quote quote) async {
    final db = await database;
    return await db.update(
      'quotes',
      quote.toMap(),
      where: 'id = ?',
      whereArgs: [quote.id],
    );
  }

  Future<int> deleteQuote(int id) async {
    final db = await database;
    return await db.delete(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Category operations
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UserStreak operations
  Future<int> insertUserStreak(UserStreak userStreak) async {
    final db = await database;
    return await db.insert('user_streak', userStreak.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserStreak?> getUserStreak() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_streak', limit: 1);
    if (maps.isNotEmpty) {
      return UserStreak.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserStreak(UserStreak userStreak) async {
    final db = await database;
    return await db.update(
      'user_streak',
      userStreak.toMap(),
      where: 'id = ?',
      whereArgs: [userStreak.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; // Reset for testing
  }

  // Method to reset the database for testing purposes
  static Future<void> resetForTesting() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quote_app.db');
    await deleteDatabase(path);
  }
}
