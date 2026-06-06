import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

import 'package:refashion/app/modules/bag/model/bag_list_model.dart';
import 'package:refashion/app/modules/bag/service/cart_api_service.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/services/cart_controller.dart';
import 'package:refashion/app/modules/product_detail/service/product_service.dart';
import 'package:refashion/app/services/wishlist_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class BagController extends GetxController {
  final CartApiService _cartApiService = CartApiService();
  final ProductService _productService = ProductService();
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isAllSelected = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<BagListModel> bagModel = Rxn<BagListModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      isLoading(true);
      final String? cartId = HiveUtils.get(HiveKeys.cartId);
      if (cartId == null || cartId.isEmpty) {
        cartItems.clear();
        CartController.to.updateCount(0);
        return;
      }

      final response = await _cartApiService.fetchCart(cartId);
      if (response != null && response['cart'] != null) {
        bagModel.value = BagListModel.fromJson(response);
        _mapApiToCartItems();
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    } finally {
      isLoading(false);
    }
  }

  void _mapApiToCartItems() {
    if (bagModel.value?.cart?.items == null) return;

    cartItems.value = bagModel.value!.cart!.items!.map((item) {
      double priceEuro = (item.unitPrice ?? 0).toDouble();
      // Dummy conversion for RFT as seen in dummy data (Euro * 10)
      // int priceRFT = (priceEuro * 10).toInt();

      final String? sellerName = item.metadata?['seller_name'];
      final String? sellerPhoto = item.metadata?['seller_photo'];

      return CartItem(
        id: item.id ?? '',
        productId: item.productId,
        title: item.title ?? '',
        description: item.productDescription ?? '',
        vendor: sellerName ?? 'Re-Fashion Store',
        priceEuro: priceEuro,
        // priceRFT: priceRFT,
        image: item.thumbnail ?? '',
        isSelected: true,
        variantTitle: item.variantTitle ?? '',
        quantity: item.quantity ?? 1,
        sellerName: sellerName,
        sellerPhoto: sellerPhoto,
      );
    }).toList();

    _checkIsAllSelected();
    CartController.to.updateCount(cartItems.length);
  }

  void toggleSelection(int index) {
    cartItems[index].isSelected.toggle();
    _checkIsAllSelected();
  }

  void toggleAllSelection() {
    isAllSelected.toggle();
    for (var item in cartItems) {
      item.isSelected.value = isAllSelected.value;
    }
  }

  void _checkIsAllSelected() {
    isAllSelected.value =
        cartItems.isNotEmpty &&
        cartItems.every((item) => item.isSelected.value);
  }

  int get selectedCount =>
      cartItems.where((item) => item.isSelected.value).length;

  void onEditTap(CartItem item) {
    _showMoveFromBagSheet(item);
  }

  void _showMoveFromBagSheet(CartItem item) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: CachedImageView(
                      imagePath: item.image,
                      height: 60.h,
                      width: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.value.moveFromBag,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          locale.value.confirmMoveFromBag,
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
                    onTap: () => deleteItem(item),
                    text: locale.value.deleteText,
                    color: ColorHelper.white,
                    textColor: ColorHelper.subHeadingColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.borderColor),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    onTap: () => moveToFavorite(item),
                    text: locale.value.moveToFavorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  final RxBool showMovedToFavorite = false.obs;

  Future<void> deleteItem(CartItem item) async {
    try {
      final String? cartId = HiveUtils.get(HiveKeys.cartId);
      if (cartId == null || cartId.isEmpty) return;
      if (Get.isBottomSheetOpen ?? false) Get.back();
      isLoading(true);
      final response = await _cartApiService.deleteLineItem(cartId, item.id);

      if (response != null) {
        // Option 1: Re-fetch the whole cart to ensure accuracy
        await fetchCartData();

        // Option 2: Locally remove if you want it faster (already covered by fetchCartData above)
        // cartItems.remove(item);
        // _checkIsAllSelected();

        if (Get.isBottomSheetOpen ?? false) Get.back();
      }
    } catch (e) {
      debugPrint('Error deleting item: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> moveToFavorite(CartItem item) async {
    if (item.productId == null) return;

    try {
      if (Get.isBottomSheetOpen ?? false) Get.back();
      isLoading(true);

      // 1. Add to wishlist
      await _productService.addToWishlist(item.productId!, "product");

      // 2. Delete from cart
      final String? cartId = HiveUtils.get(HiveKeys.cartId);
      if (cartId != null && cartId.isNotEmpty) {
        await _cartApiService.deleteLineItem(cartId, item.id);
      }

      // 3. Update local state
      await fetchCartData();

      // 4. Sync global wishlist state
      WishlistController.to.fetchWishlist(isRefresh: true);

      showMovedToFavorite.value = true;
      Future.delayed(const Duration(seconds: 3), () {
        showMovedToFavorite.value = false;
      });
    } catch (e) {
      debugPrint('Error moving to favorite from bag: $e');
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Total number of items in the cart (regardless of selection state).
  int get cartItemCount =>
      bagModel.value?.cart?.items?.length ?? cartItems.length;

  /// Item-only subtotal from the API (excludes shipping subtotal).
  double get itemSubtotalEuro =>
      bagModel.value?.cart?.itemSubtotal?.toDouble() ?? subTotalEuro;

  double get subTotalEuro {
    if (isAllSelected.value) {
      return bagModel.value?.cart?.itemSubtotal?.toDouble() ??
          _calculateLocalSubtotal();
    }
    return _calculateLocalSubtotal();
  }

  double _calculateLocalSubtotal() {
    return cartItems
        .where((item) => item.isSelected.value)
        .fold(0.0, (sum, item) => sum + item.priceEuro);
  }

  double get discountTotalEuro =>
      bagModel.value?.cart?.discountTotal?.toDouble() ?? 0.0;

  double get taxTotalEuro => bagModel.value?.cart?.taxTotal?.toDouble() ?? 0.0;

  double get shippingTotalEuro =>
      bagModel.value?.cart?.shippingTotal?.toDouble() ?? 0.0;

  double get totalEuro =>
      bagModel.value?.cart?.total?.toDouble() ?? subTotalEuro;

  void proceedToCheckout() {
    Get.toNamed(Routes.checkout);
  }

  void startExploring() {
    Get.back();
  }
}

class CartItem {
  final String id;
  final String? productId;
  final String title;
  final String description;
  final String vendor;
  final double priceEuro;
  // final int priceRFT;
  final String image;
  final String variantTitle;
  final int quantity;
  final RxBool isSelected;
  final String? sellerName;
  final String? sellerPhoto;

  CartItem({
    required this.id,
    this.productId,
    required this.title,
    required this.description,
    required this.vendor,
    required this.priceEuro,
    // required this.priceRFT,
    required this.image,
    required this.variantTitle,
    required this.quantity,
    bool isSelected = false,
    this.sellerName,
    this.sellerPhoto,
  }) : isSelected = isSelected.obs;
}
