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

import 'package:refashion/app/modules/profile/controllers/profile_controller.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';
import '../shimmer/profile_shimmer.dart';
import '../shimmer/product_grid_shimmer.dart';
import 'package:refashion/app/constant/empty_widget.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appBar(),
      body: Obx(
        () => controller.isLoading.value
            ? const ProfileShimmer()
            : RefreshIndicator(
                onRefresh: controller.onRefresh,
                backgroundColor: ColorHelper.white,
                color: ColorHelper.primary,
                child: AnimatedScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 8.h),
                    _buildProfileCard(),
                    SizedBox(height: 12.h),
                    _buildActivityIcons(),
                    SizedBox(height: 12.h),
                    _buildProductGrid(),
                    SizedBox(height: 66.h),
                  ],
                ),
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
            locale.value.myProfile,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
      actions: [
        // IconButton(
        //   onPressed: controller.onChatTap,
        //   padding: EdgeInsets.zero,
        //   visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        //   constraints: const BoxConstraints(),
        //   icon: CachedImageView(
        //     imagePath: ImageHelper.icChat,
        //     height: 24.sp,
        //     width: 24.sp,
        //   ),
        // ),
        // SizedBox(width: 6.w),
        BagBadgeWidget(onTap: controller.onBagTap),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50.r,
                  width: 50.r,
                  padding: controller.profileImage.value.isEmpty
                      ? EdgeInsets.all(8.r)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorHelper.lightGrey.withValues(alpha: 0.4),
                  ),
                  child: ClipOval(
                    child: CachedImageView(
                      imagePath: controller.profileImage.value.isEmpty
                          ? ImageHelper.icProfile
                          : controller.profileImage.value,
                      size: 50.sp,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : (controller.firstName.value.isNotEmpty ||
                                  controller.lastName.value.isNotEmpty)
                            ? "${controller.firstName.value} ${controller.lastName.value}"
                                  .trim()
                            : "...",
                        style: TextStyleHelper.urBold700().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      Text(
                        controller.userId.value.isNotEmpty
                            ? controller.userId.value
                            : "...",
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.onSettingTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  icon: CachedImageView(
                    imagePath: ImageHelper.icSetting,
                    size: 24.sp,
                    color: ColorHelper.greyScale,
                  ),
                ),
              ],
            ),
            if (controller.bio.value.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                controller.bio.value,
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                  height: 1.5,
                ),
              ),
            ],
            // SizedBox(height: 12.h),
            // Container(
            //   decoration: BoxDecoration(
            //     color: ColorHelper.offWhite,
            //     borderRadius: BorderRadius.circular(8.r),
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: _buildCountItem(
            //           controller.followersCount.value.toString(),
            //           locale.value.followers,
            //           onTap: controller.onFollowersTap,
            //         ),
            //       ),
            //       Container(
            //         width: 1.w,
            //         height: 58.h,
            //         color: ColorHelper.borderColor,
            //       ),
            //       Expanded(
            //         child: _buildCountItem(
            //           controller.followingCount.value.toString(),
            //           locale.value.following,
            //           onTap: controller.onFollowingTap,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCountItem(String count, String label, {VoidCallback? onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           count,
  //           style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp),
  //         ),
  //         Text(
  //           label,
  //           style: TextStyleHelper.urRegular400().copyWith(fontSize: 14.sp),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActivityTabs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _buildTabItem(
                  locale.value.buyingActivity,
                  controller.selectedTab.value == 0,
                  () => controller.changeTab(0),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => _buildTabItem(
                  locale.value.sellingActivity,
                  controller.selectedTab.value == 1,
                  () => controller.changeTab(1),
                ),
              ),
            ),
          ],
        ),
        Container(height: 1.h, color: ColorHelper.dividerColor),
      ],
    );
  }

  Widget _buildTabItem(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              title,
              style: TextStyleHelper.urBold700().copyWith(
                fontSize: 14.sp,
                color: isSelected
                    ? ColorHelper.primary
                    : ColorHelper.subHeadingColor,
              ),
            ),
          ),
          if (isSelected)
            Container(height: 2.h, color: ColorHelper.primary)
          else
            SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildActivityIcons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActivityTabs(),
          SizedBox(height: 16.h),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.selectedTab.value == 0
                  ? [
                      _buildActionButton(
                        locale.value.purchased,
                        ImageHelper.icPurchased,
                        ColorHelper.vividPurple.withValues(alpha: 0.1),
                        ColorHelper.vividPurple,
                        onTap: controller.onPurchasedTap,
                      ),
                      _buildActionButton(
                        locale.value.received,
                        ImageHelper.icReceived,
                        ColorHelper.teal.withValues(alpha: 0.1),
                        ColorHelper.teal,
                        onTap: controller.onReceivedTap,
                      ),
                      _buildActionButton(
                        locale.value.returned,
                        ImageHelper.icReturned,
                        ColorHelper.coolGray.withValues(alpha: 0.1),
                        ColorHelper.coolGray,
                        onTap: controller.onReturnedTap,
                      ),
                    ]
                  : [
                      _buildActionButton(
                        locale.value.soldText,
                        ImageHelper.icTag,
                        ColorHelper.primary.withValues(alpha: 0.1),
                        ColorHelper.primary,
                        badgeCount: controller.soldCount.value,
                        onTap: controller.onSoldTap,
                      ),
                      _buildActionButton(
                        locale.value.shippedText,
                        ImageHelper.icShipped,
                        ColorHelper.royalBlue.withValues(alpha: 0.1),
                        ColorHelper.royalBlue,
                        badgeCount: controller.shippedCount.value,
                        onTap: controller.onShippedTap,
                      ),
                      _buildActionButton(
                        locale.value.cancelledText,
                        ImageHelper.icCancelled,
                        ColorHelper.coolGray.withValues(alpha: 0.1),
                        ColorHelper.coolGray,
                        badgeCount: controller.cancelledCount.value,
                        onTap: controller.onCancelledTap,
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    String icon,
    Color bgColor,
    Color iconColor, {
    int? badgeCount,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Badge(
                isLabelVisible: (badgeCount ?? 0) > 0,
                backgroundColor: ColorHelper.error,
                textStyle: TextStyleHelper.dmRegular400().copyWith(
                  color: ColorHelper.white,
                  fontSize: 10.sp,
                ),
                label: Text(badgeCount.toString()),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CachedImageView(
                    imagePath: icon,
                    size: 24.sp,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          locale.value.myProducts,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => controller.isProductLoading.value
              ? const ProductGridShimmer()
              : controller.myProducts.isEmpty
              ? SizedBox(
                  height: 300.h,
                  child: EmptyWidget(
                    title: locale.value.youHavntAddedAnythingToSellYet,
                    description: locale.value.supportSustainableFashion,
                    icon: ImageHelper.noDataFound,
                    height: 100.sp,
                    width: 100.sp,
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.myProducts.length,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 4.h,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.myProducts[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        controller.onProductTap(product);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: ColorHelper.borderColor,
                          ),
                          child: CachedImageView(
                            imagePath: product.thumbnail ?? '',
                            fit: BoxFit.cover,
                            errorHeight: 50.h,
                            errorWidth: 50.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Obx(() {
          if (controller.isMoreProductLoading.value) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              alignment: Alignment.center,
              child: const SpinKitCircle(color: ColorHelper.primary, size: 32),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
