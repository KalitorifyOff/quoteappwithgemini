import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/models/category.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper;

  CategoryRepository(this._dbHelper);

  Future<int> insertCategory(Category category) async {
    return await _dbHelper.insertCategory(category);
  }

  Future<List<Category>> getCategories() async {
    return await _dbHelper.getCategories();
  }

  Future<int> updateCategory(Category category) async {
    return await _dbHelper.updateCategory(category);
  }

  Future<int> deleteCategory(int id) async {
    return await _dbHelper.deleteCategory(id);
  }
}
