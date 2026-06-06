import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class StatsShimmer extends StatelessWidget {
  const StatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _shimmerItem()),
            SizedBox(width: 12.w),
            Expanded(child: _shimmerItem()),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _shimmerItem()),
            SizedBox(width: 12.w),
            Expanded(child: _shimmerItem()),
          ],
        ),
      ],
    );
  }

  Widget _shimmerItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        children: [
          _shimmerWrapper(
            Container(
              height: 52.r,
              width: 52.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _shimmerWrapper(
            Container(
              height: 18.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          _shimmerWrapper(
            Container(
              height: 14.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerWrapper(Widget child) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }

  /* Widget _myImpactCardShimmerOriginal() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          3,
          (index) => Column(
            children: [
              _shimmerWrapper(
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _shimmerWrapper(
                Container(
                  height: 12.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              _shimmerWrapper(
                Container(
                  height: 12.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } */
}
