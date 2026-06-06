import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/utills/extension.dart';

import '../controllers/address_controller.dart';

class AddAddressView extends GetView<AddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.addressFormText),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ).copyWith(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(locale.value.addressLocationText),
            SizedBox(height: 12.h),
            _countryPickerField(context),
            SizedBox(height: 12.h),
            /* _sectionTitle(locale.value.addressText),
            SizedBox(height: 4.h),
            CommanTextField(
              controller: controller.searchController,
              textFieldType: TextFieldType.OTHER,
              readOnly: true,
              onTap: () => controller.onAddressSearchTap(),
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
            SizedBox(height: 12.h), */
            InkWell(
              onTap: () => controller.onEnterLocationManually(),
              child: Text(
                locale.value.enterLocationManuallyText,
                style: TextStyleHelper.urBold700().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyleHelper.urSemiBold600().copyWith(
        fontSize: 18.sp,
        color: ColorHelper.headingColor,
      ),
    );
  }

  Widget _countryPickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.countryNameText,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 4.h),
        Obx(
          () => InkWell(
            onTap: () => controller.showCountryPickerSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: ColorHelper.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(controller.countryCodeMap[controller.selectedAddressCountry.value] ?? '').toFlagEmoji()}  ${controller.selectedAddressCountry.value}',
                    style: TextStyleHelper.urRegular400().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorHelper.iconColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyleHelper.urRegular400().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.hintColor,
      ),
      filled: true,
      fillColor: ColorHelper.transparent,
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
  } */
}
