import 'dart:async';
import 'package:bokon_app/hooks/fetch_articles.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/views/articles/articles_list.dart';
import 'package:bokon_app/views/articles/articles_updates.dart';
import 'package:bokon_app/views/articles/help_article.dart';
import 'package:bokon_app/views/articles/send_error.dart';
import 'package:bokon_app/views/errors/catalog.dart';
import 'package:bokon_app/views/errors/groups_list.dart';
import 'package:bokon_app/views/home/home_screen.dart';
import 'package:bokon_app/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

Widget defaultHome = const HomeScreen();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Connectivity().onConnectivityChanged.listen(
    (ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        debugPrint('No internet connection');
      } else {
        debugPrint('Internet connection available');
      }
    },
  );

  final String catalogItems =
      await rootBundle.loadString('assets/json/catalog_items.json');
  final String catalogCategories =
      await rootBundle.loadString('assets/json/catalog_categories.json');

  if (prefs.getString('CatalogItems') == null ||
      prefs.getString('CatalogItems').toString().isEmpty) {
    prefs.setString('CatalogItems', catalogItems);
  }

  if (prefs.getString('CatalogTreeCategories') == null ||
      prefs.getString('CatalogTreeCategories').toString().isEmpty) {
    prefs.setString('CatalogTreeCategories', catalogCategories);
  }

  runApp(MyApp(preferences: prefs));
}

class MyApp extends HookWidget {
  const MyApp({
    super.key,
    required this.preferences,
  });

  final SharedPreferences preferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final hookCatalogTreeCategories = useFetchAllCategories();
    if (hookCatalogTreeCategories.isLoading == false &&
        hookCatalogTreeCategories.data != null) {
      preferences.setString(
        'CatalogTreeCategories',
        categoriesModelToJson(hookCatalogTreeCategories.data),
      );
    }

    final hookCatalogItems = useFetchAllItems();
    if (hookCatalogItems.isLoading == false && hookCatalogItems.data != null) {
      // print(hookCatalogItems.data);
      preferences.setString(
        'CatalogItems',
        itemsModelToJson(hookCatalogItems.data),
      );
    }

    // сохраняет позиции контента в кэш при каждом подключении интернета
    useFetchAllArticles();

    // сохраняет типы контента в кэш при каждом подключении интернета
    useFetchAllCtype();

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
            // GetPage(
            //   name: '/profile/',
            //   page: () => MyProfile(),
            // ),
            GetPage(
              name: '/category/:id',
              page: () => GroupsList(),
              transition: Transition.leftToRight,
              transitionDuration: const Duration(microseconds: 500),
            ),
            // GetPage(
            //   name: '/third',
            //   page: () => Third(),
            //   transition: Transition.cupertino,
            // ),
          ],
        );
      },
    );
  }
}
