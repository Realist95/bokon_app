import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/hooks/articles_hook.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/views/articles/widgets/grid_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class ArticlesList extends HookWidget {
  const ArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    var params = Get.parameters;
    int? ctype = int.parse((params['id'] ?? '0').toString());

    final String title = params['title'].toString();

    final hookResult = useFetchArticles(ctype);
    List<ArticleModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: MainAppBar(true, title),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: isLoading
            ? const CategoriesShimmer()
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                children: items
                    .map(
                      (item) => !item.isSpecial
                          ? GridArticle(item: item, arguments: const {})
                          : const SizedBox(),
                    )
                    .toList(growable: false),
              ),
      ),
    );
  }
}
