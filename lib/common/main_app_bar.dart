import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bokon_app/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar(this.needBack, {super.key});

  final bool needBack;

  @override
  Widget build(BuildContext context) {
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
          ButtonBar(
            buttonPadding: EdgeInsets.zero,
            alignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 15.h,
              ),
              (needBack)
                  ? MaterialButton(
                      elevation: 0,
                      minWidth: 46,
                      height: 46,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
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
              (needBack)
                  ? SizedBox(
                      width: 10.w,
                    )
                  : const SizedBox(),
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
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
