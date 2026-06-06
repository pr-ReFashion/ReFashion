import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';
import 'package:refashion/app/widget/custom_multiselect_dropdown.dart';
import 'package:refashion/app/widget/custom_switch.dart';

import '../controllers/add_item_controller.dart';
import '../shimmer/organize_shimmer.dart';

class OrganizeView extends GetView<AddItemController> {
  const OrganizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.white,
      appBar: CommonAppBar(title: locale.value.organizeTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isOrganizeLoading.value) {
                return const OrganizeShimmer();
              }
              return RefreshIndicator(
                onRefresh: controller.fetchOrganizeData,
                color: ColorHelper.primary,
                backgroundColor: ColorHelper.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      _buildDiscountableSection(),
                      SizedBox(height: 24.h),
                      _buildOrganizeOptions(),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              );
            }),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildDiscountableSection() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomSwitch(
                value: controller.isDiscountable.value,
                onChanged: (val) => controller.isDiscountable.value = val,
              ),
              SizedBox(width: 12.w),
              Text(
                "${locale.value.discountableLabel} ",
                style: TextStyleHelper.urSemiBold600().copyWith(
                  color: ColorHelper.headingColor,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                locale.value.optionalText,
                style: TextStyleHelper.urRegular400().copyWith(
                  color: ColorHelper.subHeadingColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 56.w),
            child: Text(
              locale.value.discountableDesc,
              style: TextStyleHelper.urRegular400().copyWith(
                color: ColorHelper.subHeadingColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizeOptions() {
    return Column(
      children: [
        _buildDropdown(
          label: "${locale.value.typeLabel} ${locale.value.optionalText}",
          hint: locale.value.selectTypeHint,
          value: controller.selectedTypeId.value,
          items: controller.productTypesList
              .map(
                (e) => DropdownItem<String>(
                  value: e.id ?? "",
                  label: e.value ?? "",
                ),
              )
              .toList(),
          onChanged: (val) => controller.selectedTypeId.value = val,
        ),
        SizedBox(height: 16.h),
        _buildDropdown(
          label: "${locale.value.collectionLabel} ${locale.value.optionalText}",
          hint: locale.value.selectCollectionHint,
          value: controller.selectedCollectionId.value,
          items: controller.productCollectionsList
              .map(
                (e) => DropdownItem<String>(
                  value: e.id ?? "",
                  label: e.title ?? "",
                ),
              )
              .toList(),
          onChanged: (val) => controller.selectedCollectionId.value = val,
        ),
        SizedBox(height: 16.h),
        _buildDropdown(
          label: "${locale.value.categoryText} ${locale.value.optionalText}",
          hint: locale.value.selectCategoryText,
          value: controller.selectedCategoryId.value,
          items: controller.productCategoriesList
              .map(
                (e) => DropdownItem<String>(
                  value: e.id ?? "",
                  label: e.name ?? "",
                ),
              )
              .toList(),
          onChanged: (val) => controller.selectedCategoryId.value = val,
        ),
        SizedBox(height: 16.h),
        Obx(
          () => CustomMultiSelectDropdown<String>(
            label: "${locale.value.tagsLabel} ${locale.value.optionalText}",
            hint: locale.value.selectTagsHint,
            selectedValues: controller.selectedTagIds.toList(),
            items: controller.productTagsList
                .map(
                  (e) => DropdownItem<String>(
                    value: e.id ?? "",
                    label: e.value ?? "",
                  ),
                )
                .toList(),
            onChanged: (val) => controller.selectedTagIds.assignAll(val),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return CustomDropdown<String>(
      label: label,
      hint: hint,
      value: value,
      items: items,
      onChanged: onChanged,
      labelStyle: TextStyleHelper.urMedium500().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.headingColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: CommonBtn(
        onTap: () => Get.back(),
        text: locale.value.saveAndContinue,
        width: double.infinity,
      ),
    );
  }
}
