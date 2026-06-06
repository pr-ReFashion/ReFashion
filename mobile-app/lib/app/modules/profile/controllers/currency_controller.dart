import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/profile/model/currency_model.dart';
import 'package:refashion/app/modules/profile/service/currency_api_service.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class CurrencyController extends GetxController {
  static CurrencyController get to => Get.find();

  final CurrencyApiService _apiService = CurrencyApiService();
  final RxBool isInitialLoading = false.obs;
  final RxBool isFetching = false.obs;

  final Rx<CurrencyModel> _selectedCurrency = CurrencyModel(
    code: 'eur',
    name: 'Euro',
    symbol: '€',
    symbolNative: '€',
  ).obs;

  CurrencyModel get selectedCurrency => _selectedCurrency.value;

  final RxList<CurrencyModel> availableCurrencies = <CurrencyModel>[].obs;
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    _loadCurrency();
    fetchCurrencies(isInitial: true);
  }

  Future<void> fetchCurrencies({
    bool isRefresh = false,
    String? search,
    bool isInitial = false,
  }) async {
    try {
      if (isInitial) isInitialLoading.value = true;

      if (search != null || isRefresh) {
        if (search != null) searchQuery = search;
        isFetching.value = true;
      }

      final response = await _apiService.fetchCurrencies(search: searchQuery);

      if (response.currencies != null) {
        availableCurrencies.assignAll(response.currencies!);
      }
    } catch (e) {
      debugPrint('Error fetching currencies: $e');
    } finally {
      isInitialLoading.value = false;
      isFetching.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery = query;
    fetchCurrencies(search: query);
  }

  void _loadCurrency() {
    final savedData = HiveUtils.get(HiveKeys.selectedCurrency);
    debugPrint('CurrencyController: Loading from Hive: $savedData');
    if (savedData != null && savedData is Map) {
      try {
        _selectedCurrency.value = CurrencyModel.fromJson(
          Map<String, dynamic>.from(savedData),
        );
        debugPrint(
          'CurrencyController: Loaded selection: ${_selectedCurrency.value.code}',
        );
      } catch (e) {
        debugPrint('Error loading currency: $e');
      }
    }
  }

  Future<void> changeCurrency(CurrencyModel currency) async {
    debugPrint('CurrencyController: Changing currency to: ${currency.code}');
    _selectedCurrency.value = currency;
    await HiveUtils.set(HiveKeys.selectedCurrency, currency.toJson());
  }
}
