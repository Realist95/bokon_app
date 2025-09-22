import 'package:bokon_app/common/app_style.dart';
// import 'package:bokon_app/common/input_filed.dart';
import 'package:bokon_app/controllers/form_controller.dart';
import 'package:bokon_app/models/profile/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phone = TextEditingController();
  String phoneNumber = '';
  bool isValid = false;

  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');

  final controller = Get.put(FormController());

  // @override
  // void initState() {
  //   super.initState();

  //   print(number);

  //   // phone.addListener(_formatPhoneNumber);
  //   // _focusNode.addListener(() {
  //   //   if (_focusNode.hasFocus) {
  //   //     // При фокусе проверяем содержимое
  //   //     if (phone.text.isEmpty || !phone.text.startsWith('+7')) {
  //   //       phone.text = '+7(';
  //   //       // Устанавливаем курсор в конец текста
  //   //       phone.selection = TextSelection.fromPosition(
  //   //         TextPosition(offset: phone.text.length),
  //   //       );
  //   //     }
  //   //   }
  //   // });
  // }

  // void _formatPhoneNumber() {
  //   if (_isEditing) return;
  //   String text = phone.text;

  //   // Удаляем все нецифровые символы
  //   String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
  //   if (phone.text.isNotEmpty) return;

  //   // Заменяем на '+7'
  //   cleaned = '+7(';

  //   _isEditing = true;
  //   phone.value = TextEditingValue(
  //     text: cleaned,
  //     selection: TextSelection.collapsed(offset: cleaned.length),
  //   );
  //   _isEditing = false;
  // }

  // @override
  // void dispose() {
  //   // phone.dispose();
  //   // _focusNode.dispose();
  //   super.dispose();
  // }

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
                              Container(
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(227, 227, 232, .2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(227, 227, 232, 1),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    InternationalPhoneNumberInput(
                                      selectorButtonOnErrorPadding: 0,
                                      searchBoxDecoration: InputDecoration(
                                        label: const Text(
                                            'Введите название страны'),
                                        labelStyle: appStyle(
                                          18,
                                          const Color.fromRGBO(85, 85, 109, 1),
                                          FontWeight.w400,
                                        ),
                                      ),
                                      inputDecoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: 0,
                                          bottom: 10,
                                          left: 0,
                                          right: 0,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Телефон',
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromRGBO(85, 85, 109, 1),
                                          fontWeight: FontWeight.w400,
                                          textBaseline: TextBaseline.alphabetic,

                                          // textAlign: TextAlign.left,
                                          // textAlignVertical: TextAlignVertical.top,
                                        ),
                                      ),
                                      countries: const ['RU', 'KZ', 'BY'],
                                      maxLength: 13,
                                      onInputChanged: (PhoneNumber number) {
                                        phoneNumber = number.phoneNumber ?? '';
                                      },
                                      autoFocus: true,
                                      onInputValidated: (bool value) {
                                        setState(() {
                                          isValid = value;
                                        });
                                      },
                                      locale: 'ru',
                                      selectorConfig: const SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.DIALOG,
                                        trailingSpace: false,
                                        leadingPadding: 5,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode:
                                          AutovalidateMode.disabled,
                                      selectorTextStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(85, 85, 109, 1),
                                        fontWeight: FontWeight.w400,
                                        textBaseline: TextBaseline.alphabetic,

                                        // textAlign: TextAlign.left,
                                        // textAlignVertical: TextAlignVertical.top,
                                      ),
                                      initialValue: number,
                                      textFieldController: phone,
                                      formatInput: true,
                                      inputBorder: InputBorder.none,
                                      onSaved: (PhoneNumber number) {
                                        print('On Saved: $number');
                                      },
                                      spaceBetweenSelectorAndTextField: 0,
                                      // hintText: 'Телефон',
                                      errorMessage: 'Укажите ваш телефон!',
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 70),
                                  height: 60,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: (!isValid || controller.isLoading)
                                        ? const Color.fromRGBO(248, 148, 75, .4)
                                        : const Color.fromRGBO(248, 148, 75, 1),
                                    borderRadius: const BorderRadius.all(
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
                                      if (!isValid || controller.isLoading) {
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        LoginModel loginModel = LoginModel(
                                          phone: phoneNumber,
                                          code: '',
                                        );
                                        controller.getSmsCodeForm(
                                          loginModel.phone,
                                          context,
                                        );
                                      }
                                      return;
                                      final snackBar = SnackBar(
                                        backgroundColor: const Color.fromRGBO(
                                            213, 43, 30, 1),
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
