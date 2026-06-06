import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/my_activity/models/my_activity_models.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

import '../controllers/my_activity_controller.dart';

class MyActivityView extends GetView<MyActivityController> {
  const MyActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        final profile = controller.userProfile.value;
        return AnimatedScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _buildHeader(profile),
            SizedBox(height: 4.h),
            _buildBio(profile),
            SizedBox(height: 8.h),
            _buildActionButtons(),
            SizedBox(height: 24.h),
            _buildProductGrid(),
            SizedBox(height: 20.h),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBar(
      titleWidget: Obx(
        () => Text(
          controller.userProfile.value.username,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 20.sp,
            color: ColorHelper.headingColor,
          ),
        ),
      ),
      actions: [
        BagBadgeWidget(onTap: controller.onBagTap),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildHeader(UserProfileModel profile) {
    return Row(
      children: [
        SizedBox(width: 16.w),
        ClipOval(
          child: CachedImageView(
            imagePath: profile.profileImage,
            size: 74.sp,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox.shrink(),
              _buildStatItem(
                profile.followersCount,
                locale.value.followers,
                onTap: controller.onFollowersTap,
              ),
              Container(
                height: 54.h,
                width: 1.w,
                color: ColorHelper.borderColor,
              ),
              _buildStatItem(
                profile.followingCount,
                locale.value.following,
                onTap: controller.onFollowingTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyleHelper.urBold700().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyleHelper.urRegular400().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(UserProfileModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: profile.bio
          .map<Widget>(
            (text) => Text(
              text,
              style: TextStyleHelper.urRegular400().copyWith(
                fontSize: 14.sp,
                height: 1.4,
                color: ColorHelper.headingColor,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Expanded(
        //   child: CommonBtn(
        //     onTap: controller.onMessageTap,
        //     text: locale.value.messageText,
        //     padding: EdgeInsets.symmetric(vertical: 8.h),
        //     color: ColorHelper.transparent,
        //     textColor: ColorHelper.subHeadingColor,
        //     shapeBorder: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.r),
        //       side: const BorderSide(color: ColorHelper.subHeadingColor),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 12.w),
        Expanded(
          child: Obx(
            () => CommonBtn(
              onTap: controller.onFollowTap,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              text: controller.isFollowing.value
                  ? locale.value.following
                  : locale.value.followText,
              color: controller.isFollowing.value
                  ? ColorHelper.lightGrey
                  : ColorHelper.primary,
              textColor: controller.isFollowing.value
                  ? ColorHelper.subHeadingColor
                  : ColorHelper.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.w,
          mainAxisSpacing: 6.h,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ColorHelper.lightGrey.withValues(alpha: 0.4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedImageView(
                imagePath: product.thumbnail ?? '',
                fit: BoxFit.cover,
                errorHeight: 50.h,
                errorWidth: 50.w,
              ),
            ),
          );
        },
      ),
    );
  }
}
