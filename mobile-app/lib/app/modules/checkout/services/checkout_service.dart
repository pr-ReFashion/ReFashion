import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/modules/checkout/model/shipping_option_model.dart';

class CheckoutService {
  Future<List<ShippingOption>> fetchShippingOptions(String cartId) async {
    try {
      final response = await ApiService().get(
        ApiConfig.storeShippingOptions(cartId),
      );
      if (response != null && response['shipping_options'] != null) {
        return (response['shipping_options'] as List)
            .map((e) => ShippingOption.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> applyPromotionCode(
    String cartId,
    String promoCode,
  ) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storeCartPromotions(cartId),
        body: {
          "promo_codes": [promoCode],
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> removePromotionCode(
    String cartId,
    String promoCode,
  ) async {
    try {
      final response = await ApiService().delete(
        ApiConfig.storeCartPromotions(cartId),
        body: {
          "promo_codes": [promoCode],
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateCart(
    String cartId,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storeCart(cartId),
        body: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addShippingMethod(
    String cartId,
    String optionId,
  ) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storeCartShippingMethods(cartId),
        body: {"option_id": optionId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createPaymentCollection(String cartId) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storePaymentCollections,
        body: {"cart_id": cartId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createPaymentSession(
    String paymentCollectionId,
  ) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storePaymentSessions(paymentCollectionId),
        body: {"provider_id": "pp_system_default"},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> completeCart(String cartId) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storeCartComplete(cartId),
        body: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
