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
import '../controllers/payment_info_controller.dart';

class EditCardView extends GetView<PaymentInfoController> {
  const EditCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.editCard),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          Text(
            locale.value.creditCardDetails,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          CommanTextField(
            title: locale.value.cardNumber,
            controller: controller.cardNumberController,
            textFieldType: TextFieldType.NAME, // For credit card formatting
            decoration: _inputDecoration(locale.value.cardNumber),
          ),
          SizedBox(height: 12.h),
          CommanTextField(
            title: locale.value.nameOnCard,
            controller: controller.nameOnCardController,
            textFieldType: TextFieldType.NAME,
            decoration: _inputDecoration(locale.value.nameOnCard),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommanTextField(
                  title: locale.value.validThru,
                  controller: controller.expiryDateController,
                  textFieldType: TextFieldType.NAME,
                  decoration: _inputDecoration(locale.value.mmYyHint),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CommanTextField(
                  title: locale.value.cvv,
                  controller: controller.cvvController,
                  textFieldType: TextFieldType.NUMBER,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: _inputDecoration(locale.value.cvv),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: CommonBtn(
                  text: locale.value.removeCard,
                  color: ColorHelper.transparent,
                  textColor: ColorHelper.subHeadingColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(color: ColorHelper.borderColor),
                  ),
                  onTap: controller.onRemoveCard,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => CommonBtn(
                    text: locale.value.saveChanges,
                    enabled: controller.isCardChanged.value,
                    onTap: controller.onSaveCardChanges,
                    disabledColor: ColorHelper.lightGrey,
                    textColor: controller.isCardChanged.value
                        ? ColorHelper.white
                        : ColorHelper.hintColor,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
}
