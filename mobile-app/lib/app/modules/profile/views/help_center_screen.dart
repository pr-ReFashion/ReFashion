import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/help_center_controller.dart';

class HelpCenterScreen extends GetView<HelpCenterController> {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.helpCenter),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          _buildHeading(),
          SizedBox(height: 12.h),
          _buildSearchField(),
          SizedBox(height: 12.h),
          _buildPopularTopics(),
          SizedBox(height: 24.h),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          locale.value.reFashionHelp,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          locale.value.whatCanWeHelpYouWith,
          style: TextStyleHelper.urRegular400().copyWith(
            fontSize: 12.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return CommanTextField(
      controller: controller.searchController,
      textFieldType: TextFieldType.NAME,
      decoration: InputDecoration(
        hintText: locale.value.seachHere,
        prefixIcon: Padding(
          padding: EdgeInsets.all(18.sp),
          child: CachedImageView(
            imagePath: ImageHelper.icSearch,
            size: 18.sp,
            color: ColorHelper.iconColor,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorHelper.primary),
        ),
      ),
    );
  }

  Widget _buildPopularTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.popularTopics,
          style: TextStyleHelper.urBold700().copyWith(
            fontSize: 20.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            children: [
              _buildTopicItem(
                locale.value.buyingInReFashion,
                () => controller.onTopicTap('Buying'),
                isFirst: true,
              ),
              const Divider(color: ColorHelper.borderColor, height: 1),
              _buildTopicItem(
                locale.value.sellingInReFashion,
                () => controller.onTopicTap('Selling'),
              ),
              const Divider(color: ColorHelper.borderColor, height: 1),
              _buildTopicItem(
                locale.value.reFashionTokensHelp,
                () => controller.onTopicTap('Tokens'),
              ),
              const Divider(color: ColorHelper.borderColor, height: 1),
              _buildTopicItem(
                locale.value.reFashionAchievements,
                () => controller.onTopicTap('Achievements'),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicItem(
    String title,
    VoidCallback onTap, {
    bool isLast = false,
    bool isFirst = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? BorderRadius.vertical(bottom: Radius.circular(8.r))
          : isFirst
          ? BorderRadius.vertical(top: Radius.circular(8.r))
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: ColorHelper.iconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return CommonBtn(
      color: ColorHelper.success,
      onTap: controller.onChatTap,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedImageView(
            imagePath: ImageHelper.icChat,
            size: 22.sp,
            color: ColorHelper.white,
          ),
          SizedBox(width: 10.w),
          Text(
            locale.value.chatText,
            style: TextStyleHelper.urSemiBold600().copyWith(
              color: ColorHelper.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
