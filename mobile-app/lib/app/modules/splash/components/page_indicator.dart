import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;

  const PageIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 6.h,
      width: isActive ? 40.w : 16.w,
      decoration: BoxDecoration(
        color: isActive ? ColorHelper.secondary : ColorHelper.borderColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
