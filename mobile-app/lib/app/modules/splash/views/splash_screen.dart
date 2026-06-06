import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/splash/controllers/splash_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/cached_image_view.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            const CachedImageView(
              imagePath: ImageHelper.splashBG,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Positioned(
              top: 91.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CachedImageView(imagePath: ImageHelper.logo, size: 48.r),
                  SizedBox(height: 20.h),
                  Text(
                    locale.value.reFashion,
                    style: TextStyleHelper.urExtraBold800().copyWith(
                      fontSize: 32.sp,
                      color: ColorHelper.white,
                    ),
                  ),
                ],
              ),
            ),
            // Obx(
            //   () => controller.isLoggedIn.value
            //       ? const SizedBox.shrink()
            //       : Positioned(
            //           bottom: 60.h,
            //           left: 18,
            //           right: 18,
            //           child: Column(
            //             children: [
            //               Text(
            //                 textAlign: TextAlign.center,
            //                 locale
            //                     .value
            //                     .reFashionForStylishAndSustainableFuture,
            //                 style: TextStyleHelper.urBold700().copyWith(
            //                   fontSize: 28.sp,
            //                   color: ColorHelper.white,
            //                 ),
            //               ),
            //               SizedBox(height: 36.h),
            //               CommonBtn(
            //                 height: 44.h,
            //                 width: double.infinity,
            //                 onTap: controller.getStartedOnTap,
            //                 text: locale.value.getStarted,
            //                 textStyle: TextStyleHelper.urSemiBold600().copyWith(
            //                   fontSize: 14.sp,
            //                   color: ColorHelper.white,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
