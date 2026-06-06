import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/product_item_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductShimmer extends StatelessWidget {
  const HomeProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _baseShimmer(
            child: Container(
              height: 20.h,
              width: 150.w,
              color: ColorHelper.white,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: ProductItemWidget.itemHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              return Container(
                width: 160.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: ColorHelper.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _baseShimmer(
                      child: Container(
                        height: 150.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _baseShimmer(
                            child: Container(
                              height: 14.h,
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
                          SizedBox(height: 8.h),
                          _baseShimmer(
                            child: Container(
                              height: 16.h,
                              width: 60.w,
                              color: ColorHelper.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
