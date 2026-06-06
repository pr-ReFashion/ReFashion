import 'package:get/get.dart';
import 'package:refashion/app/modules/auth/controller/login_controller.dart';
import 'package:refashion/app/modules/auth/controller/sign_up_controller.dart';
import 'package:refashion/app/modules/auth/controller/sign_in_option_controller.dart';
import 'package:refashion/app/modules/auth/controller/forget_password_controller.dart';
import 'package:refashion/app/modules/auth/service/auth_api_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthApiService>(AuthApiService());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
    Get.lazyPut<SignInOptionController>(() => SignInOptionController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
  }
}
