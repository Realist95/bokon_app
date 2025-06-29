import 'dart:async';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/input_filed.dart';
import 'package:bokon_app/controllers/form_controller.dart';
import 'package:bokon_app/models/profile/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bokon_app/constants/constants.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({
    super.key,
    required this.phone,
  });

  final String phone;
  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();

  final controller = Get.put(FormController());

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
                          'Регистрация',
                          style: appStyle(
                            24,
                            const Color.fromRGBO(27, 29, 31, 1),
                            FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InputFiled(
                                label: "Ваше имя",
                                textError: "Ввведите пожалуйста ваше имя!",
                                isRequired: true,
                                // keyboardType: TextInputType.number,
                                controller: name,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Номер телефона",
                                textError: "Ввведите пожалуйста ваш телефон!",
                                isRequired: true,
                                keyboardType: TextInputType.number,
                                controller: phone..text = widget.phone,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                readOnly: true,
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
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.regiesterAccountForm(
                                        phone.text,
                                        name.text,
                                        context,
                                      );
                                    }
                                  },
                                  child: Text(
                                    controller.isLoading
                                        ? 'Ожидайте...'
                                        : 'Зарегистрироваться',
                                    style: appStyle(
                                      18,
                                      Colors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
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
