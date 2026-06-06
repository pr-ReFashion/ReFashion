import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/modules/profile/controllers/region_controller.dart';
import 'package:refashion/app/modules/profile/model/currency_model.dart';
import 'package:refashion/app/modules/profile/model/locale_list_model.dart';
import 'package:refashion/app/modules/profile/service/locale_api_service.dart';
import 'package:refashion/app/modules/address/model/country_list_model.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class LanguageCurrencyController extends GetxController {
  final LocaleApiService _localeApiService = LocaleApiService();
  final RxBool isLocalesLoading = false.obs;

  final Rx<LocaleModel?> _selectedLocale = Rx<LocaleModel?>(null);
  LocaleModel? get selectedLocale => _selectedLocale.value;
  final Rx<LocaleModel?> tempSelectedLocale = Rx<LocaleModel?>(null);

  // Use CurrencyController and RegionController for global state
  CurrencyController get currencyController => CurrencyController.to;
  RegionController get regionController => RegionController.to;

  late Rx<Region?> tempSelectedRegion;
  late Rx<Country?> tempSelectedCountry;
  late Rx<CurrencyModel> tempSelectedCurrency;

  final RxList<LocaleModel> availableLocales = <LocaleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    tempSelectedCurrency = currencyController.selectedCurrency.obs;
    tempSelectedRegion = regionController.selectedRegion.obs;
    tempSelectedCountry = regionController.selectedCountry.obs;
    // _loadSavedLocale();
    // Reset search when entering the page
    currencyController.onSearch('');
    // fetchLocales();
  }

  // void _loadSavedLocale() {
  //   final savedData = HiveUtils.get(HiveKeys.selectedLocale);
  //   if (savedData != null && savedData is Map) {
  //     try {
  //       _selectedLocale.value = LocaleModel.fromJson(
  //         Map<String, dynamic>.from(savedData),
  //       );
  //       tempSelectedLocale.value = _selectedLocale.value;
  //     } catch (e) {
  //       debugPrint('Error loading saved locale: $e');
  //     }
  //   }
  // }

  Future<void> fetchLocales() async {
    try {
      isLocalesLoading.value = true;
      final response = await _localeApiService.fetchLocales();
      if (response.locales != null) {
        availableLocales.assignAll(response.locales!);

        // If no locale was loaded from Hive, set a default
        if (_selectedLocale.value == null && availableLocales.isNotEmpty) {
          final defaultLocale = availableLocales.firstWhere(
            (element) => element.name == 'English',
            orElse: () => availableLocales.first,
          );
          _selectedLocale.value = defaultLocale;
          tempSelectedLocale.value = defaultLocale;
        } else if (_selectedLocale.value != null) {
          // Sync the selected locale object with the one in the list to ensure reference equality for dropdown
          final index = availableLocales.indexWhere(
            (element) => element.code == _selectedLocale.value?.code,
          );
          if (index != -1) {
            _selectedLocale.value = availableLocales[index];
            tempSelectedLocale.value = availableLocales[index];
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching locales: $e');
    } finally {
      isLocalesLoading.value = false;
    }
  }

  void onLanguageChanged(LocaleModel? value) {
    if (value != null) {
      tempSelectedLocale.value = value;
    }
  }

  void onRegionChanged(Region? value) {
    if (value != null) {
      tempSelectedRegion.value = value;
      if (value.countries != null && value.countries!.isNotEmpty) {
        tempSelectedCountry.value = value.countries!.first;
      } else {
        tempSelectedCountry.value = null;
      }

      // Auto-select currency based on region
      if (value.currencyCode != null) {
        final currency = currencyController.availableCurrencies
            .firstWhereOrNull(
              (e) => e.code?.toLowerCase() == value.currencyCode?.toLowerCase(),
            );
        if (currency != null) {
          tempSelectedCurrency.value = currency;
        } else {
          debugPrint(
            'Currency ${value.currencyCode} not found in available currencies',
          );
        }
      }
    }
  }

  void onCountryChanged(Country? value) {
    if (value != null) {
      tempSelectedCountry.value = value;
    }
  }

  void onCurrencyChanged(CurrencyModel? value) {
    if (value != null) {
      tempSelectedCurrency.value = value;
    }
  }

  Future<void> onUpdateTap() async {
    // Save Currency
    await currencyController.changeCurrency(tempSelectedCurrency.value);

    // Save Language
    if (tempSelectedLocale.value != null) {
      _selectedLocale.value = tempSelectedLocale.value;
      await HiveUtils.set(
        HiveKeys.selectedLocale,
        tempSelectedLocale.value!.toJson(),
      );
    }

    // Save Region and Country
    if (tempSelectedRegion.value != null) {
      await regionController.selectRegion(
        tempSelectedRegion.value!,
        country: tempSelectedCountry.value,
      );
    }

    Get.back();
  }
}
