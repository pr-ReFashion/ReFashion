import 'package:flutter/material.dart';
import 'package:get/get.dart';
/* import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart'; */

import '../controllers/add_item_controller.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    /* 
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.whoIsThisItemFor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _progressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _sectionTitle(locale.value.genderText),
                  SizedBox(height: 12.h),
                  _genderSelection(),
                  SizedBox(height: 18.h),
                  _sectionTitle(locale.value.categoryText),
                  SizedBox(height: 12.h),
                  _categoryList(),
                  SizedBox(height: 18.h),
                  _sectionTitle(locale.value.brandText),
                  SizedBox(height: 12.h),
                  _brandSearch(),
                  _cantFindBrandLink(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
          _nextButton(),
        ],
      ),
    );
    */
    return const Scaffold(
      body: Center(child: Text("Basic Info Step (Commented)")),
    );
  }

  /*
  Widget _progressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        const totalSegments = 3;
        bool isGenderFilled =
            controller.selectedGender.value !=
            -1; // Assuming -1 or similar for unselected if we want it strict, but current default is 0
        bool isCategoryFilled = controller.selectedSubcategory.value.isNotEmpty;
        bool isBrandFilled = controller.selectedBrand.value.isNotEmpty;

        int completedSegments = 0;
        if (isGenderFilled) completedSegments++;
        if (isCategoryFilled) completedSegments++;
        if (isBrandFilled) completedSegments++;

        return Row(
          children: List.generate(totalSegments, (index) {
            bool isFilled = index < completedSegments;
            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.only(
                  right: index == totalSegments - 1 ? 0 : 8.w,
                ),
                decoration: BoxDecoration(
                  color: isFilled ? ColorHelper.primary : ColorHelper.offWhite,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyleHelper.urSemiBold600().copyWith(
        color: ColorHelper.headingColor,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _genderSelection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: List.generate(controller.genders.length, (index) {
          return Expanded(
            child: Obx(() {
              bool isSelected = controller.selectedGender.value == index;
              return GestureDetector(
                onTap: () => controller.onGenderTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorHelper.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.genders[index],
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: isSelected
                          ? ColorHelper.white
                          : ColorHelper.headingColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _categoryList() {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Obx(() {
        return Column(
          children: List.generate(controller.categories.length, (index) {
            final category = controller.categories[index];
            bool isExpanded = category.isExpanded.value;
            return Column(
              children: [
                InkWell(
                  onTap: () => controller.toggleCategory(index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          category.title,
                          style: TextStyleHelper.urMedium500().copyWith(
                            color: ColorHelper.headingColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        const Spacer(),
                        if (!isExpanded &&
                            category.subcategories.contains(
                              controller.selectedSubcategory.value,
                            )) ...[
                          Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorHelper.success,
                            ),
                            child: Icon(
                              Icons.check,
                              color: ColorHelper.white,
                              size: 12.sp,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: ColorHelper.iconColor,
                            size: 20.sp,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Column(
                    children: category.subcategories.map((sub) {
                      return Obx(() {
                        bool isSelected =
                            controller.selectedSubcategory.value == sub;
                        return InkWell(
                          onTap: () =>
                              controller.selectSubcategory(category.title, sub),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 2.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            color: isSelected
                                ? ColorHelper.primaryLightColor
                                : Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  sub,
                                  style: TextStyleHelper.urRegular400()
                                      .copyWith(
                                        color: ColorHelper.headingColor,
                                        fontSize: 14.sp,
                                      ),
                                ),
                                const Spacer(),
                                if (isSelected) ...[
                                  Container(
                                    padding: EdgeInsets.all(2.r),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorHelper.success,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: ColorHelper.white,
                                      size: 12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                ],
                              ],
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                if (index != controller.categories.length - 1) ...[
                  const Divider(height: 1, color: ColorHelper.borderColor),
                ],
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _brandSearch() {
    return Obx(() {
      return CommanTextField(
        textFieldType: TextFieldType.OTHER,
        readOnly: true,
        onTap: controller.goToSelectBrand,
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: locale.value.searchForBrand,
          fillColor: ColorHelper.white,
          prefixIcon: CachedImageView(
            imagePath: ImageHelper.icSearch,
            height: 12.h,
            width: 12.w,
          ).paddingAll(14.sp),
        ),
      );
    });
  }

  Widget _cantFindBrandLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppTextBtn(
        onPressed: controller.onCantFindBrandTap,
        title: locale.value.cantFindYourBrand,
        style: TextStyleHelper.urMedium500().copyWith(
          color: ColorHelper.primary,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(() {
        return CommonBtn(
          onTap: controller.isNextEnabled ? controller.onNextTap : null,
          text: locale.value.next,
          width: double.infinity,
          disabledColor: ColorHelper.lightGrey,
          textColor: controller.isNextEnabled
              ? ColorHelper.white
              : ColorHelper.hintColor,
        );
      }),
    );
  }
*/
}
