import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryShimmer extends StatelessWidget {
  const HomeCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(width: 20.w),
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _baseShimmer(
                child: Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              _baseShimmer(
                child: Container(
                  height: 14.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          );
        },
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
