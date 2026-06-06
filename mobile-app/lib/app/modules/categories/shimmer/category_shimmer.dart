import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Shimmer
        Container(
          width: 96.w,
          color: ColorHelper.lightGrey.withValues(alpha: 0.5),
          child: ListView.builder(
            itemCount: 8,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                child: Column(
                  children: [
                    _baseShimmer(
                      child: Container(
                        height: 70.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _baseShimmer(
                      child: Container(
                        height: 10.h,
                        width: 40.w,
                        color: ColorHelper.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Content Shimmer
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: _baseShimmer(
                  child: Container(
                    height: 16.h,
                    width: 120.w,
                    color: ColorHelper.white,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Column(
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
                        SizedBox(height: 10.h),
                        _baseShimmer(
                          child: Container(
                            height: 12.h,
                            width: 80.w,
                            color: ColorHelper.white,
                          ),
                        ),
                      ],
                    );
                  },
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
