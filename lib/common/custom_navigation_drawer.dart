import 'dart:io';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_share/flutter_share.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Скачать приложение',
      text: 'Скачать приложение',
      linkUrl: 'https://bokon.ru/download-app',
      chooserTitle: 'Здесь можно скачать актуальную версию приложения',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      width: MediaQuery.of(context).size.width - 90,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .25),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                top: 0,
                bottom: 10,
                left: 16,
              ),
              minTileHeight: 0,
              title: Text(
                'Меню'.toUpperCase(),
                style: const TextStyle(
                  color: kButtonText,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildMenuItem('Главная', '/', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem('Справочник', '/catalog', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem('Новости', '/articles-list/8',
                      {"id": "8", "title": "Новости"}, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem('Инструкция', '/articles-list/10',
                      {"id": "10", "title": "Инструкция"}, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem(
                      'О приложении', '/articles-updates', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem('Помощь', '/help', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem(
                      'Поделиться приложением', 'share', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem(
                      'Сообщить об ошибке', '/send-error', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                  buildMenuItem('Выход', 'exit', null, context),
                  Container(
                    height: 1,
                    color: const Color(0xFFbfbfbf),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(String text, String navigation,
      Map<String, String>? parameters, context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        if (navigation == 'share') {
          share();
          return;
        }
        if (navigation == 'exit') {
          exit(0);
          // AlertDialog(
          //   title: const Text('Please confirm'),
          //   content: const Text('Do you want to exit the app?'),
          //   actions: <Widget>[
          //     TextButton(
          //       onPressed: () => Navigator.of(context).pop(false),
          //       child: const Text('No'),
          //     ),
          //     TextButton(
          //       onPressed: () => Navigator.of(context).pop(true),
          //       child: const Text('Yes'),
          //     ),
          //   ],
          // );
        }

        Navigator.of(context).pop(true);
        Get.toNamed(navigation, parameters: parameters);
      },
      title: Text(
        text,
        style: appStyle(16, kButtonText, FontWeight.w400),
      ),
    );
  }
}
