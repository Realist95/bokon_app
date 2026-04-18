import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 120),
      alignment: Alignment.topCenter,
      child: const SizedBox(
        width: 105,
        height: 105,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: Color.fromRGBO(248, 148, 75, 1),
          backgroundColor: Color.fromRGBO(235, 236, 243, 1),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 120),
  //     alignment: Alignment.topCenter,
  //     child: SizedBox(
  //       width: 111.w,
  //       height: 111.h,
  //       child: const CircularProgressIndicator(
  //         color: Color.fromRGBO(248, 148, 75, 1),
  //         backgroundColor: Color.fromRGBO(235, 236, 243, 1),
  //       ),
  //     ),
  //   );
  // }
}
