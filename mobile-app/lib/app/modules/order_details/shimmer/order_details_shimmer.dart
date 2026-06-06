import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsShimmer extends StatelessWidget {
  const OrderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          _buildProductInfoShimmer(),
          SizedBox(height: 24.h),
          _buildMyActivityShimmer(),
          SizedBox(height: 24.h),
          _buildTotalItemPriceShimmer(),
          SizedBox(height: 24.h),
          _buildUpdatesSentToShimmer(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildProductInfoShimmer() {
    return Column(
      children: [
        _baseShimmer(
          child: Container(
            height: 100.sp,
            width: 100.sp,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _baseShimmer(
          child: Container(
            height: 20.h,
            width: 150.w,
            color: ColorHelper.white,
          ),
        ),
        SizedBox(height: 8.h),
        _baseShimmer(
          child: Container(
            height: 14.h,
            width: 250.w,
            color: ColorHelper.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMyActivityShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baseShimmer(
          child: Container(
            height: 22.h,
            width: 120.w,
            color: ColorHelper.white,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _baseShimmer(
                child: Container(
                  height: 18.h,
                  width: 150.w,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalItemPriceShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baseShimmer(
          child: Container(
            height: 22.h,
            width: 150.w,
            color: ColorHelper.white,
          ),
        ),
        SizedBox(height: 12.h),
        _baseShimmer(
          child: Container(
            height: 40.h,
            width: double.infinity,
            color: ColorHelper.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatesSentToShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baseShimmer(
          child: Container(
            height: 22.h,
            width: 140.w,
            color: ColorHelper.white,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            children: [
              _baseShimmer(
                child: Container(
                  height: 16.h,
                  width: double.infinity,
                  color: ColorHelper.white,
                ),
              ),
              SizedBox(height: 8.h),
              _baseShimmer(
                child: Container(
                  height: 16.h,
                  width: double.infinity,
                  color: ColorHelper.white,
                ),
              ),
            ],
          ),
        ),
      ],
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
