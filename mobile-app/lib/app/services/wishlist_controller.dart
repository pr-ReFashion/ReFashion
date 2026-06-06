import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/favorite/model/wishlist_model.dart';
import 'package:refashion/app/modules/product_detail/service/product_service.dart';

class WishlistController extends GetxController {
  static WishlistController get to => Get.find<WishlistController>();

  final ProductService _productService = ProductService();
  final RxList<WishlistProduct> favoriteItems = <WishlistProduct>[].obs;
  final RxSet<String> wishlistedIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  int currentProductPage = 1;
  final int _limit = 10;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist(isRefresh: true);
  }

  Future<void> fetchWishlist({bool isRefresh = false}) async {
    if (isRefresh) {
      currentProductPage = 1;
      hasMore = true;
    }

    if (!hasMore && !isRefresh) return;

    try {
      if (isRefresh) {
        isLoading(true);
      } else {
        isLoadingMore(true);
      }

      int offset = (currentProductPage - 1) * _limit;

      final response = await _productService.fetchWishlist(
        limit: _limit,
        offset: offset,
      );

      List<WishlistProduct> products = [];
      final Set<String> ids = {};

      if (response.wishlists != null) {
        for (var wishlist in response.wishlists!) {
          if (wishlist.products != null) {
            for (var product in wishlist.products!) {
              product.wishlistId = wishlist.id;
              products.add(product);
              if (product.id != null) {
                ids.add(product.id!);
              }
            }
          }
        }
      }

      if (isRefresh) {
        favoriteItems.assignAll(products);
        wishlistedIds.assignAll(ids);
      } else {
        favoriteItems.addAll(products);
        wishlistedIds.addAll(ids);
      }

      final int apiCount = response.count ?? 0;
      final int currentLoadedCount = favoriteItems.length;

      // If we have a count from the API, use it to determine if there's more.
      // Otherwise, fallback to checking if we fetched a full page.
      if (response.count != null) {
        hasMore = currentLoadedCount < apiCount;
      } else {
        hasMore = products.length >= _limit;
      }

      if (hasMore) {
        currentProductPage++;
      }
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  Future<void> removeFromFavorite(WishlistProduct product) async {
    try {
      String? wishlistId = product.wishlistId;
      String? productId = product.id;

      if (wishlistId == null || productId == null) {
        final wishlistResponse = await _productService.fetchWishlist();
        if (wishlistResponse.wishlists != null) {
          for (var wishlist in wishlistResponse.wishlists!) {
            if (wishlist.products != null &&
                wishlist.products!.any((p) => p.id == product.id)) {
              wishlistId = wishlist.id;
              break;
            }
          }
        }
      }

      if (wishlistId != null && productId != null) {
        // Optimistic update
        favoriteItems.removeWhere((p) => p.id == product.id);
        wishlistedIds.remove(productId);

        await _productService.deleteProductFromWishlist(wishlistId, productId);
        toast(locale.value.moveFromFavorite);
      } else {
        toast(locale.value.errorUnknown);
      }
    } catch (e) {
      debugPrint('Error removing from favorite: $e');
      toast(e.toString());
      // Re-fetch to sync if failed
      fetchWishlist(isRefresh: true);
    }
  }

  Future<void> toggleWishlist(String productId) async {
    final bool wasWishlisted = wishlistedIds.contains(productId);

    try {
      // Optimistic update
      if (wasWishlisted) {
        wishlistedIds.remove(productId);
        favoriteItems.removeWhere((p) => p.id == productId);
      } else {
        wishlistedIds.add(productId);
        HapticFeedback.lightImpact();
      }

      if (wasWishlisted) {
        final wishlistResponse = await _productService.fetchWishlist();
        String? wishlistIdToDelete;
        if (wishlistResponse.wishlists != null) {
          for (var wishlist in wishlistResponse.wishlists!) {
            if (wishlist.products != null &&
                wishlist.products!.any((p) => p.id == productId)) {
              wishlistIdToDelete = wishlist.id;
              break;
            }
          }
        }
        if (wishlistIdToDelete != null) {
          await _productService.deleteProductFromWishlist(
            wishlistIdToDelete,
            productId,
          );
          toast(locale.value.moveFromFavorite);
        }
      } else {
        final response = await _productService.addToWishlist(
          productId,
          "product",
        );
        if (response != null) {
          toast(locale.value.movedToFavorite);
        }
      }

      // Update favoriteItems by re-fetching if we added a new item
      // because we need the full WishlistProduct model.
      if (!wasWishlisted) {
        fetchWishlist(isRefresh: true);
      }
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
      if (wasWishlisted) {
        wishlistedIds.add(productId);
      } else {
        wishlistedIds.remove(productId);
      }
      toast(e.toString());
      fetchWishlist(isRefresh: true);
    }
  }
}
