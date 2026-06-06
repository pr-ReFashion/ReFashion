import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';
import '../shimmer/personal_info_shimmer.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoView extends GetView<PersonalInfoController> {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(
        title: locale.value.personalInfo,
        leading: controller.isFromRegister.value
            ? const SizedBox.shrink()
            : null,
        actions: [
          if (controller.isFromRegister.value)
            AppTextBtn(
              onPressed: controller.onLogout,
              title: locale.value.logout,
              btnStyle: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              style: TextStyleHelper.urBold700().copyWith(
                color: ColorHelper.primary,
                fontSize: 14.sp,
              ),
            ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const PersonalInfoShimmer().paddingSymmetric(horizontal: 16.w);
        }
        if (controller.hasError.value) {
          return _buildErrorWidget();
        }
        return AbsorbPointer(
          absorbing: controller.isUpdating.value,
          child: AnimatedScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            children: [
              if (controller.isFromRegister.value) ...[
                _buildRegistrationBanner(),
                SizedBox(height: 24.h),
              ],
              _buildSectionTitle(locale.value.account),
              SizedBox(height: 24.h),
              _buildAccountFields(),
              SizedBox(height: 24.h),
              _buildSectionTitle(locale.value.sellerDetails),
              _buildSellerStatusInfo(),
              SizedBox(height: 24.h),
              _buildSellerFields(context),
              SizedBox(height: 30.h),
              _buildSubmitButton(),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRegistrationBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorHelper.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorHelper.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          Text(
            locale.value.almostThere,
            style: TextStyleHelper.urBold700().copyWith(
              color: ColorHelper.primary,
              fontSize: 18.sp,
            ),
          ),
          Text(
            locale.value.completeProfileDesc,
            style: TextStyleHelper.urRegular400().copyWith(
              color: ColorHelper.headingColor.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountFields() {
    return Column(
      spacing: 12.h,
      children: [
        CommanTextField(
          title: locale.value.firstNameText,
          controller: controller.firstNameController,
          textFieldType: TextFieldType.NAME,
          decoration: _inputDecoration(locale.value.firstNameText),
        ),
        CommanTextField(
          title: locale.value.lastNameText,
          controller: controller.lastNameController,
          textFieldType: TextFieldType.NAME,
          decoration: _inputDecoration(locale.value.lastNameText),
        ),
        _buildGenderSelection(),
        CommanTextField(
          title: locale.value.email,
          controller: controller.emailController,
          textFieldType: TextFieldType.EMAIL,
          readOnly: true,
          decoration: _inputDecoration(locale.value.email),
        ),
        CommanTextField(
          title: '${locale.value.bio} (${locale.value.optional})',
          controller: controller.bioController,
          textFieldType: TextFieldType.MULTILINE,
          maxLines: 5,
          decoration: _inputDecoration(locale.value.bio),
        ),
        CommanTextField(
          title: locale.value.locationText,
          controller: controller.locationController,
          textFieldType: TextFieldType.OTHER,
          decoration: _inputDecoration(locale.value.locationText),
        ),
        CommanTextField(
          title: locale.value.refashionId,
          controller: controller.refashionIdController,
          textFieldType: TextFieldType.OTHER,
          readOnly: true,
          decoration: _inputDecoration(
            locale.value.refashionId,
          ).copyWith(fillColor: ColorHelper.lightGrey.withValues(alpha: 0.4)),
        ),
        CommanTextField(
          title: locale.value.username,
          controller: controller.usernameController,
          textFieldType: TextFieldType.USERNAME,
          decoration: _inputDecoration(locale.value.username),
        ),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CommanTextField(
            title: locale.value.mobileNumberText,
            controller: controller.phoneController,
            textFieldType: TextFieldType.PHONE,
            validator: controller.validatePhone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration(locale.value.mobileNumberText),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerStatusInfo() {
    return Obx(() {
      if (!controller.isSellerInactive.value) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorHelper.amberGold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.amberGold),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: ColorHelper.amberGold, size: 20.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Text(
                    locale.value.sellerStatusPending,
                    style: TextStyleHelper.urBold700().copyWith(
                      color: ColorHelper.amberGold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    locale.value.sellerStatusPendingDesc,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.amberGold.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSellerFields(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.isSellerInactive.value) return const SizedBox.shrink();
          return Column(
            spacing: 12.h,
            children: [
              CommanTextField(
                title: locale.value.companyName,
                controller: controller.companyNameController,
                textFieldType: TextFieldType.NAME,
                decoration: _inputDecoration(locale.value.companyName),
              ),
              CommanTextField(
                title: locale.value.storeName,
                controller: controller.storeNameController,
                textFieldType: TextFieldType.NAME,
                decoration: _inputDecoration(locale.value.storeName),
              ),
              CommanTextField(
                title: locale.value.vatNumber,
                controller: controller.vatNumberController,
                textFieldType: TextFieldType.OTHER,
                decoration: _inputDecoration(locale.value.vatNumber),
              ),
              CommanTextField(
                title: locale.value.taxOffice,
                controller: controller.taxOfficeController,
                textFieldType: TextFieldType.NAME,
                decoration: _inputDecoration(locale.value.taxOffice),
              ),
              CommanTextField(
                title: locale.value.addressLine,
                controller: controller.addressLineController,
                textFieldType: TextFieldType.MULTILINE,
                decoration: _inputDecoration(locale.value.addressLine),
              ),
              CommanTextField(
                title: locale.value.city,
                controller: controller.cityController,
                textFieldType: TextFieldType.NAME,
                decoration: _inputDecoration(locale.value.city),
              ),
              CommanTextField(
                title: locale.value.postalCode,
                controller: controller.postalCodeController,
                textFieldType: TextFieldType.NUMBER,
                decoration: _inputDecoration(locale.value.postalCode),
              ),
              _buildCountryPicker(context),
              SizedBox(height: 12.h),
            ],
          );
        }),
        CommanTextField(
          title: locale.value.sellerEmail,
          controller: controller.sellerEmailController,
          textFieldType: TextFieldType.EMAIL,
          readOnly: true,
          decoration: _inputDecoration(
            locale.value.sellerEmail,
          ).copyWith(fillColor: ColorHelper.lightGrey.withValues(alpha: 0.4)),
        ),
      ],
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    return Obx(
      () => CustomDropdown<String>(
        label: locale.value.countryCode,
        hint: locale.value.selectCountry,
        items: controller.countryDropdownItems,
        value: controller.selectedCountryCode.value.isEmpty
            ? null
            : controller.selectedCountryCode.value,
        isLoading: controller.isRegionsLoading.value,
        activeLabelBgColor: ColorHelper.white,
        onChanged: (value) {
          if (value != null) {
            controller.selectedCountryCode.value = value;
          }
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => CommonBtn(
        text: controller.isFromRegister.value
            ? locale.value.joinReFashion
            : controller.isCreationMode.value
            ? locale.value.setupProfile
            : locale.value.updateProfile,
        enabled: controller.canSubmit,
        isLoading: controller.isUpdating.value,
        textColor: controller.canSubmit
            ? ColorHelper.white
            : ColorHelper.hintColor,
        disabledColor: ColorHelper.lightGrey,
        onTap: controller.onUpdateProfile,
        width: double.infinity,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: EmptyWidget(
        title: '',
        description: controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : 'We couldn\'t load your profile information. Please try again.',
        icon: ImageHelper.errorFound,
        btnText: locale.value.retryText,
        onTap: controller.fetchUserInfo,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: ColorHelper.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.primary),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.borderColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyleHelper.urSemiBold600().copyWith(
        fontSize: 18.sp,
        color: ColorHelper.headingColor,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Text(
          locale.value.gender,
          style: TextStyleHelper.urMedium500().copyWith(
            color: ColorHelper.headingColor,
            fontSize: 16.sp,
          ),
        ),
        Row(
          spacing: 12.w,
          children: [
            Expanded(child: _buildGenderRadio(locale.value.female, 'Female')),
            Expanded(child: _buildGenderRadio(locale.value.male, 'Male')),
            Expanded(child: _buildGenderRadio(locale.value.other, 'Other')),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderRadio(String label, String value) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.onGenderChange(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.w,
            children: [
              Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.selectedGender.value == value
                        ? ColorHelper.primary
                        : ColorHelper.iconColor,
                    width: 1.5.w,
                  ),
                ),
                child: controller.selectedGender.value == value
                    ? Center(
                        child: Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            color: ColorHelper.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              Text(
                label,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
