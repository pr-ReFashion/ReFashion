import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/address/model/google_map_model.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/common_base.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';
import 'package:refashion/env/env.dart';
import 'package:refashion/app/modules/address/widgets/map_marker_helper.dart';
import 'package:refashion/app/modules/address/services/address_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/utills/extension.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressFormController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final postcodeController = TextEditingController();
  final companyController = TextEditingController();
  final addressNameController = TextEditingController();
  final phoneCodeController = TextEditingController();

  Rx<Country> selectedPhoneCode = defaultCountry.obs;
  final RxList<String> countries = <String>[].obs;
  final RxBool isRegionsLoading = false.obs;
  final RxMap<String, String> countryCodeMap = <String, String>{}.obs;
  RxString selectedAddressCountry = ''.obs;

  // Phone validation regex: 6-12 digits
  final phoneRegex = RegExp(r'^[0-9]{6,12}$');

  final RxBool isChanged = false.obs;
  final RxBool isManualEntry = true.obs;
  final RxBool isSearchMode = false.obs;
  final RxBool isFormValid = false.obs;
  final RxBool isEditing = false.obs;
  AddressModel? currentAddress;

  final RxString addressSearchQuery = ''.obs;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Initial values to track changes
  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialMobile = '';
  String _initialAddress = '';
  String _initialCity = '';
  String _initialProvince = '';
  String _initialPostcode = '';
  String _initialCompany = '';
  String _initialAddressName = '';
  Country? _initialPhoneCode;
  String _initialAddressCountry = '';

  // Map related

  // Map related
  GoogleMapController? mapController;
  final Rx<CameraPosition> cameraPosition = const CameraPosition(
    target: LatLng(1.3506, 103.8517), // Default location
    zoom: 15,
  ).obs;

  final RxString selectedAddressName = ''.obs;
  final RxString selectedFullAddress = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedPostcode = ''.obs;

  final RxList<GooglePlacesModel> searchResults = <GooglePlacesModel>[].obs;
  final RxBool isMapLoading = false.obs;
  final RxBool isLocationLoading = false.obs;
  final RxBool isDraggingMap = false.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<BitmapDescriptor?> customMarkerIcon = Rx<BitmapDescriptor?>(null);

  Future<void> loadCustomMarker() async {
    customMarkerIcon.value = await MapMarkerHelper.getCustomMarker();
    if (cameraPosition.value.target.latitude != 0) {
      updateMarkerPosition(cameraPosition.value.target);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    loadCustomMarker();
  }

  void updateMarkerPosition(LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('delivery_pin'),
        position: latLng,
        icon: customMarkerIcon.value ?? BitmapDescriptor.defaultMarker,
        draggable: true,
        onDragEnd: (newPosition) {
          updateMarkerPosition(newPosition);
          reverseGeocode(newPosition.latitude, newPosition.longitude);
        },
      ),
    );
  }

  void onCameraMoveStarted() {
    isDraggingMap.value = true;
  }

  void onCameraMove(CameraPosition position) {
    cameraPosition.value = position;
  }

  void onCameraIdle() {
    isDraggingMap.value = false;
  }

  Future<void> reverseGeocode(double lat, double lng) async {
    try {
      String googleBaseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
      String request = '$googleBaseUrl?latlng=$lat,$lng&key=${Env.googleMapKey}';

      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String status = responseData['status'] ?? '';

        if (status == 'OK') {
          final List results = responseData['results'] ?? [];
          if (results.isNotEmpty) {
            final String fullAddress = results[0]['formatted_address'];
            final List addressComponents = results[0]['address_components'];

            String name = 'Unknown';
            String city = '';
            String postcode = '';

            for (var component in addressComponents) {
              final types = component['types'] as List;
              if (types.contains('route') || types.contains('neighborhood')) {
                name = component['long_name'];
              } else if (types.contains('locality') || types.contains('postal_town')) {
                city = component['long_name'];
              } else if (types.contains('postal_code')) {
                postcode = component['long_name'];
              }
            }

            selectedAddressName.value = name;
            selectedFullAddress.value = fullAddress;
            selectedCity.value = city;
            selectedPostcode.value = postcode;
          }
        }
      }
    } catch (e) {
      debugPrint('Exception while reverse geocoding: $e');
    }
  }

  void moveCamera(LatLng latLng) {
    cameraPosition.value = CameraPosition(target: latLng, zoom: 15);
    try {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition.value));
    } catch (e) {
      debugPrint('GoogleMapController animateCamera error: $e');
      // If the controller is disposed, nullify it to avoid further stale calls
      mapController = null;
    }
  }

  void onMapTap(LatLng latLng) {
    moveCamera(latLng);
    updateMarkerPosition(latLng);
    reverseGeocode(latLng.latitude, latLng.longitude);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  Future<void> onSuggestionSelected(GooglePlacesModel suggestion, {bool navigateToMap = false}) async {
    isLocationLoading.value = true;
    hideKeyboard(Get.context!);
    searchController.text = suggestion.description ?? '';
    searchQuery.value = suggestion.description ?? '';

    if (suggestion.placeId != null) {
      try {
        String detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${suggestion.placeId}&key=${Env.googleMapKey}';
        final response = await http.get(Uri.parse(detailsUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data['status'] == 'OK') {
            final result = data['result'];
            final location = result['geometry']['location'];
            final latLng = LatLng(location['lat'], location['lng']);

            moveCamera(latLng);
            updateMarkerPosition(latLng);

            selectedAddressName.value = suggestion.description ?? '';
            selectedFullAddress.value = suggestion.description ?? '';

            // Extract city and postcode from details if available
            final List addressComponents = result['address_components'] ?? [];
            for (var component in addressComponents) {
              final types = component['types'] as List;
              if (types.contains('locality') || types.contains('postal_town')) {
                selectedCity.value = component['long_name'];
              } else if (types.contains('postal_code')) {
                selectedPostcode.value = component['long_name'];
              }
            }

            // searchResults.clear();
            if (navigateToMap) {
              onSelectLocation();
            }
          }
        }
      } catch (e) {
        debugPrint('Exception while fetching place details: $e');
      } finally {
        isLocationLoading.value = false;
      }
    } else {
      isLocationLoading.value = false;
    }
  }

  Future<List<GooglePlacesModel>> getSuggestion(String input) async {
    if (input.isEmpty) {
      return [];
    }
    try {
      String googleBaseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

      // Restrict search to the selected country
      String countryCode = _getCountryCodeFromAddress(selectedAddressCountry.value);
      String components = countryCode.isNotEmpty ? '&components=country:$countryCode' : '';

      String request = '$googleBaseUrl?input=$input&key=${Env.googleMapKey}&sessiontoken=123456$components';

      debugPrint('Fetching suggestions for: $input in $countryCode');
      debugPrint('Request URL: $request');

      final response = await http.get(Uri.parse(request));
      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String status = responseData['status'] ?? '';

        if (status == 'OK') {
          final List predictions = responseData['predictions'] ?? [];
          return predictions.map((e) => GooglePlacesModel.fromJson(e)).toList();
        } else {
          debugPrint('Google Places API Error Status: $status');
          if (responseData.containsKey('error_message')) {
            debugPrint('Error Message: ${responseData['error_message']}');
          }
        }
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception while getting suggestions: $e');
    }
    return [];
  }

  Future<List<GooglePlacesModel>> getAddressSuggestions(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return [];
    }
    final List<GooglePlacesModel> results = await getSuggestion(query);
    searchResults.value = results;
    return results;
  }

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    // Add listeners to track changes
    firstNameController.addListener(checkChanges);
    lastNameController.addListener(checkChanges);
    mobileController.addListener(checkChanges);
    addressFormController.addListener(checkChanges);
    cityController.addListener(checkChanges);
    provinceController.addListener(checkChanges);
    postcodeController.addListener(checkChanges);
    companyController.addListener(checkChanges);
    addressNameController.addListener(checkChanges);
    ever(selectedPhoneCode, (_) => checkChanges());
    ever(selectedAddressCountry, (_) => checkChanges());

    fetchAddresses();

    // If editing (passed via arguments), populate form
    final args = Get.arguments;
    if (args is AddressModel) {
      isEditing.value = true;
      currentAddress = args;
      _populateForm(args);
    } else {
      isEditing.value = false;
      currentAddress = null;
      _setInitialValues();
    }
    fetchRegions();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final response = await AddressService().fetchAddresses();
      if (response != null && response['addresses'] != null) {
        final addressList = AddressListModel.fromJson(response);
        addresses.assignAll(addressList.addresses ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRegions() async {
    isRegionsLoading.value = true;
    try {
      final regionData = await AddressService().fetchRegions();
      if (regionData != null && regionData.regions != null) {
        final List<String> fetchedCountries = [];
        final Map<String, String> fetchedCodes = {};
        for (var region in regionData.regions!) {
          if (region.countries != null) {
            for (var country in region.countries!) {
              final String? name = country.displayName ?? country.name;
              if (name != null && country.iso2 != null) {
                fetchedCountries.add(name);
                fetchedCodes[name] = country.iso2!;
              }
            }
          }
        }
        if (fetchedCountries.isNotEmpty) {
          countries.assignAll(fetchedCountries);
          countryCodeMap.assignAll(fetchedCodes);

          // Handle selection after list is loaded
          if (isEditing.value) {
            final args = Get.arguments;
            if (args is AddressModel && args.countryCode != null) {
              String? foundName;
              for (var entry in countryCodeMap.entries) {
                if (entry.value.toLowerCase() == args.countryCode!.toLowerCase()) {
                  foundName = entry.key;
                  break;
                }
              }
              if (foundName != null) {
                _initialAddressCountry = foundName;
                selectedAddressCountry.value = foundName;
              }
            }
          }

          // Set a default if current selection is still empty or not in list
          if (selectedAddressCountry.value.isEmpty || !countries.contains(selectedAddressCountry.value)) {
            final defaultVal = countries.isNotEmpty ? countries.first : '';
            _initialAddressCountry = defaultVal;
            selectedAddressCountry.value = defaultVal;
          }
          checkChanges();
        }
      }
    } catch (e) {
      debugPrint('Error fetching regions: $e');
    } finally {
      isRegionsLoading.value = false;
    }
  }

  void _populateForm(AddressModel address) {
    firstNameController.text = address.firstName ?? '';
    lastNameController.text = address.lastName ?? '';
    mobileController.text = address.phone ?? '';
    addressFormController.text = address.address1 ?? '';
    cityController.text = address.city ?? '';
    provinceController.text = address.province ?? '';
    postcodeController.text = address.postalCode ?? '';
    companyController.text = address.company ?? '';
    addressNameController.text = address.addressName ?? '';

    // Try to find country name from code in the map
    if (address.countryCode != null) {
      String? foundName;
      for (var entry in countryCodeMap.entries) {
        if (entry.value.toLowerCase() == address.countryCode!.toLowerCase()) {
          foundName = entry.key;
          break;
        }
      }

      if (foundName != null) {
        selectedAddressCountry.value = foundName;
      } else if (countries.contains(address.countryCode)) {
        // Fallback if countryCode is actually a name
        selectedAddressCountry.value = address.countryCode!;
      }
    }

    _setInitialValues();
  }

  void _setInitialValues() {
    _initialFirstName = firstNameController.text;
    _initialLastName = lastNameController.text;
    _initialMobile = mobileController.text;
    _initialAddress = addressFormController.text;
    _initialCity = cityController.text;
    _initialProvince = provinceController.text;
    _initialPostcode = postcodeController.text;
    _initialCompany = companyController.text;
    _initialAddressName = addressNameController.text;
    _initialPhoneCode = selectedPhoneCode.value;
    _initialAddressCountry = selectedAddressCountry.value;
    validateForm();
    checkChanges();
  }

  void validateForm() {
    isFormValid.value =
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        phoneRegex.hasMatch(mobileController.text) &&
        addressFormController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        provinceController.text.isNotEmpty &&
        postcodeController.text.isNotEmpty;
  }

  void checkChanges() {
    validateForm();
    isChanged.value =
        firstNameController.text != _initialFirstName ||
        lastNameController.text != _initialLastName ||
        mobileController.text != _initialMobile ||
        addressFormController.text != _initialAddress ||
        cityController.text != _initialCity ||
        provinceController.text != _initialProvince ||
        postcodeController.text != _initialPostcode ||
        companyController.text != _initialCompany ||
        addressNameController.text != _initialAddressName ||
        selectedPhoneCode.value.countryCode != _initialPhoneCode?.countryCode ||
        selectedAddressCountry.value != _initialAddressCountry;
  }

  void onAddAddressTap() {
    // Reset form and navigate to form
    _clearForm();
    Get.toNamed(Routes.addressForm);
  }

  void onEditAddressTap(AddressModel address, {bool isNewAddress = false}) {
    isEditing.value = !isNewAddress;
    _populateForm(address);
    Get.toNamed(Routes.addressForm, arguments: address);
  }

  void onDeleteAddressTap(AddressModel address) {
    _showDeleteConfirmation(address);
  }

  void _showDeleteConfirmation(AddressModel address) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorHelper.offWhite, borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.value.deleteAddress,
                    style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.headingColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    locale.value.confirmDeleteAddress,
                    style: TextStyleHelper.dmRegular400().copyWith(fontSize: 12.sp, color: ColorHelper.subHeadingColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CommonBtn(
                    onTap: () => Get.back(),
                    text: locale.value.cancelText,
                    color: ColorHelper.white,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.borderColor),
                    ),
                    textColor: ColorHelper.subHeadingColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    onTap: () {
                      Get.back();
                      if (address.id != null) {
                        deleteAddress(address.id!);
                      }
                    },
                    text: locale.value.deleteText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> deleteAddress(String addressId) async {
    isLoading.value = true;
    try {
      await AddressService().deleteAddress(addressId);
      toast(locale.value.addressDeletedSuccessfully);
      await fetchAddresses();
    } catch (e) {
      toast(e.toString());
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    mobileController.clear();
    addressFormController.clear();
    cityController.clear();
    provinceController.clear();
    postcodeController.clear();
    companyController.clear();
    addressNameController.clear();
    selectedPhoneCode.value = defaultCountry;
    selectedAddressCountry.value = countries.isNotEmpty ? countries.first : '';
    isEditing.value = false;
    currentAddress = null;
    _setInitialValues();
  }

  Future<void> onUpdateAddress() async {
    if (!isFormValid.value) return;

    isActionLoading.value = true;
    try {
      final countryCode = _getCountryCodeFromAddress(selectedAddressCountry.value);

      final Map<String, dynamic> body = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'phone': mobileController.text.trim(),
        'address_1': addressFormController.text.trim(),
        'city': cityController.text.trim(),
        'company': companyController.text.trim(),
        'province': provinceController.text.trim(),
        'country_code': countryCode.toLowerCase(),
        'postal_code': postcodeController.text.trim(),
        'address_name': addressNameController.text.trim(),
        'is_default_shipping': isEditing.value ? (currentAddress?.isDefaultShipping ?? false) : addresses.isEmpty,
        'is_default_billing': isEditing.value ? (currentAddress?.isDefaultBilling ?? false) : false,
      };

      if (isEditing.value) {
        final addressId = currentAddress?.id;
        if (addressId != null) {
          await AddressService().updateAddress(addressId, body);
          toast(locale.value.addressUpdatedSuccessfully);
        }
      } else {
        await AddressService().addAddress(body);
        toast(locale.value.addressAddedSuccessfully);
      }

      await fetchAddresses();
      if (isEditing.value) {
        Get.back();
      } else {
        Get.until((route) => route.settings.name == Routes.address);
      }
    } catch (e) {
      toast(e.toString());
      log(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  void onEnterLocationManually() {
    // _clearForm();
    Get.toNamed(Routes.addressForm);
  }

  void onAddressSearchTap() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
    Get.toNamed(Routes.addressSearch);
  }

  void onSelectLocation() {
    hideKeyboard(Get.context!);
    Get.toNamed(Routes.selectDeliveryAddress);
  }

  Future<void> onUseCurrentLocationTap() async {
    isLocationLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationLoading.value = false;
        toast(locale.value.locationServicesDisabled);
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLocationLoading.value = false;
          toast(locale.value.locationPermissionDenied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLocationLoading.value = false;
        toast(locale.value.locationPermissionPermanentlyDenied);
        await Geolocator.openAppSettings();
        return;
      }

      // Industry standard: Try last known position for speed
      Position? position = await Geolocator.getLastKnownPosition();

      // If no last known position, get current position with medium accuracy for speed
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
      );

      // Update map camera and marker
      cameraPosition.value = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15);
      updateMarkerPosition(LatLng(position.latitude, position.longitude));
      // Reverse geocode in background to fill address details
      await reverseGeocode(position.latitude, position.longitude);

      // Fast navigation: Go to map page immediately
      hideKeyboard(Get.context!);
      Get.toNamed(Routes.selectDeliveryAddress);
      isLocationLoading.value = false;
    } catch (e) {
      isLocationLoading.value = false;
      debugPrint('Error getting location: $e');
      // If it fails but we want to be user friendly, just go to the map with default or show error
      hideKeyboard(Get.context!);
      Get.toNamed(Routes.selectDeliveryAddress);
    }
  }

  void onConfirmLocation() {
    // Set form field values from selected location
    addressFormController.text = selectedFullAddress.value;
    cityController.text = selectedCity.value;
    postcodeController.text = selectedPostcode.value;
    // Province might be available from maps as well if we wanted, but for now we focus on user input

    // Navigate to Address Form
    Get.toNamed(Routes.addressForm);
  }

  void onPhoneCodeTap(BuildContext context) {
    Get.focusScope?.unfocus();
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        selectedPhoneCode.value = country;
      },
    );
  }

  void showCountryPickerSheet(BuildContext context) {
    Get.focusScope?.unfocus();
    int initialIndex = countries.indexOf(selectedAddressCountry.value);
    if (initialIndex == -1) initialIndex = 0;
    int tempSelectedIndex = initialIndex;

    Get.bottomSheet(
      Container(
        height: 300.h,
        color: ColorHelper.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  selectedAddressCountry.value = countries[tempSelectedIndex];
                  Get.back();
                },
                child: Text(
                  locale.value.doneText,
                  style: TextStyleHelper.urSemiBold600().copyWith(color: ColorHelper.subHeadingColor, fontSize: 14.sp),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => isRegionsLoading.value
                    ? const SpinKitCircle(color: ColorHelper.primary)
                    : countries.isEmpty
                    ? Center(child: Text(locale.value.noCountriesAvailable, style: TextStyleHelper.urRegular400()))
                    : CupertinoPicker(
                        itemExtent: 40.h,
                        scrollController: FixedExtentScrollController(initialItem: initialIndex),
                        onSelectedItemChanged: (index) {
                          tempSelectedIndex = index;
                        },
                        children: countries
                            .map(
                              (e) => Center(
                                child: Text(
                                  '${(countryCodeMap[e] ?? '').toFlagEmoji()}  $e',
                                  style: TextStyleHelper.urRegular400().copyWith(fontSize: 18.sp, color: ColorHelper.headingColor),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCountryCodeFromAddress(String countryName) {
    return countryCodeMap[countryName] ?? '';
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    addressFormController.dispose();
    cityController.dispose();
    provinceController.dispose();
    postcodeController.dispose();
    companyController.dispose();
    addressNameController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
