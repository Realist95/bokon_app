import 'dart:async';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/input_filed.dart';
import 'package:bokon_app/controllers/form_controller.dart';
import 'package:bokon_app/models/profile/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bokon_app/constants/constants.dart';

class ValidateScreen extends StatefulWidget {
  const ValidateScreen({
    super.key,
    required this.phone,
  });

  final String phone;
  @override
  State<ValidateScreen> createState() => _ValidateScreenState();
}

class _ValidateScreenState extends State<ValidateScreen> {
  final formKey = GlobalKey<FormState>();
  final code = TextEditingController();
  final int timerValue = 60;
  int _resendTimer = 0;

  final controller = Get.put(FormController());

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _resendTimer = timerValue;
  }

  _startResendTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendTimer--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: mainBg,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 410,
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.white,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(227, 227, 232, 1),
                            ),
                          ),
                        ),
                        child: Text(
                          'Войти',
                          style: appStyle(
                            24,
                            const Color.fromRGBO(27, 29, 31, 1),
                            FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                          bottom: 30,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Мы отправили вам код в SMS на номер: ',
                            style: appStyle(
                              18,
                              const Color.fromRGBO(27, 29, 31, 1),
                              FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: widget.phone,
                                style: appStyle(
                                  18,
                                  const Color.fromRGBO(27, 29, 31, 1),
                                  FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InputFiled(
                                maxLength: 4,
                                label: "Введите код",
                                textError: "Укажите проверочный код!",
                                isRequired: true,
                                keyboardType: TextInputType.number,
                                controller: code,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width - 70),
                                height: 60,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(248, 148, 75, 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                  onPressed: controller
                                          .isLoading // отключаем кнопку, пока идет загрузка кода
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            LoginModel loginModel = LoginModel(
                                              phone: widget.phone,
                                              code: code.text,
                                            );

                                            controller.validateSmsCodeForm(
                                              loginModel.phone,
                                              loginModel.code,
                                              context,
                                            );
                                          }
                                        },
                                  child: Text(
                                    controller.isLoading
                                        ? 'Ожидайте...'
                                        : 'Подтвердить',
                                    style: appStyle(
                                      18,
                                      Colors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              _resendTimer > 0
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Text(
                                        'Отправить код повторно через ${_resendTimer} сек.',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(85, 85, 109, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        controller.getSmsCodeForm(
                                          widget.phone,
                                          context,
                                        );
                                        setState(() {
                                          _resendTimer = timerValue;
                                        });
                                        _startResendTimer();
                                      },
                                      child: const Text(
                                        'Отправить код повторно',
                                        style: TextStyle(
                                          color: Color.fromRGBO(189, 66, 66, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
