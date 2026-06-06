import 'package:get/get.dart';
import '../controllers/paypal_controller.dart';

class PayPalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayPalController>(() => PayPalController());
  }
}
