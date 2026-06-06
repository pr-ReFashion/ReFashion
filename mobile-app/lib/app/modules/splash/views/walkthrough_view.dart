import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/splash/controllers/walkthrough_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/modules/splash/components/walkthrough_content.dart';
import 'package:refashion/app/modules/splash/components/page_indicator.dart';
import 'package:refashion/app/modules/splash/components/bottom_controls.dart';
import 'package:refashion/app/utills/size_utils.dart';

class WalkthroughView extends GetView<WalkthroughController> {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      body: Stack(
        children: [
          // Content Pages
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              return WalkthroughContent(
                data: controller.pages[index],
                index: index,
                controller: controller,
                totalPages: controller.pages.length,
              );
            },
          ),

          // Persistent Bottom UI (Indicators & Controls)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 32.h),
              decoration: BoxDecoration(
                // Use a gradient to fade the background content behind the controls
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorHelper.white.withAlpha(0),
                    ColorHelper.white.withAlpha(200),
                    ColorHelper.white,
                  ],
                  stops: const [0.0, 0.3, 0.45],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pages.length,
                        (index) => PageIndicator(
                          isActive: index == controller.currentPage.value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Bottom Buttons (Skip/Next)
                  BottomControls(
                    controller: controller,
                    totalPages: controller.pages.length,
                  ),
                  // Safe area space for modern phones
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom > 0 ? 0 : 8.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
