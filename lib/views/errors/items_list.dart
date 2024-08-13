import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/errors/filter_screen.dart';
import 'package:bokon_app/views/errors/single_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class ItemsList extends HookWidget {
  ItemsList({super.key});
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    print("subCategory ${controller.subCategory!.id}");
    final hookResult = useFetchItems(controller.subCategory!.id, 1000);
    List<CatalogItemModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final numberError = TextEditingController();
    final validate = useState<bool>(true);

    String? validateSearch(String value) {
      return "Укажите не менее 2-х символов";
    }

    return BackGroundContainer(
      child: Scaffold(
        drawer: const CustomNavigationDrawer(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const CategoriesShimmer()
            : Column(
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
                            categoryId: controller.subCategory!.id,
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
                                  categoryId: controller.subCategory!.id,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 2.3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
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

  final CatalogItemModel item;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      focusColor: kButtonBgActive,
      onPressed: () {
        controller.setCurrentItem(widget.item);
        Get.to(
          () => SingleCatalogItems(),
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
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .15),
                  spreadRadius: -4,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: kButtonBg.withOpacity(.6),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .4),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.item.name.toUpperCase(),
                      style: appStyle(
                        20,
                        kPrimary,
                        FontWeight.w500,
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
