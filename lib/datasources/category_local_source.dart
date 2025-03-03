import 'package:bokon_app/models/catalog/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> saveCategories(List<CategoryModel> categories);
}

const cachedCategories = 'CACHED_CATEGORIES';

class CategoryLocalSourceImpl implements CategoryLocalSource {
  final SharedPreferences prefs;
  CategoryLocalSourceImpl({required this.prefs});

  @override
  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 3), () async {
      final categoriesPrefs = prefs.getString(cachedCategories) ?? '';
      if (categoriesPrefs.isEmpty) return items;
      items = categoriesModelFromJson(categoriesPrefs.toString());
      return items;
    });
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) {
    prefs.setString(cachedCategories, categoriesModelToJson(categories));

    return Future.value();
  }
}
