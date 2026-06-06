import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import '../controllers/payment_info_controller.dart';

class PaymentInfoView extends GetView<PaymentInfoController> {
  const PaymentInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.paymentInfo),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          Text(
            locale.value.paymentMethods,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPaymentItem(
            icon: ImageHelper.icMasterCard,
            title: locale.value.creditDebitCard,
            subtitle: 'Card ending ************3275',
            onEdit: () => Get.toNamed(Routes.editCard),
          ),
          SizedBox(height: 4.h),
          _buildPaymentItem(
            icon: ImageHelper.icPayPal,
            title: locale.value.payPal,
            subtitle: '${locale.value.connected}: akanshap@gmail.com',
            onEdit: () => Get.toNamed(Routes.payPal),
          ),
          SizedBox(height: 4.h),
          _buildPaymentItem(
            icon: ImageHelper.icWallet,
            title: locale.value.rftWallet,
            subtitle:
                '${locale.value.balance}: 680 RFT\n${locale.value.walletId}: RFT-98234',
            showEdit: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onEdit,
    bool showEdit = true,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageView(imagePath: icon, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          if (showEdit)
            GestureDetector(
              onTap: onEdit,
              child: CachedImageView(
                imagePath: ImageHelper.icPen,
                size: 18.sp,
                color: ColorHelper.iconColor,
              ),
            ),
        ],
      ),
    );
  }
}
