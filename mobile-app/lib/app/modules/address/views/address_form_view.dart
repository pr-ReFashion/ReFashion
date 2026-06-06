import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';

import '../controllers/address_controller.dart';

class AddressFormView extends GetView<AddressController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.addressFormText),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ).copyWith(bottom: 16.h),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(locale.value.contactText),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.addressNameController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.addressNameText,
                decoration: _inputDecoration(
                  hintText: locale.value.addressNameHintText,
                ),
                isValidationRequired: false,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.firstNameController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.firstNameText,
                decoration: _inputDecoration(
                  hintText: locale.value.firstNameText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
                isValidationRequired: true,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.lastNameController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.lastNameText,
                decoration: _inputDecoration(
                  hintText: locale.value.lastNameText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
                isValidationRequired: true,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.companyController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.companyText,
                isValidationRequired: false,
                decoration: _inputDecoration(
                  hintText: locale.value.companyText,
                ),
              ),
              SizedBox(height: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: Text(
                      //     locale.value.phoneCodeText,
                      //     style: TextStyleHelper.urMedium500().copyWith(
                      //       fontSize: 16.sp,
                      //       color: ColorHelper.headingColor,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(width: 12.w),
                      Expanded(
                        // flex: 3,
                        child: Text(
                          locale.value.mobileNumberText,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: Obx(() {
                      //     final country = controller.selectedPhoneCode.value;
                      //     return GestureDetector(
                      //       onTap: () => controller.onPhoneCodeTap(context),
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 16.w),
                      //         decoration: BoxDecoration(
                      //           color: ColorHelper.transparent,
                      //           borderRadius: BorderRadius.circular(8.r),
                      //           border: Border.all(
                      //             color: ColorHelper.borderColor,
                      //           ),
                      //         ),
                      //         alignment: Alignment.centerLeft,
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               "+${country.phoneCode}",
                      //               style: TextStyleHelper.urMedium500()
                      //                   .copyWith(
                      //                     color: ColorHelper.subHeadingColor,
                      //                     fontSize: 14.sp,
                      //                   ),
                      //             ),
                      //             const Spacer(),
                      //             Icon(
                      //               Icons.keyboard_arrow_down,
                      //               size: 20.0.sp,
                      //               color: ColorHelper.iconColor,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   }),
                      // ),
                      // SizedBox(width: 12.w),
                      Expanded(
                        // flex: 3,
                        child: CommanTextField(
                          controller: controller.mobileController,
                          textFieldType: TextFieldType.PHONE,
                          decoration: _inputDecoration(
                            hintText: locale.value.mobileNumberText,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return locale.value.errorFieldRequired;
                            }
                            if (!controller.phoneRegex.hasMatch(value)) {
                              return locale.value.invalidPhoneNumber;
                            }
                            return null;
                          },
                          isValidationRequired: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _sectionTitle(locale.value.addressLocationText),
              SizedBox(height: 12.h),
              _dropdownField(
                title: locale.value.countryNameText,
                value: controller.selectedAddressCountry,
                options: controller.countries,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.addressFormController,
                textFieldType: TextFieldType.OTHER,
                title: locale.value.addressText,
                decoration: _inputDecoration(hintText: '12 Ermou Street'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.cityController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.cityText,
                decoration: _inputDecoration(hintText: 'Athina, Greece'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
                isValidationRequired: true,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.provinceController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.provinceText,
                decoration: _inputDecoration(
                  hintText: locale.value.provinceText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
                isValidationRequired: true,
              ),
              SizedBox(height: 12.h),
              CommanTextField(
                controller: controller.postcodeController,
                textFieldType: TextFieldType.PHONE,
                title: locale.value.postcodeText,
                decoration: _inputDecoration(hintText: '90210'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.errorFieldRequired;
                  }
                  return null;
                },
                isValidationRequired: true,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => CommonBtn(
                  onTap: controller.onUpdateAddress,
                  isLoading: controller.isActionLoading.value,
                  text: controller.isEditing.value
                      ? locale.value.updateAddressText
                      : locale.value.addAddressText,
                  width: double.infinity,
                  textColor:
                      (controller.isEditing.value
                          ? (controller.isChanged.value &&
                                controller.isFormValid.value)
                          : controller.isFormValid.value)
                      ? ColorHelper.white
                      : ColorHelper.subHeadingColor,
                  disabledColor: ColorHelper.lightGrey,
                  enabled: controller.isEditing.value
                      ? (controller.isChanged.value &&
                            controller.isFormValid.value)
                      : controller.isFormValid.value,
                ),
              ),
            ],
          ),
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

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyleHelper.urRegular400().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.hintColor,
      ),
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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

  Widget _dropdownField({
    required String title,
    required RxString value,
    required List<String> options,
  }) {
    return Obx(
      () => CustomDropdown<String>(
        label: title,
        value: value.value,
        items: options
            .map(
              (e) => DropdownItem(
                value: e,
                label:
                    '${(controller.countryCodeMap[e] ?? '').toFlagEmoji()}  $e',
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) value.value = val;
        },
      ),
    );
  }
}
