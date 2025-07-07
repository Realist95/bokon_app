import 'dart:convert';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/models/feedback/error_model.dart';
import 'package:bokon_app/models/profile/login_model.dart';
import 'package:bokon_app/services/hive_service.dart';
import 'package:bokon_app/views/home/home_screen.dart';
import 'package:bokon_app/views/profile/register_account_screen.dart';
import 'package:bokon_app/views/profile/validate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

final Dio dio = Dio();

class FormController extends GetxController {
  // final formKey = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) => _isLoading.value = newState;

  void sendErrorForm(String data, context) async {
    // if (formKey.currentState!.validate()) {
    //   formKey.currentState!.save();
    // }

    Uri url = Uri.parse("https://bokon.ru/feedback/getadd");
    setLoading = true;
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

        Navigator.pop(context);
      } else {
        throw Exception('Неизвестная ошибка');
      }
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

  void getSmsCodeForm(String phone, context) async {
    setLoading = true;
    try {
      final response = await dio.post(
        '$apiBaseUrl/auth:send.code',
        data: {"phone": phone},
      );

      if (response.statusCode == 200) {
        ResponseLoginModel data = responseLoginModelFromJson(
          response.data,
        );

        if (!data.success) {
          throw Exception(data.html);
        }

        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ValidateScreen(
              phone: phone,
            ),
          ),
        )
            .then((value) {
          Navigator.of(context).pop(true);
        });
      } else {
        throw Exception('Неизвестная ошибка');
      }
    } catch (e) {
      debugPrint(e.toString());

      Get.snackbar(
        "Ошибка отправки SMS",
        "Повторите попытку позже",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      );
    } finally {
      setLoading = false;
    }
  }

  void validateSmsCodeForm(String phone, String code, context) async {
    setLoading = true;
    try {
      final response = await dio.post(
        '$apiBaseUrl/auth:validate.code',
        data: {"phone": phone, "code": code},
      );

      // debugPrint(response.statusCode.toString());
      // debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        ResponseLoginModel data = responseLoginModelFromJson(response.data);

        if (!data.success) {
          throw Exception(data.html);
        }

        // Get.snackbar(
        //   "Спасибо",
        //   "Ваше сообщение передано администрации, в ближайшее время мы с вами свяжемся!",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: const Color(0xff68C659),
        //   colorText: Colors.white,
        //   margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
        // );

        // Navigator.pop(context);

        // обновим профиль юзера, если он есть
        if (data.userData!.id > 0) {
          HiveService.putUserData(data.userData!);
        }

        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => data.userData!.id <= 0
                ? RegisterAccountScreen(
                    phone: phone,
                  )
                : const HomeScreen(),
          ),
        )
            .then((value) {
          Navigator.of(context).pop(true);
        });
      } else {
        throw Exception('Неизвестная ошибка');
      }
    } on DioException catch (e) {
      // debugPrint(e.response.toString());
      Get.snackbar(
        "Ошибка",
        json.decode(e.response.toString())['error']['message'] ??
            'Не удалось проверить код',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      );
    } finally {
      setLoading = false;
    }
  }

  void regiesterAccountForm(String phone, String name, context) async {
    setLoading = true;
    try {
      final response = await dio.post(
        '$apiBaseUrl/profile:register.account',
        data: {"phone": phone, "name": name},
      );

      // debugPrint(response.statusCode.toString());
      // debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        ResponseLoginModel data = responseLoginModelFromJson(response.data);

        if (!data.success) {
          throw Exception(data.html);
        }

        Get.snackbar(
          "Спасибо",
          "Вы успешно зарегистрировались, дальше мы текст еще не придумали!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff68C659),
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
        );

        // Navigator.pop(context);

        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        )
            .then((value) {
          Navigator.of(context).pop(true);
        });
      } else {
        throw Exception('Неизвестная ошибка');
      }
    } on DioException catch (e) {
      // debugPrint(e.response.toString());
      Get.snackbar(
        "Ошибка",
        json.decode(e.response.toString())['error']['message'] ??
            'Не удалось проверить код',
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
