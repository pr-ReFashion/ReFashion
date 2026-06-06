import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/favorite/views/favorite_view.dart';
import 'package:refashion/app/modules/home/views/home_view.dart';
import 'package:refashion/app/modules/profile/views/profile_view.dart';
import 'package:refashion/app/modules/sell/views/sell_view.dart';
import 'package:refashion/app/modules/stats/views/stats_view.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/string_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/stylish_bottom_bar/src/bottom_bar.dart';
import 'package:refashion/app/widget/stylish_bottom_bar/src/model/bar_items.dart';
import 'package:refashion/app/widget/stylish_bottom_bar/src/model/options.dart';
import 'package:refashion/app/widget/stylish_bottom_bar/src/utils/enums.dart';
import 'package:refashion/app/services/wishlist_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          return IndexedStack(
            index: controller.currentIndex.value,
            children: [
              const HomeView(),
              controller.visitedIndices.contains(1)
                  ? const FavoriteView()
                  : const SizedBox.shrink(),
              controller.visitedIndices.contains(2)
                  ? const SellView()
                  : const SizedBox.shrink(),
              controller.visitedIndices.contains(3)
                  ? const StatsView()
                  : const SizedBox.shrink(),
              controller.visitedIndices.contains(4)
                  ? const ProfileView()
                  : const SizedBox.shrink(),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        return StylishBottomBar(
          elevation: 0,
          backgroundColor: ColorHelper.white,
          option: AnimatedBarOptions(padding: EdgeInsets.only(top: 6.h)),
          fabSize: 54.0.sp,
          items: [
            BottomBarItem(
              icon: CachedImageView(imagePath: ImageHelper.icHome, size: 24.sp),
              selectedIcon: CachedImageView(
                imagePath: ImageHelper.icHomeFill,
                size: 24.sp,
                color: ColorHelper.primary,
              ),
              selectedColor: ColorHelper.primary,
              unSelectedColor: ColorHelper.iconColor,
              title: Text(
                locale.value.homeText,
                style: TextStyle(
                  fontFamily: StringHelper.urbanistFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            BottomBarItem(
              icon: CachedImageView(
                imagePath: ImageHelper.icHeart,
                size: 24.sp,
              ),
              selectedIcon: CachedImageView(
                imagePath: ImageHelper.icHeartFill,
                size: 24.sp,
                color: ColorHelper.primary,
              ),
              selectedColor: ColorHelper.primary,
              unSelectedColor: ColorHelper.iconColor,
              title: Text(
                locale.value.favoriteText,
                style: TextStyle(
                  fontFamily: StringHelper.urbanistFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              showBadge: WishlistController.to.wishlistedIds.isNotEmpty,
              badgeColor: ColorHelper.error,
              badge: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  WishlistController.to.wishlistedIds.length > 99
                      ? '99+'
                      : WishlistController.to.wishlistedIds.length.toString(),
                  style: TextStyle(
                    color: ColorHelper.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Sell item (index 2) - This becomes the FAB when fabLocation is center
            BottomBarItem(
              icon: Container(
                width: 54.0.w,
                height: 54.0.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorHelper.primary,
                ),
                child: Container(
                  width: 54.0.w,
                  height: 54.0.h,
                  margin: EdgeInsets.all(3.0.sp),
                  decoration: const BoxDecoration(
                    color: ColorHelper.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: ColorHelper.primary,
                    size: 28.0.sp,
                  ),
                ),
              ),
              selectedIcon: Container(
                margin: EdgeInsets.all(3.0.sp),
                decoration: const BoxDecoration(
                  color: ColorHelper.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: ColorHelper.white, size: 28.0.sp),
              ),
              selectedColor: ColorHelper.primary,
              unSelectedColor: ColorHelper.iconColor,
              backgroundColor: ColorHelper.primary,
              title: const SizedBox.shrink(),
            ),
            BottomBarItem(
              icon: CachedImageView(
                imagePath: ImageHelper.icStats,
                size: 24.sp,
              ),
              selectedIcon: CachedImageView(
                imagePath: ImageHelper.icStatsFill,
                size: 24.sp,
                color: ColorHelper.primary,
              ),
              selectedColor: ColorHelper.primary,
              unSelectedColor: ColorHelper.iconColor,
              title: Text(
                locale.value.statsText,
                style: TextStyle(
                  fontFamily: StringHelper.urbanistFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            BottomBarItem(
              icon: CachedImageView(
                imagePath: ImageHelper.icProfile,
                size: 24.sp,
              ),
              selectedIcon: CachedImageView(
                imagePath: ImageHelper.icProfileFill,
                size: 24.sp,
                color: ColorHelper.primary,
              ),
              selectedColor: ColorHelper.primary,
              unSelectedColor: ColorHelper.iconColor,
              title: Text(
                locale.value.profileText,
                style: TextStyle(
                  fontFamily: StringHelper.urbanistFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          currentIndex: controller.currentIndex.value,
          notchStyle: NotchStyle.convex,
          fabLabelColor: ColorHelper.iconColor,
          onTap: controller.changeIndex,
        );
      }),
    );
  }
}
