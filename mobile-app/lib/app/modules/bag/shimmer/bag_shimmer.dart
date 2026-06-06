import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class BagShimmer extends StatelessWidget {
  const BagShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: 4,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return _itemShimmer();
            },
          ),
        ),
      ],
    );
  }

  Widget _itemShimmer() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _baseShimmer(
            child: Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _baseShimmer(
                  child: Container(
                    height: 18.h,
                    width: 140.w,
                    color: ColorHelper.white,
                  ),
                ),
                SizedBox(height: 8.h),
                _baseShimmer(
                  child: Container(
                    height: 14.h,
                    width: double.infinity,
                    color: ColorHelper.white,
                  ),
                ),
                SizedBox(height: 8.h),
                _baseShimmer(
                  child: Container(
                    height: 12.h,
                    width: 100.w,
                    color: ColorHelper.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _baseShimmer(
                      child: Container(
                        height: 16.h,
                        width: 50.w,
                        color: ColorHelper.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _baseShimmer(
                      child: Container(
                        height: 16.h,
                        width: 1.w,
                        color: ColorHelper.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _baseShimmer(
                      child: Container(
                        height: 16.h,
                        width: 60.w,
                        color: ColorHelper.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _baseShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: ColorHelper.offWhite,
      highlightColor: ColorHelper.shimmerColor,
      child: child,
    );
  }
}
