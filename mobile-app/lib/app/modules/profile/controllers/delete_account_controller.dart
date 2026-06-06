import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class DeleteAccountController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final RxInt selectedReasonIndex = 0.obs;
  final isLoading = false.obs;

  List<String> reasons = [
    'I don’t use ReFashion anymore',
    'I want to open a new account',
    'My items aren’t selling',
    'I had an issue with a transaction',
    'I don’t agree with ReFashion’s policies',
    'I don’t agree with ReFashion’s fees',
    'My reason isn’t listed',
  ];

  void onReasonChanged(int index) {
    selectedReasonIndex.value = index;
  }

  Future<void> confirmDelete() async {
    try {
      isLoading.value = true;
      Get.back(); // Close bottom sheet

      // 1. Get current customer info to get the actual backend ID (cus_xxx)
      final response = await _profileApiService.getCustomerInfo();
      final customerId = response.customer?.id;

      if (customerId == null) {
        throw "Could not find customer ID";
      }

      // 2. Call the force-delete API
      await _profileApiService.deleteAccount(customerId);

      // 3. Logout and navigate away
      await ApiService().logout(forceLogout: true);

      toast(locale.value.toastAccountDeleted);
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onDeleteTap() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.value.deleteAccount,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    locale.value.deleteAccountConfirmation,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.subHeadingColor,
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
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    text: locale.value.confirm,
                    color: ColorHelper.primary,
                    onTap: confirmDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
