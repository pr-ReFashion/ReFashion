import 'package:refashion/app/modules/buying/models/order_list_model.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';

class BuyingService {
  Future<OrderListModel?> fetchOrders() async {
    try {
      final response = await ApiService().get(
        ApiConfig.storeOrders,
        queryParameters: {'order': '-created_at'},
      );
      if (response != null) {
        return OrderListModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
