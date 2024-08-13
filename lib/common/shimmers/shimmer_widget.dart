import 'package:bokon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.shimmerWidth,
    required this.shimmerHeight,
    required this.shimmerRadius,
  });
  final double shimmerWidth;
  final double shimmerHeight;
  final double shimmerRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shimmerWidth,
      height: shimmerHeight,
      padding: const EdgeInsets.only(right: 12, top: 8),
      child: _buildShimmerLine(
          height: shimmerHeight - 20,
          width: shimmerWidth - 15,
          radius: shimmerRadius),
    );
  }

  _buildShimmerLine(
      {required double height, required double width, required double radius}) {
    return Shimmer.fromColors(
      baseColor: kPrimaryAlt,
      highlightColor: kPrimaryAlt,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
