import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/controllers/content_controller.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/views/articles/single_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GridArticle extends StatefulWidget {
  const GridArticle({super.key, required this.item, required this.arguments});
  final ArticleModel item;
  final Map arguments;

  @override
  State<GridArticle> createState() => _GridArticleState();
}

class _GridArticleState extends State<GridArticle> {
  // final controller = Get.put(ContentController());
  final controller = Get.put(ContentController());

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        controller.setCurrentItem(widget.item);
        Get.to(
          () => SingleArticle(),
          transition: Transition.leftToRight,
          duration: const Duration(microseconds: 500),
          arguments: widget.arguments,
        );
      },
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
          height: 236.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.59),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appStyle(
                        19,
                        const Color.fromRGBO(27, 30, 36, 1),
                        FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.item.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: appStyle(
                        14,
                        const Color.fromRGBO(27, 30, 36, 1),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // margin: margin,
                    height: 40.h,
                    width: 120.w,
                    // padding:
                    // const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        controller.setCurrentItem(widget.item);
                        Get.to(
                          () => SingleArticle(),
                          transition: Transition.leftToRight,
                          duration: const Duration(microseconds: 500),
                        );
                      },
                      child: Text(
                        "прочитать".toUpperCase(),
                        style: appStyle(
                          14,
                          const Color.fromRGBO(255, 117, 54, 1),
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
