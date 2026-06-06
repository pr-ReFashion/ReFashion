import 'package:get/get.dart';

class PrivacyController extends GetxController {
  final RxBool isAllowSearchEnabled = false.obs;
  final RxBool isAllowMessagesEnabled = false.obs;

  void toggleAllowSearch(bool value) => isAllowSearchEnabled.value = value;
  void toggleAllowMessages(bool value) => isAllowMessagesEnabled.value = value;

  void enableAll() {
    isAllowSearchEnabled.value = true;
    isAllowMessagesEnabled.value = true;
  }
}
