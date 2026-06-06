import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _baseShimmer(
            child: Container(
              height: 250.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _baseShimmer(
            child: Container(
              height: 20.h,
              width: 200.w,
              color: ColorHelper.white,
            ),
          ),
          SizedBox(height: 8.h),
          _baseShimmer(
            child: Container(
              height: 16.h,
              width: 150.w,
              color: ColorHelper.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _baseShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: ColorHelper.white,
      highlightColor: ColorHelper.shimmerColor,
      child: child,
    );
  }
}
