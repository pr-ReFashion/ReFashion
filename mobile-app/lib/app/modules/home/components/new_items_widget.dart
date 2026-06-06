import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/product_item_widget.dart';
import 'package:refashion/app/widget/view_all_widget.dart';

class NewItemsWidget extends StatelessWidget {
  const NewItemsWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.newItems.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllWidget(
            title: locale.value.newItemsText,
            viewAllOnTap: controller.newItems.length > 7
                ? controller.onViewAllNewItems
                : null,
          ).paddingSymmetric(horizontal: 16.w),
          SizedBox(height: 12.h),
          SizedBox(
            height: ProductItemWidget.itemHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.newItems.length > 7
                  ? 7
                  : controller.newItems.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final product = controller.newItems[index];
                return Obx(
                  () => ProductItemWidget(
                    product: product,
                    isFavorite: controller.wishlistedIds.contains(product.id),
                    onTap: () => controller.goToProductDetail(product),
                    onFavoriteTap: () => controller.toggleWishlist(product),
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
