import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:get/get.dart';

class ContentController extends GetxController {
  CategoryModel? _category;
  CategoryModel? get category => _category;

  ArticleModel? _currentItem;
  ArticleModel? get currentItem => _currentItem;

  // set setCategory(String current) {
  //   _category = current;
  // }

  void setCategory(CategoryModel current) {
    _category = current;
    update();
  }

  void setCurrentItem(ArticleModel current) {
    _currentItem = current;
    update();
  }
}
