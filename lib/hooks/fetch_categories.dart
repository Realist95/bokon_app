import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchCategories() {
  final categories = useState<List<CategoryModel>?>(null);
  // final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse("$apiBaseUrl/catalog:get.categories");
      final response = await http.post(url);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        // ApiError.value = apiErrorFromJson(response.body);
      }

      categories.value = responseCategoriesModelFromJson(response.body).items;
    } catch (e) {
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
  final categories = useState<List<CatalogItemModel>?>(null);
  // final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      print("$apiBaseUrl/catalog:get.items");
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
      // print(response.body);
      if (response.statusCode == 200) {
        // ApiError.value = apiErrorFromJson(response.body);
        categories.value = responseItemsModelFromJson(response.body).items;
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
