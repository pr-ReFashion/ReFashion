import 'package:get/get.dart';
import 'package:refashion/app/modules/splash/controllers/walkthrough_controller.dart';

class WalkthroughBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WalkthroughController>(WalkthroughController());
  }
}
