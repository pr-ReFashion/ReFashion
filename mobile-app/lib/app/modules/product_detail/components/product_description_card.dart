import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';
import '../models/product_list_model.dart';

class ProductDescriptionCard extends GetView<ProductDetailController> {
  final Product product;

  const ProductDescriptionCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.toggleDescription,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              color: Colors.transparent, // For better hit testing
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.value.descriptionText.toUpperCase(),
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.subHeadingColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Obx(() {
                    return Icon(
                      controller.isDescriptionExpanded.value
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
            if (!controller.isDescriptionExpanded.value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: _buildDescription(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description ?? '',
      style: TextStyleHelper.dmRegular400().copyWith(
        color: ColorHelper.subHeadingColor,
        fontSize: 12.sp,
        height: 1.5,
      ),
    );
  }

  /* Widget _buildDetails() {
    // Ensure Obx has a dependency even if product has no options
    final _ = controller.selectedOptions.length;

    final Map<String, String> details = {};

    if (product.options != null) {
      for (var option in product.options!) {
        if (option.id != null && option.title != null) {
          // Priority: Selected option (lookup by ID) > First value placeholder
          final selectedValueText = controller.getSelectedOptionValueText(
            option.id!,
          );
          if (selectedValueText != null) {
            details[option.title!] = selectedValueText;
          } else if (option.values != null && option.values!.isNotEmpty) {
            details[option.title!] = option.values!.first.value ?? '';
          }
        }
      }
    }

    if (product.material != null && product.material!.isNotEmpty) {
      details['Material'] = product.material!;
    }

    final selectedVariant = controller.selectedVariant.value;
    if (selectedVariant != null) {
      if (selectedVariant.sku != null && selectedVariant.sku!.isNotEmpty) {
        details['SKU'] = selectedVariant.sku!;
      }
      if (selectedVariant.weight != null) {
        details['Weight'] = '${selectedVariant.weight}g';
      }
      if (selectedVariant.length != null &&
          selectedVariant.width != null &&
          selectedVariant.height != null) {
        details['Dimensions'] =
            '${selectedVariant.length}x${selectedVariant.width}x${selectedVariant.height}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.detailsText,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 8.h),
        ...details.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    entry.key,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TextStyleHelper.dmMedium500().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  } */

  /* Widget _buildAuthentication() {
    // Note: Authentication data is not present in the Medusa Product model directly.
    // Using placeholders for now.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.value.authenticationText,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            Row(
              children: [
                Text(
                  locale.value.verifiedText,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                CachedImageView(
                  imagePath: ImageHelper.icVerified,
                  fit: BoxFit.contain,
                  size: 18.sp,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          locale.value.authenticatedOn('Now'), // Placeholder
          style: TextStyleHelper.dmRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 12.sp,
          ),
        ),
        Text(
          'Authenticity confirmed', // Placeholder
          style: TextStyleHelper.dmRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  } */
}
