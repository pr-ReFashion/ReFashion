import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';

class CartApiService {
  final ApiService _apiService = ApiService();

  Future<dynamic> createCart({
    required String regionId,
    required String email,
    required String currencyCode,
  }) async {
    final body = {
      "region_id": regionId,
      "email": email,
      "currency_code": currencyCode,
    };

    return await _apiService.post(ApiConfig.storeCarts, body: body);
  }

  Future<dynamic> addLineItem({
    required String cartId,
    required String variantId,
    int quantity = 1,
    Map<String, dynamic>? metadata,
  }) async {
    final body = {
      "variant_id": variantId,
      "quantity": quantity,
      if (metadata != null) "metadata": metadata,
    };

    return await _apiService.post(
      ApiConfig.storeCartLineItems(cartId),
      body: body,
    );
  }

  Future<dynamic> fetchCart(String cartId) async {
    try {
      return await _apiService.get(ApiConfig.storeCart(cartId));
    } catch (e) {
      toast(e.toString());
      return null;
    }
  }

  Future<dynamic> deleteLineItem(String cartId, String lineId) async {
    try {
      return await _apiService.delete(
        ApiConfig.storeCartLineItemDelete(cartId, lineId),
      );
    } catch (e) {
      toast(e.toString());
      return null;
    }
  }
}
