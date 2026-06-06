import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/achievement_history_controller.dart';

class AchievementHistoryView extends GetView<AchievementHistoryController> {
  const AchievementHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.achievements),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 10.h),
          Obx(() => _levelProgressCard()),

          SizedBox(height: 10.h),
          _badgesHeader(),
          SizedBox(height: 10.h),
          Obx(() => _badgesGrid()),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _badgesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          locale.value.yourBadges,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        IconButton(
          onPressed: controller.onInfoTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          icon: CachedImageView(imagePath: ImageHelper.icInfo, size: 24.sp),
        ),
      ],
    );
  }

  Widget _levelProgressCard() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${locale.value.levelText} ${controller.currentLevel.value}',
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              AppTextBtn(
                onPressed: controller.onLevelInfoTap,
                title: locale.value.seeHow,
                btnStyle: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                style: TextStyleHelper.dmSemiBold600().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          LinearProgressIndicator(
            value: controller.progressPercent.value,
            minHeight: 12.h,
            backgroundColor: ColorHelper.borderColor,
            borderRadius: BorderRadius.circular(64.r),
            valueColor: const AlwaysStoppedAnimation<Color>(
              ColorHelper.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            locale.value.toLevel(
              (controller.progressPercent.value * 100).toInt().toString(),
              controller.nextLevel.value.toString(),
            ),
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 10.sp,
              letterSpacing: 0.5,
              color: ColorHelper.subHeadingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _motivationBox(),
        ],
      ),
    );
  }

  Widget _motivationBox() {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: ColorHelper.offerNotificationBgGradient,
      ),
      child: Row(
        children: [
          CachedImageView(
            imagePath: ImageHelper.icRocket,
            height: 24.h,
            width: 24.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              locale.value.achievementMotivation,
              style: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.statsController.achievements.length,
      itemBuilder: (context, index) {
        final achievement = controller.statsController.achievements[index];
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedImageView(
                      imagePath: achievement.imageUrl,
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      achievement.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 16.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),

                    Text(
                      achievement.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.dmRegular400().copyWith(
                        fontSize: 12.sp,
                        height: 1.6,
                        color: ColorHelper.subHeadingColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (achievement.isLocked) ...[
                Container(
                  decoration: BoxDecoration(
                    color: ColorHelper.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: CachedImageView(
                      imagePath: ImageHelper.icLock,
                      height: 48.h,
                      width: 48.w,
                      color: ColorHelper.primaryLightColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
