import 'package:refashion/app/modules/order_details/models/order_detail_model.dart';
import 'package:refashion/app/modules/order_details/models/return_reasom_model.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';

class OrderDetailsService {
  Future<OrderDetailModel?> fetchOrderDetail(String orderId) async {
    try {
      final response = await ApiService().get(ApiConfig.storeOrdersId(orderId));
      if (response != null) {
        return OrderDetailModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderDetailModel?> fetchVendorOrderDetail(String orderId) async {
    try {
      final response = await ApiService().get(
        ApiConfig.vendorOrdersId(orderId),
        isSeller: true,
      );
      if (response != null) {
        return OrderDetailModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReturnReasonModel?> fetchReturnReasons() async {
    try {
      final response = await ApiService().get(ApiConfig.storeReturnReasons);
      if (response != null) {
        return ReturnReasonModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createReturn(Map<String, dynamic> data) async {
    try {
      final response = await ApiService().post(
        ApiConfig.storeReturns,
        body: data,
      );
      return response != null;
    } catch (e) {
      rethrow;
    }
  }
}
