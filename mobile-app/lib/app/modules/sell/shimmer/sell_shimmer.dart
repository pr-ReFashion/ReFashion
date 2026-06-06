import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class SellShimmer extends StatelessWidget {
  const SellShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _itemShimmer();
      },
    );
  }

  Widget _itemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
              height: 80.sp,
              width: 80.sp,
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
                    decoration: BoxDecoration(
                      color: ColorHelper.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _baseShimmer(
                  child: Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorHelper.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                _baseShimmer(
                  child: Container(
                    height: 14.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: ColorHelper.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _baseShimmer(
                  child: Container(
                    height: 16.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: ColorHelper.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _baseShimmer(
            child: Container(
              height: 20.sp,
              width: 20.sp,
              decoration: const BoxDecoration(
                color: ColorHelper.white,
                shape: BoxShape.circle,
              ),
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
