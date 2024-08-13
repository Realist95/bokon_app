// import 'dart:ffi';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_articles.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchArticles(8, 5);
    final List<ArticleModel> newsList = hookResult.data ?? [];
    bool isLoading = hookResult.isLoading;

    final hookResult2 = useFetchArticles(10, 5);
    final List<ArticleModel> itemsList = hookResult2.data ?? [];

    // final error = hookResult.error;

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(false),
        ),
        drawer: const CustomNavigationDrawer(),
        body: isLoading
            ? const CategoriesShimmer()
            : ContentWidgetTabs(newsList: newsList, itemsList: itemsList),
      ),
    );
  }
}

// ignore: must_be_immutable
class ContentWidgetTabs extends StatefulWidget {
  const ContentWidgetTabs({
    super.key,
    required this.newsList,
    required this.itemsList,
  });

  // final CategoryModel item;
  final List<ArticleModel> newsList;
  final List<ArticleModel> itemsList;

  @override
  State<ContentWidgetTabs> createState() => _ContentWidgetTabsState();
}

class _ContentWidgetTabsState extends State<ContentWidgetTabs> {
  final controller = Get.put(CatalogController());
  // TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              automaticIndicatorColorAdjustment: false,
              isScrollable: false,
              // indicatorSize: TabBarIndicatorSize.tab,
              // controller: _tabController,
              indicatorColor: const Color.fromRGBO(251, 97, 74, 1),
              indicatorSize: TabBarIndicatorSize.label,
              // labelColor: const Color.fromRGBO(251, 97, 74, 1),
              unselectedLabelColor: const Color.fromRGBO(51, 50, 50, 1),
              labelStyle: appStyle(
                16,
                const Color.fromRGBO(251, 97, 74, 1),
                FontWeight.w500,
              ),
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: BorderRadius.circular(25),
              ),
              tabs: const [
                Text('Новости'),
                // Text('Обновления'),
                Text('Инструкция'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      children: widget.newsList
                          .map((item) => GridArticle(item: item))
                          .toList(growable: false),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      children: widget.itemsList
                          .map((item) => GridArticle(item: item))
                          .toList(growable: false),
                    ),
                  ),
                  // Center(
                  //   child: Text('test 1'),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GridArticle extends StatefulWidget {
  const GridArticle({super.key, required this.item});
  final ArticleModel item;

  @override
  State<GridArticle> createState() => _GridArticleState();
}

class _GridArticleState extends State<GridArticle> {
  // final controller = Get.put(ContentController());

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      // focusColor: kButtonBgActive,
      onPressed: () {
        // controller.setCurrentItem(widget.item);
        // Get.to(
        //   () => SingleArticle(),
        //   transition: Transition.leftToRight,
        //   duration: const Duration(microseconds: 500),
        // );
      },
      // textColor: kButtonText,
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(16),
          height: 236.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.59),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                widget.item.name,
                style: appStyle(
                  19,
                  const Color.fromRGBO(27, 30, 36, 1),
                  FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.item.description,
                style: appStyle(
                  14,
                  const Color.fromRGBO(27, 30, 36, 1),
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // margin: margin,
                    height: 40.h,
                    width: 120.w,
                    // padding:
                    // const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "прочитать".toUpperCase(),
                        style: appStyle(
                          14,
                          const Color.fromRGBO(255, 117, 54, 1),
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
