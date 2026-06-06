import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/chat/model/chat_message_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/chat_bubble.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildProductCard(),
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBar(
      titleWidget: Obx(() {
        final user = controller.chatUser.value;
        if (user == null) return const SizedBox();

        return Row(
          children: [
            _buildUserAvatar(user.profileImage, size: 40.sp),
            SizedBox(width: 12.w),
            _buildUserInfo(user.name, user.status),
          ],
        );
      }),
    );
  }

  Widget _buildUserAvatar(String imagePath, {required double size}) {
    return ClipOval(
      child: CachedImageView(
        imagePath: imagePath,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildUserInfo(String name, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyleHelper.urMedium500().copyWith(fontSize: 14.sp),
        ),
        Text(
          status,
          style: TextStyleHelper.dmRegular400().copyWith(
            fontSize: 12.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard() {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: const BoxDecoration(color: ColorHelper.lightGrey),
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedImageView(
                  imagePath: product.image,
                  height: 80.r,
                  width: 80.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(child: _buildProductDetails(product)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProductDetails(ChatProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        Text(
          product.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyleHelper.urRegular400().copyWith(
            fontSize: 12.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${locale.value.soldByText} StyleCast',
          style: TextStyleHelper.urRegular400().copyWith(
            fontSize: 10.sp,
            color: ColorHelper.hintColor,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              product.price.toString().toPrice(),
              style: TextStyleHelper.urBold700().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              product.rftPrice,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      if (controller.messages.isEmpty) return const SizedBox();

      // Group messages by date
      final groupedMessages = controller.messages.groupBy(
        (m) => DateTime.parse(m.createdAt).toLocal().yymmdd(),
      );

      final dates = groupedMessages.keys.toList()
        ..sort((a, b) => a.compareTo(b));

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: dates.length,
        reverse: true,
        itemBuilder: (context, index) {
          final date = dates[dates.length - 1 - index];
          final messages = groupedMessages[date]!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateHeader(date),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.h);
                },
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageItem(message);
                },
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildMessageItem(ChatMessageModel message) {
    final isSender = message.senderId == controller.myUserId;

    return Row(
      mainAxisAlignment: isSender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender) ...[_buildAvatar(), SizedBox(width: 8.w)],
        ChatBubble(message: message, isSender: isSender),
        if (isSender) ...[SizedBox(width: 8.w), _buildAvatar()],
      ],
    );
  }

  Widget _buildAvatar() {
    return Obx(() {
      final user = controller.chatUser.value;
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedImageView(
            imagePath: user?.profileImage ?? '',
            height: 24.r,
            width: 24.r,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  Widget _buildDateHeader(String createdAt) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorHelper.lightGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _getDateLabel(createdAt),
        style: TextStyleHelper.urMedium500().copyWith(
          fontSize: 12.sp,
          color: ColorHelper.subHeadingColor,
        ),
      ),
    );
  }

  String _getDateLabel(String createdAt) {
    final date = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return locale.value.todayText;
    } else if (messageDate == yesterday) {
      return locale.value.yesterdayText;
    } else {
      return date.dMy();
    }
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Row(
        children: [
          Expanded(
            child: CommanTextField(
              controller: controller.messageController,
              textFieldType: TextFieldType.OTHER,
              decoration: InputDecoration(
                fillColor: ColorHelper.white,
                hintText: locale.value.writeMessageHint,
                border: InputBorder.none,
                suffixIcon: _buildAttachmentButton(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return IconButton(
      onPressed: () {},
      icon: CachedImageView(
        imagePath: ImageHelper.icAttachment,
        height: 18.r,
        width: 18.r,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: controller.sendMessage,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: const BoxDecoration(
          color: ColorHelper.white,
          shape: BoxShape.circle,
        ),
        child: CachedImageView(
          imagePath: ImageHelper.icSend,
          height: 18.r,
          width: 18.r,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
