import 'package:get/get.dart';
import '../../address/controllers/address_controller.dart';
import '../controllers/add_item_controller.dart';

class AddItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddItemController>(() => AddItemController());
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
