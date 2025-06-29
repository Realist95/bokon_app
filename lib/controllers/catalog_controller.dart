import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:get/get.dart';

class CatalogController extends GetxController {
  CatalogCategoryModel? _category;
  CatalogCategoryModel? get category => _category;

  CatalogCategoryModel? _subCategory;
  CatalogCategoryModel? get subCategory => _subCategory;

  CatalogItemModel? _currentItem;
  CatalogItemModel? get currentItem => _currentItem;

  // set setCategory(String current) {
  //   _category = current;
  // }

  void setCategory(CatalogCategoryModel current) {
    _category = current;
    update();
  }

  void setSubCategory(CatalogCategoryModel current) {
    _subCategory = current;
    update();
  }

  void setCurrentItem(CatalogItemModel current) {
    _currentItem = current;
    update();
  }
}
