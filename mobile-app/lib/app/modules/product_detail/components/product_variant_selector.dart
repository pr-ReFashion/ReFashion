import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';
import '../models/product_list_model.dart';

class ProductVariantSelector extends GetView<ProductDetailController> {
  const ProductVariantSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product.value;
      if (product == null ||
          product.options == null ||
          product.options!.isEmpty) {
        return const SizedBox.shrink();
      }

      // Filter out options that don't have values
      final options = product.options!
          .where((opt) => opt.values != null && opt.values!.isNotEmpty)
          .toList();

      if (options.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...options.map((option) => _buildOptionRow(option)),
          SizedBox(height: 8.h),
        ],
      );
    });
  }

  Widget _buildOptionRow(ProductOption option) {
    final title = option.title ?? '';
    final optionId = option.id ?? '';
    // Use a set to get unique values for this option title
    final values = option.values ?? [];

    if (values.isEmpty || optionId.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final selectedValueText = controller.getSelectedOptionValueText(
              optionId,
            );
            return RichText(
              text: TextSpan(
                text: '$title: ',
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.subHeadingColor,
                ),
                children: [
                  if (selectedValueText != null)
                    TextSpan(
                      text: selectedValueText,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 14.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: values
                .map((valueObj) => _buildValueChip(optionId, valueObj))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildValueChip(String optionId, OptionValue valueObj) {
    return Obx(() {
      final valueId = valueObj.id ?? '';
      final valueText = valueObj.value ?? '';

      final isSelected = controller.selectedOptions[optionId] == valueId;
      final isAvailable = controller.isOptionAvailable(optionId, valueId);

      return GestureDetector(
        onTap: isAvailable
            ? () => controller.onOptionSelected(optionId, valueId)
            : null,
        child: Opacity(
          opacity: isAvailable ? 1.0 : 0.4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? ColorHelper.primary : ColorHelper.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? ColorHelper.primary
                    : ColorHelper.borderColor,
              ),
            ),
            child: Text(
              valueText,
              style: TextStyleHelper.dmMedium500().copyWith(
                fontSize: 12.sp,
                color: isSelected
                    ? ColorHelper.white
                    : ColorHelper.subHeadingColor,
                decoration: isAvailable ? null : TextDecoration.lineThrough,
                decorationColor: ColorHelper.subHeadingColor,
                decorationThickness: 2,
              ),
            ),
          ),
        ),
      );
    });
  }
}
