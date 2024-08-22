import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:bokon_app/controllers/content_controller.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class SingleArticle extends HookWidget {
  SingleArticle({super.key});
  final ContentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    ArticleModel item = controller.currentItem!;
    var params = Get.parameters;
    final String title = params['title'].toString();

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
    // debugPrint(widget.item.content);
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
                18,
                kPrimary,
                FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Markdown(
              data: widget.item.content,
              imageDirectory: 'https://bokon.ru',
            ),
          ),
        ],
      ),
    );

    // Column(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    //         // height: 200,
    //         decoration: BoxDecoration(
    //           borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    //           color: kButtonBg.withOpacity(.6),
    //           border:
    //               Border.all(color: const Color.fromRGBO(122, 118, 128, 0.65)),
    //         ),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             // margin: const EdgeInsets.all(15),
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 15, left: 15),
    //                 child: Text(
    //                   widget.item.name,
    //                   style: appStyle(
    //                     18,
    //                     kPrimary,
    //                     FontWeight.w600,
    //                   ),
    //                 ),
    //               ),
    //               Expanded(child: Markdown(data: widget.item.content)

    //                   // Container(
    //                   //   alignment: Alignment.topLeft,
    //                   //   padding: const EdgeInsets.symmetric(
    //                   //     horizontal: 15,
    //                   //     vertical: 15,
    //                   //   ),
    //                   //   child: Markdown(data: widget.item.content),

    //                   //   // HtmlWidget(
    //                   //   //   widget.item.content,
    //                   //   //   textStyle: const TextStyle(
    //                   //   //     color: kPrimary,
    //                   //   //     fontSize: 18,
    //                   //   //     fontWeight: FontWeight.w400,
    //                   //   //   ),
    //                   //   // ),

    //                   //   // Html.fromDom(
    //                   //   //   document: dom.Document.html(widget.item.content),
    //                   //   //   shrinkWrap: true,
    //                   //   // )

    //                   //   // Text(
    //                   //   //   widget.item.content,
    //                   //   // ),
    //                   //   // child: Html(
    //                   //   //   data: widget.item.content,
    //                   //   //   style: {
    //                   //   //     "p": Style(
    //                   //   //       color: kPrimary,
    //                   //   //       fontSize: FontSize(20),
    //                   //   //       fontWeight: FontWeight.w500,
    //                   //   //     ),
    //                   //   //     "table": Style(
    //                   //   //       backgroundColor: Colors.white,
    //                   //   //     ),
    //                   //   //     "tr": Style(
    //                   //   //       // padding:  const EdgeInsets.all(2),
    //                   //   //       border: Border.all(color: Colors.black),
    //                   //   //     ),
    //                   //   //     "th": Style(
    //                   //   //       // padding: const EdgeInsets.all(2),
    //                   //   //       border: Border.all(color: Colors.black),
    //                   //   //     ),
    //                   //   //     "td": Style(
    //                   //   //       // padding: const EdgeInsets.all(2),
    //                   //   //       border: Border.all(color: Colors.black),
    //                   //   //     ),
    //                   //   //   },
    //                   //   // ),
    //                   // ),
    //                   ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
