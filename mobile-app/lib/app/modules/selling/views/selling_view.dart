import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/order_card.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/selling_controller.dart';
import '../shimmer/selling_shimmer.dart';

class SellingView extends GetView<SellingController> {
  const SellingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: controller.title.value),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          _buildSearchAndSort(),
          SizedBox(height: 20.h),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const SellingShimmer();
              }

              if (controller.filteredItems.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.fetchOrders,
                  color: ColorHelper.primary,
                  backgroundColor: ColorHelper.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: Get.height * 0.6,
                      child: EmptyWidget(
                        title: locale.value.yourOrderListIsEmpty,
                        description: locale.value.orderListEmptyDescription,
                        icon: ImageHelper.noDataFound,
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchOrders,
                color: ColorHelper.primary,
                backgroundColor: ColorHelper.white,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.filteredItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = controller.filteredItems[index];
                    return OrderCard(
                      item: item,
                      onTrackTap: controller.onTrackTap,
                      onTap: () => controller.onItemTap(item),
                    );
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Obx(
            () => CommanTextField(
              controller: controller.searchController,
              textFieldType: TextFieldType.NAME,
              onChanged: controller.onSearch,
              decoration: InputDecoration(
                hintText: locale.value.searchInOrders,
                fillColor: ColorHelper.white,
                prefixIcon: CachedImageView(
                  imagePath: ImageHelper.icSearch,
                  height: 12.h,
                  width: 12.w,
                ).paddingAll(14.r),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.onSearch('');
                        },
                        icon: Icon(
                          Icons.close,
                          color: ColorHelper.iconColor,
                          size: 20.sp,
                        ),
                      )
                    : null,
              ),
            ),
          ).expand(),
          /* SizedBox(width: 20.w),
          InkWell(
            onTap: controller.onSortTap,
            child: Row(
              children: [
                Text(
                  locale.value.sortByText.toLowerCase(),
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(width: 4.w),
                CachedImageView(
                  imagePath: ImageHelper.icFilter,
                  size: 18.sp,
                  color: ColorHelper.iconColor,
                ),
              ],
            ),
          ), */
        ],
      ),
    );
  }
}
