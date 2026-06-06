import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class CurrencyShimmer extends StatelessWidget {
  const CurrencyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          // Title Shimmer
          _baseShimmer(
            child: Container(
              height: 22.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Language Dropdown Shimmer
          _dropdownShimmer(),
          SizedBox(height: 12.h),
          // Currency Dropdown Shimmer
          _dropdownShimmer(),
          const Spacer(),
          // Button Shimmer
          _baseShimmer(
            child: Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _dropdownShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baseShimmer(
          child: Container(
            height: 14.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _baseShimmer(
          child: Container(
            height: 48.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
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
