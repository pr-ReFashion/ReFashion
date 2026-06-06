import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class OrganizeShimmer extends StatelessWidget {
  const OrganizeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          _buildDiscountableShimmer(),
          SizedBox(height: 24.h),
          _buildDropdownShimmer(),
          SizedBox(height: 16.h),
          _buildDropdownShimmer(),
          SizedBox(height: 16.h),
          _buildDropdownShimmer(),
          SizedBox(height: 16.h),
          _buildDropdownShimmer(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildDiscountableShimmer() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _baseShimmer(
                child: Container(
                  height: 24.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              _baseShimmer(
                child: Container(
                  height: 20.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 56.w),
            child: _baseShimmer(
              child: Container(
                height: 14.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorHelper.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 56.w),
            child: _baseShimmer(
              child: Container(
                height: 14.h,
                width: 200.w,
                decoration: BoxDecoration(
                  color: ColorHelper.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baseShimmer(
          child: Container(
            height: 18.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _baseShimmer(
          child: Container(
            height: 48.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
          ),
        ),
      ],
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
