import 'package:get/get.dart';
import '../controllers/impact_history_controller.dart';

class ImpactHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImpactHistoryController>(() => ImpactHistoryController());
  }
}
