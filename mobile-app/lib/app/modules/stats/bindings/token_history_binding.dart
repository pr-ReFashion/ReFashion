import 'package:get/get.dart';
import '../controllers/token_history_controller.dart';

class TokenHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenHistoryController>(() => TokenHistoryController());
  }
}
