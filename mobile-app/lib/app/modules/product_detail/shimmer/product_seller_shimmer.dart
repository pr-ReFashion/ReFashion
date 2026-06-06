import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';

class ProductSellerShimmer extends StatelessWidget {
  const ProductSellerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              // Seller profile photo placeholder
              Shimmer.fromColors(
                baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                highlightColor: ColorHelper.shimmerColor,
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Seller name and rating placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer.fromColors(
                      baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                      highlightColor: ColorHelper.shimmerColor,
                      child: Container(
                        height: 14.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                          highlightColor: ColorHelper.shimmerColor,
                          child: Container(
                            height: 12.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: ColorHelper.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Shimmer.fromColors(
                          baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                          highlightColor: ColorHelper.shimmerColor,
                          child: Container(
                            height: 12.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: ColorHelper.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: ColorHelper.subHeadingColor.withValues(alpha: 0.3),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(
            color: ColorHelper.borderColor.withValues(alpha: 0.5),
            height: 1,
          ),
          SizedBox(height: 12.h),
          // Shimmer reviews list
          const ProductSellerReviewsShimmer(),
        ],
      ),
    );
  }
}

class ProductSellerReviewsShimmer extends StatelessWidget {
  const ProductSellerReviewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Divider(
          color: ColorHelper.borderColor.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                highlightColor: ColorHelper.shimmerColor,
                child: Container(
                  width: 60.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Shimmer.fromColors(
                baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
                highlightColor: ColorHelper.shimmerColor,
                child: Container(
                  width: 100.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Shimmer.fromColors(
            baseColor: ColorHelper.borderColor.withValues(alpha: 0.3),
            highlightColor: ColorHelper.shimmerColor,
            child: Container(
              width: double.infinity,
              height: 12.h,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
