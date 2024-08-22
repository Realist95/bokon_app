import 'dart:convert';
import 'package:bokon_app/models/feedback/error_model.dart';
import 'package:bokon_app/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FormController extends GetxController {
  // final formKey = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) => _isLoading.value = newState;

  void sendErrorForm(String data) async {
    // if (formKey.currentState!.validate()) {
    //   formKey.currentState!.save();
    // }

    Uri url = Uri.parse("https://bokon.ru/feedback/getadd");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName('utf-8'),
        body: json.decode(data),
      );

      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        ResponseErrorModel data = responseErrorModelFromJson(response.body);

        if (!data.success) {
          throw Exception(data.html);
        }

        Get.snackbar(
          "Спасибо",
          "Ваше сообщение передано администрации, в ближайшее время мы с вами свяжемся!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff68C659),
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
        );
      }

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint(e.toString());

      Get.snackbar(
        "Ошибка",
        "Сообщение не отправлено",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      );
    } finally {
      setLoading = false;
    }
  }
}
