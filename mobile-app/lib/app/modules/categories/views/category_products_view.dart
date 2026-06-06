import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

import 'package:refashion/app/constant/empty_widget.dart';
import '../controllers/category_products_controller.dart';
import '../shimmer/category_product_shimmer.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(
        titleWidget: Obx(
          () => Text(
            controller.displayTitle,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 20.sp,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.onSearchTap,
            icon: CachedImageView(
              imagePath: ImageHelper.icSearch,
              size: 24.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          BagBadgeWidget(onTap: controller.onBagTap),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          _filterBar(),
          Obx(() {
            if (controller.appliedFilterCount.value == 0) {
              return const SizedBox();
            }
            return _appliedFilterChips();
          }),

          Expanded(
            child: Obx(
              () =>
                  controller.isLoadingProducts.value &&
                      controller.products.isEmpty
                  ? const CategoryProductShimmer()
                  : controller.products.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (controller.searchQuery.value.isNotEmpty) ...[
                          GestureDetector(
                            onTap: controller.clearSearch,
                            child: Container(
                              margin: EdgeInsets.only(right: 16.w, top: 16.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorHelper.primaryLightColor,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    locale.value.clearSearch,
                                    style: TextStyleHelper.urMedium500()
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: ColorHelper.primary,
                                        ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.close,
                                    size: 14.sp,
                                    color: ColorHelper.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          child: EmptyWidget(
                            title: locale.value.errorNotFound,
                            description: locale.value.tryDifferentKeywordText,
                            icon: ImageHelper.noDataFound,
                            btnText: locale.value.retryText,
                            onTap: controller.onRefreshProducts,
                          ),
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: controller.onRefreshProducts,
                      color: ColorHelper.primary,
                      backgroundColor: ColorHelper.white,
                      child: SingleChildScrollView(
                        controller: controller.productScrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Removed _statsBar() as count and filter are now in the sticky _filterBar
                            SizedBox(height: 8.h),
                            _productGrid(),
                            if (controller.isLoadingMoreProducts.value)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: const SpinKitCircle(
                                  color: ColorHelper.primary,
                                  size: 24,
                                ),
                              ),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: ColorHelper.white,
        border: Border(
          bottom: BorderSide(color: ColorHelper.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              locale.value.items(controller.totalProductCount.value),
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
          InkWell(
            onTap: controller.onFilterTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: ColorHelper.borderColor, width: 1.h),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Badge.count(
                      count: controller.appliedFilterCount.value,
                      isLabelVisible: controller.appliedFilterCount.value > 0,
                      backgroundColor: ColorHelper.primary,
                      offset: const Offset(4, -4),
                      textStyle: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 10.sp,
                        color: ColorHelper.white,
                      ),
                      child: Icon(
                        Icons.tune,
                        size: 18.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    locale.value.filterText,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 14.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appliedFilterChips() {
    final filters = controller.activeFilters;
    return Container(
      height: 44.h,
      width: double.infinity,
      color: ColorHelper.white,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: ColorHelper.offWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: ColorHelper.borderColor, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter.value,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () => controller.removeFilter(filter),
                  child: Icon(
                    Icons.close,
                    size: 14.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _productGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.68,
      ),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        return _categoryProductItem(index);
      },
    );
  }

  Widget _categoryProductItem(int index) {
    final product = controller.products[index];
    return GestureDetector(
      onTap: () => controller.onProductTap(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: ColorHelper.white,
          boxShadow: [
            BoxShadow(
              color: ColorHelper.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorHelper.lightGrey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedImageView(
                        imagePath: product.thumbnail ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        errorHeight: 80.h,
                        errorWidth: 80.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () => controller.onProductFavoriteTap(index),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: const BoxDecoration(
                          color: ColorHelper.white,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => CachedImageView(
                            imagePath:
                                controller.wishlistedIds.contains(product.id)
                                ? ImageHelper.icHeartFill
                                : ImageHelper.icHeart,
                            size: 16.sp,
                            color: controller.wishlistedIds.contains(product.id)
                                ? ColorHelper.error
                                : ColorHelper.iconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              product.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.headingColor,
              ),
            ).paddingSymmetric(horizontal: 8.w),
            SizedBox(height: 2.h),
            Text(
              product.subtitle ?? product.description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.subHeadingColor,
              ),
            ).paddingSymmetric(horizontal: 8.w),
            SizedBox(height: 4.h),
            Text(
              product.displayPrice.toString().toPrice(),
              style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp),
            ).paddingSymmetric(horizontal: 8.w),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
