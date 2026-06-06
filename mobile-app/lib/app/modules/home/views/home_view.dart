import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/components/new_items_widget.dart';
import 'package:refashion/app/modules/home/components/trending_items_widget.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/modules/home/shimmer/home_category_shimmer.dart';
import 'package:refashion/app/modules/home/shimmer/home_product_shimmer.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: BaseScaffold(
        gradient: const LinearGradient(
          stops: [0.0, 0.25, 0.5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorHelper.gradientStart,
            ColorHelper.gradientStart,
            ColorHelper.gradientEnd,
          ],
        ),
        body: RefreshIndicator(
          onRefresh: controller.onRefresh,
          backgroundColor: ColorHelper.white,
          color: ColorHelper.primary,
          child: Obx(() {
            // Full Page Error: Both failed and both lists are empty
            bool isFullPageError =
                controller.errorCategories.value &&
                controller.errorProducts.value &&
                controller.productCategories.isEmpty &&
                controller.newItems.isEmpty &&
                controller.trendingItems.isEmpty;

            // Full Page Empty: Both finished loading, neither failed, but everything is empty
            bool isFullPageEmpty =
                !controller.isLoadingCategories.value &&
                !controller.isLoadingProducts.value &&
                !controller.errorCategories.value &&
                !controller.errorProducts.value &&
                controller.productCategories.isEmpty &&
                controller.newItems.isEmpty &&
                controller.trendingItems.isEmpty;

            if (isFullPageError || isFullPageEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: EmptyWidget(
                        onTap: controller.onRefresh,
                        icon: isFullPageError
                            ? ImageHelper.errorFound
                            : ImageHelper.noDataFound,
                        title: isFullPageError
                            ? locale.value.somethingWentWrong
                            : locale.value.noItemsFound,
                        description: isFullPageError
                            ? locale.value.errorDescription
                            : locale.value.emptyDescription,
                        btnText: isFullPageError
                            ? locale.value.tryAgain
                            : locale.value.refreshPage,
                      ),
                    ),
                  );
                },
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 96.h),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  _headerView(),
                  SizedBox(height: 8.h),
                  _categoryView(),
                  SizedBox(height: 22.h),
                  // const HomeBanner(),
                  // SizedBox(height: 30.h),
                  Obx(
                    () => controller.isLoadingProducts.value
                        ? const HomeProductShimmer()
                        : NewItemsWidget(controller: controller),
                  ),
                  SizedBox(height: 22.h),
                  Obx(
                    () => controller.isLoadingProducts.value
                        ? const HomeProductShimmer()
                        : TrendingItemsWidget(controller: controller),
                  ),
                  // SizedBox(height: 30.h),
                  // NewsWidget(controller: controller),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _categoryView() {
    return Obx(() {
      if (!controller.isLoadingCategories.value &&
          controller.productCategories.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              locale.value.categoryText,
              style: TextStyleHelper.urSemiBold600().copyWith(
                color: ColorHelper.headingColor,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // _tabBarView(),
          // SizedBox(height: 8.h),
          _categoryListView(),
        ],
      );
    });
  }

  /* Widget _tabBarView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 12.w),
              Obx(() => _tabItem(locale.value.menText, 0)),
              SizedBox(width: 24.w),
              Obx(() => _tabItem(locale.value.womenText, 1)),
              SizedBox(width: 24.w),
              Obx(() => _tabItem(locale.value.kidsText, 2)),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: InkWell(
                  onTap: controller.onMenuTap,
                  child: CachedImageView(
                    imagePath: ImageHelper.icDrawer,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: ColorHelper.primary.withValues(alpha: 0.3),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyleHelper.urMedium500().copyWith(
                color: isSelected
                    ? ColorHelper.primary
                    : ColorHelper.subHeadingColor,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 3.h,
              decoration: BoxDecoration(
                color: isSelected ? ColorHelper.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  } */

  Widget _categoryListView() {
    return Obx(() {
      if (controller.isLoadingCategories.value &&
          controller.productCategories.isEmpty) {
        return const HomeCategoryShimmer();
      }
      return SizedBox(
        height: 100.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: controller.productCategories.length,
          separatorBuilder: (context, index) => SizedBox(width: 20.w),
          itemBuilder: (context, index) {
            final category = controller.productCategories[index];
            return GestureDetector(
              onTap: () => controller.onCategoryTap(category),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: ColorHelper.categoryBgGradient,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: category.metadata?['image'] != null
                          ? CachedImageView(
                              imagePath: category.metadata?['image'],
                            )
                          : CachedImageView(
                              imagePath: ImageHelper.getCategoryIcon(
                                category.name,
                              ),
                            ).paddingAll(10.r),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    (category.name ?? "").capitalizeFirstLetter(),
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: ColorHelper.headingColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _headerView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          CommanTextField(
            textFieldType: TextFieldType.OTHER,
            readOnly: true,
            onTap: controller.goToSearch,

            controller: controller.searchController,
            decoration: InputDecoration(
              fillColor: ColorHelper.white,
              hintText: locale.value.seachHere,
              focusedBorder: OutlineInputBorder(
                borderRadius: radius(defaultRadius),
                borderSide: const BorderSide(
                  color: ColorHelper.transparent,
                  width: 0.0,
                ),
              ),
              prefixIcon: CachedImageView(
                imagePath: ImageHelper.icSearch,
                height: 12.h,
                width: 12.w,
              ).paddingAll(14.r),
            ),
          ).expand(),
          SizedBox(width: 20.w),
          BagBadgeWidget(onTap: controller.onBagTap),
          /* SizedBox(width: 6.w),
          Badge.count(
            count: 2,
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
                height: 22.h,
                width: 22.w,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
