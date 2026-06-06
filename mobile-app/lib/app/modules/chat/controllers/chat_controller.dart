import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/chat/model/chat_message_model.dart';
import 'package:refashion/app/modules/my_activity/models/my_activity_models.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();

  final chatUser = Rxn<ChatUser>();
  final product = Rxn<ChatProduct>();
  final messages = <ChatMessageModel>[].obs;

  final String myUserId = '1';

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is UserProfileModel) {
      final user = Get.arguments as UserProfileModel;
      chatUser.value = ChatUser(
        name: user.username,
        status: locale.value.activeTodayText,
        profileImage: user.profileImage,
      );
    } else {
      // Default dummy data
      chatUser.value = ChatUser(
        name: 'greatgemsn',
        status: locale.value.activeTodayText,
        profileImage:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
      );
    }

    product.value = ChatProduct(
      name: 'Exotic',
      description: 'Textured Structured Handheld Bag...',
      price: '280',
      rftPrice: '2800 RFT',
      image:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=1935&auto=format&fit=crop',
    );

    messages.assignAll([
      ChatMessageModel(
        message: 'This offer still available?',
        createdAt: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day - 1,
          DateTime.now().hour,
          DateTime.now().minute,
        ).toUtc().subtract(const Duration(minutes: 13)).toIso8601String(),
        senderId: myUserId,
      ),
      ChatMessageModel(
        message:
            'Hi, I\'m interested in buying this T-shirt. Is it still available?',
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        senderId: '2', // other user
      ),
    ]);
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add(
        ChatMessageModel(
          message: messageController.text.trim(),
          createdAt: DateTime.now().toUtc().toIso8601String(),
          senderId: myUserId,
        ),
      );
      messageController.clear();
    }
  }
}

class ChatUser {
  final String name;
  final String status;
  final String profileImage;

  ChatUser({
    required this.name,
    required this.status,
    required this.profileImage,
  });
}

class ChatProduct {
  final String name;
  final String description;
  final String price;
  final String rftPrice;
  final String image;

  ChatProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.rftPrice,
    required this.image,
  });
}

class ChatMessage {
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({required this.text, required this.time, required this.isMe});
}
