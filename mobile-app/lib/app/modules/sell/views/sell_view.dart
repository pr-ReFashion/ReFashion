import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/modules/sell/shimmer/sell_shimmer.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';

import 'package:refashion/app/modules/sell/controllers/sell_controller.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

class SellView extends GetView<SellController> {
  const SellView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: ColorHelper.white,
        color: ColorHelper.primary,
        child: Obx(() {
          if (controller.isLoading.value || controller.isDeleting.value) {
            return const SellShimmer();
          }

          if (controller.storeStatus.value != "ACTIVE") {
            return _inactiveStoreView();
          }

          if (controller.products.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: Get.height - Get.bottomBarHeight - 100.h,
                child: EmptyWidget(
                  title: locale.value.youHavntAddedAnythingToSellYet,
                  description: '',
                  icon: ImageHelper.icEmptyFavorite,
                  onTap: controller.addNewItem,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: ColorHelper.white, size: 24.sp),
                      SizedBox(width: 8.w),
                      Text(
                        locale.value.addNewItem,
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          color: ColorHelper.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return _sellListView();
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.isDeleting.value ||
            controller.storeStatus.value != "ACTIVE" ||
            controller.products.isEmpty) {
          return const SizedBox.shrink();
        }
        return _addNewItemButton();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _inactiveStoreView() {
    String title;
    String description;
    String icon = ImageHelper.icEmptyFavorite; // Default icon
    VoidCallback? onTap;
    String? btnText;

    switch (controller.storeStatus.value) {
      case "PENDING":
        title = locale.value.storePendingTitle;
        description = locale.value.storePendingDesc;
        break;
      case "ERROR":
        title = locale.value.noSellerAccountTitle;
        description = locale.value.noSellerAccountDesc;
        btnText = locale.value.completeProfile;
        onTap = () => Get.toNamed(Routes.personalInfo);
        break;
      default:
        title = locale.value.storeDeactivatedTitle;
        description = locale.value.storeDeactivatedDesc;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: Get.height - Get.bottomBarHeight - 100.h,
        child: EmptyWidget(
          title: title,
          description: description,
          icon: icon,
          btnText: btnText,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _sellListView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount:
                controller.products.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.products.length) {
                final item = controller.products[index];
                return _itemCard(item, index);
              } else {
                return Container(
                  padding: EdgeInsets.all(12.h),
                  child: const SpinKitCircle(
                    color: ColorHelper.primary,
                    size: 24,
                  ),
                );
              }
            },
          ),
        ),
        // _addNewItemButton(),
        SizedBox(height: 66.h),
      ],
    );
  }

  Widget _itemCard(Product item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ColorHelper.greyScale.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedImageView(
                imagePath: item.thumbnail ?? "",
                height: 80.sp,
                width: 80.sp,
                errorHeight: 30.sp,
                errorWidth: 30.sp,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? "",
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
                SizedBox(height: 8.h),
                RichText(
                  text: TextSpan(
                    text: '${locale.value.status}: ',
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.headingColor,
                    ),
                    children: [
                      TextSpan(
                        text: item.id != null
                            ? "Active"
                            : "Draft", // Logic placeholder
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => controller.showDeleteConfirmation(item, index),
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: ColorHelper.iconColor,
            ).paddingAll(8.sp),
          ),
        ],
      ),
    );
  }

  Widget _addNewItemButton() {
    return CommonBtn(
      margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 96.h),
      onTap: controller.addNewItem,
      width: 200.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: ColorHelper.white, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            locale.value.addNewItem,
            style: TextStyleHelper.urSemiBold600().copyWith(
              color: ColorHelper.white,
              fontSize: 14.sp,
            ),
          ),
        ],
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
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),*/
          SizedBox(width: 8.w),
          Text(
            locale.value.sellText,
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
}
