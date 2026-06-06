import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductShimmer extends StatelessWidget {
  const CategoryProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _statsBarShimmer(),
          SizedBox(height: 16.h),
          _productGridShimmer(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _statsBarShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        _baseShimmer(
          child: Container(
            height: 18.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.68,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _productItemShimmer();
      },
    );
  }

  Widget _productItemShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _baseShimmer(
            child: Container(
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _baseShimmer(
          child: Container(
            height: 14.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        _baseShimmer(
          child: Container(
            height: 12.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        _baseShimmer(
          child: Container(
            height: 16.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
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
