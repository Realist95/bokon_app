import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/views/errors/filter_screen.dart';
import 'package:bokon_app/views/errors/items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubGroupsList extends HookWidget {
  SubGroupsList({super.key});
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final items = controller.category!.childrens;
    final hookResult = useFetchItems(controller.category!.id, 10000);
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final numberError = TextEditingController();
    final validate = useState<bool>(true);

    String? validateSearch(String value) {
      return "Укажите не менее 2-х символов";
    }

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: MainAppBar(true, controller.category!.name),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: Column(
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
                onSubmitted: (value) {
                  if (value.isEmpty || value.length < 2) {
                    validate.value = false;
                    return;
                  }
                  validate.value = true;
                  Get.to(
                    () => FilterScreen(
                      numberError: numberError,
                      categoryId: controller.category!.id,
                      needNotice: true,
                    ),
                    transition: Transition.leftToRight,
                    duration: const Duration(microseconds: 500),
                  );
                },
                decoration: InputDecoration(
                  errorText: (validate.value == false
                      ? validateSearch(numberError.text)
                      : null),
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
                            categoryId: controller.category!.id,
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
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                children: items
                    .map((item) => GridItem(item: item))
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
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
    return ListTile(
      focusColor: kButtonBgActive,
      onTap: () {
        controller.setSubCategory(widget.item);
        if (widget.item.childrens.isNotEmpty) {
          Get.toNamed("/category/${widget.item.id}",
              arguments: 'Get is the best');
        } else {
          Get.to(
            () => ItemsList(),
            transition: Transition.leftToRight,
            duration: const Duration(microseconds: 500),
          );
        }
      },
      textColor: kButtonText,
      contentPadding: const EdgeInsets.all(0),
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
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.item.name,
            style: appStyle(
              16,
              kPrimary,
              FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
