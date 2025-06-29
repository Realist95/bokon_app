import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:get/get.dart';

class ContentController extends GetxController {
  CatalogCategoryModel? _category;
  CatalogCategoryModel? get category => _category;

  ArticleModel? _currentItem;
  ArticleModel? get currentItem => _currentItem;

  // set setCategory(String current) {
  //   _category = current;
  // }

  void setCategory(CatalogCategoryModel current) {
    _category = current;
    update();
  }

  void setCurrentItem(ArticleModel current) {
    _currentItem = current;
    update();
  }
}
