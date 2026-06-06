import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/modules/bag/controllers/bag_controller.dart';
import 'package:refashion/app/services/cart_controller.dart';
import 'package:refashion/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:refashion/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/modules/profile/controllers/profile_controller.dart';
import 'package:refashion/app/modules/sell/controllers/sell_controller.dart';
import 'package:refashion/app/modules/stats/controllers/stats_controller.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/network/api_service.dart';
import '../model/profile_settings_model.dart';

class ProfileSettingsController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final isDeleting = false.obs;

  List<ProfileSettingsModel> accountItems = [];
  List<ProfileSettingsModel> othersItems = [];
  List<ProfileSettingsModel> helpItems = [];

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    accountItems = [
      ProfileSettingsModel(
        title: locale.value.personalInfo,
        icon: ImageHelper.icProfile,
        onTap: () => Get.toNamed(Routes.personalInfo),
      ),
      ProfileSettingsModel(
        title: locale.value.addressesText,
        icon: ImageHelper.icAddress,
        onTap: () => Get.toNamed(Routes.address),
      ),

      // ProfileSettingsModel(
      //   title: locale.value.paymentInfo,
      //   icon: ImageHelper.icPayment,
      //   onTap: () => Get.toNamed(Routes.paymentInfo),
      // ),
    ];

    othersItems = [
      // ProfileSettingsModel(
      //   title: locale.value.notificationText,
      //   icon: ImageHelper.icNotification,
      //   onTap: () => Get.toNamed(Routes.notificationSettings),
      // ),
      ProfileSettingsModel(
        title: locale.value.ragionAndCurrency,
        icon: ImageHelper.icLanguage,
        onTap: () => Get.toNamed(Routes.languageAndCurrency),
      ),

      // ProfileSettingsModel(
      //   title: locale.value.privacy,
      //   icon: ImageHelper.icPrivacy,
      //   onTap: () => Get.toNamed(Routes.privacy),
      // ),
    ];

    helpItems = [
      ProfileSettingsModel(
        title: locale.value.help,
        icon: ImageHelper.icInfo,
        onTap: () => Get.toNamed(Routes.helpCenter),
      ),
    ];

    // manageItems = [
    //   ProfileSettingsModel(
    //     title: locale.value.deleteAccount,
    //     icon: ImageHelper.icTrash,
    //     onTap: () => Get.toNamed(Routes.deleteAccount),
    //   ),
    // ];
  }

  void onLogoutTap() {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.value.logout,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    locale.value.logoutConfirmation,
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
                    text: locale.value.no,
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
                    text: locale.value.yes,
                    color: ColorHelper.primary,
                    textColor: ColorHelper.white,
                    onTap: () async {
                      // Clear all local data
                      await HiveUtils.clear();

                      // Reset global state
                      if (Get.isRegistered<CartController>()) {
                        CartController.to.clearCartCount();
                      }

                      toast(locale.value.loggedOutSuccessfully);

                      // Selective deletion of dashboard-related controllers
                      Get.delete<HomeController>();
                      Get.delete<FavoriteController>();
                      Get.delete<BagController>();
                      Get.delete<SellController>();
                      Get.delete<StatsController>();
                      Get.delete<ProfileController>();
                      Get.delete<DashboardController>();

                      // Navigate to SignInOption and clear stack
                      Get.offAllNamed(Routes.signInOption);
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
    );
  }

  void onDeleteAccountTap() {
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
                    onTap: _confirmDeleteAccount,
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

  Future<void> _confirmDeleteAccount() async {
    try {
      isDeleting.value = true;
      Get.back(); // Close bottom sheet

      // 1. Get current customer info to get the actual backend ID
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
      isDeleting.value = false;
    }
  }
}
