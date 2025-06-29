import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/errors/single_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsListWidget extends StatelessWidget {
  const ItemsListWidget({
    super.key,
    required this.items,
    required this.needNotice,
    required this.category,
  });
  final List<dynamic> items;
  final bool needNotice;
  final CatalogCategoryModel? category;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        children: [
          needNotice
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: kButtonBg.withOpacity(.6),
                    border: Border.all(
                        color: const Color.fromRGBO(122, 118, 128, 0.65)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'ВАЖНО!',
                          textAlign: TextAlign.center,
                          style: appStyle(
                            20,
                            const Color(0xFFD52B1E),
                            FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: Text(
                          'Этот код принадлежит к разным системам, выберете интересующий блок для устранения ошибки',
                          textAlign: TextAlign.center,
                          style: appStyle(
                            18,
                            const Color(0xFF464646),
                            FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          ...items.map((item) => GridItem(item: item, category: category!)),
        ]);
  }
}

class GridItem extends StatefulWidget {
  const GridItem({
    super.key,
    required this.item,
    required this.category,
  });
  final CatalogItemModel item;
  final CatalogCategoryModel category;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final controller = Get.put(CatalogController());
  @override
  Widget build(BuildContext context) {
    CatalogCategoryModel parent = widget.category;

    for (var children in widget.category.childrens) {
      if (children.id == widget.item.maingroup) {
        parent = children;
      }
    }

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
            height: 70.h,
            alignment: Alignment.center,
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
              parent.titleH1.isNotEmpty ? parent.titleH1 : parent.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: appStyle(
                16,
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
