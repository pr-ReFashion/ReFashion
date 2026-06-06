import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/chat_bubble.dart';

import '../controllers/support_chat_controller.dart';

class SupportChatView extends GetView<SupportChatController> {
  const SupportChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBar(title: locale.value.chatWithUs);
  }

  Widget _buildMessageList() {
    return Obx(() {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isSender = message.senderId == controller.myUserId;
          return Column(
            children: [
              ChatBubble(
                message: message,
                isSender: isSender,
                color: ColorHelper.primaryLightColor,
              ),
              SizedBox(height: 8.h),
            ],
          );
        },
      );
    });
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: TextStyleHelper.urRegular400().copyWith(
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: locale.value.writeMessageHint,
                        hintStyle: TextStyleHelper.urRegular400().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.hintColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: CachedImageView(
                      imagePath: ImageHelper.icAttachment,
                      size: 20.sp,
                      color: ColorHelper.greyScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(
                color: ColorHelper.white,
                shape: BoxShape.circle,
              ),
              child: CachedImageView(
                imagePath: ImageHelper.icSend,
                size: 20.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
