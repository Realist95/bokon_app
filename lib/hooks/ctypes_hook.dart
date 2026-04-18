import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/models/hook_models/hook_result.dart';
import 'package:bokon_app/services/hive_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

FetchHook useFetchCtype(int ctype) {
  final articles = useState<List<CtypeModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  /// ищет локальные позиции по типу контента
  Future<List<CtypeModel>> getLocalData(int ctype, [int limit = 10]) async {
    List<CtypeModel> items = [];
    // Simulate fetching data from a remote server
    return Future.delayed(const Duration(seconds: 1), () async {
      final localArticles = HiveService.getCtypes();

      for (CtypeModel item in localArticles) {
        print(ctype);
        print(item.id);
        if (item.id != ctype) continue;
        items.add(item);
        if (items.length == limit) break;
      }
      return items;
    });
  }

  Future<void> fetchData(int ctype) async {
    isLoading.value = true;

    List<CtypeModel> result = <CtypeModel>[];

    try {
      final response = await dio.post(
        '$apiBaseUrl/content:get.ctypes',
        data: {"limit": 1000},
      );
      // debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        result = responseCtypesModelFromJson(response.data).items;
      }
      // обновит позиции контента
      HiveService.addCtypes(result);
    } catch (e) {
      debugPrint('useFetchCtype');
      debugPrint(e.toString());
      // error.value = e as Exception;
      // print(error.value);
    } finally {
      if (result.isNotEmpty) {
        articles.value = await getLocalData(ctype);
        isLoading.value = false;
      }
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
