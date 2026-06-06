import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Image Slider Shimmer
          _baseShimmer(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 300.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Page Indicator Shimmer
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _baseShimmer(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 12.w,
                    height: 12.w,
                    decoration: const BoxDecoration(
                      color: ColorHelper.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Offers Banner Shimmer
          _baseShimmer(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Header Info Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        SizedBox(height: 8.h),
                        _baseShimmer(
                          child: Container(
                            height: 20.h,
                            width: 250.w,
                            color: ColorHelper.white,
                          ),
                        ),
                      ],
                    ),
                    _baseShimmer(
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: const BoxDecoration(
                          color: ColorHelper.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _baseShimmer(
                  child: Container(
                    height: 16.h,
                    width: 150.w,
                    color: ColorHelper.white,
                  ),
                ),
                SizedBox(height: 8.h),
                _baseShimmer(
                  child: Container(
                    height: 24.h,
                    width: 120.w,
                    color: ColorHelper.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Description Card Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _baseShimmer(
                    child: Container(
                      height: 20.h,
                      width: 120.w,
                      color: ColorHelper.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _baseShimmer(
                    child: Container(
                      height: 14.h,
                      width: double.infinity,
                      color: ColorHelper.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _baseShimmer(
                    child: Container(
                      height: 14.h,
                      width: double.infinity,
                      color: ColorHelper.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _baseShimmer(
                    child: Container(
                      height: 14.h,
                      width: 200.w,
                      color: ColorHelper.white,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _baseShimmer(
                    child: Container(
                      height: 20.h,
                      width: 100.w,
                      color: ColorHelper.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildDetailRow(),
                  _buildDetailRow(),
                  _buildDetailRow(),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Seller Card Shimmer
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16.w),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const ProductSellerShimmer(),
          //       SizedBox(height: 12.h),
          //       const Divider(
          //         color: ColorHelper.borderColor,
          //         height: 1,
          //         thickness: 1,
          //       ),
          //       SizedBox(height: 12.h),
          //       _baseShimmer(
          //         child: Container(
          //           height: 12.h,
          //           width: 100.w,
          //           decoration: BoxDecoration(
          //             color: ColorHelper.white,
          //             borderRadius: BorderRadius.circular(4.r),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDetailRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          _baseShimmer(
            child: Container(
              height: 12.h,
              width: 60.w,
              color: ColorHelper.white,
            ),
          ),
          SizedBox(width: 20.w),
          _baseShimmer(
            child: Container(
              height: 12.h,
              width: 100.w,
              color: ColorHelper.white,
            ),
          ),
        ],
      ),
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
