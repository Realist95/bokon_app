import 'dart:async';
import 'package:bokon_app/services/hive_service.dart';
import 'package:bokon_app/views/articles/articles_list.dart';
import 'package:bokon_app/views/articles/articles_updates.dart';
import 'package:bokon_app/views/articles/help_article.dart';
import 'package:bokon_app/views/articles/send_error.dart';
import 'package:bokon_app/views/errors/catalog.dart';
import 'package:bokon_app/views/errors/groups_list.dart';
import 'package:bokon_app/views/errors/items_list.dart';
import 'package:bokon_app/views/home/home_screen.dart';
import 'package:bokon_app/views/profile/login.dart';
import 'package:bokon_app/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget defaultHome = const HomeScreen();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.initHive();

  // Connectivity().onConnectivityChanged.listen(
  //   (ConnectivityResult result) {
  //     if (result == ConnectivityResult.none) {
  //       debugPrint('No internet connection');
  //     } else {
  //       debugPrint('Internet connection available');
  //     }
  //   },
  // );

  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Загружает в кэш список категорий для раздела справочник
    // useFetchAllCategories();

    // загружает в кэш список позиций для раздела справочник
    // useFetchAllItems();

    // сохраняет позиции контента в кэш при каждом подключении интернета
    // useFetchAllArticles();

    // сохраняет типы контента в кэш при каждом подключении интернета
    // useFetchAllCtype();

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'БОКОН',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/login',
              page: () => const LoginScreen(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/home',
              page: () => defaultHome,
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/catalog',
              page: () => const CatalogScreen(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/articles-list/:id',
              page: () => const ArticlesList(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/articles-updates',
              page: () => const ArticlesUpdates(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/help',
              page: () => const HelpArticle(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/send-error',
              page: () => const SendError(
                block: '',
                errorNumber: '',
              ),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/category/:id',
              page: () => const GroupsList(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            GetPage(
              name: '/items/:id',
              page: () => ItemsList(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
          ],
        );
      },
    );
  }
}
