import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

import '../controllers/categories_controller.dart';
import '../shimmer/category_shimmer.dart';
import '../shimmer/sub_category_shimmer.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.categoriesText),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CategoryShimmer();
        }
        if (controller.productCategories.isEmpty) {
          return EmptyWidget(
            title: locale.value.errorNotFound,
            description: locale.value.tryDifferentKeywordText,
            icon: ImageHelper.noDataFound,
            btnText: locale.value.retryText,
            onTap: () => controller.fetchCategories(),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchCategories(isRefresh: true),
          color: ColorHelper.primary,
          backgroundColor: ColorHelper.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  locale.value.categoryText,
                  style: TextStyleHelper.urSemiBold600().copyWith(
                    color: ColorHelper.headingColor,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              _genderTabBar(),
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: ColorHelper.whiteOpacity,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _mainCategoryList(),
                    Expanded(child: _subCategoryGrid()),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _genderTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _genderTabItem(locale.value.menText, 0),
          SizedBox(width: 24.w),
          _genderTabItem(locale.value.womenText, 1),
          SizedBox(width: 24.w),
          _genderTabItem(locale.value.kidsText, 2),
        ],
      ),
    );
  }

  Widget _genderTabItem(String title, int index) {
    return Obx(() {
      bool isSelected = controller.selectedGenderIndex.value == index;
      return GestureDetector(
        onTap: () => controller.onGenderTabTap(index),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Text(
                title,
                style: TextStyleHelper.urRegular400().copyWith(
                  color: isSelected
                      ? ColorHelper.primary
                      : ColorHelper.subHeadingColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 2.h,
                decoration: BoxDecoration(
                  color: isSelected ? ColorHelper.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _mainCategoryList() {
    return Container(
      width: 96.w,
      color: ColorHelper.lightGrey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: controller.sidebarScrollController,
              padding: EdgeInsets.zero,
              itemCount: controller.productCategories.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final category = controller.productCategories[index];
                return Obx(() {
                  bool isSelected =
                      controller.selectedMainCategoryIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.onMainCategoryTap(index),
                    child: Container(
                      color: isSelected ? ColorHelper.white : null,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 4.w,
                              margin: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorHelper.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.r),
                                  bottomRight: Radius.circular(4.r),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.r),
                                    child: CachedImageView(
                                      imagePath:
                                          category.metadata?['image'] ??
                                          ImageHelper.getCategoryIcon(
                                            category.name,
                                          ),
                                      fit: BoxFit.cover,
                                      height: 70.h,
                                      width: 70.w,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    category.name ?? "",
                                    style: TextStyleHelper.urRegular400()
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: isSelected
                                              ? ColorHelper.primary
                                              : ColorHelper.subHeadingColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Obx(
            () => controller.isLoadingMore.value
                ? Container(
                    padding: EdgeInsets.all(12.h),
                    child: const SpinKitCircle(
                      color: ColorHelper.primary,
                      size: 24,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _subCategoryGrid() {
    return Obx(() {
      if (controller.productCategories.isEmpty ||
          controller.selectedMainCategoryIndex.value >=
              controller.productCategories.length) {
        return const SizedBox();
      }
      final selectedCategory = controller
          .productCategories[controller.selectedMainCategoryIndex.value];

      if (controller.isLoadingCollections.value &&
          controller.collections.isEmpty) {
        return const SubCategoryShimmer();
      }

      if (controller.collections.isEmpty) {
        return EmptyWidget(
          title: locale.value.errorNotFound,
          description: locale.value.tryDifferentKeywordText,
          icon: ImageHelper.noDataFound,
          btnText: locale.value.retryText,
          onTap: () => controller.fetchCollections(),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              locale.value.allCategoryWithName(selectedCategory.name ?? ""),
              style: TextStyleHelper.urBold700().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.subHeadingColor,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: controller.collectionScrollController,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.collections.length,
              itemBuilder: (context, index) {
                final collection = controller.collections[index];
                final String collectionTitle = collection.title ?? "";
                const String collectionImage = '';
                // final String collectionImage = ImageHelper.getCategoryIcon(
                //   collectionTitle,
                // );

                return GestureDetector(
                  onTap: () => controller.goToCategoryProducts(
                    categoryId: selectedCategory.id,
                    collectionId: collection.id,
                    collectionTitle: collectionTitle,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorHelper.lightGrey.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedImageView(
                              imagePath: collectionImage,
                              // fit: BoxFit.cover,
                              height: 90.h,
                              width: 130.w,
                              errorWidth: 40.w,
                              errorHeight: 40.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        collectionTitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.headingColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(
            () => controller.isLoadingMoreCollections.value
                ? Container(
                    padding: EdgeInsets.all(12.h),
                    child: const SpinKitCircle(
                      color: ColorHelper.primary,
                      size: 24,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    });
  }
}
