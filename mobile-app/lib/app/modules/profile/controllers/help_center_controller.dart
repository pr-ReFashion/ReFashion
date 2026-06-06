import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenterController extends GetxController {
  final searchController = TextEditingController();
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onChatTap() {
    // Navigate to chat or open support chat
    Get.back();
  }

  void onTopicTap(String topic) {
    // Handle topic selection
    debugPrint('Topic tapped: $topic');
  }
}
