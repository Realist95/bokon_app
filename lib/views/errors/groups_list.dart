import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/catalog_hook.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/views/errors/subgroups_list.dart';
import 'package:bokon_app/views/errors/widgets/categories_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class GroupsList extends HookWidget {
  GroupsList({super.key});
  final controller = Get.put(CatalogController());

  @override
  Widget build(BuildContext context) {
    final int categoryId = int.parse(Get.parameters['id'] ?? '0');
    final hookResult = useFetchCategory(categoryId);

    final CatalogCategoryModel? category = hookResult.data;
    final isLoading = hookResult.isLoading;

    final List<dynamic> items = category?.childrens ?? [];
    if (!isLoading && category is CatalogCategoryModel) {
      controller.setCategory(category);
    }

    if (isLoading) {
      return BackGroundContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 90,
            backgroundColor: Colors.transparent,
            flexibleSpace: MainAppBar(true, category?.name ?? ''),
            automaticallyImplyLeading: false,
          ),
          drawer: const CustomNavigationDrawer(),
          body: const CategoriesShimmer(),
        ),
      );
    }

    return ((category!.childrens.isNotEmpty && category.parent != 0)
        ? SubGroupsList()
        : BackGroundContainer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                toolbarHeight: 90,
                backgroundColor: Colors.transparent,
                flexibleSpace: MainAppBar(true, category.name ?? ''),
                automaticallyImplyLeading: false,
              ),
              drawer: const CustomNavigationDrawer(),
              body: CategoriesGridWidget(
                items: items,
                category: category,
              ),
            ),
          ));
  }
}
