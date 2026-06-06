import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import '../controllers/product_detail_controller.dart';
import '../components/product_detail_bottom_bar.dart';
import '../components/product_description_card.dart';
import '../components/product_header_info.dart';
import '../components/product_image_slider.dart';
import '../components/product_variant_selector.dart';
import '../components/product_shipping_returns.dart';
import '../components/product_eco_score_card.dart';
import '../components/product_seller_info_card.dart';
import '../shimmer/product_detail_shimmer.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/widget/bag_badge_widget.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product.value;
      final isInitialDataLoading = controller.isLoading.value;
      final selectedVariant = controller.selectedVariant.value;
      final isAddingToBag = controller.isBagLoading.value;

      return BaseScaffold(
        appBar: CommonAppBar(
          title: product?.title ?? locale.value.productDetails,
          actions: [
            IconButton(
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: CachedImageView(
                imagePath: ImageHelper.icShare,
                fit: BoxFit.contain,
                size: 24.sp,
              ),
              onPressed: controller.onShareTap,
            ),
            SizedBox(width: 10.w),
            BagBadgeWidget(onTap: controller.onBagTap),
            SizedBox(width: 8.w),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: ColorHelper.primary,
          backgroundColor: ColorHelper.white,
          child: isInitialDataLoading
              ? const ProductDetailShimmer()
              : product == null
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Get.height - Get.bottomBarHeight - 100.h,
                    child: EmptyWidget(
                      title: locale.value.errorNotFound,
                      description: locale.value.noItemsFoundText,
                      icon: ImageHelper.noDataFound,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      ProductImageSlider(
                        images: product.images ?? [],
                        currentIndex: controller.currentImageIndex,
                        onPageChanged: controller.onPageChanged,
                      ),
                      SizedBox(height: 4.h),
                      ProductHeaderInfo(product: product),
                      SizedBox(height: 8.h),
                      const ProductVariantSelector(),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12.h,
                          children: [
                            const ProductEcoScoreCard(),
                            ProductDescriptionCard(
                              key: controller.descriptionKey,
                              product: product,
                            ),
                            ProductShippingReturns(key: controller.shippingKey),
                            const ProductSellerInfoCard(),
                            SizedBox(height: 12.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: product == null
            ? null
            : ProductDetailBottomBar(
                onChatTap: controller.onChatTap,
                onMakeOfferTap: controller.onMakeOfferTap,
                onAddToBagTap: controller.onAddToBagTap,
                isVariantSelected: selectedVariant != null,
                isInStock: controller.isVariantInStock(selectedVariant),
                isLoading: isAddingToBag,
              ),
      );
    });
  }
}
