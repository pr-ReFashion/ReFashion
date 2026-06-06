import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/splash/controllers/walkthrough_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class BottomControls extends StatelessWidget {
  final WalkthroughController controller;
  final int totalPages;

  const BottomControls({
    super.key,
    required this.controller,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLastPage = controller.currentPage.value == totalPages - 1;

      return Row(
        children: [
          // Skip Button
          if (!isLastPage)
            Expanded(
              child: AppTextBtn(
                onPressed: () => controller.skip(),
                title: locale.value.skip,
              ),
            ),

          if (!isLastPage) SizedBox(width: 16.w),

          // Next / Let's Start Button
          Expanded(
            flex: isLastPage ? 1 : 0,
            child: CommonBtn(
              // Dynamic width if not last page, full width if last page (handled by Expanded)
              width: isLastPage ? double.infinity : 172.w,
              height: 44.h,
              onTap: () => controller.nextPage(),
              text: isLastPage ? locale.value.letsStart : locale.value.next,
              textStyle: TextStyleHelper.urRegular400().copyWith(
                fontWeight: FontWeight.w600,
                color: ColorHelper.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
