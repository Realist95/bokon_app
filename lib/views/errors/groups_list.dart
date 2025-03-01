import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/views/errors/subgroups_list.dart';
import 'package:bokon_app/views/errors/widgets/categories_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsList extends StatelessWidget {
  GroupsList({super.key});
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<dynamic> items = controller.category!.childrens;

    return controller.category!.id == 1284
        ? SubGroupsList()
        : BackGroundContainer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                toolbarHeight: 90,
                backgroundColor: Colors.transparent,
                flexibleSpace: MainAppBar(true, controller.category!.name),
                automaticallyImplyLeading: false,
              ),
              drawer: const CustomNavigationDrawer(),
              body: CategoriesGridWidget(items: items),
            ),
          );
  }
}
