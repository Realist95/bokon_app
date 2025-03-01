import 'package:bokon_app/models/catalog/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> saveCategories(List<CategoryModel> categories);
}

const CASHED_CATEGORIES = 'CACHED_CATEGORIES';

class CategoryLocalSourceImpl implements CategoryLocalSource {
  final SharedPreferences prefs;
  CategoryLocalSourceImpl({required this.prefs});

  @override
  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 3), () async {
      final categoriesPrefs = prefs.getString(CASHED_CATEGORIES) ?? '';
      if (categoriesPrefs.isEmpty) return items;
      items = categoriesModelFromJson(categoriesPrefs.toString());
      return items;
    });
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) {
    prefs.setString(CASHED_CATEGORIES, categoriesModelToJson(categories));

    return Future.value();
  }
}
