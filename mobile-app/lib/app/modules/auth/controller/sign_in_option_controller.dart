import 'package:get/get.dart';
import 'package:refashion/app/routes/app_pages.dart';

class SignInOptionController extends GetxController {
  void onContinueWithGoogle() {
    Get.toNamed(Routes.dashboard);
  }

  void onContinueWithApple() {
    // TODO: Implement Apple Sign In
    Get.toNamed(Routes.dashboard);
  }

  void onCreateAccount() {
    Get.toNamed(Routes.signUp);
  }

  void onLogin() {
    Get.toNamed(Routes.logIn);
  }

  void onTermsOfService() {
    // TODO: Navigate to Terms of Service
  }

  void onPrivacyPolicy() {
    // TODO: Navigate to Privacy Policy
  }
}
