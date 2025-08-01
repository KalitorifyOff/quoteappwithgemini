import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/models/quote.dart';

class QuoteRepository {
  final DatabaseHelper _dbHelper;

  QuoteRepository(this._dbHelper);

  Future<int> insertQuote(Quote quote) async {
    return await _dbHelper.insertQuote(quote);
  }

  Future<List<Quote>> getQuotes() async {
    return await _dbHelper.getQuotes();
  }

  Future<int> updateQuote(Quote quote) async {
    return await _dbHelper.updateQuote(quote);
  }

  Future<int> deleteQuote(int id) async {
    return await _dbHelper.deleteQuote(id);
  }

  Future<List<Quote>> getFavoriteQuotes() async {
    final allQuotes = await _dbHelper.getQuotes();
    return allQuotes.where((quote) => quote.isFavorite).toList();
  }

  Future<List<Quote>> getQuotesByCategory(int categoryId) async {
    final allQuotes = await _dbHelper.getQuotes();
    return allQuotes.where((quote) => quote.categoryId == categoryId).toList();
  }

  Future<List<Quote>> searchQuotes(String query) async {
    final allQuotes = await _dbHelper.getQuotes();
    return allQuotes.where((quote) =>
        quote.content.toLowerCase().contains(query.toLowerCase()) ||
        quote.author.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
