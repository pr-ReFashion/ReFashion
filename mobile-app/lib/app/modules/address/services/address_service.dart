import 'package:refashion/app/modules/address/model/country_list_model.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';

class AddressService {
  Future<CountryListModel?> fetchRegions() async {
    try {
      final response = await ApiService().get(ApiConfig.storeRegions);
      if (response != null) {
        return CountryListModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addAddress(Map<String, dynamic> body) async {
    try {
      return await ApiService().post(ApiConfig.customerMeAddresses, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateAddress(String id, Map<String, dynamic> body) async {
    try {
      return await ApiService().post(
        ApiConfig.customerAddressById(id),
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchAddresses() async {
    try {
      return await ApiService().post(ApiConfig.customerAddress, body: {});
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteAddress(String id) async {
    try {
      return await ApiService().delete(ApiConfig.customerAddressById(id));
    } catch (e) {
      rethrow;
    }
  }
}
