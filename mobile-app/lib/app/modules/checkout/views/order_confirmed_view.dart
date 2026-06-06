import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class OrderConfirmedView extends GetView<CheckoutController> {
  const OrderConfirmedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(
        title: locale.value.orderConfirmed,
        leading: IconButton(
          onPressed: controller.onOrderConfirmedCloseTap,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 22.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.onOrderConfirmedCloseTap,
            icon: Icon(Icons.close, color: ColorHelper.iconColor, size: 24.sp),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            CachedImageView(
              imagePath: ImageHelper.icSuccess,
              height: 140.sp,
              width: 140.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              locale.value.thankYouForSupportingDescription,
              textAlign: TextAlign.center,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Column(
                children: [
                  Obx(
                    () => _confirmItem(
                      icon: ImageHelper.icFile,
                      label: locale.value.orderID,
                      value:
                          controller.orderSetRes.value?.orderSet?.displayId
                              ?.toString() ??
                          '',
                    ),
                  ),
                  // _divider(),
                  // _confirmItem(
                  //   icon: ImageHelper.icCalender,
                  //   label: locale.value.estimatedDelivery,
                  //   value: DateTime.now()
                  //       .add(const Duration(days: 7))
                  //       .eeMMD(), // Example fallback date
                  // ),
                  _divider(),
                  Obx(
                    () => _confirmItem(
                      icon: ImageHelper.icPurse,
                      label: locale.value.totalCharged,
                      value:
                          (controller.orderSetRes.value?.orderSet?.total ?? 0.0)
                              .toDouble()
                              .toPrice(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CommonBtn(
                    text: locale.value.continueShopping,
                    onTap: controller.onContinueShoppingTap,
                    color: ColorHelper.transparent,
                    textColor: ColorHelper.primary,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.primary),
                    ),
                  ),
                ),
                // SizedBox(width: 12.w),
                // Expanded(
                //   child: CommonBtn(
                //     text: locale.value.trackOrder,
                //     onTap: controller.onTrackOrderTap,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _confirmItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CachedImageView(
          imagePath: icon,
          height: 20.sp,
          width: 20.sp,
          color: ColorHelper.subHeadingColor,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyleHelper.dmRegular400().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.subHeadingColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: const Divider(height: 1, color: ColorHelper.borderColor),
    );
  }
}
