import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class PaymentInfoController extends GetxController {
  // Card Details
  final cardNumberController = TextEditingController();
  final nameOnCardController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  // Initial values for change tracking
  String initialCardNumber = '6011 1111 1111 4242';
  String initialNameOnCard = 'Akansha pandey';
  String initialExpiryDate = '12/25';
  String initialCvv = '867';

  final RxBool isCardChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initFields();
    _setupListeners();
  }

  void _initFields() {
    cardNumberController.text = initialCardNumber;
    nameOnCardController.text = initialNameOnCard;
    expiryDateController.text = initialExpiryDate;
    cvvController.text = initialCvv;
  }

  void _setupListeners() {
    cardNumberController.addListener(_checkChanges);
    nameOnCardController.addListener(_checkChanges);
    expiryDateController.addListener(_checkChanges);
    cvvController.addListener(_checkChanges);
  }

  void _checkChanges() {
    isCardChanged.value =
        cardNumberController.text != initialCardNumber ||
        nameOnCardController.text != initialNameOnCard ||
        expiryDateController.text != initialExpiryDate ||
        cvvController.text != initialCvv;
  }

  void onEditCard() {
    // Navigate to Edit Card screen
  }

  void onSaveCardChanges() {
    // Logic to save card changes
    Get.back();
  }

  void onRemoveCard() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImageView(
                    imagePath: ImageHelper.icMasterCard,
                    size: 42.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.value.removeCard,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          locale.value.removeCardConfirmation,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CommonBtn(
                    text: locale.value.cancel,
                    color: ColorHelper.transparent,
                    textColor: ColorHelper.subHeadingColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.borderColor),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    text: locale.value.confirm,
                    color: ColorHelper.primary,
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      Get.back(); // Navigate back from Edit Card screen
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((value) {
      Get.focusScope?.unfocus();
    });
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    nameOnCardController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}
