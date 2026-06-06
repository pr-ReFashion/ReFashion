import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';

class AuthApiService {
  final ApiService _apiService = ApiService();

  Future<dynamic> register({
    required String email,
    required String password,
  }) async {
    final body = {"email": email, "password": password};

    return await _apiService.post(
      ApiConfig.authCustomerEmailpassRegister,
      body: body,
    );
  }

  Future<dynamic> sellerRegister({
    required String email,
    required String password,
  }) async {
    try {
      final sellerEmail = "$email.refashion";
      final body = {"email": sellerEmail, "password": password};

      return await _apiService.post(
        ApiConfig.authSellerEmailpassRegister,
        body: body,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = {"email": email, "password": password};

      return await _apiService.post(
        ApiConfig.authCustomerEmailpassLogin,
        body: body,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> sellerLogin({
    required String email,
    required String password,
  }) async {
    try {
      final sellerEmail = "$email.refashion";
      final body = {"email": sellerEmail, "password": password};

      return await _apiService.post(
        ApiConfig.authSellerEmailpassLogin,
        body: body,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> resetPassword({required String identifier}) async {
    final body = {"identifier": identifier};

    return await _apiService.post(ApiConfig.customerResetPassword, body: body);
  }

  Future<dynamic> updatePassword({
    required String email,
    required String password,
    required String token,
  }) async {
    final body = {"email": email, "password": password};

    return await _apiService.post(
      ApiConfig.customerUpdatePassword,
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
