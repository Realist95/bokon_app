import 'dart:io';

import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/views/errors/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/services/img_network.dart';
import 'package:bokon_app/views/errors/items_list.dart';
import 'package:bokon_app/views/errors/subgroups_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CategoriesGridWidget extends HookWidget {
  CategoriesGridWidget({super.key, required this.items});
  final List<dynamic> items;

  final CatalogController controller = Get.find();

  String? validateSearch(String value) {
    return "Укажите не менее 2-х символов";
  }

  @override
  Widget build(BuildContext context) {
    final numberError = TextEditingController();
    final validate = useState<bool>(true);
    final errorText = useState<String>('');

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(244, 245, 246, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: TextField(
            maxLength: 6,
            textInputAction: TextInputAction.go,
            controller: numberError,
            onChanged: (value) {
              final cyrillicRegex = RegExp(r'[А-Яа-я]');
              if (cyrillicRegex.hasMatch(value)) {
                errorText.value = 'Допускается только латиница и цифры.';
              }
            },
            onSubmitted: (value) {
              if (value.isEmpty || value.length < 2) {
                errorText.value = "Укажите не менее 2-х символов";
                validate.value = false;
                return;
              }
              validate.value = true;
              Get.to(
                () => FilterScreen(
                  numberError: numberError,
                  category: controller.category,
                  needNotice: true,
                ),
                transition: Transition.leftToRight,
                duration: const Duration(microseconds: 500),
              );
            },
            decoration: InputDecoration(
              errorText: errorText.value.isNotEmpty ? errorText.value : null,
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 148, 49, 1),
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(222, 222, 226, 1),
                ),
              ),
              focusColor: const Color.fromRGBO(255, 148, 49, 1),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 60,
                maxHeight: 36,
              ),
              prefixIcon: SvgPicture.asset(
                width: 60,
                height: 36,
                'assets/images/keyboard.svg',
              ),
              labelText: "Введите номер ошибки",
              labelStyle: appStyle(
                16,
                const Color.fromRGBO(85, 85, 109, 1),
                FontWeight.w400,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 14),
                child: IconButton(
                  onPressed: () {
                    if (numberError.text.isEmpty ||
                        numberError.text.length < 2) {
                      validate.value = false;
                      return;
                    }
                    validate.value = true;
                    Get.to(
                      () => FilterScreen(
                        numberError: numberError,
                        category: controller.category,
                        needNotice: true,
                      ),
                      transition: Transition.leftToRight,
                      duration: const Duration(microseconds: 500),
                    );
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: SvgPicture.asset(
                      width: 36,
                      height: 36,
                      'assets/images/search.svg',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: .8,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            children: items
                .map((item) => GridItem(item: item))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class GridItem extends StatefulWidget {
  const GridItem({super.key, required this.item});
  final CatalogCategoryModel item;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final controller = Get.put(CatalogController());

  @override
  Widget build(BuildContext context) {
    const String imagePath =
        '/data/user/0/com.bokon_app.test.bokon_app/cache/uploads/shop/photos/original/';
    final String pathImg = widget.item.image.isNotEmpty
        ? imagePath + widget.item.image
        : 'assets/images/short-logo.png';

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
                  child:
                      //   ImgNetwork(
                      //     fit: BoxFit.cover,
                      //     pathImg: pathImg,
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(16),
                      //       topRight: Radius.circular(16),
                      //       bottomRight: Radius.circular(8),
                      //       bottomLeft: Radius.circular(8),
                      //     ),
                      //   )
                      // :
                      ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: widget.item.image.isNotEmpty
                        ? Image.file(
                            File(pathImg),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/short-logo.png',
                            fit: BoxFit.cover,
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
                        20,
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
