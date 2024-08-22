// import 'dart:ffi';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class CatalogScreen extends HookWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCategories();

    List<CategoryModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true, 'Справочник'),
        ),
        drawer: const CustomNavigationDrawer(),
        body: isLoading
            ? const CategoriesShimmer()
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                children: items
                    .map((item) => GridItem(item: item))
                    .toList(growable: false),
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GridItem extends StatefulWidget {
  const GridItem({super.key, required this.item});

  final CategoryModel item;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final controller = Get.put(CatalogController());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: kButtonBgActive,
      onTap: () {
        controller.setCategory(widget.item);
        Get.toNamed("/category/${widget.item.id}");
      },
      textColor: kButtonText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: kButtonBg.withOpacity(.6),
          border: Border.all(
            color: kButtonBorder,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .8),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 0),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.item.name,
              style: appStyle(
                18,
                kPrimary,
                FontWeight.w500,
              ),
            ),
            Text(
              widget.item.description,
              style: appStyle(
                14,
                kPrimary,
                FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class GridItem extends StatefulWidget {
//   const GridItem({super.key, required this.item});

//   final CategoryModel item;

//   @override
//   State<GridItem> createState() => _GridItemState();
// }

// class _GridItemState extends State<GridItem> {
//   final controller = Get.put(CatalogController());

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       focusColor: kButtonBgActive,
//       onTap: () {
//         controller.setCategory(widget.item);
//         Get.toNamed("/category/${widget.item.id}");
//       },
//       textColor:
//           (widget.item.id == controller.category?.id) ? kButtonBg : kButtonText,
//       contentPadding: const EdgeInsets.all(0),
//       title: !(widget.item.id == controller.category?.id)
//           ? Stack(
//               alignment: AlignmentDirectional.bottomEnd,
//               children: [
//                 Container(
//                   height: 1,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, .25),
//                         spreadRadius: -4,
//                         blurRadius: 1,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//                     color: kButtonBg.withOpacity(.6),
//                     border: Border.all(
//                       color: kButtonBorder,
//                     ),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, .8),
//                         spreadRadius: 0,
//                         blurRadius: 3,
//                         offset: Offset(0, 1),
//                         blurStyle: BlurStyle.outer,
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     widget.item.name.toUpperCase(),
//                     style: appStyle(
//                       18,
//                       kPrimary,
//                       FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           // оранжевая кнопка рабочий вариант
//           : Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(6.0)),
//                 border: Border.all(
//                   color: kButtonBorder,
//                 ),
//                 boxShadow: [
//                   const BoxShadow(
//                     color: Color.fromRGBO(0, 0, 0, .4),
//                     blurStyle: BlurStyle.inner,
//                   ),
//                   BoxShadow(
//                     color: kButtonBgActive.withOpacity(.8),
//                     spreadRadius: -2.0,
//                     blurRadius: 2.0,
//                     offset: const Offset(
//                       2,
//                       1.0,
//                     ),
//                   ),
//                   BoxShadow(
//                     color: kButtonBgActive.withOpacity(.8),
//                     spreadRadius: -2.0,
//                     blurRadius: 2.0,
//                     offset: const Offset(
//                       -2,
//                       1.0,
//                     ),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   widget.item.name.toString().toUpperCase(),
//                   style: appStyle(
//                     18,
//                     Colors.white,
//                     FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
