import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';

class ProductShippingReturns extends GetView<ProductDetailController> {
  const ProductShippingReturns({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleShippingReturns,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              color: Colors.transparent, // For better hit testing
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.value.shippingAndReturns,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.subHeadingColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Obx(() {
                    return Icon(
                      controller.isShippingReturnsExpanded.value
                          ? Icons.remove
                          : Icons.add,
                      size: 20.sp,
                      color: ColorHelper.headingColor,
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(() {
            if (!controller.isShippingReturnsExpanded.value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint(locale.value.shippingPolicy),
                  SizedBox(height: 12.h),
                  _buildBulletPoint(locale.value.returnPolicy),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Container(
            width: 4.w,
            height: 4.w,
            decoration: const BoxDecoration(
              color: ColorHelper.subHeadingColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
