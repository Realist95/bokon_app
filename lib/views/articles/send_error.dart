import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/input_filed.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class SendError extends StatefulWidget {
  const SendError({super.key});

  @override
  State<SendError> createState() => _SendErrorState();
}

class _SendErrorState extends State<SendError> {
  final formKey = GlobalKey<FormState>();
  final block = TextEditingController();
  final errorNumber = TextEditingController();
  final generation = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: Column(
          children: [
            Expanded(
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
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(227, 227, 232, 1),
                            ),
                          ),
                        ),
                        child: Text(
                          'Сообщить об ошибке',
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
                                label: "Название блока",
                                textError: "Укажите название блока!",
                                isRequired: true,
                                controller: block,
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
                                  right: 20,
                                  bottom: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Номер ошибки",
                                textError: "Укажите номер ошибки!",
                                isRequired: true,
                                controller: errorNumber,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Годы выпуска",
                                textError: "Укажите годы выпуска!",
                                isRequired: true,
                                controller: generation,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Ваше имя",
                                textError: "Укажите ваше имя!",
                                isRequired: true,
                                controller: name,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Телефон",
                                textError: "Укажите ваш телефон!",
                                isRequired: true,
                                keyboardType: TextInputType.phone,
                                listInputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: "+7(###) ###-##-##"),
                                ],
                                controller: phone,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "E-mail",
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              InputFiled(
                                label: "Сообщение",
                                controller: message,
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
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                    } else {
                                      final snackBar = SnackBar(
                                        backgroundColor: const Color.fromRGBO(
                                            213, 43, 30, 1),
                                        content: Text(
                                          'Вы заполнили не все поля!',
                                          style: appStyle(
                                            18,
                                            Colors.white,
                                            FontWeight.w400,
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          textColor: Colors.white,
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );

                                      // Find the ScaffoldMessenger in the widget tree
                                      // and use it to show a SnackBar.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text(
                                    'Отправить',
                                    style: appStyle(
                                      18,
                                      Colors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
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
