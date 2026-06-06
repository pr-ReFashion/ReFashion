import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/bag/controllers/bag_controller.dart';
import 'package:refashion/app/services/cart_controller.dart';
import 'package:refashion/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:refashion/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/modules/profile/controllers/profile_controller.dart';
import 'package:refashion/app/modules/sell/controllers/sell_controller.dart';
import 'package:refashion/app/modules/stats/controllers/stats_controller.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/env/env.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final String baseUrl;
  final Duration timeoutDuration = const Duration(seconds: 60);

  ApiService._internal({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  Future<Map<String, String>> _getHeaders({Map<String, String>? extraHeaders, bool isSeller = false}) async {
    final Map<String, String> headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'x-publishable-api-key': Env.publishableKey};

    final tokenKey = isSeller ? HiveKeys.sellerToken : HiveKeys.authToken;

    if (HiveUtils.isContainKey(tokenKey)) {
      final token = HiveUtils.get(tokenKey);
      if (token != null && token.toString().trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  // GET Request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers, Map<String, dynamic>? queryParameters, bool isSeller = false, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParameters);
      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);

      final response = await http.get(uri, headers: finalHeaders).timeout(timeoutDuration);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return get(endpoint, headers: headers, queryParameters: queryParameters, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'GET');
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers, bool isSeller = false, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);

      final response = await http.post(uri, headers: finalHeaders, body: jsonEncode(body)).timeout(timeoutDuration);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return post(endpoint, body: body, headers: headers, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'POST');
    }
  }

  // PATCH Request
  Future<dynamic> patch(String endpoint, {dynamic body, Map<String, String>? headers, bool isSeller = false, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);

      final response = await http.patch(uri, headers: finalHeaders, body: jsonEncode(body)).timeout(timeoutDuration);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return patch(endpoint, body: body, headers: headers, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'PATCH');
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers, dynamic body, bool isSeller = false, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);

      final response = await http.delete(uri, headers: finalHeaders, body: body != null ? jsonEncode(body) : null).timeout(timeoutDuration);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return delete(endpoint, headers: headers, body: body, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'DELETE');
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, {Map<String, String>? headers, bool isSeller = false, dynamic body, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);

      final response = await http.put(uri, headers: finalHeaders, body: body != null ? jsonEncode(body) : null).timeout(timeoutDuration);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return put(endpoint, headers: headers, body: body, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'PUT');
    }
  }

  // Upload Multiple Images
  Future<dynamic> uploadImages(String endpoint, List<File> imageFiles, {Map<String, String>? fields, Map<String, String>? headers, bool isSeller = false, bool isRetry = false}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final request = http.MultipartRequest('POST', uri);

      final finalHeaders = await _getHeaders(extraHeaders: headers, isSeller: isSeller);
      request.headers.addAll(finalHeaders);

      for (var imageFile in imageFiles) {
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();

        final multipartFile = http.MultipartFile('files', fileStream, fileLength, filename: imageFile.path.split('/').last);
        request.files.add(multipartFile);
      }

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401 && !endpoint.contains('auth/')) {
        if (!isRetry) {
          final success = await _reLogin(isSeller: isSeller);
          if (success) {
            return uploadImages(endpoint, imageFiles, fields: fields, headers: headers, isSeller: isSeller, isRetry: true);
          }
        }
        await logout();
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'UPLOAD');
    }
  }

  // Upload Image
  Future<dynamic> uploadImage(String endpoint, File imageFile, {Map<String, String>? fields, Map<String, String>? headers, bool isSeller = false, bool isRetry = false}) async {
    return uploadImages(endpoint, [imageFile], fields: fields, headers: headers, isSeller: isSeller, isRetry: isRetry);
  }

  // Handle API Response
  dynamic _handleResponse(http.Response response) {
    String requestBody = "";
    if (response.request is http.Request) {
      requestBody = (response.request as http.Request).body;
    } else if (response.request is http.MultipartRequest) {
      requestBody = (response.request as http.MultipartRequest).fields.toString();
    }

    apiPrint(
      url: response.request?.url.toString() ?? "",
      headers: jsonEncode(response.request?.headers),
      statusCode: response.statusCode,
      request: response.request?.toString() ?? "",
      requestBody: requestBody,
      responseBody: response.body,
      methodtype: response.request?.method ?? "",
    );

    final responseBody = response.body;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseBody.trim().isEmpty) return {};
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        return responseBody;
      }
    } else {
      String errorMessage = _getMessageForStatusCode(response.statusCode);

      try {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'];
        } else if (decoded is Map && decoded.containsKey('error')) {
          errorMessage = decoded['error'];
        }
      } catch (_) {}

      throw errorMessage;
    }
  }

  // Auto Logout Function
  Future<void> logout({bool forceLogout = false}) async {
    // Clear all auth tokens and credentials
    await HiveUtils.remove(HiveKeys.authToken);
    await HiveUtils.remove(HiveKeys.sellerToken);
    if (forceLogout) {
      await HiveUtils.remove(HiveKeys.userPassword);
    }

    //Selective deletion of dashboard-related controllers
    try {
      if (Get.isRegistered<CartController>()) {
        CartController.to.clearCartCount();
      }

      if (Get.isRegistered<HomeController>()) Get.delete<HomeController>();
      if (Get.isRegistered<FavoriteController>()) {
        Get.delete<FavoriteController>();
      }
      if (Get.isRegistered<BagController>()) Get.delete<BagController>();
      if (Get.isRegistered<SellController>()) Get.delete<SellController>();
      if (Get.isRegistered<StatsController>()) Get.delete<StatsController>();
      if (Get.isRegistered<ProfileController>()) {
        Get.delete<ProfileController>();
      }
      if (Get.isRegistered<DashboardController>()) {
        Get.delete<DashboardController>();
      }
    } catch (e) {
      debugPrint("Error deleting controllers on logout: $e");
    }

    // Navigate to SignInOption and clear stack
    Get.offAllNamed(Routes.signInOption);
  }

  // Re-login logic for 401 recovery
  Future<bool> _reLogin({bool isSeller = false}) async {
    try {
      if (!HiveUtils.isContainKey(HiveKeys.userEmail) || !HiveUtils.isContainKey(HiveKeys.userPassword)) {
        return false;
      }

      final email = HiveUtils.get(HiveKeys.userEmail);
      final password = HiveUtils.get(HiveKeys.userPassword);

      if (email == null || password == null) return false;

      final authEndpoint = isSeller ? ApiConfig.authSellerEmailpassLogin : ApiConfig.authCustomerEmailpassLogin;

      final uri = Uri.parse('$baseUrl/$authEndpoint');
      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'x-publishable-api-key': Env.publishableKey}, body: jsonEncode({"email": email, "password": password}))
          .timeout(timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded != null && decoded['token'] != null) {
          final tokenKey = isSeller ? HiveKeys.sellerToken : HiveKeys.authToken;
          await HiveUtils.set(tokenKey, decoded['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Re-login error: $e");
      return false;
    }
  }

  String _getMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return locale.value.errorBadRequest;
      case 401:
        return locale.value.errorUnauthorized;
      case 403:
        return locale.value.errorForbidden;
      case 404:
        return locale.value.errorNotFound;
      case 500:
        return locale.value.errorInternalServer;
      case 502:
        return locale.value.errorBadGateway;
      case 503:
        return locale.value.errorServiceUnavailable;
      default:
        return locale.value.errorUnknown;
    }
  }

  dynamic _handleError(dynamic e, String method) {
    if (e is String) throw e;

    if (e is SocketException) {
      throw locale.value.lblInternetNotAvailableTitle;
    } else if (e is http.ClientException) {
      throw locale.value.errorUnknown;
    } else if (e.toString().contains('TimeoutException')) {
      throw locale.value.errorTimeout;
    }

    final String errorStr = e.toString();
    // Remove "Exception: " prefix if present for cleaner UI display
    throw errorStr.startsWith('Exception: ') ? errorStr.replaceFirst('Exception: ', '') : errorStr;
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  String requestBody = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93m Method: \u001B[39m \u001b[96m$methodtype\u001B[39m");
  log("\u001b[93m Url: \u001B[39m $url");
  log("\u001b[93m Header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) {
    log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  }
  if (requestBody.isNotEmpty) {
    log("\u001b[93m Request Body: \u001B[39m \u001b[96m$requestBody\u001B[39m");
  }
  log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
  log('Response $statusCode: $responseBody');
  log("\u001B[0m");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}
