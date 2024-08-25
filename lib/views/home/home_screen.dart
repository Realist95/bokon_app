import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_articles.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/views/articles/widgets/grid_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
          flexibleSpace: const MainAppBar(false, 'Главная'),
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
                      // horizontal: 15,
                      vertical: 15,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      children: widget.newsList
                          .map(
                            (item) => GridArticle(
                              item: item,
                              arguments: const {"title": "Новости"},
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      // horizontal: 15,
                      vertical: 15,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      children: widget.itemsList
                          .map(
                            (item) => GridArticle(
                              item: item,
                              arguments: const {"title": "Инструкция"},
                            ),
                          )
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
