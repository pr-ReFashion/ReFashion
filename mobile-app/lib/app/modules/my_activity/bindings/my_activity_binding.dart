import 'package:get/get.dart';

import '../controllers/my_activity_controller.dart';

class MyActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityController>(
      () => MyActivityController(),
    );
  }
}
