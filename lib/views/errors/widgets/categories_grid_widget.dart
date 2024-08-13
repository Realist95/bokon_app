import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:flutter/material.dart';
import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/services/img_network.dart';
import 'package:bokon_app/views/errors/items_list.dart';
import 'package:bokon_app/views/errors/subgroups_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesGridWidget extends StatelessWidget {
  const CategoriesGridWidget({super.key, required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: .8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children:
          items.map((item) => GridItem(item: item)).toList(growable: false),
    );
  }
}

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
    final String pathImg = widget.item.image.isNotEmpty
        ? "https://bokon.ru/uploads/shop/photos/original/${widget.item.image}"
        : "https://app.bokon.ru/img/icons/short-logo.jpg";

    return MaterialButton(
      focusColor: kButtonBgActive,
      onPressed: () {
        controller.setCategory(widget.item);
        Get.to(
          () =>
              widget.item.childrens.isNotEmpty ? SubGroupsList() : ItemsList(),
          transition: Transition.leftToRight,
          duration: const Duration(microseconds: 500),
        );
      },
      textColor: kButtonText,
      padding: const EdgeInsets.all(0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            height: 1,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .4),
                  spreadRadius: -6,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              color: kButtonBg.withOpacity(.6),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 350.w,
                  height: 200.h,
                  // fit: FlexFit.tight,
                  child: ImgNetwork(
                    fit: BoxFit.cover,
                    pathImg: pathImg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.item.name.toUpperCase(),
                      style: appStyle(
                        18,
                        kPrimary,
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
