import 'package:get/get.dart';

import '../controllers/selling_controller.dart';

class SellingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellingController>(
      () => SellingController(),
    );
  }
}
