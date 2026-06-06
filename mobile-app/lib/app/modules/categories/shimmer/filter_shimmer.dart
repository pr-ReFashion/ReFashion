import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class FilterShimmer extends StatelessWidget {
  const FilterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Shimmer
        Container(
          width: 120.w,
          color: ColorHelper.offWhite,
          child: ListView.builder(
            itemCount: 4,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorHelper.borderColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Center(
                  child: _baseShimmer(
                    child: Container(
                      height: 16.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: ColorHelper.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Content Shimmer
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    _baseShimmer(
                      child: Container(
                        height: 18.sp,
                        width: 18.sp,
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _baseShimmer(
                      child: Container(
                        height: 16.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _baseShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: ColorHelper.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorHelper.shimmerColor,
      child: child,
    );
  }
}
