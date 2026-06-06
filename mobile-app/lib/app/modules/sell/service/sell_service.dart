import 'dart:io';
import 'dart:developer';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';
import '../model/product_tag_list_model.dart';
import '../model/product_type_list.dart';
import '../model/sales_channels_model.dart';

class SellService {
  final ApiService _apiService = ApiService();

  Future<void> syncProductStock(String productId) async {
    try {
      log("Background: Starting stock update for product: $productId");

      // 1. Fetch Stock Locations
      final slResponse = await fetchStockLocations();
      final List<dynamic> stockLocations = slResponse['stock_locations'] ?? [];
      if (stockLocations.isEmpty) {
        log("Background Error: No stock locations found");
        return;
      }
      final String stockLocationId = stockLocations.first['id'];

      // 2. Fetch Sales Channels
      final scResponse = await fetchSalesChannels();
      final List<SalesChannel> salesChannels = scResponse.salesChannels ?? [];
      if (salesChannels.isEmpty) {
        log("Background Error: No sales channels found");
        return;
      }
      final String salesChannelId = salesChannels.first.id!;

      // 3. Link Stock Location to Sales Channel
      await addSalesChannelsToStockLocation(stockLocationId, [salesChannelId]);

      // 4. Fetch Product with Inventory Items
      final productDetailsResponse = await fetchProductWithInventory(productId);
      final product = productDetailsResponse['product'];
      if (product == null) return;

      final List<dynamic> variants = product['variants'] ?? [];
      List<String> inventoryItemIds = [];
      for (var variant in variants) {
        final List<dynamic> inventoryItems = variant['inventory_items'] ?? [];
        for (var item in inventoryItems) {
          if (item['inventory_item_id'] != null) {
            inventoryItemIds.add(item['inventory_item_id']);
          }
        }
      }

      // 5. Update Stock for each Inventory Item
      for (var invId in inventoryItemIds) {
        try {
          await createInventoryLocationBatch(invId, stockLocationId, 1);
          await updateInventoryLocationLevel(invId, stockLocationId, 1);
          log("Background Success: Updated stock for $invId");
        } catch (e) {
          log("Background Error: Failed for $invId: $e");
        }
      }
      log("Background Success: All inventory updated for $productId.");
    } catch (e) {
      log("Background Critical Error: $e");
    }
  }

  Future<ProductTagListModel> fetchProductTags({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeProductTags,
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      return ProductTagListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ProductTypeListModel> fetchProductTypes({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeProductTypes,
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      return ProductTypeListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<SalesChannelsModel> fetchSalesChannels({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.vendorSalesChannels,
        // queryParameters: {
        //   'limit': limit.toString(),
        //   'offset': offset.toString(),
        // },
        isSeller: true,
      );
      return SalesChannelsModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorProducts,
        body: productData,
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ProductListModel> fetchVendorProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.vendorProducts,
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
          'fields': '+thumbnail,*categories,+status',
          'order': '-created_at',
        },
        isSeller: true,
      );
      return ProductListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> deleteProduct(String id) async {
    try {
      final response = await _apiService.delete(
        ApiConfig.vendorProductById(id),
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> uploadImages(List<File> imageFiles) async {
    try {
      final response = await _apiService.uploadImages(
        ApiConfig.vendorUploads,
        imageFiles,
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> fetchStockLocations() async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeStockLocations,
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> addSalesChannelsToStockLocation(
    String stockLocationId,
    List<String> salesChannelIds,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConfig.storeStockLocationsSalesChannels(stockLocationId),
        body: {"add": salesChannelIds},
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> fetchProductWithInventory(String productId) async {
    try {
      final response = await _apiService.get(
        ApiConfig.vendorProductById(productId),
        queryParameters: {'fields': '*variants.inventory_items'},
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> createInventoryLocationBatch(
    String inventoryItemId,
    String locationId,
    int quantity,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorInventoryItemsBatch(inventoryItemId),
        body: {
          "create": [
            {"location_id": locationId, "stocked_quantity": quantity},
          ],
          "update": [],
          "delete": [],
        },
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateInventoryLocationLevel(
    String inventoryItemId,
    String locationId,
    int quantity,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorInventoryItemsLocation(inventoryItemId, locationId),
        body: {"stocked_quantity": quantity},
        isSeller: true,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
