import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/add_item_controller.dart';
import '../model/product_variant_model.dart';

class VariantInventoryView extends GetView<AddItemController> {
  const VariantInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.white,
      appBar: CommonAppBar(title: locale.value.variantInventoryTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              if (controller.generatedVariants.isEmpty) {
                return Center(
                  child: Text(
                    locale.value.noVariantsSelectedHint,
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.hintColor,
                      fontSize: 14.sp,
                    ),
                  ).paddingAll(24.sp),
                );
              }

              // Filter only selected variants for inventory management
              final selectedVariants = controller.generatedVariants
                  .where((v) => v.isSelected.value)
                  .toList();

              if (selectedVariants.isEmpty) {
                return Center(
                  child: Text(
                    locale.value.noVariantsSelectedHint,
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.hintColor,
                      fontSize: 14.sp,
                    ),
                  ).paddingAll(24.sp),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildInventoryList(selectedVariants),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            }),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildInventoryList(List<ProductVariant> variants) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => _buildVariantCard(variants[index]),
    );
  }

  Widget _buildVariantCard(ProductVariant variant) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorHelper.borderColor),
        boxShadow: [
          BoxShadow(
            color: ColorHelper.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant Identifier
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorHelper.primaryLightColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  variant.displayTitle,
                  style: TextStyleHelper.urSemiBold600().copyWith(
                    fontSize: 13.sp,
                    color: ColorHelper.primary,
                  ),
                ),
              ),
              const Spacer(),
              // Optional: Show status or select checkbox if needed
            ],
          ),
          SizedBox(height: 16.h),

          // Title Segment
          _buildFieldLabel(locale.value.titleLabel),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: variant.titleController,
            hint: locale.value.optionTitleHint,
          ),
          SizedBox(height: 16.h),

          // SKU and Price Segment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(locale.value.skuLabel),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: variant.skuController,
                      hint: locale.value.skuHint,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(locale.value.priceEurLabel),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: variant.priceController,
                      hint: locale.value.pricePlaceholder,
                      prefix: "€ ",
                      keyboardType: TextInputType.number,
                      onChanged: (val) => controller.updateSectionStatus(),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyleHelper.urMedium500().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.subHeadingColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? prefix,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyleHelper.urMedium500().copyWith(fontSize: 14.sp),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          prefixText: prefix,
          prefixStyle: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.headingColor,
          ),
          hintStyle: TextStyleHelper.urRegular400().copyWith(
            color: ColorHelper.hintColor,
            fontSize: 14.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(() {
        final isValid = controller.isInventoryCompletedRx.value;
        return CommonBtn(
          onTap: isValid
              ? () {
                  Get.back();
                }
              : null,
          color: isValid ? ColorHelper.primary : ColorHelper.borderColor,
          text: locale.value.saveAndContinue,
          disabledColor: ColorHelper.borderColor,
          textColor: isValid ? ColorHelper.white : ColorHelper.hintColor,
          width: double.infinity,
        );
      }),
    );
  }
}
