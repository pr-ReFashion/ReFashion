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
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/utills/image_helper.dart';

import '../controllers/add_item_controller.dart';

class SelectBrandView extends GetView<AddItemController> {
  const SelectBrandView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.selectBrandText),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _searchBar(),
          Expanded(
            child: Obx(() {
              if (controller.filteredBrands.isEmpty) {
                return Center(
                  child: Text(
                    locale.value.noResultsFoundText,
                    style: TextStyleHelper.urMedium500(),
                  ),
                );
              }

              final groupedBrands = _groupBrands(controller.filteredBrands);
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: groupedBrands.length,
                itemBuilder: (context, index) {
                  final group = groupedBrands[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        group.letter,
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          color: ColorHelper.headingColor,
                          fontSize: 18.sp,
                        ),
                      ),
                      ...group.items.map((brand) {
                        return Obx(() {
                          bool isSelected =
                              controller.selectedBrand.value == brand;
                          return InkWell(
                            onTap: () => controller.selectBrand(brand),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorHelper.primaryLightColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                brand,
                                style: TextStyleHelper.dmRegular400().copyWith(
                                  color: ColorHelper.headingColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          );
                        });
                      }),
                    ],
                  );
                },
              );
            }),
          ),
          _cantFindBrandLink(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CommanTextField(
              textFieldType: TextFieldType.OTHER,
              controller: controller.searchBrandController,
              onChanged: controller.onSearchBrandChanged,
              decoration: InputDecoration(
                hintText: locale.value.searchForBrand,
                fillColor: ColorHelper.white,
                prefixIcon: CachedImageView(
                  imagePath: ImageHelper.icSearch,
                  height: 12.h,
                  width: 12.w,
                ).paddingAll(14.r),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isSearchEmpty.value) {
              return AppTextBtn(
                onPressed: controller.onCancelSearchTap,
                title: locale.value.cancelText,
                style: TextStyleHelper.urMedium500().copyWith(
                  color: ColorHelper.headingColor,
                  fontSize: 14.sp,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
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

  List<_BrandGroup> _groupBrands(List<String> brands) {
    brands.sort((a, b) => a.compareTo(b));
    final groups = <String, List<String>>{};
    for (var brand in brands) {
      if (brand.isEmpty) continue;
      final firstLetter = brand[0].toUpperCase();
      if (!groups.containsKey(firstLetter)) {
        groups[firstLetter] = [];
      }
      groups[firstLetter]!.add(brand);
    }
    return groups.entries
        .map((e) => _BrandGroup(letter: e.key, items: e.value))
        .toList();
  }
}

class _BrandGroup {
  final String letter;
  final List<String> items;
  _BrandGroup({required this.letter, required this.items});
}
