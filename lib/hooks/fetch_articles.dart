import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchArticles(int ctype, [int limit = 10]) {
  final categories = useState<List<ArticleModel>?>(null);
  // final categories = useState<List<CategoryModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  // final apiError = useState<ApiError?>(null);

  Future<void> fetchData(int ctype) async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse("$apiBaseUrl/content:get.items");
      final response = await http.post(
        url,
        body: jsonEncode({
          "ctype": ctype,
          "limit": limit,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        // ApiError.value = apiErrorFromJson(response.body);
        categories.value = responseArticlesModelFromJson(response.body).items;
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
    fetchData(ctype);
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData(ctype);
  }

  return FetchHook(
    data: categories.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
