import 'package:bokon_app/views/articles/articles_list.dart';
import 'package:bokon_app/views/articles/articles_updates.dart';
import 'package:bokon_app/views/articles/help_article.dart';
import 'package:bokon_app/views/articles/send_error.dart';
import 'package:bokon_app/views/errors/catalog.dart';
import 'package:bokon_app/views/errors/groups_list.dart';
import 'package:bokon_app/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget defaultHome = const HomeScreen();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          // home: defaultHome,
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
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
