import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'stats_controller.dart';

class AchievementHistoryController extends GetxController {
  final statsController = Get.find<StatsController>();

  final currentLevel = 1.obs;
  final nextLevel = 2.obs;
  final progressPercent = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _calculateLevel();

    // Listen to changes in achievements and recalculate level
    ever(statsController.achievements, (_) => _calculateLevel());
  }

  void _calculateLevel() {
    final unlockedCount = statsController.achievements
        .where((a) => !a.isLocked)
        .length;

    if (unlockedCount <= 1) {
      currentLevel.value = 1;
      nextLevel.value = 2;
      progressPercent.value = unlockedCount / 2; // 0–1
    } else if (unlockedCount <= 3) {
      currentLevel.value = 2;
      nextLevel.value = 3;
      progressPercent.value = (unlockedCount - 1) / 2; // 2–3
    } else if (unlockedCount <= 6) {
      currentLevel.value = 3;
      nextLevel.value = 4;
      progressPercent.value = (unlockedCount - 3) / 3; // 4–6
    } else if (unlockedCount <= 9) {
      currentLevel.value = 4;
      nextLevel.value = 5;
      progressPercent.value = (unlockedCount - 6) / 3; // 7–9
    } else {
      currentLevel.value = 5;
      nextLevel.value = 5;
      progressPercent.value = 1.0; // max
    }
  }

  final levels = <Level>[
    Level(
      id: 1,
      title: locale.value.newcomer,
      description: locale.value.newcomerDesc,
      icon: ImageHelper.icLevelOne,
      range: '0-1',
    ),
    Level(
      id: 2,
      title: locale.value.gettingStarted,
      description: locale.value.gettingStartedDesc,
      icon: ImageHelper.icLevelTwo,
      range: '2-3',
    ),
    Level(
      id: 3,
      title: locale.value.consciousContributor,
      description: locale.value.consciousContributorDesc,
      icon: ImageHelper.icLevelThree,
      range: '4-6',
    ),
    Level(
      id: 4,
      title: locale.value.impactMaker,
      description: locale.value.impactMakerDesc,
      icon: ImageHelper.icLevelFour,
      range: '7-9',
    ),
    Level(
      id: 5,
      title: locale.value.refashionChampion,
      description: locale.value.refashionChampionDesc,
      icon: ImageHelper.icLevelFive,
      range: '10',
    ),
  ];

  final badges = <Badge>[
    Badge(
      title: locale.value.firstSale,
      description: locale.value.firstSaleDesc,
      icon: ImageHelper.icFirstSale,
    ),
    Badge(
      title: locale.value.firstPurchase,
      description: locale.value.firstPurchaseDesc,
      icon: ImageHelper.icEcoWarrior,
    ),
    Badge(
      title: locale.value.consistentSeller,
      description: locale.value.consistentSellerDesc,
      icon: ImageHelper.icFirstSale,
    ),
    Badge(
      title: locale.value.superSeller,
      description: locale.value.superSellerDesc,
      icon: ImageHelper.icEcoWarrior,
    ),
    Badge(
      title: locale.value.superBuyer,
      description: locale.value.superBuyerDesc,
      icon: ImageHelper.icFirstSale,
    ),
    Badge(
      title: locale.value.vintageAmbassador,
      description: locale.value.vintageAmbassadorDesc,
      icon: ImageHelper.icEcoWarrior,
    ),
    Badge(
      title: locale.value.personalImpact,
      description: locale.value.personalImpactDesc,
      icon: ImageHelper.icFirstSale,
    ),
    Badge(
      title: locale.value.oneOfAKind,
      description: locale.value.oneOfAKindDesc,
      icon: ImageHelper.icEcoWarrior,
    ),
    Badge(
      title: locale.value.quickShipper,
      description: locale.value.quickShipperDesc,
      icon: ImageHelper.icFirstSale,
    ),
    Badge(
      title: locale.value.refashionStar,
      description: locale.value.refashionStarDesc,
      icon: ImageHelper.icEcoWarrior,
    ),
  ];

  void onBackTap() {
    Get.back();
  }

  void onInfoTap() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: ColorHelper.warmSoftDiagonal,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.reFashionBadges,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 20.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        color: ColorHelper.headingColor,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16.w, right: 6.w),
                SizedBox(height: 8.h),
                AspectRatio(
                  aspectRatio: 356 / 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      ImageHelper.badgeBanner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 10.h),
                _badgeItem(badges),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badgeItem(List<Badge> badges) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.h,
            width: 48.w,
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(
              color: ColorHelper.peach,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CachedImageView(
              imagePath: badges[index].icon,
              height: 48.h,
              width: 48.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badges[index].title,
                  style: TextStyleHelper.urSemiBold600().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  badges[index].description,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemCount: badges.length,
    );
  }

  void onLevelInfoTap() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            gradient: ColorHelper.warmSoftDiagonal,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.levelUpTips,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 20.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        color: ColorHelper.headingColor,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16.w, right: 6.w),
                SizedBox(height: 8.h),
                AspectRatio(
                  aspectRatio: 356 / 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      ImageHelper.levelUpBanner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 10.h),
                _levelItem(levels),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _levelItem(List<Level> levels) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedImageView(
                imagePath: levels[index].icon,
                height: 30.h,
                width: 30.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${locale.value.levelText} ${levels[index].id}',
                      style: TextStyleHelper.urBold700().copyWith(
                        fontSize: 16.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Container(
                        height: 20.h,
                        width: 1.w,
                        color: ColorHelper.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        levels[index].title,
                        style: TextStyleHelper.urRegular400().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            levels[index].description,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
              height: 1.4,
            ),
          ),
        ],
      ),
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemCount: levels.length,
    );
  }
}

class Level {
  final int id;
  final String title;
  final String description;
  final String icon;
  final String range;

  Level({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.range,
  });
}

class Badge {
  final String title;
  final String description;
  final String icon;

  Badge({required this.title, required this.description, required this.icon});
}
