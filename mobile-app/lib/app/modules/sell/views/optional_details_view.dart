import 'dart:io';
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
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/widget/custom_switch.dart';

class OptionalDetailsView extends GetView<AddItemController> {
  const OptionalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.optionalDetails),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _buildVintageSection(),
            SizedBox(height: 16.h),
            _buildPurchaseInfoSection(),
            SizedBox(height: 16.h),
            _buildPackagingSection(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Sticky bottom button with validation
  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.onOptionalDetailsSaveTap,
          text: locale.value.saveAndContinue,
          enabled: controller.isOptionalDetailsValid.value,
          disabledColor: ColorHelper.lightGrey,
        ),
      ),
    );
  }

  /// Section Header Helper
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyleHelper.urMedium500().copyWith(
        fontSize: 18.sp,
        color: ColorHelper.headingColor,
      ),
    );
  }

  /// Vintage Status Section
  Widget _buildVintageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(locale.value.vintage),
        SizedBox(height: 12.h),
        InkWell(
          onTap: controller.onToggleVintageTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.value.thisIsAVintageItem,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                Obx(
                  () => CustomSwitch(
                    value: controller.isVintage.value,
                    activeColor: ColorHelper.primary,
                    onChanged: controller.onVintageChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          locale.value.over15YearsOld,
          style: TextStyleHelper.urRegular400().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.error.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  /// Purchase Details Section
  Widget _buildPurchaseInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(locale.value.purchaseInfo),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommanTextField(
                controller: controller.placeOfPurchaseController,
                textFieldType: TextFieldType.NAME,
                title: locale.value.placeOfPurchase,
                decoration: _inputDecoration(
                  hintText: locale.value.placeOfPurchaseHint,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CommanTextField(
                      controller: controller.yearOfPurchaseController,
                      textFieldType: TextFieldType.NUMBER,
                      title: locale.value.year,
                      decoration: _inputDecoration(
                        hintText: locale.value.yearHint,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Obx(
                      () => CommanTextField(
                        controller: controller.purchasePriceController,
                        textFieldType: TextFieldType.NUMBER,
                        title: locale.value.price,
                        decoration: _inputDecoration(
                          hintText: locale.value.purchasePriceHint(
                            CurrencyController.to.selectedCurrency.symbolText,
                          ),
                          prefixText: controller.purchasePrice.value.isNotEmpty
                              ? '${CurrencyController.to.selectedCurrency.symbolText} '
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildReceiptUploadArea(),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  locale.value.privacyInfo,
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.error.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Receipt Upload Widget
  Widget _buildReceiptUploadArea() {
    return InkWell(
      onTap: controller.pickReceipt,
      child: DottedBorderWidget(
        color: ColorHelper.lightGrey,
        gap: 4,
        radius: 8.r,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Obx(() {
            final path = controller.receiptPath.value;
            if (path == null) return _buildUploadPlaceholder();
            return _buildFilePreview(path);
          }),
        ),
      ),
    );
  }

  /// Placeholder for upload area
  Widget _buildUploadPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: const BoxDecoration(
            color: ColorHelper.offWhite,
            shape: BoxShape.circle,
          ),
          child: CachedImageView(
            imagePath: ImageHelper.icFileSend,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.value.uploadReceiptInvoice,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
            Text(
              locale.value.uploadReceiptDesc,
              style: TextStyleHelper.urRegular400().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.subHeadingColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// File preview widget (Image or PDF)
  Widget _buildFilePreview(String path) {
    final isPdf = path.toLowerCase().endsWith('.pdf');
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: isPdf
              ? Column(
                  children: [
                    CachedImageView(
                      imagePath: ImageHelper.icFileSend,
                      size: 40.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      path.split('/').last,
                      style: TextStyleHelper.urRegular400().copyWith(
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).paddingSymmetric(horizontal: 16.w),
                  ],
                )
              : Image.file(File(path), height: 60.h),
        ),
        SizedBox(height: 8.h),
        Text(
          locale.value.changeReceipt,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.primary,
          ),
        ),
      ],
    );
  }

  /// Packaging Options Section
  Widget _buildPackagingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(locale.value.packaging),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCheckboxTile(
                title: locale.value.cardOfCertificate,
                obsValue: controller.hasCertificate,
                onTap: controller.onToggleCertificateTap,
              ),
              _buildCheckboxTile(
                title: locale.value.dustBag,
                obsValue: controller.hasDustBag,
                onTap: controller.onToggleDustBagTap,
              ),
              _buildCheckboxTile(
                title: locale.value.originalBox,
                obsValue: controller.hasOriginalBox,
                onTap: controller.onToggleOriginalBoxTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Custom Checkbox Tile
  Widget _buildCheckboxTile({
    required String title,
    required RxBool obsValue,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          children: [
            Obx(
              () => Container(
                width: 18.sp,
                height: 18.sp,
                decoration: BoxDecoration(
                  color: obsValue.value
                      ? ColorHelper.primary
                      : ColorHelper.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: obsValue.value
                        ? ColorHelper.primary
                        : ColorHelper.borderColor,
                  ),
                ),
                child: obsValue.value
                    ? Icon(Icons.check, color: ColorHelper.white, size: 14.sp)
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input Decoration Helper
  InputDecoration _inputDecoration({
    required String hintText,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      prefixStyle: TextStyleHelper.urMedium500().copyWith(
        fontSize: 14.sp,
        color: ColorHelper.headingColor,
      ),

      filled: true,
      fillColor: ColorHelper.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
