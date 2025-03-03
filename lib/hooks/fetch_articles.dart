import 'dart:convert';

import 'package:bokon_app/constants/constants.dart';
// import 'package:bokon_app/models/api_error.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const keyCtypeCache = 'cacheCtypes';

const keyCtypeArticles = 'cacheArticles';

FetchHook useFetchArticles(int ctype, [int limit = 10]) {
  final articles = useState<List<ArticleModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  /// ищет локальные позиции по типу контента
  Future<List<ArticleModel>> getLocalData(int ctype) async {
    List<ArticleModel> items = [];

    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();

      final articlesPrefs = prefs.getString(keyCtypeArticles) ?? '';
      if (articlesPrefs.isNotEmpty) {
        final localArticles = articlesModelFromJson(articlesPrefs.toString());
        items = (localArticles
            .where((item) => item.ctype.contains(ctype.toString()))
            .toList());
      }

      return items;
    });
  }

  Future<void> fetchData(int ctype) async {
    isLoading.value = true;

    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    try {
      articles.value = await getLocalData(ctype);
      if (articles.value == null || articles.value!.isEmpty && isOnline) {
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
        // debugPrint(response.statusCode.toString());
        // debugPrint(response.body);
        if (response.statusCode == 200) {
          // ApiError.value = apiErrorFromJson(response.body);
          articles.value = responseArticlesModelFromJson(response.body).items;
        }
      }

      // print(articles.value);
      //   articles.value = await getLocalData(ctype);
      // }
    } catch (e) {
      // debugPrint('useFetchArticles');
      // debugPrint(e.toString());
      // debugPrint(e.toString());
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
    data: articles.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

FetchHook useFetchCtype(int ctype, [int limit = 10]) {
  final ctypes = useState<List<CtypeModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  /// ищет локальные типы контента по id
  Future<List<CtypeModel>> getLocalData(int ctype) async {
    List<CtypeModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();

      final ctypesPrefs = prefs.getString(keyCtypeCache) ?? '';

      if (ctypesPrefs.isEmpty) return items;

      final localCtypes = ctypeModelFromJson(ctypesPrefs.toString());
      items = (localCtypes.where((item) => item.id == ctype).toList());

      return items;
    });
  }

  Future<void> fetchData(int ctype) async {
    isLoading.value = true;
    // final isOnline =
    // await Connectivity().checkConnectivity() != ConnectivityResult.none;
    try {
      ctypes.value = await getLocalData(ctype);
      // if (isOnline) {
      //   Uri url = Uri.parse("$apiBaseUrl/content:get.ctypes");
      //   final response = await http.post(
      //     url,
      //     body: jsonEncode({
      //       "ctype": ctype,
      //       "limit": limit,
      //     }),
      //     headers: {
      //       'Content-Type': 'application/json; charset=UTF-8',
      //     },
      //   );
      //   debugPrint(response.statusCode.toString());
      //   debugPrint(response.body);
      //   if (response.statusCode == 200) {
      //     ctypes.value = responseCtypesModelFromJson(response.body).items;
      //   }
      // } else {
      //   ctypes.value = await getLocalData(ctype);
      // }
    } catch (e) {
      // debugPrint('useFetchCtype');
      // debugPrint(e.toString());
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
    data: ctypes.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

/// загружает с сервера все позиции контента
FetchHook useFetchAllArticles() {
  final items = useState<List<ArticleModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    isLoading.value = true;

    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    try {
      if (isOnline) {
        Uri url = Uri.parse("$apiBaseUrl/content:get.items");
        final response = await http.post(
          url,
          body: jsonEncode({"paginated": 0}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          items.value = responseArticlesModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      debugPrint(articlesModelToJson(items.value ?? []));

      if (items.value != null) {
        prefs.setString(
          keyCtypeArticles,
          articlesModelToJson(items.value ?? []),
        );
      }
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

/// загружает типы контента в локлаьное хранилище
FetchHook useFetchAllCtype() {
  final ctypes = useState<List<CtypeModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    try {
      if (isOnline) {
        Uri url = Uri.parse("$apiBaseUrl/content:get.ctypes");
        final response = await http.post(
          url,
          body: jsonEncode({"paginated": 0}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          ctypes.value = responseCtypesModelFromJson(response.body).items;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      if (ctypes.value != null) {
        prefs.setString(
          keyCtypeCache,
          ctypeModelToJson(ctypes.value ?? []),
        );
      }
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
    data: ctypes.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
