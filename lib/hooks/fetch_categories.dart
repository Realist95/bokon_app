import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

      final categoriesPrefs = prefs.getString('CatalogTreeCategories') ?? '';
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

  getAllCategories(List arr, parentid) {
    for (var item in arr) {
      if (item.id == parentId || item.parent == parentId) {
        localCategories.add(item.id);
        getAllCategories(item.childrens, parentid);
      } else if (item.childrens.isNotEmpty) {
        getAllCategories(item.childrens, parentid);
      }
    }

    return localCategories;
  }

  List<int> getLast(List arr, int parentId, List<int> ids) {
    print(arr);
    final categories =
        (arr.where((item) => (item.id == parentId || item.parent == parentId)))
            .toList();

    print(categories);

    for (var category in categories) {
      if (category.childrens.isNotEmpty) {
        getLast(category.childrens, category.id, ids);
      }

      print(category.id);

      if (!ids.contains(category.id)) ids.add(category.id);
    }

    return ids;
  }

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

      final ctypesPrefs = prefs.getString('CatalogItems') ?? '';

      if (ctypesPrefs.isEmpty) return items;

      final localCatalogItems =
          catalogItemsModelFromJson(ctypesPrefs.toString());

      items = (localCatalogItems
          .where((item) => categoryIds.contains(item.maingroup))
          .toList());

      return items;
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    final prefs = await SharedPreferences.getInstance();

    final categoriesPrefs = prefs.getString('CatalogTreeCategories') ?? '';
    List<CategoryModel> treeCategories =
        categoriesModelFromJson(categoriesPrefs.toString());
    List<int> categoryIds = [];

    categoryIds = getAllCategories(treeCategories, parentId);

    // categoryIds = getLast(localCategories, parentId, categoryIds);

    try {
      if (isOnline) {
        // print("$apiBaseUrl/catalog:get.items");
        Uri url = Uri.parse("$apiBaseUrl/catalog:get.items");
        final response = await http.post(
          url,
          body: jsonEncode(
              {"category": parentId.toString(), "limit": limit.toString()}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          // ApiError.value = apiErrorFromJson(response.body);
          items.value = responseItemsModelFromJson(response.body).items;
        }
      } else {
        items.value = await getLocalData(parentId, categoryIds);
      }
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
  // final apiError = useState<ApiError?>(null);

  Future<void> fetchData(getTree) async {
    isLoading.value = true;

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
        // debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          // ApiError.value = apiErrorFromJson(response.body);
          categories.value =
              responseCategoriesModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
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
  // final data = useState<ResponseItemsModel?>(null);
  // final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);
  Future<void> fetchData(parent) async {
    isLoading.value = true;
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
        // debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          // ApiError.value = apiErrorFromJson(response.body);
          items.value = responseItemsModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      // error.value = e as Exception;
      // print(error.value);
    } finally {
      isLoading.value = false;
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
