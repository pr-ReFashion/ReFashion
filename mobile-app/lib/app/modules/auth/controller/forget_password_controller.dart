import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/modules/auth/service/auth_api_service.dart';

class ForgetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> createPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final RxBool isFormValid = false.obs;
  final RxBool isSendEmailLoading = false.obs;

  final AuthApiService _authApiService = Get.find<AuthApiService>();

  // Create Password Logic
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool isCreatePasswordFormValid = false.obs;
  final RxBool isSubmitLoading = false.obs;

  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateForm);
    tokenController.addListener(_validateCreatePasswordForm);
    newPasswordController.addListener(_validateCreatePasswordForm);
    confirmPasswordController.addListener(_validateCreatePasswordForm);
  }

  void _validateForm() {
    isFormValid.value = _emailRegex.hasMatch(emailController.text.trim());
  }

  void _validateCreatePasswordForm() {
    isCreatePasswordFormValid.value =
        tokenController.text.trim().isNotEmpty &&
        _passwordRegex.hasMatch(newPasswordController.text) &&
        newPasswordController.text == confirmPasswordController.text &&
        newPasswordController.text.isNotEmpty;
  }

  @override
  void onClose() {
    emailController.removeListener(_validateForm);
    tokenController.removeListener(_validateCreatePasswordForm);
    newPasswordController.removeListener(_validateCreatePasswordForm);
    confirmPasswordController.removeListener(_validateCreatePasswordForm);
    emailController.dispose();
    tokenController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
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

  String? validateToken(String? value) {
    if (value == null || value.trim().isEmpty) {
      return locale.value.errorTokenRequired;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.errorPasswordRequired;
    }
    if (value != newPasswordController.text) {
      return locale.value.errorPasswordsDoNotMatch;
    }
    return null;
  }

  void onSendEmail() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isSendEmailLoading.value = true;

        await _authApiService.resetPassword(
          identifier: emailController.text.trim(),
        );

        isSendEmailLoading.value = false;

        tokenController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.toNamed(Routes.createPassword);
      } catch (e) {
        isSendEmailLoading.value = false;
        toast(e.toString());
      }
    }
  }

  void onSubmitTap() async {
    if (createPasswordFormKey.currentState?.validate() ?? false) {
      try {
        isSubmitLoading.value = true;

        final response = await _authApiService.updatePassword(
          email: emailController.text.trim(),
          password: newPasswordController.text,
          token: tokenController.text.trim(),
        );

        isSubmitLoading.value = false;

        if (response != null && response['success'] == true) {
          toast(locale.value.toastPasswordUpdatedSuccessfully);
          Get.offAllNamed(Routes.logIn);
        } else {
          toast(response?['message'] ?? locale.value.errorUnknown);
        }
      } catch (e) {
        isSubmitLoading.value = false;
        toast(e.toString());
      }
    }
  }
}
