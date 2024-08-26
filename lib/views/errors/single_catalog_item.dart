import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
import 'package:bokon_app/hooks/fetch_categories.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/articles/send_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SingleCatalogItems extends HookWidget {
  SingleCatalogItems({super.key});
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchItems(controller.category!.id, 1000);

    CatalogItemModel item = controller.currentItem!;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: MainAppBar(true, item.name),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: GridItem(item: item),
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
  @override
  Widget build(BuildContext context) {
    final Color badgeColor = widget.item.difficulty == 'Сложная'
        ? const Color(0xFFee1d00)
        : const Color(0xff68C659);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.item.difficulty.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  height: 30,
                  width: 107,
                  decoration: BoxDecoration(
                    color: widget.item.difficulty == 'Сложная'
                        ? const Color.fromRGBO(255, 255, 255, 0.55)
                        : kButtonBg.withOpacity(.6),
                    border: Border.all(
                      color: badgeColor,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SvgPicture.asset(
                          'assets/images/warning.svg',
                          colorFilter: ColorFilter.mode(
                            badgeColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        widget.item.difficulty,
                        style: appStyle(
                          14,
                          badgeColor,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: kButtonBg.withOpacity(.6),
              border:
                  Border.all(color: const Color.fromRGBO(122, 118, 128, 0.65)),
            ),
            child: Column(
              // margin: const EdgeInsets.all(15),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.item.parent!.titleH1.isNotEmpty
                        ? widget.item.parent!.titleH1
                        : widget.item.parent!.description,
                    style: appStyle(
                      16,
                      kPrimary,
                      FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15),
                    child: Markdown(
                      data: widget.item.content,
                      imageDirectory: 'https://bokon.ru',
                      styleSheet: MarkdownStyleSheet(
                        p: appStyle(
                          14,
                          const Color(0xFF000000),
                          FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          ListTile(
            focusColor: kButtonBgActive,
            onTap: () {
              Get.toNamed('/help');
            },
            textColor: kButtonText,
            contentPadding: const EdgeInsets.all(0),
            title: Container(
              alignment: Alignment.center,
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
              child: Text(
                'Тех поддержка',
                style: appStyle(
                  18,
                  kPrimary,
                  FontWeight.w500,
                ),
              ),
            ),
          ),
          ListTile(
            focusColor: kButtonBgActive,
            onTap: () {
              Get.to(
                () => SendError(
                  block: widget.item.parent!.name,
                  errorNumber: widget.item.name,
                ),
                transition: Transition.leftToRight,
                duration: const Duration(microseconds: 500),
              );
            },
            textColor: kButtonText,
            contentPadding: const EdgeInsets.all(0),
            title: Container(
              alignment: Alignment.center,
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
              child: Text(
                'Сообщить об ошибке',
                style: appStyle(
                  18,
                  kPrimary,
                  FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
