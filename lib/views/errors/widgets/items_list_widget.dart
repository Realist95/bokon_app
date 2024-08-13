import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/errors/single_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/services/img_network.dart';
import 'package:bokon_app/views/errors/items_list.dart';
import 'package:bokon_app/views/errors/subgroups_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsListWidget extends StatelessWidget {
  const ItemsListWidget({super.key, required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      children:
          items.map((item) => GridItem(item: item)).toList(growable: false),
    );
  }
}

class GridItem extends StatefulWidget {
  const GridItem({super.key, required this.item});
  final CatalogItemModel item;

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
        controller.setCurrentItem(widget.item);
        Get.to(
          () => SingleCatalogItems(),
          transition: Transition.leftToRight,
          duration: const Duration(microseconds: 500),
        );
        // controller.setCategory(widget.item);
        // widget.item.childrens.isNotEmpty
        //     ? Get.toNamed("/category/${widget.item.id}")
        //     : Get.to(
        //         () => ItemsList(),
        //         transition: Transition.leftToRight,
        //         duration: const Duration(microseconds: 500),
        //       );
      },
      textColor: kButtonText,
      contentPadding: const EdgeInsets.all(0),
      title: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            height: 1,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .25),
                  spreadRadius: -4,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  offset: Offset(0, 1),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Text(
              widget.item.parent!.titleH1.isNotEmpty
                  ? widget.item.parent!.titleH1
                  : widget.item.parent!.description.toUpperCase(),
              style: appStyle(
                18,
                kPrimary,
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
