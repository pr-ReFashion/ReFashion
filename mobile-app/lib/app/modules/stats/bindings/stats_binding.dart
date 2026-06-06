import 'package:get/get.dart';

import 'package:refashion/app/modules/stats/controllers/stats_controller.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatsController>(
      () => StatsController(),
    );
  }
}
