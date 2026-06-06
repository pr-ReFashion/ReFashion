import 'package:refashion/app/modules/profile/model/customer_model.dart';
import 'package:refashion/app/modules/profile/model/seller_model.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/env/env.dart';

class ProfileApiService {
  final ApiService _apiService = ApiService();

  Future<void> deleteAccount(String customerId) async {
    try {
      await _apiService.delete(
        ApiConfig.adminCustomerForceDelete(customerId),
        headers: {'Authorization': 'Basic ${Env.secretKey}'},
        body: {},
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CustomerModel> getCustomerInfo({bool isRetry = true}) async {
    try {
      final response = await _apiService.get(
        ApiConfig.storeCustomerMe,
        isRetry: isRetry,
      );

      if (response is Map<String, dynamic>) {
        return CustomerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CustomerModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConfig.storeCustomerMe,
        body: data,
      );

      if (response is Map<String, dynamic>) {
        return CustomerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConfig.storeCustomers,
        body: data,
      );

      if (response is Map<String, dynamic>) {
        return CustomerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SellerModel> getSellerInfo() async {
    try {
      final response = await _apiService.get(
        ApiConfig.vendorSellersMe,
        isSeller: true,
      );
      if (response is Map<String, dynamic>) {
        return SellerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SellerModel> registerSeller(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorSellers,
        body: data,
        isSeller: true,
      );
      if (response is Map<String, dynamic>) {
        return SellerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SellerModel> updateSellerInfo(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConfig.vendorSellersMe,
        body: data,
        isSeller: true,
      );
      if (response is Map<String, dynamic>) {
        return SellerModel.fromJson(response);
      } else {
        throw "Invalid response format";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
