import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_check_box.dart';

import 'package:refashion/app/modules/bag/shimmer/bag_shimmer.dart';

import '../controllers/bag_controller.dart';

class BagView extends GetView<BagController> {
  const BagView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.bagText),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const BagShimmer();
        }
        if (controller.cartItems.isEmpty) {
          return EmptyWidget(
            title: locale.value.yourBagIsEmpty,
            description: locale.value.supportSustainableFashion,
            icon: ImageHelper.icEmptyFavorite,
            btnText: locale.value.startExploringNow,
            onTap: controller.startExploring,
          );
        }
        return Column(
          children: [
            Obx(
              () => controller.showMovedToFavorite.value
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: const BoxDecoration(
                        color: ColorHelper.headingColor,
                      ),
                      child: Text(
                        locale.value.movedToFavorite,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.dmMedium500().copyWith(
                          color: ColorHelper.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: AnimatedScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  SizedBox(height: 16.h),
                  Obx(
                    () => CustomCheckbox(
                      value: controller.isAllSelected.value,
                      size: 18.sp,
                      onChanged: (val) => controller.toggleAllSelection(),
                      label:
                          '${controller.selectedCount} ${locale.value.itemSelected}',
                      labelStyle: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 14.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.cartItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final item = controller.cartItems[index];
                      return _itemWidget(item, index);
                    },
                  ),
                  SizedBox(height: 8.h),
                  if (controller.selectedCount == 0) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: ColorHelper.offerNotificationBgGradient,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        locale
                            .value
                            .noItemSelectedSelectAtLeastOneItemToPlaceOrder,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                    ),
                  ] else ...[
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorHelper.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorHelper.borderColor),
                        ),
                        child: Column(
                          children: [
                            _priceRow(
                              locale.value.priceDetailsWithCount(
                                controller.selectedCount,
                              ),
                              controller.subTotalEuro,
                            ),
                            if (controller.discountTotalEuro > 0) ...[
                              SizedBox(height: 8.h),
                              _priceRow(
                                locale.value.discount,
                                -controller.discountTotalEuro,
                                valueColor: Colors.green,
                              ),
                            ],
                            if (controller.taxTotalEuro > 0) ...[
                              SizedBox(height: 8.h),
                              _priceRow(
                                locale.value.tax,
                                controller.taxTotalEuro,
                              ),
                            ],
                            if (controller.shippingTotalEuro > 0) ...[
                              SizedBox(height: 8.h),
                              _priceRow(
                                locale.value.shippingText,
                                controller.shippingTotalEuro,
                              ),
                            ],
                            SizedBox(height: 8.h),
                            _priceRow(
                              locale.value.totalText,
                              controller.totalEuro,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
            CommonBtn(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
              disabledColor: ColorHelper.lightGrey,
              textColor: controller.selectedCount > 0
                  ? ColorHelper.white
                  : ColorHelper.subHeadingColor,
              onTap: controller.selectedCount > 0
                  ? controller.proceedToCheckout
                  : null,
              text: locale.value.proceedToCheckout,
              enabled: controller.selectedCount > 0,
            ),
          ],
        );
      }),
    );
  }

  Widget _itemWidget(CartItem item, int index) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedImageView(
                  imagePath: item.image,
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.cover,
                ),
              ),
              Obx(
                () => Positioned(
                  left: 6.w,
                  top: 6.h,
                  child: CustomCheckbox(
                    size: 18.sp,
                    value: item.isSelected.value,
                    onChanged: (val) => controller.toggleSelection(index),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.onEditTap(item),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: CachedImageView(
                          imagePath: ImageHelper.icPen,
                          height: 18.h,
                          width: 18.w,
                          color: ColorHelper.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variantTitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.variantTitle,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  '${locale.value.quantityText}: ${item.quantity}',
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${locale.value.soldByText} ${item.vendor}',
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 10.sp,
                    color: ColorHelper.hintColor,
                  ),
                ),
                SizedBox(height: 8.h),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        item.priceEuro.toPrice(),
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      /*SizedBox(width: 8.w),
                  const VerticalDivider(
                    width: 1,
                    color: ColorHelper.borderColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${item.priceRFT} RFT',
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.primary,
                    ),
                  ),*/
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

  Widget _priceRow(
    String label,
    double euro, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? TextStyleHelper.urBold700().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.primary,
                  )
                : TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Text(
                euro.toPrice(),
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                  color: valueColor ?? ColorHelper.headingColor,
                ),
              ),
              /*SizedBox(width: 8.w),
              const VerticalDivider(width: 1, color: ColorHelper.lightGrey),
              SizedBox(width: 8.w),
              Text(
                '$rft RFT',
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                  color: isTotal ? ColorHelper.primary : ColorHelper.hintColor,
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
