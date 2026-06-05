// import 'dart:convert';

import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:bokon_app/services/hive_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const localPathItems = 'assets/json/catalog_items.json';
const localPathCategories = 'assets/json/catalog_categories.json';

final Dio dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(
      seconds: 5,
    ), // Время до установления соединения, в миллисекундах
    receiveTimeout: const Duration(
      seconds: 2,
    ), // Время ожидания получения ответа, в миллисекундах
    sendTimeout: const Duration(
      seconds: 5,
    ), // Время ожидания отправки данных, в миллисекундах
  ),
);

/// получает список всех категорий
FetchHook useFetchCategories() {
  final categories = useState<List<CatalogCategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  Future<List<CatalogCategoryModel>> getLocalData() async {
    List<CatalogCategoryModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      items = HiveService.getCatalogCategories();

      if (items.isEmpty) {
        String jsonString = await rootBundle.loadString(localPathCategories);
        Map<String, dynamic> jsonData = {
          "items": json.decode(jsonString),
          "paging": {
            "limit": 0,
            "totalItems": 0,
            "totalPages": 0,
          }
        };
        items = responseCategoriesModelFromJson(jsonData).items;
        HiveService.addCatalogCategories(items);
      }

      return items;
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    List<CatalogCategoryModel> result = <CatalogCategoryModel>[];
    try {
      final response = await dio.post(
        '$apiBaseUrl/catalog:get.categories',
        data: {"allTree": 1, "paginated": 0},
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        result = responseCategoriesModelFromJson(response.data).items;
      }

      HiveService.addCatalogCategories(result);
    } catch (e) {
      debugPrint('useFetchCategories');
      debugPrint(e.toString());
      // error.value = e as Exception;
      result = await getLocalData().then((value) {
        return value;
      });
    } finally {
      categories.value = result;
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: categories.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

/// получает ошибки по категории
FetchHook useFetchItems(int parentId, int limit) {
  final items = useState<List<CatalogItemModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);
  Future<List<CatalogItemModel>> getLocalData(
    int parentId, [
    List<int> categories = const [],
  ]) async {
    List<CatalogItemModel> items = [];
    List<int> categoryIds = [];

    if (categories.isNotEmpty) {
      categoryIds = categories;
    } else {
      categoryIds.add(parentId);
    }

    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(milliseconds: 300), () async {
      items = HiveService.getCatalogItems();
      if (items.isEmpty) {
        String jsonString = await rootBundle.loadString(localPathItems);
        Map<String, dynamic> jsonData = {
          "items": json.decode(jsonString),
          "paging": {
            "limit": 0,
            "totalItems": 0,
            "totalPages": 0,
          }
        };
        items = responseItemsModelFromJson(jsonData).items;
        HiveService.addCatalogItems(items);
      }

      items = (items.where((item) {
        return categoryIds.contains(item.maingroup);
      }).toList());

      // items = items.where((product) {
      //   final idStr = product.maingroup.toString();
      //   return !categoryIds.any((num) => idStr.contains(num.toString()));
      // }).toList();

      return items;
    });
  }

  List<int> localCategories = [];
  getAllCategories(List arr, int parentId) {
    for (var item in arr) {
      if (item.id != parentId && item.parent != parentId) {
        print(
            ' item.id ${item.id} item.parent ${item.parent} parentId ${parentId}');
        getAllCategories(item.childrens, parentId);
        continue;
      }

      localCategories.add(item.id);
      if (item.childrens.isNotEmpty) {
        getAllCategories(item.childrens, item.id);
      }
    }

    return localCategories;
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    localCategories = [];
    List<CatalogCategoryModel> treeCategories =
        HiveService.getCatalogCategories();
    List<int> categoryIds = getAllCategories(treeCategories, parentId);

    List<CatalogItemModel> result = <CatalogItemModel>[];
    List<CatalogItemModel> data = <CatalogItemModel>[];
    try {
      final response = await dio.post(
        '$apiBaseUrl/catalog:get.items',
        data: {"category": 0, "paginated": 0},
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        data = responseItemsModelFromJson(response.data).items;
      }

      HiveService.addCatalogItems(data);
    } catch (e) {
      debugPrint('useFetchItems');
      debugPrint(e.toString());
      // error.value = e as Exception;
    } finally {
      items.value = await getLocalData(parentId, categoryIds).then((value) {
        isLoading.value = false;
        return value;
      });
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

FetchHook useFetchCategory(int categoryId) {
  final category = useState<CatalogCategoryModel?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  getCategoryPath(List<CatalogCategoryModel> categories, String categoryId) {
    CatalogCategoryModel? category;

    for (var item in categories) {
      debugPrint(item.id.toString());
      if (item.id == int.parse(categoryId)) {
        category = item;
        break;
      }

      if (item.childrens.isEmpty) {
        continue;
      }

      category = getCategoryPath(item.childrens, categoryId);
      if (category is CatalogCategoryModel) {
        break;
      }
    }

    return category;
  }

  Future<List<CatalogCategoryModel>> getLocalData() async {
    List<CatalogCategoryModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      items = HiveService.getCatalogCategories();
      if (items.isEmpty) {
        String jsonString = await rootBundle.loadString(localPathCategories);
        Map<String, dynamic> jsonData = {
          "items": json.decode(jsonString),
          "paging": {
            "limit": 0,
            "totalItems": 0,
            "totalPages": 0,
          }
        };
        items = responseCategoriesModelFromJson(jsonData).items;
        HiveService.addCatalogCategories(items);
      }

      return items;
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    CatalogCategoryModel? result;
    try {
      result = await getLocalData().then((categories) {
        return getCategoryPath(categories, categoryId.toString());
      });

      print(result!.name);
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('useFetchCategory');
    } finally {
      category.value = result;
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: category.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
