import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_switch.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:refashion/app/utills/keyboard_action_helper.dart';

import '../controllers/make_an_offer_controller.dart';

class MakeAnOfferView extends GetView<MakeAnOfferController> {
  const MakeAnOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScaffold(
        appBar: CommonAppBar(
          title: controller.isSellerSide.value
              ? locale.value.makeAnOffer
              : locale.value.newOfferText,
        ),
        body: KeyboardActions(
          barSize: 26,
          config: KeyboardActionHelper.getKeyboardConfig(
            context: context,
            focusNodes: [controller.customOfferFocusNode],
            onClear: () {
              controller.customOfferController.clear();
              controller.selectedOfferPercentage.value = 0;
            },
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: controller.isSellerSide.value
                ? _buildSellerSide(context)
                : _buildBuyerSide(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyerSide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOffersInProgress(context),
        SizedBox(height: 8.h),
        _buildProductCard(context),
        SizedBox(height: 12.h),
        Text(
          locale.value.makeAnOffer,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          locale.value.offerRecommendationText,
          style: TextStyleHelper.dmRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 12.h),
        _buildOfferButtons(),
        SizedBox(height: 12.h),
        Text(
          locale.value.customOfferText,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildCustomOfferTextField(),
        SizedBox(height: 10.h),
        _buildTokenSwitch(),
        SizedBox(height: 24.h),
        _buildBuyerBottomButtons(context),
      ],
    );
  }

  Widget _buildSellerSide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOfferReceivedBanner(),
        SizedBox(height: 10.h),
        _buildProductCard(context),
        SizedBox(height: 12.h),
        Text(
          locale.value.offerDetailsText,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildOfferDetailsCard(),
        SizedBox(height: 24.h),
        _buildSellerBottomButtons(),
      ],
    );
  }

  Widget _buildOfferReceivedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        gradient: ColorHelper.offerProgressBgGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.value.youReceivedAnOffer,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          CommonBtn(
            text: locale.value.acceptOffer,
            width: double.infinity,
            height: 48.h,
            onTap: controller.onAcceptOffer,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferDetailsCard() {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedImageView(
                  imagePath: controller.offerDetails.buyerImage,
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.offerDetails.buyerName,
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: ColorHelper.headingColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    controller.offerDetails.buyerRole,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(color: ColorHelper.borderColor, height: 1),
          SizedBox(height: 8.h),
          _buildDetailRow(
            locale.value.offerAmount,
            controller.offerDetails.offerAmount,
            textColor: ColorHelper.primary,
            isBold: true,
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            locale.value.discount,
            controller.offerDetails.discountPercentage,
            textColor: ColorHelper.subHeadingColor,
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            locale.value.submitted,
            controller.offerDetails.submittedTime,
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icClock,
                  size: 18.sp,
                  color: ColorHelper.iconColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  controller.offerDetails.submittedTime,
                  style: TextStyleHelper.urRegular400().copyWith(
                    color: ColorHelper.hintColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            showValue: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? textColor,
    bool isBold = false,
    Widget? trailingWidget,
    bool showValue = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyleHelper.urBold700().copyWith(
            color: isBold ? ColorHelper.primary : ColorHelper.headingColor,
            fontSize: 16.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        if (showValue)
          Text(
            value,
            style: TextStyleHelper.urBold700().copyWith(
              color: textColor ?? ColorHelper.headingColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontSize: isBold ? 16.sp : 14.sp,
            ),
          ),
        if (trailingWidget != null) trailingWidget,
      ],
    );
  }

  Widget _buildSellerBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: CommonBtn(
            color: ColorHelper.transparent,
            shapeBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorHelper.success),
            ),
            onTap: controller.onChatTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icChat,
                  color: ColorHelper.success,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  locale.value.chatText,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.black,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CommonBtn(
            text: locale.value.rejectOffer,
            color: ColorHelper.primary,
            onTap: controller.onRejectOffer,
          ),
        ),
      ],
    );
  }

  Widget _buildBuyerBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CommonBtn(
            color: ColorHelper.transparent,
            shapeBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorHelper.success),
            ),
            onTap: controller.onChatTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icChat,
                  color: ColorHelper.success,
                  size: 24.sp,
                ),
                const SizedBox(width: 8),
                Text(
                  locale.value.chatText,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.black,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CommonBtn(
            text: locale.value.sendAnOfferText,
            color: ColorHelper.primary,
            onTap: controller.showOfferSentBottomSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomOfferTextField() {
    return CommanTextField(
      controller: controller.customOfferController,
      focus: controller.customOfferFocusNode,
      textFieldType: TextFieldType.NUMBER,
      textStyle: TextStyleHelper.urMedium500().copyWith(
        color: ColorHelper.primary,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CurrencyController.to.selectedCurrency.symbolText,
              style: TextStyleHelper.urMedium500().copyWith(
                color: ColorHelper.primary,
                fontSize: 14.sp,
              ),
            ).paddingOnly(left: 12.w, right: 2.w),
          ],
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: ColorHelper.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.primary),
        ),
      ),
      onChanged: (val) {
        if (val.isNotEmpty) {
          controller.selectedOfferPercentage.value = 0;
        }
      },
    );
  }

  Widget _buildTokenSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          locale.value.useRefashionTokensText,
          style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp),
        ),
        Obx(
          () => CustomSwitch(
            value: controller.useRefashionTokens.value,
            onChanged: controller.toggleRefashionTokens,
            activeColor: ColorHelper.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOffersInProgress(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        gradient: ColorHelper.offerProgressBgGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.value.offersInProgressText(2),
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          CommonBtn(
            text: locale.value.buyNowText,
            width: double.infinity,
            height: 48.h,
            onTap: controller.onBuyNowTap,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedImageView(
              imagePath: controller.product.images.isNotEmpty
                  ? controller.product.images.first
                  : '',
              height: 100.h,
              width: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.product.brand,
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  controller.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${locale.value.soldByText} ${controller.product.seller.name}',
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 10.sp,
                    color: ColorHelper.hintColor,
                  ),
                ),
                SizedBox(height: 8.h),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          controller.product.price.toPrice(),
                          style: TextStyleHelper.urSemiBold600().copyWith(
                            fontSize: 14.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      const VerticalDivider(
                        color: ColorHelper.borderColor,
                        thickness: 2,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '2800 RFT',
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          color: ColorHelper.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPercentageButton(5),
        SizedBox(width: 12.w),
        _buildPercentageButton(10),
        SizedBox(width: 12.w),
        _buildPercentageButton(15),
      ],
    );
  }

  Widget _buildPercentageButton(int percentage) {
    return Expanded(
      child: Obx(() {
        final isSelected =
            controller.selectedOfferPercentage.value == percentage;
        final price = controller
            .getDiscountedPrice(percentage)
            .toStringAsFixed(0);

        return InkWell(
          onTap: () => controller.selectOffer(percentage),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: isSelected ? ColorHelper.offWhite : ColorHelper.softGrey,
              border: Border.all(
                color: isSelected
                    ? ColorHelper.primary
                    : ColorHelper.transparent,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price.toPrice(),
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 18.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$percentage% off',
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                    color: isSelected
                        ? ColorHelper.primary
                        : ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
