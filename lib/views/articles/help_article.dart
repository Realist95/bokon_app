import 'package:bokon_app/common/app_style.dart';
import 'package:bokon_app/common/background_container.dart';
import 'package:bokon_app/common/custom_navigation_drawer.dart';
import 'package:bokon_app/common/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpArticle extends StatelessWidget {
  const HelpArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          flexibleSpace: const MainAppBar(true, 'Помощь'),
          automaticallyImplyLeading: false,
        ),
        drawer: const CustomNavigationDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              SizedBox(height: 52.h),
              Center(
                child: SvgPicture.asset(
                  'assets/images/help.svg',
                ),
              ),
              SizedBox(height: 52.h),
              Center(
                child: Text(
                  'Нужна помощь?',
                  style: appStyle(
                    20,
                    Colors.black,
                    FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 19.h),
              Container(
                width: 900,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Text(
                  'Команда техподдержки поможет',
                  style: appStyle(
                    18,
                    Colors.black,
                    FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: 900,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Text(
                  'разобраться во всех вопросах',
                  style: appStyle(
                    18,
                    Colors.black,
                    FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 36.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 164.w,
                    height: 164.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(244, 245, 246, 0.6),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      onTap: () async {
                        await launchUrl(Uri.parse('https://t.me/+79776005008'));
                      },
                      title: Column(
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/telegram.svg',
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Телеграмм',
                            style: appStyle(
                              14,
                              const Color.fromRGBO(0, 0, 0, 1),
                              FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 164.w,
                    height: 164.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(244, 245, 246, 0.6),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            'https://api.whatsapp.com/send?phone=9776005008'));
                      },
                      title: Column(
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/whatsapp.svg',
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'WhatsApp',
                            style: appStyle(
                              14,
                              const Color.fromRGBO(0, 0, 0, 1),
                              FontWeight.w500,
                            ),
                          )
                        ],
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
