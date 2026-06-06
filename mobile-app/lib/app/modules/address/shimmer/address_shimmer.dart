import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: ColorHelper.borderColor.withValues(alpha: 0.5),
          highlightColor: ColorHelper.white,
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100.w,
                      height: 16.h,
                      color: ColorHelper.white,
                    ),
                    const Spacer(),
                    Container(
                      width: 50.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: ColorHelper.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(width: 200.w, height: 14.h, color: ColorHelper.white),
                SizedBox(height: 4.h),
                Container(width: 150.w, height: 14.h, color: ColorHelper.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
