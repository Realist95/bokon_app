import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/common/shimmers/categories_shemmer.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/content_controller.dart';
import 'package:bokon_app/hooks/fetch_articles.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/views/articles/single_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesUpdates extends HookWidget {
  const ArticlesUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult2 = useFetchCtype(11);
    CtypeModel ctype = hookResult2.data?[0] ??
        CtypeModel(id: 0, name: '', content: '', description: '');

    final hookResult = useFetchArticles(11);
    List<ArticleModel> items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true, 'Обновления'),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: isLoading
            ? const CategoriesShimmer()
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    // height: 200,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      color: kButtonBg.withOpacity(.6),
                      border: Border.all(
                          color: const Color.fromRGBO(122, 118, 128, 0.65)),
                    ),
                    child: Text(
                      ctype.content,
                      style: appStyle(
                        16,
                        const Color(0xFF000000),
                        FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
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
  final ArticleModel item;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final controller = Get.put(ContentController());

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      focusColor: kButtonBgActive,
      onPressed: () {
        controller.setCurrentItem(widget.item);
        Get.to(
          () => SingleArticle(),
          transition: Transition.leftToRight,
          duration: const Duration(microseconds: 500),
          arguments: {"title": "Инструкция"},
        );
      },
      textColor: kButtonText,
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: kButtonBg.withOpacity(.6),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, .8),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.name,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: kPrimary,
                        // height: 24,
                      ),
                    ),
                    Text(
                      widget.item.date,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A7680),
                        // height: 24,
                      ),
                    ),
                  ],
                ),
                // height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
