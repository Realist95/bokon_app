import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:get/get.dart';

class CatalogController extends GetxController {
  CategoryModel? _category;
  CategoryModel? get category => _category;

  CategoryModel? _subCategory;
  CategoryModel? get subCategory => _subCategory;

  CatalogItemModel? _currentItem;
  CatalogItemModel? get currentItem => _currentItem;

  // set setCategory(String current) {
  //   _category = current;
  // }

  void setCategory(CategoryModel current) {
    _category = current;
    update();
  }

  void setSubCategory(CategoryModel current) {
    _subCategory = current;
    update();
  }

  void setCurrentItem(CatalogItemModel current) {
    _currentItem = current;
    update();
  }
}
