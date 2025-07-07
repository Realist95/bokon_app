import 'dart:io';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/catalog_controller.dart';
// import 'package:bokon_app/hooks/catalog_hook.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/views/articles/send_error.dart';
import 'package:bokon_app/views/photoviewer/gallery_photo_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleCatalogItems extends HookWidget {
  SingleCatalogItems({super.key});
  final CatalogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // final hookResult = useFetchItems(controller.category!.id, 1000);

    CatalogItemModel item = controller.currentItem!;
    CatalogCategoryModel parent =
        controller.subCategory ?? controller.category!;
    // final isLoading = hookResult.isLoading;
    // final error = hookResult.error;
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
        body: GridItem(item: item, parent: parent),
      ),
    );
  }
}

class GridItem extends StatefulWidget {
  const GridItem({
    super.key,
    required this.item,
    required this.parent,
  });

  final CatalogItemModel item;
  final CatalogCategoryModel parent;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    final Color badgeColor = widget.item.difficulty == 'Сложная'
        ? const Color(0xFFee1d00)
        : const Color(0xff68C659);
    const String imagePath = '/data/user/0/com.bokon.bokon_app/cache/uploads';

    String defaultDifficulty =
        widget.item.difficulty.isEmpty || widget.item.difficulty == "null"
            ? ""
            : widget.item.difficulty;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          defaultDifficulty.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  height: 30,
                  width: 107,
                  decoration: BoxDecoration(
                    color: defaultDifficulty == 'Сложная'
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
                        defaultDifficulty,
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
                    widget.parent.titleH1.isNotEmpty
                        ? widget.parent.titleH1
                        : widget.parent.description,
                    style: appStyle(
                      16,
                      kPrimary,
                      FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15),
                    child: Markdown(
                      onTapLink: (text, href, title) {
                        _launchURL(href!);
                      },
                      data: widget.item.content,
                      imageDirectory: imagePath,
                      imageBuilder: (uri, title, alt) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: GalleryPhotoWrapper(
                            imageUrl: '$imagePath${uri.path}',
                            child: Image(
                              image: FileImage(
                                File('$imagePath${uri.path}'),
                              ),
                            ),
                          ),
                        );
                      },
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
                  block: widget.parent.name,
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
                'Сообщить об ошибке в приложении',
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

  _launchURL(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch {$url}');
    }
  }
}
