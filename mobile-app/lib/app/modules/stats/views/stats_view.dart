import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';
import 'package:refashion/app/modules/stats/controllers/stats_controller.dart';
import 'package:refashion/app/modules/stats/shimmer/stats_shimmer.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: ColorHelper.white,
        color: ColorHelper.primary,
        child: AnimatedScrollView(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          physics: const AlwaysScrollableScrollPhysics(),

          children: [
            SizedBox(height: 10.h),
            /* ViewAllWidget(
              title: locale.value.myTokens,
              viewAllTitle: locale.value.viewText,
              viewAllOnTap: controller.onViewTokensTap,
            ),
            SizedBox(height: 12.h),
            _myTokensCard(),
            SizedBox(height: 24.h),
            ViewAllWidget(
              title: locale.value.myImpact,
              viewAllTitle: locale.value.viewText,
              // viewAllOnTap: controller.onViewImpactTap,
            ),
            SizedBox(height: 12.h),
            */
            Obx(
              () => controller.isImpactLoading.value
                  ? const StatsShimmer()
                  : _myImpactCard(),
            ),
            /*  SizedBox(height: 24.h),
            ViewAllWidget(
              title: locale.value.myAchievements,
              viewAllTitle: locale.value.viewText,
              // viewAllOnTap: controller.onViewAchievementsTap,
            ),
            SizedBox(height: 12.h),
            _myAchievementsList(),
            SizedBox(height: 120.h), // Spacing for bottom bar and notch
            */
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CommonAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 6.w,
      titleWidget: Row(
        children: [
          /* Badge.count(
            count: 3,
            backgroundColor: ColorHelper.error,
            textStyle: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.white,
              fontSize: 10.sp,
            ),
            offset: const Offset(-2, -2),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onPressed: controller.onNotificationTap,
              icon: CachedImageView(
                imagePath: ImageHelper.icNotification,
                height: 24.sp,
                width: 24.sp,
              ),
            ),
          ), */
          SizedBox(width: 8.w),
          Text(
            locale.value.statsText,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
      actions: [
        BagBadgeWidget(onTap: controller.onBagTap),
        SizedBox(width: 8.w),
      ],
    );
  }

  /* Widget _myTokensCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 364 / 130,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                ImageHelper.tokenBanner,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorHelper.primaryLightColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icWallet,
                  height: 20.sp,
                  width: 20.sp,
                  color: ColorHelper.greyScale,
                ),
                SizedBox(width: 8.w),
                Text(
                  locale.value.myTokens,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Text(
                    '${controller.tokens.value} ${locale.value.rft}',
                    style: TextStyleHelper.urBold700().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _myImpactCard() {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _impactGridItem(
                  iconData: ImageHelper.icReward,
                  color: ColorHelper.amberGold.withValues(alpha: 0.1),
                  valueText: '${controller.totalRewards.value}',
                  labelText: locale.value.totalRewards,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _impactGridItem(
                  iconData: ImageHelper.icCo2,
                  color: ColorHelper.deepPurple.withValues(alpha: 0.1),
                  valueText: '${controller.co2Saved.value} Kg',
                  labelText: locale.value.co2Saved,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _impactGridItem(
                  iconData: ImageHelper.icWater,
                  color: ColorHelper.primary.withValues(alpha: 0.1),
                  valueText: '${controller.waterSaved.value} lt',
                  labelText: locale.value.waterSaved,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _impactGridItem(
                  iconData: ImageHelper.icBin,
                  color: ColorHelper.subHeadingColor.withValues(alpha: 0.1),
                  valueText: '${controller.landfillReduced.value} Kg',
                  labelText: locale.value.landfillReduced,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _impactGridItem({
    required String iconData,
    required Color color,
    Color? iconColor,
    required String valueText,
    required String labelText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: CachedImageView(
              imagePath: iconData,
              height: 28.sp,
              width: 28.sp,
              color: iconColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            valueText,
            style: TextStyleHelper.urBold700().copyWith(
              fontSize: 16.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            labelText.replaceAll(' ', '\n'),
            textAlign: TextAlign.center,
            style: TextStyleHelper.urRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
        ],
      ),
    );
  }

  /* Widget _myImpactCardOriginal() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(
            () => _impactItem(
              iconData: ImageHelper.icCo2,
              color: ColorHelper.deepPurple.withValues(alpha: 0.1),
              valueText: '${controller.co2Saved.value} Kg',
              labelText: locale.value.co2Saved,
            ),
          ),
          Obx(
            () => _impactItem(
              iconData: ImageHelper.icWater,
              color: ColorHelper.primary.withValues(alpha: 0.1),
              valueText: '${controller.waterSaved.value} lt',
              labelText: locale.value.waterSaved,
            ),
          ),
          Obx(
            () => _impactItem(
              iconData: ImageHelper.icBin,
              color: ColorHelper.subHeadingColor.withValues(alpha: 0.1),
              valueText: '${controller.landfillReduced.value} Kg',
              labelText: locale.value.landfillReduced,
            ),
          ),
        ],
      ),
    );
  }

  Widget _impactItem({
    required String iconData,
    required Color color,
    Color? iconColor,
    required String valueText,
    required String labelText,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: CachedImageView(
            imagePath: iconData,
            height: 24.sp,
            width: 24.sp,
            color: iconColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          valueText,
          style: TextStyleHelper.dmSemiBold600().copyWith(
            fontSize: 12.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
        Text(
          labelText.replaceAll(' ', '\n'),
          textAlign: TextAlign.center,
          style: TextStyleHelper.urRegular400().copyWith(
            fontSize: 12.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
      ],
    );
  } */

  /* Widget _myAchievementsList() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          controller.achievements.length > 4
              ? 4
              : controller.achievements.length,
          (index) {
            final achievement = controller.achievements[index];
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == 3 ? 0 : 8.w),
                decoration: BoxDecoration(
                  color: ColorHelper.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: CachedImageView(
                        imagePath: achievement.imageUrl,
                        height: 60.sp,
                        width: 60.sp,
                      ),
                    ),
                    if (achievement.isLocked)
                      Container(
                        height: 80.h,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: ColorHelper.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: CachedImageView(
                            imagePath: ImageHelper.icLock,
                            height: 24.sp,
                            width: 24.sp,
                            color: ColorHelper.primaryLightColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }*/
}
