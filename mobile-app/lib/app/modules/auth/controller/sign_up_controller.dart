import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/service/auth_api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class SignUpController extends GetxController {
  final AuthApiService _authApiService = Get.find<AuthApiService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isAgree = false.obs;

  // Validation error messages
  RxString agreeError = ''.obs;

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  RxBool isButtonEnabled = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
    ever(isAgree, (_) => updateButtonState());
  }

  @override
  void onClose() {
    emailController.removeListener(updateButtonState);
    passwordController.removeListener(updateButtonState);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void updateButtonState() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

    // bool isNameValid = name.isNotEmpty && name.length >= 3;
    bool isEmailValid = email.isNotEmpty && emailRegex.hasMatch(email);
    bool isPasswordValid =
        password.isNotEmpty && passwordRegex.hasMatch(password);

    isButtonEnabled.value = isEmailValid && isPasswordValid;
  }

  String? validateEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (value.trim().isEmpty) {
      return locale.value.errorEmailRequired;
    } else if (!emailRegex.hasMatch(value.trim())) {
      return locale.value.errorEmailInvalid;
    }
    return null;
  }

  String? validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

    if (value.isEmpty) {
      return locale.value.errorPasswordRequired;
    } else if (!passwordRegex.hasMatch(value)) {
      return locale.value.errorPasswordInvalid;
    }
    return null;
  }

  // String? validateName(String value) {
  //   if (value.trim().isEmpty) {
  //     return locale.value.errorNameRequired;
  //   } else if (value.trim().length < 3) {
  //     return locale.value.errorNameTooShort;
  //   }
  //   return null;
  // }

  Future<void> onSignUpPressed() async {
    if (isLoading.value) return;
    Get.focusScope?.unfocus();

    agreeError.value = '';

    if (signUpFormKey.currentState!.validate()) {
      if (!isAgree.value) {
        agreeError.value = locale.value.errorTermsRequired;
        return;
      }

      isLoading.value = true;
      try {
        final email = emailController.text.trim().toLowerCase();
        final password = passwordController.text;

        // Run both registrations in parallel to save time and prevent timeout
        final responses = await Future.wait([
          _authApiService.register(email: email, password: password),
          _authApiService.sellerRegister(email: email, password: password),
        ]);

        final customerResponse = responses[0];
        final sellerResponse = responses[1];

        bool registrationSuccess = false;

        // Handle Customer Token
        if (customerResponse != null && customerResponse['token'] != null) {
          await HiveUtils.set(HiveKeys.authToken, customerResponse['token']);
          registrationSuccess = true;
        }

        // Handle Seller Token
        if (sellerResponse != null && sellerResponse['token'] != null) {
          await HiveUtils.set(HiveKeys.sellerToken, sellerResponse['token']);
          registrationSuccess = true;
        }

        if (registrationSuccess) {
          await HiveUtils.set(HiveKeys.userEmail, email);
          await HiveUtils.set(HiveKeys.userPassword, password);

          isLoading.value = false;
          Get.offAllNamed(
            Routes.personalInfo,
            arguments: {'fromRegister': true},
          );
        } else {
          toast(locale.value.toastRegistrationFailed);
        }
      } catch (e) {
        log("SignUp Error: $e");
        toast(e.toString());
      } finally {
        if (isLoading.value) {
          isLoading.value = false;
        }
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

  void onLogin() {
    Get.offAllNamed(Routes.logIn);
  }

  void openTermsAndConditions() {
    // TODO: Open terms and conditions
  }

  void onContinueWithGoogle() {
    // TODO: Implement Google Sign In
    Get.offAllNamed(Routes.dashboard);
  }

  void onContinueWithApple() {
    // TODO: Implement Apple Sign In
    Get.offAllNamed(Routes.dashboard);
  }
}
