import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/errors/widgets/items_list_widget.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FilterScreen extends HookWidget {
  FilterScreen({
    super.key,
    required this.numberError,
    required this.categoryId,
    required this.needNotice,
  });
  final CatalogController controller = Get.find();
  final TextEditingController numberError;
  final int categoryId;
  final bool needNotice;

  @override
  Widget build(BuildContext context) {
    // print("categoryId ${categoryId}");
    final hookResult = useFetchItems(categoryId, 1000);
    List<CatalogItemModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    // final error = hookResult.error;
    final validate = useState<bool>(true);

    String? validateSearch(String value) {
      return "Укажите не менее 2-х символов";
    }

    items = (items
        .where((item) =>
            item.name.toLowerCase().contains(numberError.text.toLowerCase()))
        .toList());

    return BackGroundContainer(
      child: Scaffold(
        drawer: const CustomNavigationDrawer(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true, ''),
          automaticallyImplyLeading: false,
        ),
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

                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => FilterScreen(
                      numberError: numberError,
                      categoryId: categoryId,
                      needNotice: (items.length <= 1) ? false : needNotice,
                    ),
                  ))
                      .then((value) {
                    Navigator.of(context).pop(true);
                  });
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
                    FontWeight.w500,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 14),
                    child: IconButton(
                      onPressed: () async {
                        if (numberError.text.isEmpty ||
                            numberError.text.length < 2) {
                          validate.value = false;
                          return;
                        }
                        validate.value = true;
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => FilterScreen(
                              numberError: numberError,
                              categoryId: controller.category!.id,
                              needNotice:
                                  (items.length <= 1) ? false : needNotice,
                            ),
                          ),
                        )
                            .then((value) {
                          Navigator.of(context).pop(true);
                        });
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
            isLoading
                ? const CategoriesShimmer()
                : items.isNotEmpty
                    ? Expanded(
                        child: ItemsListWidget(
                          items: items,
                          needNotice: (items.length <= 1) ? false : needNotice,
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 20, left: 16, right: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              color: kButtonBg.withOpacity(.6),
                              border: Border.all(
                                  color: const Color.fromRGBO(
                                      122, 118, 128, 0.65)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Нет совпадений',
                                  style: appStyle(
                                    20,
                                    Colors.black,
                                    FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    'Данная неисправность не найдена,\n мы уже занимаемся её поиском,\n попробуйте повторить позднее.',
                                    style: appStyle(
                                      18,
                                      Colors.black,
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                  ),
                                  child: Center(
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/- 1.png'),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Но не ранее чем через 3 часа.',
                                    style: appStyle(
                                      18,
                                      Colors.black,
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    'Нет времени ждать?',
                                    style: appStyle(
                                      18,
                                      Colors.black,
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Звони поищем вместе.',
                                    style: appStyle(
                                      18,
                                      Colors.black,
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width - 30),
                            height: 62,
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 5),
                                  inset: true,
                                ),
                              ],
                              border: Border.all(
                                color: const Color.fromRGBO(222, 222, 226, 1),
                                width: 1,
                              ),
                              color: const Color.fromRGBO(248, 148, 75, 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.toNamed('/help');
                              },
                              child: Text(
                                'Тех поддержка',
                                style: appStyle(
                                  18,
                                  Colors.white,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
