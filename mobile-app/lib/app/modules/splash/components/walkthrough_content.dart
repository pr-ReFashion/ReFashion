import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashion/app/modules/splash/controllers/walkthrough_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class WalkthroughContent extends StatelessWidget {
  final WalkthroughData data;
  final int index;
  final WalkthroughController controller;
  final int totalPages;

  const WalkthroughContent({
    super.key,
    required this.data,
    required this.index,
    required this.controller,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768; // Based on SizeUtils threshold

    // Status bar brightness logic
    final systemOverlayStyle = index == 1
        ? const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Column(
        children: [
          // Fixed Top Image Area
          Expanded(
            flex: isTablet ? 6 : 55, // Give more space to images on tablets
            child: SizedBox(
              width: double.infinity,
              child: CachedImageView(
                imagePath: data.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Text Content Area (Bottom)
          Expanded(
            flex: isTablet ? 4 : 45,
            child: Container(
              color: ColorHelper.white,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isTablet ? 20.h : 8.h),

                    // Title
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.urBold700().copyWith(
                        color: ColorHelper.headingColor,
                        fontSize: isTablet ? 42.sp : 32.sp,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24.h : 16.h),

                    // Description
                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.urMedium500().copyWith(
                        color: ColorHelper.subHeadingColor,
                        fontSize: isTablet ? 22.sp : 16.sp,
                        height: 1.5,
                      ),
                    ),

                    // Bottom padding to avoid overlapping with fixed controls in WalkthroughView
                    // The combined controls in WalkthroughView take roughly 150-180 responsive height
                    SizedBox(height: isTablet ? 220.h : 180.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
