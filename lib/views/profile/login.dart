import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/input_filed.dart';
import 'package:bokon_app/controllers/form_controller.dart';
import 'package:bokon_app/models/profile/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bokon_app/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phone = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false; // чтобы избежать рекурсии при обновлении текста

  final controller = Get.put(FormController());

  @override
  void initState() {
    super.initState();

    phone.addListener(_formatPhoneNumber);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // При фокусе проверяем содержимое
        if (phone.text.isEmpty || !phone.text.startsWith('+7')) {
          phone.text = '+7(';
          // Устанавливаем курсор в конец текста
          phone.selection = TextSelection.fromPosition(
            TextPosition(offset: phone.text.length),
          );
        }
      }
    });
  }

  void _formatPhoneNumber() {
    if (_isEditing) return;
    String text = phone.text;

    // Удаляем все нецифровые символы
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.text.isNotEmpty) return;

    // Заменяем на '+7'
    cleaned = '+7(';

    _isEditing = true;
    phone.value = TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
    _isEditing = false;
  }

  @override
  void dispose() {
    phone.dispose();
    _focusNode.dispose();
    super.dispose();
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
              height: 416,
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
                        padding: const EdgeInsets.symmetric(vertical: 30),
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
                      const Center(
                        child: Text(
                          'Номер телефона',
                          style: TextStyle(
                            color: Color.fromRGBO(248, 148, 75, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        height: 3,
                        color: const Color.fromRGBO(248, 148, 75, 1),
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                          bottom: 30,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InputFiled(
                                focusNode: _focusNode,
                                label: "Телефон",
                                textError: "Укажите ваш телефон!",
                                isRequired: true,
                                keyboardType: TextInputType.phone,
                                listInputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "+7(###) ###-##-##",
                                    initialText: "+7(",
                                  ),
                                ],
                                controller: phone,
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
                                      LoginModel loginModel = LoginModel(
                                        phone: phone.text,
                                        code: '',
                                      );
                                      controller.getSmsCodeForm(
                                        loginModel.phone,
                                        context,
                                      );
                                      return;
                                    }
                                    final snackBar = SnackBar(
                                      backgroundColor:
                                          const Color.fromRGBO(213, 43, 30, 1),
                                      content: Text(
                                        'Номер телефона указан не правильно',
                                        style: appStyle(
                                          18,
                                          Colors.white,
                                          FontWeight.w400,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                        textColor: Colors.white,
                                        label: 'Ok',
                                        onPressed: () {},
                                      ),
                                    );

                                    // Ошибка валидации
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: Text(
                                    controller.isLoading
                                        ? 'Отправка...'
                                        : 'Войти',
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
