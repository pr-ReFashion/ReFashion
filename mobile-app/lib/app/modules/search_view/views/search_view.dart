import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

import '../controllers/search_view_controller.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.searchText),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 18.h),
            // _tabSwitcherView(),
            // SizedBox(height: 16.h),
            _searchFieldView(),
            Expanded(
              child: Obx(() {
                if (controller.searchText.value.isNotEmpty) {
                  return _searchResultsView();
                } else {
                  return _recentSearchesView();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget _tabSwitcherView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Obx(
        () => Row(
          children: [
            _tabItem(locale.value.itemsText, 0),
            _tabItem(locale.value.usersText, 1),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChanged(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? ColorHelper.primary : ColorHelper.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyleHelper.urMedium500().copyWith(
              color: isSelected ? ColorHelper.white : ColorHelper.headingColor,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  } */

  Widget _searchFieldView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CommanTextField(
              textFieldType: TextFieldType.OTHER,
              controller: controller.searchController,
              autoFocus: true,
              onFieldSubmitted: (value) => controller.onSearchSubmitted(value),
              decoration: InputDecoration(
                hintText: locale.value.seachHere,
                filled: true,
                fillColor: ColorHelper.white,
                prefixIcon: CachedImageView(
                  imagePath: ImageHelper.icSearch,
                  size: 14.sp,
                ).paddingAll(14.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          TextButton(
            onPressed: controller.onCancelTap,
            child: Text(
              locale.value.cancelText,
              style: TextStyleHelper.urMedium500().copyWith(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResultsView() {
    return Obx(() {
      if (controller.selectedTab.value == 0) {
        if (controller.isLoadingResults.value) {
          return const SpinKitCircle(color: ColorHelper.primary);
        }

        if (controller.searchController.text.length >= 3 &&
            controller.searchedProducts.isEmpty &&
            (!controller.isFromCategory || controller.filteredItems.isEmpty)) {
          return Center(
            child: Text(
              locale.value.errorNotFound,
              style: TextStyleHelper.dmRegular400(),
            ),
          );
        }

        if (controller.searchedProducts.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: controller.searchedProducts.length,
            itemBuilder: (context, index) {
              final product = controller.searchedProducts[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: CachedImageView(
                    imagePath: product.thumbnail ?? '',
                    height: 48.r,
                    width: 48.r,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.title ?? '',
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.headingColor,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Text(
                  product.subtitle ?? '',
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 12.sp,
                  ),
                ),
                onTap: () {
                  controller.onProductTap(product);
                },
              );
            },
          );
        }

        if (controller.isFromCategory && controller.filteredItems.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: controller.filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  controller.filteredItems[index],
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  controller.onSuggestionTap(controller.filteredItems[index]);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      } else {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: controller.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = controller.filteredUsers[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: CachedImageView(
                  imagePath: user.image,
                  height: 40.r,
                  width: 40.r,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                user.name,
                style: TextStyleHelper.urMedium500().copyWith(
                  color: ColorHelper.headingColor,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                controller.onUserTap(user);
              },
            );
          },
        );
      }
    });
  }

  Widget _recentSearchesView() {
    return Obx(() {
      final list = controller.selectedTab.value == 0
          ? controller.recentSearches
          : controller.userRecentSearches;

      if (list.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 8.h),
            child: Text(
              locale.value.recentSearchText,
              style: TextStyleHelper.urSemiBold600().copyWith(
                fontSize: 18.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(height: 4.h),
              itemBuilder: (context, index) {
                final query = list[index];
                return InkWell(
                  onTap: () => controller.onRecentSearchTap(query),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        SizedBox(width: 14.w),
                        CachedImageView(
                          imagePath: ImageHelper.icRecentSearch,
                          size: 18.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            query,
                            style: TextStyleHelper.dmRegular400().copyWith(
                              color: ColorHelper.subHeadingColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => controller.removeRecentSearch(index),
                          icon: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
