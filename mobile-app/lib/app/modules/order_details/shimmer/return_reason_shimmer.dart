import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class ReturnReasonShimmer extends StatelessWidget {
  const ReturnReasonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(right: 6.w),
          child: Shimmer.fromColors(
            baseColor: ColorHelper.lightGrey,
            highlightColor: ColorHelper.white,
            child: Row(
              children: [
                Container(
                  height: 20.r,
                  width: 20.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorHelper.lightGrey,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 16.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.lightGrey,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
