import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import '../controllers/paypal_controller.dart';

class PayPalView extends GetView<PayPalController> {
  const PayPalView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.payPal),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          Text(
            locale.value.payPalAccount,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildAccountCard(),
          SizedBox(height: 24.h),
          CommonBtn(
            text: locale.value.connectNewAccount,
            onTap: controller.onConnectNewAccount,
            width: double.infinity,
          ),
          SizedBox(height: 12.h),
          CommonBtn(
            text: locale.value.disconnectPayPal,
            color: ColorHelper.transparent,
            textColor: ColorHelper.subHeadingColor,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: const BorderSide(color: ColorHelper.borderColor),
            ),
            onTap: controller.onDisconnectAccount,
            width: double.infinity,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CachedImageView(imagePath: ImageHelper.icPayPal, size: 48.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.connectedEmail.value,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        CachedImageView(
                          imagePath: ImageHelper.icCheckFill,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          locale.value.connected,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
