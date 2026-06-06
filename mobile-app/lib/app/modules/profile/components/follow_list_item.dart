import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../model/follower_model.dart';

class FollowListItem extends StatelessWidget {
  final FollowerModel user;
  final VoidCallback onFollowTap;

  const FollowListItem({
    super.key,
    required this.user,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipOval(
            child: CachedImageView(
              imagePath: user.image,
              height: 50.r,
              width: 50.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                Text(
                  user.username,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => CommonBtn(
              height: 36.h,
              width: 90.w,
              padding: EdgeInsets.zero,
              onTap: onFollowTap,
              color: user.isFollowing.value
                  ? ColorHelper.lightGrey
                  : ColorHelper.primary,
              textColor: user.isFollowing.value
                  ? ColorHelper.subHeadingColor
                  : ColorHelper.white,
              text: user.isFollowing.value
                  ? locale.value.following
                  : locale.value.followText,
            ),
          ),
        ],
      ),
    );
  }
}
