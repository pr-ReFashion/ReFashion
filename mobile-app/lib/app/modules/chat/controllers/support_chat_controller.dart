import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/chat/model/chat_message_model.dart';

class SupportChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final messages = <ChatMessageModel>[].obs;
  final String myUserId = 'user_123';
  final String assistantId = 'assistant_bot';

  @override
  void onInit() {
    super.onInit();
    // Clear and add initial assistant message
    messages.add(
      ChatMessageModel(
        message: locale.value.virtualAssistantWelcome,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        senderId: assistantId,
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      final text = messageController.text.trim();
      messages.add(
        ChatMessageModel(
          message: text,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          senderId: myUserId,
        ),
      );
      messageController.clear();

      // Auto-scroll logic is usually handled in the view with a ScrollController
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
