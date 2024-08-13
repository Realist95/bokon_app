import 'package:bokon_app/constants/constants.dart';
import 'package:flutter/material.dart';

class BackGroundContainer extends StatelessWidget {
  const BackGroundContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: mainBg,
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: .5,
          image: AssetImage('assets/images/background.jpg'),
        ),
      ),
      child: child,
    );
  }
}
