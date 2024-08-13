import 'package:bokon_app/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 120),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 111.w,
        height: 111.h,
        child: const CircularProgressIndicator(
          color: Color.fromRGBO(248, 148, 75, 1),
          backgroundColor: Color.fromRGBO(235, 236, 243, 1),
        ),
      ),
    );

    // Container(
    //   padding: const EdgeInsets.only(top: 12, left: 10),
    //   height: 75.h,
    //   child: ListView.builder(
    //     itemCount: 6,
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: [
    //           ShimmerWidget(
    //             shimmerWidth: 70.w,
    //             shimmerHeight: 60.h,
    //             shimmerRadius: 12,
    //           )
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}
