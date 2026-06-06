import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<int> visitedIndices = [0].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      currentIndex.value = Get.arguments as int;
      if (!visitedIndices.contains(currentIndex.value)) {
        visitedIndices.add(currentIndex.value);
      }
    }
  }

  void changeIndex(int index) {
    HapticFeedback.lightImpact();
    currentIndex.value = index;
    if (!visitedIndices.contains(index)) {
      visitedIndices.add(index);
    }
  }
}
