import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:refashion/app/modules/favorite/model/wishlist_model.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/modules/bag/service/cart_api_service.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/services/cart_controller.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/modules/product_detail/service/product_service.dart';
import 'package:refashion/app/services/wishlist_controller.dart';

class FavoriteController extends GetxController {
  final ProductService _productService = ProductService();
  final CartApiService _cartApiService = CartApiService();

  RxList<WishlistProduct> get favoriteItems =>
      WishlistController.to.favoriteItems;
  RxBool get isLoading => WishlistController.to.isLoading;
  RxBool get isLoadingMore => WishlistController.to.isLoadingMore;
  final addingToBagId = ''.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    // fetchWishlist is now handled globally, but we can refresh just in case
    WishlistController.to.fetchWishlist(isRefresh: true);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        !isLoading.value &&
        WishlistController.to.hasMore) {
      WishlistController.to.fetchWishlist();
    }
  }

  Future<void> fetchWishlist() async {
    await WishlistController.to.fetchWishlist(isRefresh: true);
  }

  Future<void> removeFromFavorite(WishlistProduct product) async {
    await WishlistController.to.removeFromFavorite(product);
  }

  void onProductTap(WishlistProduct product) {
    if (product.id != null) {
      Get.toNamed(Routes.productDetail, arguments: product.id);
    }
  }

  Future<void> addToBag(WishlistProduct product) async {
    if (product.variantId == null) {
      toast(locale.value.errorUnknown);
      return;
    }

    try {
      addingToBagId.value = product.id ?? '';
      // 1. Get required data
      final String regionId =
          HiveUtils.get(HiveKeys.regionId) ?? "reg_01K15HJ2CS7G3MWPPQM3G8QFNV";
      final String email = HiveUtils.get(HiveKeys.userEmail) ?? '';
      final String currencyCode =
          CurrencyController.to.selectedCurrency.code ?? "eur";
      String? cartId = HiveUtils.get(HiveKeys.cartId);

      // 2. Create Cart if not exists
      if (cartId == null || cartId.isEmpty) {
        final cartResponse = await _cartApiService.createCart(
          regionId: regionId,
          email: email,
          currencyCode: currencyCode,
        );

        if (cartResponse != null && cartResponse['cart'] != null) {
          cartId = cartResponse['cart']['id'];
          HiveUtils.set(HiveKeys.cartId, cartId);
        }
      }

      // 3. Fetch Seller ID
      String? sellerId;
      if (product.id != null) {
        sellerId = await _productService.fetchProductSeller(product.id!);
      }

      // 4. Add Line Item
      if (cartId != null && cartId.isNotEmpty) {
        final lineItemResponse = await _cartApiService.addLineItem(
          cartId: cartId,
          variantId: product.variantId!,
          quantity: 1,
          metadata: sellerId != null ? {"seller_id": sellerId} : null,
        );

        if (lineItemResponse != null) {
          CartController.to.refreshCartCount();
          toast(locale.value.toastAddedToBag);
        }
      }
    } catch (e) {
      debugPrint('Error adding to bag from wishlist: $e');
      toast(e.toString());
    } finally {
      addingToBagId.value = '';
    }
  }

  void startExploring() {
    final dashboardController = Get.find<DashboardController>();
    dashboardController.changeIndex(0);
  }

  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void showDeleteConfirmation(WishlistProduct product) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedImageView(
                      imagePath: product.thumbnail ?? '',
                      height: 60.r,
                      width: 60.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.value.moveFromFavorite,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          locale.value.confirmMoveFromFavorite,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CommonBtn(
                    onTap: () => Get.back(),
                    text: locale.value.cancelText,
                    color: ColorHelper.white,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.borderColor),
                    ),
                    textColor: ColorHelper.subHeadingColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    onTap: () {
                      removeFromFavorite(product);
                      Get.back();
                    },
                    text: locale.value.deleteText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> onRefresh() async {
    await fetchWishlist();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
