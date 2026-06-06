import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInfoShimmer extends StatelessWidget {
  const PersonalInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorHelper.borderColor.withAlpha(
        128,
      ), // withValues(alpha: 0.5) is equiv to withAlpha(128)
      highlightColor: ColorHelper.white,
      child: AnimatedScrollView(
        children: [
          SizedBox(height: 8.h),
          _buildShimmerBlock(width: 100.w, height: 20.h), // Account title
          // SizedBox(height: 24.h),
          // Center(
          //   child: Container(
          //     height: 80.r,
          //     width: 80.r,
          //     decoration: const BoxDecoration(
          //       color: ColorHelper.white,
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          SizedBox(height: 24.h),
          _buildTextFieldShimmer(), // First Name
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(), // Last Name
          SizedBox(height: 12.h),
          _buildShimmerBlock(width: 80.w, height: 16.h), // Gender Label
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildShimmerBlock(height: 48.h)),
              SizedBox(width: 12.w),
              Expanded(child: _buildShimmerBlock(height: 48.h)),
              SizedBox(width: 12.w),
              Expanded(child: _buildShimmerBlock(height: 48.h)),
            ],
          ),
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(), // Email
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(height: 120.h), // Bio
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(), // Location
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(), // Refashion ID
          // SizedBox(height: 24.h),
          // _buildShimmerBlock(width: 150.w, height: 20.h), // My Credentials
          SizedBox(height: 12.h),
          _buildTextFieldShimmer(), // Username
          // SizedBox(height: 12.h),
          // _buildTextFieldShimmer(), // Password
          SizedBox(height: 30.h),
          _buildShimmerBlock(
            width: double.infinity,
            height: 50.h,
            radius: 8.r,
          ), // Button
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildShimmerBlock({double? width, double? height, double? radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(radius ?? 8.r),
      ),
    );
  }

  Widget _buildTextFieldShimmer({double height = 48}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBlock(width: 80.w, height: 16.h),
        SizedBox(height: 8.h),
        _buildShimmerBlock(width: double.infinity, height: height.h),
      ],
    );
  }
}
