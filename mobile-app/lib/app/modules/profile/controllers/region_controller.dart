import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/address/model/country_list_model.dart';
import 'package:refashion/app/modules/address/services/address_service.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';

class RegionController extends GetxController {
  static RegionController get to => Get.find();

  final AddressService _addressService = AddressService();
  final RxBool isLoading = false.obs;

  final Rx<Region?> _selectedRegion = Rx<Region?>(null);
  Region? get selectedRegion => _selectedRegion.value;

  final Rx<Country?> _selectedCountry = Rx<Country?>(null);
  Country? get selectedCountry => _selectedCountry.value;

  final RxList<Region> availableRegions = <Region>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegion();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    try {
      isLoading.value = true;
      final response = await _addressService.fetchRegions();
      if (response?.regions != null) {
        availableRegions.assignAll(response!.regions!);

        // If no region was selected/saved, take the first one as default
        if (_selectedRegion.value == null && availableRegions.isNotEmpty) {
          final firstRegion = availableRegions.first;
          await selectRegion(firstRegion);
        } else if (_selectedRegion.value != null) {
          // Sync reference
          final index = availableRegions.indexWhere(
            (e) => e.id == _selectedRegion.value!.id,
          );
          if (index != -1) {
            _selectedRegion.value = availableRegions[index];

            // Sync country reference
            final savedCountryCode = HiveUtils.get(
              HiveKeys.selectedCountryCode,
            );
            if (savedCountryCode != null &&
                _selectedRegion.value!.countries != null) {
              _selectedCountry.value = _selectedRegion.value!.countries!
                  .firstWhereOrNull((e) => e.iso2 == savedCountryCode);
            }

            // Default country if none selected/found
            if (_selectedCountry.value == null &&
                _selectedRegion.value!.countries != null &&
                _selectedRegion.value!.countries!.isNotEmpty) {
              _selectedCountry.value = _selectedRegion.value!.countries!.first;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching regions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadRegion() {
    final savedRegionData = HiveUtils.get(HiveKeys.selectedRegion);
    if (savedRegionData != null && savedRegionData is Map) {
      try {
        _selectedRegion.value = Region.fromJson(
          Map<String, dynamic>.from(savedRegionData),
        );
      } catch (e) {
        debugPrint('Error loading saved region: $e');
      }
    }

    final savedCountryCode = HiveUtils.get(HiveKeys.selectedCountryCode);
    if (savedCountryCode != null && _selectedRegion.value != null) {
      _selectedCountry.value = _selectedRegion.value!.countries
          ?.firstWhereOrNull((e) => e.iso2 == savedCountryCode);
    }
  }

  Future<void> selectRegion(Region region, {Country? country}) async {
    _selectedRegion.value = region;
    await HiveUtils.set(HiveKeys.selectedRegion, region.toJson());
    if (region.id != null) {
      await HiveUtils.set(HiveKeys.regionId, region.id!);
    }

    // Default to first country if none provided
    final targetCountry =
        country ??
        (region.countries != null && region.countries!.isNotEmpty
            ? region.countries!.first
            : null);

    if (targetCountry != null) {
      await selectCountry(targetCountry);
    }

    // Auto-update currency if it matches the region code
    if (region.currencyCode != null) {
      final currencyController = Get.find<CurrencyController>();
      final currency = currencyController.availableCurrencies.firstWhereOrNull(
        (e) => e.code?.toLowerCase() == region.currencyCode?.toLowerCase(),
      );
      if (currency != null) {
        await currencyController.changeCurrency(currency);
      }
    }
  }

  Future<void> selectCountry(Country country) async {
    _selectedCountry.value = country;
    if (country.iso2 != null) {
      await HiveUtils.set(HiveKeys.selectedCountryCode, country.iso2!);
    }
  }
}
