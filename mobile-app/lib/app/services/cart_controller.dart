import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:refashion/app/modules/bag/service/cart_api_service.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final CartApiService _cartApiService = CartApiService();
  final RxInt cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshCartCount();
  }

  Future<void> refreshCartCount() async {
    try {
      final String? cartId = HiveUtils.get(HiveKeys.cartId);
      if (cartId == null || cartId.isEmpty) {
        cartCount.value = 0;
        return;
      }

      final response = await _cartApiService.fetchCart(cartId);
      if (response != null &&
          response['cart'] != null &&
          response['cart']['items'] != null) {
        final List items = response['cart']['items'];
        cartCount.value = items.length;
      }
    } catch (e) {
      debugPrint('Error refreshing cart count: $e');
    }
  }

  void updateCount(int count) {
    cartCount.value = count;
  }

  void clearCartCount() {
    cartCount.value = 0;
  }
}
