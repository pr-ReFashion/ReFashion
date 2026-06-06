import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import '../controllers/profile_settings_controller.dart';
import '../model/profile_settings_model.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.profileSettings),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          _buildSection(locale.value.account, controller.accountItems),
          SizedBox(height: 24.h),
          _buildSection(locale.value.others, controller.othersItems),
          SizedBox(height: 24.h),
          _buildSection(locale.value.help, controller.helpItems),
          SizedBox(height: 24.h),
          // _buildSection(locale.value.manage, controller.manageItems),
          // SizedBox(height: 24.h),
          CommonBtn(
            text: locale.value.logout,
            color: ColorHelper.error,
            onTap: controller.onLogoutTap,
            width: double.infinity,
          ),
          SizedBox(height: 16.h),
          Center(
            child: InkWell(
              onTap: controller.onDeleteAccountTap,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16.sp,
                      color: ColorHelper.subHeadingColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      locale.value.deleteAccount,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 13.sp,
                        color: ColorHelper.subHeadingColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<ProfileSettingsModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(color: ColorHelper.borderColor, height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSettingsItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(ProfileSettingsModel item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: ColorHelper.lightGrey,
                shape: BoxShape.circle,
              ),
              child: CachedImageView(
                imagePath: item.icon,
                size: 18.sp,
                color: ColorHelper.iconColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                item.title,
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
}
