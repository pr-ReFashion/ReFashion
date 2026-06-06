import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';

import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_check_box.dart';
import 'package:refashion/app/widget/double_circle_thumb_slider_shape.dart';

import '../controllers/categories_controller.dart';
import '../shimmer/filter_shimmer.dart';

class FilterView extends GetView<CategoriesController> {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryName =
        (Get.arguments is Map ? Get.arguments['title'] : Get.arguments) ??
        locale.value.filterText;

    return BaseScaffold(
      appBar: CommonAppBar(
        title: categoryName,
        actions: [
          TextButton(
            onPressed: controller.clearAllFilters,
            child: Text(
              locale.value.clearAllText,
              style: TextStyleHelper.urMedium500().copyWith(
                color: ColorHelper.primary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () =>
            (controller.isLoading.value ||
                controller.isLoadingCollections.value)
            ? const FilterShimmer()
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sideBar(),
                        Expanded(child: _filterContent()),
                      ],
                    ),
                  ),
                  _bottomBar(),
                ],
              ),
      ),
    );
  }

  Widget _sideBar() {
    return Container(
      width: 120.w,
      color: ColorHelper.offWhite,
      child: ListView.builder(
        itemCount: controller.filterTabs.length,
        itemBuilder: (context, index) {
          final tab = controller.filterTabs[index];
          return Obx(() {
            bool isSelected = controller.selectedFilterTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.onFilterTabTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: isSelected ? ColorHelper.white : null,
                  border: const Border(
                    bottom: BorderSide(
                      color: ColorHelper.borderColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _filterContent() {
    return Obx(() {
      final selectedTab =
          controller.filterTabs[controller.selectedFilterTabIndex.value];

      if (selectedTab == 'Price') {
        return _priceFilter();
      }

      final options = controller.filterOptions[selectedTab] ?? [];

      return Column(
        children: [
          // Search bar can be added here if needed for other tabs in the future
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Obx(() {
                    final isSelected =
                        controller.selectedFilters[selectedTab]?.contains(
                          option,
                        ) ??
                        false;
                    return InkWell(
                      onTap: () =>
                          controller.toggleFilterSelection(selectedTab, option),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            value: isSelected,
                            size: 18.sp,
                            onChanged: (_) => controller.toggleFilterSelection(
                              selectedTab,
                              option,
                            ),
                            activeColor: ColorHelper.primary,
                          ),
                          SizedBox(width: 8.w),

                          Expanded(
                            child: Text(
                              option,
                              style: TextStyleHelper.urMedium500().copyWith(
                                fontSize: 16.sp,
                                color: ColorHelper.subHeadingColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _priceFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '${controller.priceRange.value.start.toPrice(decimalDigits: 0)} - ${controller.priceRange.value.end.toPrice(decimalDigits: 0)}',
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            SizedBox(height: 16.h),
            SliderTheme(
              data: SliderTheme.of(Get.context!).copyWith(
                activeTrackColor: ColorHelper.primary,
                inactiveTrackColor: ColorHelper.lightGrey,
                thumbColor: ColorHelper.primary,
                rangeThumbShape: const DoubleCircleRangeThumbShape(),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                trackHeight: 8.0,
                padding: EdgeInsets.zero,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
                  tickMarkRadius: 0,
                ),
              ),
              child: RangeSlider(
                values: controller.priceRange.value,
                min: 0,
                max: 10000,
                divisions: 10000,
                padding: EdgeInsets.zero,
                onChanged: controller.onPriceRangeChange,
                activeColor: ColorHelper.primary,
                inactiveColor: ColorHelper.borderColor,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),

      child: Row(
        children: [
          CommonBtn(
            onTap: controller.onCloseTap,
            text: locale.value.closeText,
            color: ColorHelper.transparent,
            textColor: ColorHelper.subHeadingColor,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: ColorHelper.borderColor, width: 1.h),
            ),
          ).expand(),
          SizedBox(width: 12.w),
          CommonBtn(
            onTap: controller.applyFilters,
            text: locale.value.applyText,
          ).expand(),
        ],
      ),
    );
  }
}
