import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/app_loader.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/address_controller.dart';

class AddressSearchView extends GetView<AddressController> {
  const AddressSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(
        title: locale.value.search,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 22.sp,
            color: ColorHelper.headingColor,
          ),
          onPressed: () {
            controller.searchController.clear();
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CommanTextField(
                        controller: controller.searchController,
                        textFieldType: TextFieldType.OTHER,
                        autoFocus: true,
                        onChanged: (val) {
                          controller.addressSearchQuery.value = val;
                          controller.getAddressSuggestions(val);
                        },
                        decoration:
                            _inputDecoration(
                              hintText: locale.value.searchForAreaText,
                            ).copyWith(
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorHelper.hintColor,
                                size: 20.sp,
                              ),
                              fillColor: ColorHelper.offWhite,
                            ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: () {
                        controller.searchController.clear();
                        Get.back();
                      },
                      child: Text(
                        locale.value.cancelText,
                        style: TextStyleHelper.urMedium500().copyWith(
                          color: ColorHelper.black,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Visibility(
                  visible:
                      controller.searchResults.isEmpty &&
                      controller.searchController.text.isEmpty,
                  child: _searchResultItem(
                    imagePath: ImageHelper.icGps,
                    title: locale.value.useCurrentLocationText,
                    color: ColorHelper.primary,
                    iconColor: ColorHelper.primary,
                    isShownTrailingIcon: false,
                    onTap: () => controller.onUseCurrentLocationTap(),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Obx(() {
                  if (controller.searchResults.isEmpty &&
                      controller.searchController.text.isNotEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          locale.value.noResultsFoundText,
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.urBold700().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          locale.value.tryDifferentKeywordText,
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final suggestion = controller.searchResults[index];
                      return _searchResultItem(
                        title: suggestion.description ?? '',
                        onTap: () {
                          controller.onSuggestionSelected(
                            suggestion,
                            navigateToMap: true,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemCount: controller.searchResults.length,
                  );
                }),
              ),
            ],
          ),
          Obx(
            () => controller.isLocationLoading.value
                ? const AppLoader()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _searchResultItem({
    String? imagePath,
    required String title,
    String? subtitle,
    Color? color,
    Color? iconColor,
    required VoidCallback onTap,
    bool isShownTrailingIcon = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CachedImageView(
              imagePath: imagePath ?? ImageHelper.icLocation,
              size: 20.sp,
              color: iconColor ?? ColorHelper.iconColor,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                    color: color ?? ColorHelper.headingColor,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyleHelper.urRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.hintColor,
                    ),
                  ),
              ],
            ).expand(),

            if (isShownTrailingIcon) ...[
              SizedBox(width: 8.w),
              Icon(Icons.north_west, color: ColorHelper.iconColor, size: 18.sp),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyleHelper.urRegular400().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.hintColor,
      ),
      filled: true,
      fillColor: ColorHelper.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.primary),
      ),
    );
  }
}
