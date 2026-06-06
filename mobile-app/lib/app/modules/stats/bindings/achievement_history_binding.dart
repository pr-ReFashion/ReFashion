import 'package:get/get.dart';
import '../controllers/achievement_history_controller.dart';

class AchievementHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AchievementHistoryController>(
      () => AchievementHistoryController(),
    );
  }
}
