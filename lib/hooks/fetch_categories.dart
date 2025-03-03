import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const keyCacheItems = 'cacheCatalogItems';
const localPathItems = 'assets/json/catalog_items.json';

const keyCacheCategories = 'cacheCatalogTreeCategories';
const localPathCategories = 'assets/json/catalog_categories.json';

FetchHook useFetchCategories() {
  final categories = useState<List<CategoryModel>?>(null);
  // final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  Future<List<CategoryModel>> getLocalData() async {
    List<CategoryModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();

      final categoriesPrefs = prefs.getString(keyCacheCategories) ?? '';
      if (categoriesPrefs.isEmpty) return items;

      items = categoriesModelFromJson(categoriesPrefs.toString());

      return items;
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    try {
      if (isOnline) {
        Uri url = Uri.parse("$apiBaseUrl/catalog:get.categories");
        final response = await http.post(url);
        debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          // ApiError.value = apiErrorFromJson(response.body);
        }
        categories.value = responseCategoriesModelFromJson(response.body).items;
      } else {
        categories.value = await getLocalData();
      }
    } catch (e) {
      debugPrint('useFetchCategories');
      debugPrint(e.toString());
      // error.value = e as Exception;
      // print(error.value);
    } finally {
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

FetchHook useFetchItems(int parentId, int limit) {
  final items = useState<List<CatalogItemModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  List<int> localCategories = [];
  // List<CategoryModel> localCategories = [];

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

  // List<int> getLast(List arr, int parentId, List<int> ids) {
  //   print(arr);
  //   final categories =
  //       (arr.where((item) => (item.id == parentId || item.parent == parentId)))
  //           .toList();

  //   print(categories);

  //   for (var category in categories) {
  //     if (category.childrens.isNotEmpty) {
  //       getLast(category.childrens, category.id, ids);
  //     }

  //     print(category.id);

  //     if (!ids.contains(category.id)) ids.add(category.id);
  //   }

  //   return ids;
  // }

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
      final prefs = await SharedPreferences.getInstance();

      final catalogItems = prefs.getString(keyCacheItems) ?? '';
      if (catalogItems.isEmpty) return items;

      final localCatalogItems =
          catalogItemsModelFromJson(catalogItems.toString());

      items = (localCatalogItems
          .where((item) => categoryIds.contains(item.maingroup))
          .toList());

      return items;
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    // final isOnline =
    // await Connectivity().checkConnectivity() != ConnectivityResult.none;

    final prefs = await SharedPreferences.getInstance();

    final categoriesPrefs = prefs.getString(keyCacheCategories) ?? '';
    List<CategoryModel> treeCategories =
        categoriesModelFromJson(categoriesPrefs.toString());
    List<int> categoryIds = [];

    categoryIds = getAllCategories(treeCategories, parentId);
    // print(categoryIds);

    // categoryIds = getLast(localCategories, parentId, categoryIds);

    try {
      items.value = await getLocalData(parentId, categoryIds);
      // if (isOnline) {
      //   // print("$apiBaseUrl/catalog:get.items");
      //   Uri url = Uri.parse("$apiBaseUrl/catalog:get.items");
      //   final response = await http.post(
      //     url,
      //     body: jsonEncode(
      //         {"category": parentId.toString(), "limit": limit.toString()}),
      //     headers: {
      //       'Content-Type': 'application/json; charset=UTF-8',
      //     },
      //   );
      //   debugPrint(response.statusCode.toString());
      //   if (response.statusCode == 200) {
      //     // ApiError.value = apiErrorFromJson(response.body);
      //     items.value = responseItemsModelFromJson(response.body).items;
      //   }
      // } else {
      //   items.value = await getLocalData(parentId, categoryIds);
      // }
    } catch (e) {
      debugPrint('useFetchItemsError');
      debugPrint(e.toString());
      // debugPrint(e.toString());
      // error.value = e as Exception;
      // print(error.value);
    } finally {
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
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

FetchHook useFetchAllCategories([bool getTree = true]) {
  final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData(getTree) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    try {
      if (isOnline) {
        Uri url = Uri.parse("$apiBaseUrl/catalog:get.categories");
        final response = await http.post(
          url,
          body: jsonEncode({
            "allTree": 1,
            "paginated": 0,
            "getTree": getTree,
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          categories.value =
              responseCategoriesModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      String catalogCategories = '';
      if (categories.value != null) {
        catalogCategories = categoriesModelToJson(categories.value ?? []);
      }

      /// Если ранее в кэше не было ошибок, то загрузим ошибки из файла
      if (prefs.getString(keyCacheCategories) == null ||
          prefs.getString(keyCacheCategories).toString().isEmpty) {
        /// Получает файл с ошибками из локального файла
        catalogCategories = await rootBundle.loadString(localPathCategories);
      }

      /// Сохраняет категории в кэш, если они имеются
      if (catalogCategories.isNotEmpty) {
        prefs.setString(keyCacheCategories, catalogCategories);
      }
    }
  }

  useEffect(() {
    fetchData(getTree);
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData(getTree);
  }

  return FetchHook(
    data: categories.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

FetchHook useFetchAllItems([int parent = 0]) {
  final items = useState<List<CatalogItemModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData(parent) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    try {
      if (isOnline) {
        Uri url = Uri.parse("$apiBaseUrl/catalog:get.items");
        final response = await http.post(
          url,
          body: jsonEncode({"category": 0, "paginated": 0}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          items.value = responseItemsModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      String catalogItems = '';
      if (items.value != null) {
        catalogItems = itemsModelToJson(items.value ?? []);
      }

      /// Если ранее в кэше не было ошибок, то загрузим ошибки из файла
      if (prefs.getString(keyCacheItems) == null ||
          prefs.getString(keyCacheItems).toString().isEmpty) {
        /// Получает файл с ошибками из локального файла
        catalogItems = await rootBundle.loadString(localPathItems);
      }

      /// Сохраняет категории в кэш, если они имеются
      if (catalogItems.isNotEmpty) {
        prefs.setString(keyCacheItems, catalogItems);
      }
    }
  }

  useEffect(() {
    fetchData(parent);
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData(parent);
  }

  return FetchHook(
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
