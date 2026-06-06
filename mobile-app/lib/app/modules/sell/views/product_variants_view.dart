import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_check_box.dart';
import 'package:refashion/app/widget/custom_switch.dart';

import '../controllers/add_item_controller.dart';
import '../model/product_option_model.dart';
import '../model/product_variant_model.dart';

class ProductVariantsView extends GetView<AddItemController> {
  const ProductVariantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.white,
      appBar: CommonAppBar(title: locale.value.variantsTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildVariantToggle(),
                  Obx(
                    () => controller.isProductWithVariants.value
                        ? _buildVariantsSection()
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildVariantToggle() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.value.productWithVariantsText,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  locale.value.defaultVariantDesc,
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => CustomSwitch(
              value: controller.isProductWithVariants.value,
              onChanged: (val) {
                controller.isProductWithVariants.value = val;
                if (val && controller.productOptions.isEmpty) {
                  controller.addProductOption();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          locale.value.productOptionsSubtitle,
          style: TextStyleHelper.urBold700().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.productOptions.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return _buildOptionItem(index);
            },
          ),
        ),
        SizedBox(height: 16.h),
        _buildSmallButton(
          "+ ${locale.value.addOptionButton}",
          onTap: controller.addProductOption,
        ),
        SizedBox(height: 32.h),
        Text(
          locale.value.productVariantsSubtitle,
          style: TextStyleHelper.urBold700().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 16.h),
        _buildVariantsTable(),
      ],
    );
  }

  Widget _buildOptionItem(int index) {
    final option = controller.productOptions[index];
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                // Title Row
                Row(
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        locale.value.optionTitleLabel,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: ColorHelper.offWhite,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorHelper.borderColor),
                        ),
                        child: CommanTextField(
                          controller: option.titleController,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (_) => controller.generateVariants(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: locale.value.optionTitleHint,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Values Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: SizedBox(
                        width: 60.w,
                        child: Text(
                          locale.value.optionValuesLabel,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 14.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: ColorHelper.offWhite,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorHelper.borderColor),
                        ),
                        child: Obx(
                          () => Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              ...option.values.asMap().entries.map((entry) {
                                return _buildValueChip(
                                  index,
                                  entry.key,
                                  entry.value,
                                );
                              }),
                              SizedBox(
                                width: 100.w,
                                child: TextField(
                                  controller: option.valueInputController,
                                  onSubmitted: (val) =>
                                      controller.addValueToOption(index, val),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: locale.value.optionValuesHint,
                                    hintStyle: TextStyleHelper.urRegular400()
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: ColorHelper.hintColor,
                                        ),
                                  ),
                                  style: TextStyleHelper.urRegular400()
                                      .copyWith(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.close, color: ColorHelper.error, size: 20.sp),
            onPressed: () => controller.removeProductOption(index),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsTable() {
    return Obx(() {
      if (controller.generatedVariants.isEmpty) {
        return _buildInfoBanner(locale.value.addOptionsToCreateVariantsTip);
      }

      final activeOptions = controller.productOptions
          .where((o) => o.titleController.text.trim().isNotEmpty)
          .toList();

      List<Widget> rows = controller.generatedVariants.asMap().entries.map((
        entry,
      ) {
        final index = entry.key;
        final variant = entry.value;
        return _buildVariantRow(variant, index, activeOptions);
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(locale.value.variantUncheckedTip),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: ColorHelper.offWhite.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 340.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed Header Row
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorHelper.offWhite,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                        border: const Border(
                          bottom: BorderSide(color: ColorHelper.borderColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 24.w), // Checkbox
                          SizedBox(width: 12.w),
                          SizedBox(width: 20.sp), // Drag
                          SizedBox(width: 12.w),
                          ...activeOptions.map((o) {
                            return SizedBox(
                              width: 100.w,
                              child: Text(
                                o.titleController.text.trim(),
                                style: TextStyleHelper.urMedium500().copyWith(
                                  fontSize: 14.sp,
                                  color: ColorHelper.headingColor,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    // Reorderable Rows
                    SizedBox(
                      width:
                          340.w +
                          (activeOptions.length > 1
                              ? (activeOptions.length - 1) * 100.w
                              : 0),
                      child: ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: controller.onReorderVariants,
                        children: rows,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVariantRow(
    ProductVariant variant,
    int index,
    List<ProductOption> activeOptions,
  ) {
    return Container(
      key: ValueKey(variant.combination.toString()),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: ColorHelper.white,
        border: Border(bottom: BorderSide(color: ColorHelper.borderColor)),
      ),
      child: Row(
        children: [
          Obx(
            () => SizedBox(
              width: 24.w,
              height: 24.w,
              child: CustomCheckbox(
                value: variant.isSelected.value,
                onChanged: (val) => variant.isSelected.value = val ?? false,
                activeColor: ColorHelper.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ReorderableDragStartListener(
            index: index,
            child: Icon(
              Icons.drag_indicator_rounded,
              size: 20.sp,
              color: ColorHelper.hintColor,
            ),
          ),
          SizedBox(width: 12.w),
          ...variant.combination.values.map((val) {
            return SizedBox(
              width: 100.w,
              child: Text(
                val,
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildValueChip(int optionIndex, int valueIndex, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        mainAxisSize: minAxisSize,
        children: [
          Text(
            value,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: () =>
                controller.removeValueFromOption(optionIndex, valueIndex),
            child: Icon(Icons.close, size: 12.sp, color: ColorHelper.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorHelper.offWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.borderColor),
        ),
        child: Text(
          text,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.headingColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20.sp, color: ColorHelper.hintColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyleHelper.urRegular400().copyWith(
                fontSize: 13.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: CommonBtn(
        onTap: () {
          Get.back();
        },
        text: locale.value.saveAndContinue,
        textColor: ColorHelper.white,
        width: double.infinity,
      ),
    );
  }

  MainAxisSize get minAxisSize => MainAxisSize.min;
}
