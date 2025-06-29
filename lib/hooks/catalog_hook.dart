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

final Dio dio = Dio();

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
    categories.value = await getLocalData().then((value) {
      isLoading.value = false;
      return value;
    });

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
    } catch (e) {
      debugPrint('useFetchCategories');
      debugPrint(e.toString());
      // error.value = e as Exception;
    } finally {
      HiveService.addCatalogCategories(result);
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
    return Future.delayed(const Duration(seconds: 1), () async {
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

      items = (items
          .where((item) => categoryIds.contains(item.maingroup))
          .toList());

      return items;
    });
  }

  List<int> localCategories = [];
  getAllCategories(List arr, int parentId) {
    for (var item in arr) {
      if (item.id != parentId && item.parent != parentId) {
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

    List<CatalogCategoryModel> treeCategories =
        HiveService.getCatalogCategories();
    List<int> categoryIds = getAllCategories(treeCategories, parentId);

    items.value = await getLocalData(parentId, categoryIds).then((value) {
      isLoading.value = false;
      return value;
    });

    List<CatalogItemModel> result = <CatalogItemModel>[];
    try {
      final response = await dio.post(
        '$apiBaseUrl/catalog:get.items',
        data: {"category": 0, "paginated": 0},
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        result = responseItemsModelFromJson(response.data).items;
      }
    } catch (e) {
      debugPrint('useFetchCategories');
      debugPrint(e.toString());
      // error.value = e as Exception;
    } finally {
      HiveService.addCatalogItems(result);
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
