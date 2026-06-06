import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class SplashController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = HiveUtils.isContainKey(HiveKeys.authToken);
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for 2 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if we are still on the splash route to avoid navigating if the user already clicked "Get Started"
    if (Get.currentRoute == Routes.splash) {
      if (isLoggedIn.value) {
        // If user is already logged in, check if profile is complete
        await _checkProfileAndNavigate();
      } else {
        // If not logged in, navigate to Walkthrough
        Get.offAllNamed(Routes.walkthrough);
      }
    }
  }

  Future<void> _checkProfileAndNavigate() async {
    try {
      final response = await _profileApiService.getCustomerInfo(isRetry: false);
      if (response.customer != null) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.offAllNamed(Routes.personalInfo, arguments: {'fromRegister': true});
      }
    } catch (e) {
      debugPrint("Splash Profile Check Error: $e");
      // If unauthorized or not found, it likely means the customer record hasn't been created yet

      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('401') ||
          e.toString().contains('not found') ||
          e.toString().contains('404') ||
          e.toString().contains('not_found')) {
        toast(locale.value.toastCompleteProfile);
        Get.offAllNamed(Routes.personalInfo, arguments: {'fromRegister': true});
      } else {
        // Network or Server Error -> check if we still have a token before deciding
        if (HiveUtils.isContainKey(HiveKeys.authToken)) {
          Get.offAllNamed(Routes.dashboard);
        } else {
          Get.offAllNamed(Routes.logIn);
        }
      }
    }
  }

  void getStartedOnTap() {
    Get.offAllNamed(Routes.walkthrough);
  }
}
