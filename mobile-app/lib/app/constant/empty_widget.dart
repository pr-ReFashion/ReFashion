import 'package:flutter/material.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';

import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.height,
    this.width,
    this.btnText,
    this.onTap,
    this.child,
  });
  final String title;
  final String description;
  final String icon;
  final double? height;
  final double? width;
  final String? btnText;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageView(
              imagePath: icon,
              height: height ?? 160.sp,
              width: width ?? 160.sp,
            ),
            SizedBox(height: 40.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyleHelper.urBold700().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.subHeadingColor,
              ),
            ),
            if ((btnText != null || child != null) && onTap != null) ...[
              SizedBox(height: 24.h),
              CommonBtn(onTap: onTap!, text: btnText ?? '', child: child),
            ],
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
