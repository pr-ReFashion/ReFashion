import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class BuyingShimmer extends StatelessWidget {
  const BuyingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _baseShimmer(
                    child: Container(
                      height: 30.r,
                      width: 30.r,
                      decoration: const BoxDecoration(
                        color: ColorHelper.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _baseShimmer(
                        child: Container(
                          height: 16.h,
                          width: 100.w,
                          color: ColorHelper.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      _baseShimmer(
                        child: Container(
                          height: 12.h,
                          width: 80.w,
                          color: ColorHelper.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: ColorHelper.offWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    _baseShimmer(
                      child: Container(
                        height: 60.r,
                        width: 60.r,
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
                              height: 16.h,
                              width: 120.w,
                              color: ColorHelper.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          _baseShimmer(
                            child: Container(
                              height: 12.h,
                              width: 150.w,
                              color: ColorHelper.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
