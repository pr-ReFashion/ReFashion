import 'package:get/get.dart';
import 'package:refashion/app/modules/sell/controllers/sell_controller.dart';

class SellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellController>(() => SellController());
  }
}
