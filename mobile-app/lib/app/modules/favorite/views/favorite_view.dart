import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

import 'package:refashion/app/widget/spin_kit_loader.dart';
import 'package:refashion/app/constant/empty_widget.dart';

import 'package:refashion/app/modules/favorite/controllers/favorite_controller.dart';
import 'components/favorite_item_widget.dart';
import '../shimmer/favorite_shimmer.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: ColorHelper.white,
        color: ColorHelper.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const FavoriteShimmer();
          }
          if (controller.favoriteItems.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: Get.height - Get.bottomBarHeight - 100.h,
                child: EmptyWidget(
                  title: locale.value.yourFavoriteListIsEmpty,
                  description:
                      locale.value.heartYourFavoriteItemsAndTheyWillShowUpHere,
                  icon: ImageHelper.icEmptyFavorite,
                  btnText: locale.value.startExploringNow,
                  onTap: controller.startExploring,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _favoriteListView(),
                if (controller.isLoadingMore.value)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const SpinKitCircle(
                      color: ColorHelper.primary,
                      size: 24,
                    ),
                  ),
                SizedBox(height: 96.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CommonAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 6.w,
      titleWidget: Row(
        children: [
          /*  Badge.count(
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
            locale.value.favoriteText,
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

  Widget _favoriteListView() {
    double itemWidth = (Get.context!.width - (16.w * 2) - 18.w) / 2;
    double itemHeight = FavoriteItemWidget.itemHeight;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: itemWidth / itemHeight,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: controller.favoriteItems.length,
      itemBuilder: (context, index) {
        final product = controller.favoriteItems[index];
        return Obx(
          () => InkWell(
            onTap: () => controller.onProductTap(product),
            child: FavoriteItemWidget(
              product: product,
              onDelete: () => controller.showDeleteConfirmation(product),
              onAddToBag: () => controller.addToBag(product),
              isAddingToBag: controller.addingToBagId.value == product.id,
            ),
          ),
        );
      },
    );
  }
}
