import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/content_controller.dart';
import 'package:bokon_app/hooks/fetch_articles.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/views/articles/single_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesList extends HookWidget {
  const ArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    var params = Get.parameters;
    int? ctype = int.parse((params['id'] ?? '0').toString());

    final hookResult = useFetchArticles(ctype);
    List<ArticleModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: isLoading
            ? const CategoriesShimmer()
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                children: items
                    .map((item) => GridItem(item: item))
                    .toList(growable: false),
              ),
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
  final controller = Get.put(ContentController());

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      // focusColor: kButtonBgActive,
      onPressed: () {},
      // textColor: kButtonText,
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(16),
          height: 236.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.59),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                widget.item.name,
                style: appStyle(
                  19,
                  const Color.fromRGBO(27, 30, 36, 1),
                  FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Markdown(data: widget.item.description),
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
              const SizedBox(height: 30),
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
  // Widget build(BuildContext context) {
  //   return MaterialButton(
  //     focusColor: kButtonBgActive,
  //     onPressed: () {
  //       controller.setCurrentItem(widget.item);
  //       Get.to(
  //         () => SingleArticle(),
  //         transition: Transition.leftToRight,
  //         duration: const Duration(microseconds: 500),
  //       );
  //     },
  //     textColor: kButtonText,
  //     padding: const EdgeInsets.all(0),
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.all(0),
  //       title: Stack(
  //         alignment: AlignmentDirectional.bottomEnd,
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  //               color: kButtonBg.withOpacity(.6),
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Color.fromRGBO(0, 0, 0, .8),
  //                   spreadRadius: 0,
  //                   blurRadius: 2,
  //                   offset: Offset(0, 1),
  //                   blurStyle: BlurStyle.outer,
  //                 ),
  //               ],
  //             ),
  //             child: Container(
  //               // height: 50,
  //               alignment: Alignment.centerLeft,
  //               padding: const EdgeInsets.all(15),
  //               child: Text(
  //                 widget.item.name,
  //                 style: GoogleFonts.roboto(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w500,
  //                   color: kPrimary,
  //                   // height: 24,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
