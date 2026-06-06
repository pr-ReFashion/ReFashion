import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/sell/controllers/add_item_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class ProductPriceView extends GetView<AddItemController> {
  const ProductPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.priceViewTitle),
      bottomNavigationBar: _buildButtonWidget(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.value.priceViewDesc,
              style: TextStyleHelper.urRegular400().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Obx(
                  () => Text(
                    CurrencyController.to.selectedCurrency.name ?? '',
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CommanTextField(
                    controller: controller.euroPriceController,
                    textFieldType: TextFieldType.NUMBER,
                    textAlign: TextAlign.center,
                    decoration: _inputDecoration(hintText: '0.00'),
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  locale.value.rft,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(
                    () => Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelper.lightGrey,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: ColorHelper.borderColor),
                      ),
                      child: Text(
                        controller.rftValue.value,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.onPriceNextTap,
          text: locale.value.next,
          textColor: controller.isPriceEmpty.value
              ? ColorHelper.hintColor
              : ColorHelper.white,
          disabledColor: ColorHelper.lightGrey,
          enabled: !controller.isPriceEmpty.value,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,

      filled: true,
      fillColor: ColorHelper.white,
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
}
