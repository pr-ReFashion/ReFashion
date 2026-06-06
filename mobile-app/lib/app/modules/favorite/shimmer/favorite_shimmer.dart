import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteShimmer extends StatelessWidget {
  const FavoriteShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double itemWidth = (Get.context!.width - (16.w * 2) - 18.w) / 2;
    double itemHeight =
        150.h + // Image height
        (8.h * 1) + // Top padding
        (14.sp * 1.35) + // Brand Title
        2.h + // Spacing
        (12.sp * 1.35) + // Description
        4.h + // Spacing
        (14.sp * 1.35) + // Price
        12.h + // Spacing
        36.h + // Action row
        14.h;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 96.h),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: itemWidth / itemHeight,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.sp,
                        width: 100.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        height: 12.sp,
                        width: 130.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 14.sp,
                        width: 60.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Container(
                            height: 34.h,
                            width: 34.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              height: 34.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
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
