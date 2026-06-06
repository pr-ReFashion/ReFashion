import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:refashion/app/modules/order_details/models/order_detail_model.dart' as model;
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class CancelOrderView extends GetView<OrderDetailsController> {
  const CancelOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BaseScaffold(
        backgroundColor: ColorHelper.offWhite,
        appBar: CommonAppBar(
          title: locale.value.cancelOrder,
          actions: controller.isCancellationSent.value
              ? [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: ColorHelper.iconColor,
                      size: 24.sp,
                    ),
                  ),
                ]
              : null,
        ),
        body: controller.isCancellationSent.value
            ? _buildCancellationRequested()
            : _buildCancelOrderSelection(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 30.h),
          child: CommonBtn(
            text: controller.isCancellationSent.value
                ? locale.value.doneText
                : locale.value.confirm,
            onTap: controller.isCancellationSent.value
                ? () => Get.back()
                : controller.onConfirmCancellation,
            color: ColorHelper.primary,
            textColor: ColorHelper.white,
          ),
        ),
      );
    });
  }

  Widget _buildCancelOrderSelection() {
    final detail = controller.orderDetail.value;
    if (detail == null) return const SizedBox.shrink();

    final priceEuro = detail.total?.toString() ?? '0';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: _buildProductCard(detail),
          ),
          SizedBox(height: 12.h),
          Text(
            locale.value.chooseRefundMode,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildRefundOption(
            value: 0,
            title: locale.value.refashionWallet,
            description: locale.value.refashionWalletRefundDesc(
              priceEuro.toPrice(),
            ),
          ),
          SizedBox(height: 12.h),
          _buildRefundOption(
            value: 1,
            title: locale.value.backToSource,
            description: locale.value.backToSourceRefundDesc(
              priceEuro.toPrice(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationRequested() {
    final detail = controller.orderDetail.value;
    if (detail == null) return const SizedBox.shrink();

    final priceEuro = detail.total?.toString() ?? '0';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          Container(
            width: 100.w,
            height: 100.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorHelper.primaryLightColor,
              borderRadius: BorderRadius.circular(8.r),
              gradient: ColorHelper.hourGlassBgGradient,
            ),
            child: CachedImageView(
              imagePath: ImageHelper.icHourGlass,
              height: 52.h,
              width: 24.w,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            locale.value.cancellationRequested,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            locale.value.cancellationRequestedDesc,
            textAlign: TextAlign.center,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
              height: 1.4,
            ),
          ).paddingSymmetric(horizontal: 40.w),
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.value.itemIsCancelled(1),
              style: TextStyleHelper.urSemiBold600().copyWith(
                fontSize: 18.sp,
                color: ColorHelper.headingColor,
              ),
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
                _buildProductCard(detail, showArrow: true),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  title: locale.value.refundDetails,
                  description: locale.value.refundDetailsDesc(
                    priceEuro.toPrice(),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  title: locale.value.pleaseNote,
                  description: locale.value.pleaseNoteDesc,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildProductCard(model.Order detail, {bool showArrow = true}) {
    final item = detail.items?.first;
    if (item == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: CachedImageView(
              imagePath: item.thumbnail ?? '',
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productTitle ?? item.title ?? '',
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.productDescription ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: ColorHelper.iconColor,
            ),
        ],
      ),
    );
  }

  Widget _buildRefundOption({
    required int value,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () => controller.selectedRefundMode.value = value,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.selectedRefundMode.value == value
                      ? ColorHelper.primary
                      : ColorHelper.iconColor,
                  width: 1.5,
                ),
              ),
              child: controller.selectedRefundMode.value == value
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: const BoxDecoration(
                          color: ColorHelper.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                    fontWeight: controller.selectedRefundMode.value == value
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(text: _buildDescriptionWithColoredAmount(description)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildDescriptionWithColoredAmount(String description) {
    final symbol = CurrencyController.to.selectedCurrency.symbolText;
    final regex = RegExp('(\\d+\\s*${RegExp.escape(symbol)})');
    final matches = regex.allMatches(description);

    if (matches.isEmpty) {
      return TextSpan(
        text: description,
        style: TextStyleHelper.dmRegular400().copyWith(
          fontSize: 12.sp,
          color: ColorHelper.subHeadingColor,
          height: 1.4,
        ),
      );
    }

    final List<TextSpan> children = [];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        children.add(
          TextSpan(text: description.substring(lastIndex, match.start)),
        );
      }
      children.add(
        TextSpan(
          text: match.group(0),
          style: TextStyleHelper.dmBold700().copyWith(
            color: ColorHelper.primary,
            fontSize: 12.sp,
          ),
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < description.length) {
      children.add(TextSpan(text: description.substring(lastIndex)));
    }

    return TextSpan(
      children: children,
      style: TextStyleHelper.dmRegular400().copyWith(
        fontSize: 12.sp,
        color: ColorHelper.subHeadingColor,
        height: 1.4,
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: ColorHelper.coolGray.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.check, size: 14.sp, color: ColorHelper.white),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              SizedBox(height: 2.h),
              RichText(text: _buildDescriptionWithColoredAmount(description)),
            ],
          ),
        ),
      ],
    );
  }
}
