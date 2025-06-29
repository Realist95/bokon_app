import 'dart:io';

import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/content_controller.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/views/photoviewer/gallery_photo_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';

class SingleArticle extends HookWidget {
  SingleArticle({super.key});
  final ContentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    ArticleModel item = controller.currentItem!;
    var params = Get.parameters;
    var arguments = Get.arguments ?? {};
    final String title =
        (params['title'] ?? (arguments['title'] ?? '')).toString();

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: MainAppBar(true, title),
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

  final ArticleModel item;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    const String imagePath =
        '/data/user/0/com.bokon_app.test.bokon_app/cache/uploads';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: kButtonBg.withOpacity(.6),
        border: Border.all(color: const Color.fromRGBO(122, 118, 128, 0.65)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Text(
              widget.item.name,
              style: appStyle(
                16,
                kPrimary,
                FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Markdown(
              data: widget.item.content,
              imageDirectory: imagePath,
              imageBuilder: (uri, title, alt) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: GalleryPhotoWrapper(
                    imageUrl: File("$imagePath${uri.path}").path,
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
        ],
      ),
    );
  }
}
