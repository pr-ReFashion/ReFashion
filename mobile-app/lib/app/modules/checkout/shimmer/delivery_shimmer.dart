import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryShimmer extends StatelessWidget {
  const DeliveryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: ColorHelper.borderColor.withValues(alpha: 0.5),
          highlightColor: ColorHelper.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Container(
                  height: 20.sp,
                  width: 20.sp,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorHelper.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120.w,
                        height: 16.h,
                        color: ColorHelper.white,
                      ),
                      Container(
                        width: 60.w,
                        height: 16.h,
                        color: ColorHelper.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
