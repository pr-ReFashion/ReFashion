import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';
import '../models/product_list_model.dart';

class ProductHeaderInfo extends StatelessWidget {
  final Product product;

  const ProductHeaderInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildOffersBanner(),
        // SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildProductHeader()],
          ),
        ),
      ],
    );
  }

  // Widget _buildOffersBanner() {
  //   // Note: Favorites and offersCount are not in the provided Medusa Product model yet.
  //   // Using placeholders or handling if they exist in metadata.
  //   return Container(
  //     width: double.infinity,
  //     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8.r),
  //       gradient: ColorHelper.offerProgressBgGradient,
  //     ),
  //     child: Text(
  //       locale.value.offersInProgressText(0), // Placeholder
  //       style: TextStyleHelper.dmRegular400().copyWith(
  //         color: ColorHelper.subHeadingColor,
  //         fontSize: 12.sp,
  //       ),
  //     ),
  //   );
  // }

  String _getCondition() {
    if (product.options == null) return '';
    try {
      final conditionOption = product.options!.firstWhere(
        (option) => option.title?.toLowerCase() == 'condition',
      );
      return conditionOption.values?.firstOptionValue ?? '';
    } catch (e) {
      return '';
    }
  }

  Widget _buildProductHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.collection?.title ?? '',
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 280.w,
                  child: Text(
                    product.title ?? '',
                    style: TextStyleHelper.dmRegular400().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              final controller = Get.find<ProductDetailController>();
              final isWishlisted = controller.isWishlisted;
              return InkWell(
                onTap: controller.onWishlistTap,
                borderRadius: BorderRadius.circular(8.r),
                radius: 8.r,
                child: Container(
                  height: 32.h,
                  width: 36.w,
                  padding: EdgeInsets.all(6.r),
                  margin: EdgeInsets.only(top: 4.h),
                  decoration: BoxDecoration(
                    color: ColorHelper.lightGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CachedImageView(
                    imagePath: isWishlisted
                        ? ImageHelper.icHeartFill
                        : ImageHelper.icHeart,
                    fit: BoxFit.contain,
                    size: 18.sp,
                    color: isWishlisted ? ColorHelper.error : null,
                  ),
                ),
              );
            }),
          ],
        ),
        Builder(
          builder: (context) {
            final conditionOption = product.options?.firstWhereOrNull(
              (o) => o.title?.toLowerCase() == 'condition',
            );

            if (conditionOption == null) return const SizedBox.shrink();

            return Obx(() {
              final controller = Get.find<ProductDetailController>();
              final condition =
                  controller.getSelectedOptionValueText(conditionOption.id!) ??
                  _getCondition();

              if (condition.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text.rich(
                    TextSpan(
                      text: '${locale.value.conditionText}: ',
                      style: TextStyleHelper.dmRegular400().copyWith(
                        color: ColorHelper.subHeadingColor,
                        fontSize: 12.sp,
                      ),
                      children: [
                        TextSpan(
                          text: condition,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            color: ColorHelper.primary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
          },
        ),
        SizedBox(height: 4.h),
        Obx(() {
          final controller = Get.find<ProductDetailController>();
          final selectedVariant = controller.selectedVariant.value;

          // Use the central displayPrice getter from our model
          num priceValue =
              selectedVariant?.displayPrice ?? product.displayPrice;

          final displayPrice = priceValue.toString().toPrice();

          return Text.rich(
            TextSpan(
              text: '${locale.value.priceText}: ',
              style: TextStyleHelper.dmRegular400().copyWith(
                color: ColorHelper.subHeadingColor,
                fontSize: 12.sp,
              ),
              children: [
                TextSpan(
                  text: displayPrice,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

extension on List<OptionValue>? {
  String get firstOptionValue =>
      (this != null && this!.isNotEmpty) ? this!.first.value ?? '' : '';
}
