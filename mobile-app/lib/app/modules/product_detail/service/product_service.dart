import 'package:flutter/material.dart';
import 'package:refashion/app/modules/favorite/model/wishlist_model.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import '../models/eco_score_model.dart';
import '../models/product_list_model.dart';
import '../models/seller_info_model.dart';
import '../models/review_model.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  Future<ReviewResponse?> fetchSellerReviews({
    String? sellerId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'reference': 'seller',
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (sellerId != null && sellerId.isNotEmpty) {
        queryParams['reference_id'] = sellerId;
      }

      final response = await _apiService.get(
        ApiConfig.storeReviews,
        queryParameters: queryParams,
      );
      return ReviewResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching seller reviews: $e');
      return null;
    }
  }

  Future<EcoScoreModel?> fetchEcoScore(String productId) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.ecoScore}/$productId',
        body: {},
      );
      return EcoScoreModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching eco score: $e');
      return null;
    }
  }

  Future<ProductListModel> fetchProducts({
    int limit = 10,
    int offset = 0,
    List<String>? categoryIds,
    String? collectionId,
    String? q,
  }) async {
    final Map<String, dynamic> queryParams = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'fields': '*variants,*variants.prices,*images',
      'order': '-created_at',
    };

    if (categoryIds != null && categoryIds.isNotEmpty) {
      queryParams['category_id[]'] = categoryIds;
    }

    if (collectionId != null && collectionId.isNotEmpty) {
      queryParams['collection_id'] = collectionId;
    }

    if (q != null && q.isNotEmpty) {
      queryParams['q'] = q;
    }

    final response = await _apiService.get(
      ApiConfig.storeProducts,
      queryParameters: queryParams,
    );
    return ProductListModel.fromJson(response);
  }

  Future<Product?> fetchProductDetail(String id) async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeProductsId(id),
        queryParameters: {
          'fields':
              '*variants,*variants.prices,*images,*variants.inventory_items,'
              '*variants.inventory_items.inventory.location_levels',
        },
      );
      return Product.fromJson(response['product']);
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchProductSeller(String id) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorProductsIdSeller(id),
        body: {},
      );
      return response['seller_id'];
    } catch (e) {
      debugPrint('Error fetching product seller: $e');
      return null;
    }
  }

  Future<SellerInfo?> fetchSellerInfo(String productId) async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeProductsId(productId),
        queryParameters: {
          'fields': 'seller.id,seller.name,seller.created_at,seller.photo',
        },
      );
      if (response['product'] != null &&
          response['product']['seller'] != null) {
        return SellerInfo.fromJson(response['product']['seller']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching seller info: $e');
      return null;
    }
  }

  Future<dynamic> addToWishlist(String referenceId, String reference) async {
    final response = await _apiService.post(
      ApiConfig.storeWishlist,
      body: {"reference_id": referenceId, "reference": reference},
    );
    return response;
  }

  Future<WishlistModel> fetchWishlist({int limit = 10, int offset = 0}) async {
    final response = await _apiService.get(
      ApiConfig.storeWishlist,
      queryParameters: {
        'order': '-created_at',
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );
    return WishlistModel.fromJson(response);
  }

  Future<dynamic> deleteProductFromWishlist(
    String wishlistId,
    String productId,
  ) async {
    final response = await _apiService.delete(
      ApiConfig.storeWishlistProduct(wishlistId, productId),
    );
    return response;
  }

  Future<ProductListModel> fetchFilteredProducts({
    String? material,
    String? collection,
    String? categoryName,
    num? minPrice,
    num? maxPrice,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fields': '*variants,*variants.prices,*images',
        'order': '-created_at',
      };
      if (material != null && material.isNotEmpty) {
        queryParams['material'] = material;
      }
      if (collection != null && collection.isNotEmpty) {
        queryParams['collection'] = collection;
      }
      if (categoryName != null && categoryName.isNotEmpty) {
        queryParams['category_name'] = categoryName;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }

      final response = await _apiService.get(
        ApiConfig.storeFilters,
        queryParameters: queryParams,
      );
      return ProductListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
