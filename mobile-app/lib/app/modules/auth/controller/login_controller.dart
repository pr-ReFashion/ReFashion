import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/service/auth_api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';

class LoginController extends GetxController {
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final ProfileApiService _profileApiService = ProfileApiService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isFormValid = false.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value =
        _emailRegex.hasMatch(emailController.text.trim()) &&
        _passwordRegex.hasMatch(passwordController.text);
  }

  @override
  void onClose() {
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void onForgotPasswordPressed() {
    Get.toNamed(Routes.forgotPassword);
  }

  Future<void> onLogin() async {
    if (isLoading.value) return;

    Get.focusScope?.unfocus();

    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        final email = emailController.text.trim();
        final password = passwordController.text;

        // Run both logins in parallel for faster response
        final responses = await Future.wait([
          _authApiService.login(email: email, password: password),
          _authApiService.sellerLogin(email: email, password: password),
        ]);

        final customerResponse = responses[0];
        final sellerResponse = responses[1];

        bool loginSuccess = false;

        // Handle Customer Token
        if (customerResponse != null && customerResponse['token'] != null) {
          await HiveUtils.set(HiveKeys.authToken, customerResponse['token']);
          loginSuccess = true;
        }

        // Handle Seller Token
        if (sellerResponse != null && sellerResponse['token'] != null) {
          await HiveUtils.set(HiveKeys.sellerToken, sellerResponse['token']);
          loginSuccess = true;
        }

        if (loginSuccess) {
          await HiveUtils.set(HiveKeys.userEmail, email);
          await HiveUtils.set(HiveKeys.userPassword, password);

          // Check if profile is complete
          await _checkProfileAndNavigate();

          isLoading.value = false;
        } else {
          toast(locale.value.toastInvalidEmailOrPassword);
        }
      } catch (e) {
        log("Login Error: $e");
        toast(e.toString());
      } finally {
        if (isLoading.value) {
          isLoading.value = false;
        }
      }
    }
  }

  Future<void> _checkProfileAndNavigate() async {
    try {
      final response = await _profileApiService.getCustomerInfo();
      if (response.customer != null) {
        Get.offAllNamed(Routes.dashboard);
        toast(locale.value.toastLoginSuccess);
      } else {
        Get.offAllNamed(Routes.personalInfo, arguments: {'fromRegister': true});
      }
    } catch (e) {
      log("Profile Check Error: $e");
      // If unauthorized or not found, it likely means the customer record hasn't been created yet
      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('401') ||
          e.toString().contains('not found') ||
          e.toString().contains('404') ||
          e.toString().contains('not_found')) {
        toast(locale.value.toastCompleteProfile);
        Get.offAllNamed(Routes.personalInfo, arguments: {'fromRegister': true});
      } else {
        // Show user friendly message instead of a generic fallback to dashboard
        toast(locale.value.errorProfileFetch);
      }
    }
  }

  // Map<String, dynamic> _decodeJwt(String token) {
  //   try {
  //     final parts = token.split('.');
  //     if (parts.length != 3) {
  //       throw Exception('Invalid token');
  //     }
  //     final payload = parts[1];
  //     String normalizedSource = base64Url.normalize(payload);
  //     final String decoded = utf8.decode(base64Url.decode(normalizedSource));
  //     return json.decode(decoded);
  //   } catch (e) {
  //     log("JWT Decode Error: $e");
  //     return {};
  //   }
  // }

  void onContinueWithGoogle() {
    // TODO: Implement Google Sign In
    Get.offAllNamed(Routes.dashboard);
  }

  void onContinueWithApple() {
    // TODO: Implement Apple Sign In
    Get.offAllNamed(Routes.dashboard);
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return locale.value.errorEmailRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return locale.value.errorEmailInvalid;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.errorPasswordRequired;
    }
    if (!_passwordRegex.hasMatch(value)) {
      return locale.value.errorPasswordInvalid;
    }
    return null;
  }

  void signUpOnTap() {
    Get.offAllNamed(Routes.signUp);
  }
}
