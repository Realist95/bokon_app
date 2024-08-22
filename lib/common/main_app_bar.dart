import 'package:bokon_app/common/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar(this.needBack, this.title, {super.key});

  final bool needBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment mainAxisAlignment =
        !needBack ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween;

    return SizedBox(
      width: width,
      height: 140.h,
      // color: Colors.amber,
      // color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40.h,
            // color: const Color(0xFF717173),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ButtonBar(
              buttonPadding: EdgeInsets.zero,
              alignment: mainAxisAlignment,
              children: [
                (needBack)
                    ? MaterialButton(
                        elevation: 0,
                        minWidth: 46,
                        height: 46,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.arrow_left,
                              color: kPrimaryAlt,
                              size: 26.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                  child: Text(
                    title.toString(),
                    style: appStyle(28, Colors.black, FontWeight.w600),
                  ),
                ),
                MaterialButton(
                  elevation: 0,
                  minWidth: 46,
                  height: 46,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        color: Colors.white),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/burger.svg',
                      ),
                    ),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    // Scaffold.of(context).hasDrawer;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
