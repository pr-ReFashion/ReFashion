import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/auth/service/auth_api_service.dart';
import 'package:refashion/app/modules/address/services/address_service.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';

class PersonalInfoController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final AuthApiService _authApiService = AuthApiService();
  final ApiService _apiService = ApiService();
  final AddressService _addressService = AddressService();

  late final Map<String, TextEditingController> _controllers;

  TextEditingController get firstNameController => _controllers['first_name']!;

  TextEditingController get lastNameController => _controllers['last_name']!;

  TextEditingController get emailController => _controllers['email']!;

  TextEditingController get bioController => _controllers['bio']!;

  TextEditingController get locationController => _controllers['location']!;

  TextEditingController get refashionIdController => _controllers['refashion_id']!;

  TextEditingController get usernameController => _controllers['username']!;

  TextEditingController get phoneController => _controllers['phone']!;

  TextEditingController get companyNameController => _controllers['company_name']!;

  TextEditingController get storeNameController => _controllers['store_name']!;

  TextEditingController get vatNumberController => _controllers['vat_number']!;

  TextEditingController get taxOfficeController => _controllers['tax_office']!;

  TextEditingController get sellerEmailController => _controllers['seller_email']!;

  TextEditingController get addressLineController => _controllers['address_line']!;

  TextEditingController get postalCodeController => _controllers['postal_code']!;

  TextEditingController get cityController => _controllers['city']!;

  final RxString selectedGender = 'Male'.obs;
  final RxString profileImage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isSellerInactive = false.obs;
  final RxBool isRegionsLoading = false.obs;
  final RxString selectedCountryCode = ''.obs;
  final RxString selectedCountryName = ''.obs;
  final RxList<String> countries = <String>[].obs;
  final RxMap<String, String> countryCodeMap = <String, String>{}.obs;
  final RxList<DropdownItem<String>> countryDropdownItems = <DropdownItem<String>>[].obs;

  final phoneRegex = RegExp(r'^[0-9]{6,12}$');

  bool _isDisposed = false;

  // Initial values map for easier comparison
  final Map<String, String> _initialValues = {};

  final RxBool isChanged = false.obs;
  final RxBool isFormValid = false.obs;
  final RxBool isFromRegister = false.obs;
  final RxBool isCreationMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();

    if (HiveUtils.isContainKey(HiveKeys.userEmail)) {
      emailController.text = HiveUtils.get(HiveKeys.userEmail).toString();
      sellerEmailController.text = "${emailController.text}.refashion";
    }

    final arguments = Get.arguments as Map<String, dynamic>?;
    isFromRegister.value = arguments?['fromRegister'] ?? false;
    isCreationMode.value = isFromRegister.value;

    if (!isCreationMode.value) {
      fetchUserInfo();
    } else {
      final id = _generateRandomRefashionId();
      _initialValues['refashion_id'] = id;
      refashionIdController.text = id;
    }

    _setupListeners();
    fetchRegions();
    _checkChanges();
  }

  void _initializeControllers() {
    _controllers = {
      'first_name': TextEditingController(),
      'last_name': TextEditingController(),
      'email': TextEditingController(),
      'bio': TextEditingController(),
      'location': TextEditingController(),
      'refashion_id': TextEditingController(),
      'username': TextEditingController(),
      'phone': TextEditingController(),
      'company_name': TextEditingController(),
      'store_name': TextEditingController(),
      'vat_number': TextEditingController(),
      'tax_office': TextEditingController(),
      'seller_email': TextEditingController(),
      'address_line': TextEditingController(),
      'postal_code': TextEditingController(),
      'city': TextEditingController(),
    };
  }

  void _setupListeners() {
    for (var controller in _controllers.values) {
      controller.addListener(_checkChanges);
    }
    ever(selectedGender, (_) => _checkChanges());
    ever(profileImage, (_) => _checkChanges());
    ever(isCreationMode, (_) => _checkChanges());
    ever(selectedCountryCode, (_) => _checkChanges());
  }

  Future<void> fetchUserInfo() async {
    try {
      hasError.value = false;
      isLoading.value = true;
      final response = await _profileApiService.getCustomerInfo();
      if (_isDisposed) return;

      if (response.customer != null) {
        final customer = response.customer!;
        final metadata = customer.metadata;

        _initialValues['first_name'] = customer.firstName ?? '';
        _initialValues['last_name'] = customer.lastName ?? '';
        _initialValues['bio'] = metadata?.bio ?? '';
        _initialValues['location'] = metadata?.location ?? '';
        _initialValues['username'] = metadata?.username ?? '';
        _initialValues['gender'] = metadata?.gender ?? 'Female';
        _initialValues['refashion_id'] = metadata?.refashionId ?? '';
        _initialValues['phone'] = customer.phone ?? '';
        _initialValues['company_name'] = customer.companyName ?? '';
        _initialValues['profile_image'] = '';

        // Update controllers
        firstNameController.text = _initialValues['first_name']!;
        lastNameController.text = _initialValues['last_name']!;
        emailController.text = customer.email ?? HiveUtils.get(HiveKeys.userEmail) ?? '';
        sellerEmailController.text = "${emailController.text}.refashion";
        phoneController.text = _initialValues['phone']!;
        companyNameController.text = _initialValues['company_name']!;
        bioController.text = _initialValues['bio']!;
        locationController.text = _initialValues['location']!;
        refashionIdController.text = _initialValues['refashion_id']!;
        usernameController.text = _initialValues['username']!;
        selectedGender.value = _initialValues['gender']!;
        profileImage.value = _initialValues['profile_image']!;

        // Fetch Seller Info
        await _fetchSellerInfo();
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
      if (e.toString().contains(locale.value.errorUnauthorized) || e.toString() == 'Unauthorized') {
        isCreationMode.value = true;
      } else {
        hasError.value = true;
        errorMessage.value = e.toString();
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        _checkChanges();
      }
    }
  }

  Future<void> _fetchSellerInfo() async {
    try {
      final sellerResponse = await _profileApiService.getSellerInfo();
      if (_isDisposed) return;

      if (sellerResponse.seller != null) {
        final seller = sellerResponse.seller!;
        _initialValues['vat_number'] = seller.vatNumber ?? seller.taxId ?? '';
        _initialValues['tax_office'] = seller.taxOffice ?? '';
        _initialValues['store_name'] = seller.name ?? '';
        _initialValues['address_line'] = seller.addressLine ?? '';
        _initialValues['postal_code'] = seller.postalCode ?? '';
        _initialValues['city'] = seller.city ?? '';
        _initialValues['country_code'] = seller.countryCode ?? '';

        vatNumberController.text = _initialValues['vat_number']!;
        taxOfficeController.text = _initialValues['tax_office']!;
        storeNameController.text = _initialValues['store_name']!;
        addressLineController.text = _initialValues['address_line']!;
        postalCodeController.text = _initialValues['postal_code']!;
        cityController.text = _initialValues['city']!;

        if (_initialValues['country_code']!.isNotEmpty) {
          selectedCountryCode.value = _initialValues['country_code']!;
          // We'll find the name once regions are loaded or if we have a map
          _updateCountryNameFromCode();
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller info: $e');
      if (e.toString().contains('403') || e.toString().toLowerCase().contains('not active')) {
        isSellerInactive.value = true;
      }
    }
  }

  void _checkChanges() {
    if (_isDisposed) return;

    final currentValues = {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'bio': bioController.text.trim(),
      'location': locationController.text.trim(),
      'username': usernameController.text.trim(),
      'phone': phoneController.text.trim(),
      'company_name': companyNameController.text.trim(),
      'store_name': storeNameController.text.trim(),
      'vat_number': vatNumberController.text.trim(),
      'tax_office': taxOfficeController.text.trim(),
      'address_line': addressLineController.text.trim(),
      'postal_code': postalCodeController.text.trim(),
      'city': cityController.text.trim(),
      'country_code': selectedCountryCode.value,
      'gender': selectedGender.value,
    };

    bool changed = false;
    currentValues.forEach((key, value) {
      if (value != (_initialValues[key] ?? '')) {
        changed = true;
      }
    });

    isChanged.value = changed;

    isFormValid.value =
        currentValues['first_name']!.isNotEmpty &&
        currentValues['last_name']!.isNotEmpty &&
        currentValues['location']!.isNotEmpty &&
        currentValues['username']!.isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        currentValues['phone']!.isNotEmpty &&
        phoneRegex.hasMatch(currentValues['phone']!) &&
        currentValues['company_name']!.isNotEmpty &&
        (isSellerInactive.value ||
            (currentValues['store_name']!.isNotEmpty &&
                currentValues['vat_number']!.isNotEmpty &&
                currentValues['tax_office']!.isNotEmpty &&
                currentValues['address_line']!.isNotEmpty &&
                currentValues['postal_code']!.isNotEmpty &&
                currentValues['city']!.isNotEmpty &&
                currentValues['country_code']!.isNotEmpty));
  }

  bool get canSubmit => isFormValid.value && (isCreationMode.value || isChanged.value) && !isUpdating.value;

  void onGenderChange(String? value) {
    if (value != null) selectedGender.value = value;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.pleaseEnterYourPhoneNumber;
    } else if (!phoneRegex.hasMatch(value)) {
      return locale.value.invalidPhoneNumber;
    }
    return null;
  }

  Future<void> onUpdateProfile() async {
    try {
      isUpdating.value = true;

      final Map<String, dynamic> updateData = {};
      final Map<String, dynamic> metadata = {};

      void addToUpdate(String key, String apiKey, {bool isMetadata = false}) {
        final current = key == 'gender' ? selectedGender.value : _controllers[key]?.text.trim();
        if (current != (_initialValues[key] ?? '')) {
          if (isMetadata) {
            metadata[apiKey] = current;
          } else {
            updateData[apiKey] = current;
          }
        }
      }

      addToUpdate('first_name', 'first_name');
      addToUpdate('last_name', 'last_name');
      addToUpdate('phone', 'phone');
      // addToUpdate('company_name', 'company_name');
      addToUpdate('bio', 'bio', isMetadata: true);
      addToUpdate('gender', 'gender', isMetadata: true);
      addToUpdate('location', 'location', isMetadata: true);
      addToUpdate('username', 'username', isMetadata: true);

      if (isFromRegister.value) {
        metadata['refashion_id'] = refashionIdController.text.trim();
        if (emailController.text.isNotEmpty) {
          updateData['email'] = emailController.text.trim();
        }
      }

      if (metadata.isNotEmpty) updateData['metadata'] = metadata;

      bool sellerChanged =
          storeNameController.text.trim() != (_initialValues['store_name'] ?? '') ||
          vatNumberController.text.trim() != (_initialValues['vat_number'] ?? '') ||
          taxOfficeController.text.trim() != (_initialValues['tax_office'] ?? '') ||
          addressLineController.text.trim() != (_initialValues['address_line'] ?? '') ||
          postalCodeController.text.trim() != (_initialValues['postal_code'] ?? '') ||
          cityController.text.trim() != (_initialValues['city'] ?? '') ||
          selectedCountryCode.value != (_initialValues['country_code'] ?? '');

      if (updateData.isEmpty && !sellerChanged && !isCreationMode.value) {
        toast(locale.value.toastNoChangesDetected);
        return;
      }

      bool wasFromRegister = isFromRegister.value;
      bool success = true;

      if (updateData.isNotEmpty || isCreationMode.value) {
        final response = isCreationMode.value ? await _profileApiService.createCustomer(updateData) : await _profileApiService.updateProfile(updateData);

        if (_isDisposed) return;
        if (response.customer == null) success = false;
      }

      if (success) {
        // Sync initial values
        _initialValues['first_name'] = firstNameController.text.trim();
        _initialValues['last_name'] = lastNameController.text.trim();
        _initialValues['bio'] = bioController.text.trim();
        _initialValues['location'] = locationController.text.trim();
        _initialValues['username'] = usernameController.text.trim();
        _initialValues['gender'] = selectedGender.value;
        _initialValues['phone'] = phoneController.text.trim();
        _initialValues['company_name'] = companyNameController.text.trim();
        _initialValues['store_name'] = storeNameController.text.trim();
        _initialValues['vat_number'] = vatNumberController.text.trim();
        _initialValues['tax_office'] = taxOfficeController.text.trim();
        _initialValues['address_line'] = addressLineController.text.trim();
        _initialValues['postal_code'] = postalCodeController.text.trim();
        _initialValues['city'] = cityController.text.trim();
        _initialValues['country_code'] = selectedCountryCode.value;

        _checkChanges();

        if (wasFromRegister || isCreationMode.value) await _refreshToken();

        isCreationMode.value = false;
        isFromRegister.value = false;

        if (wasFromRegister) {
          await _syncSellerProfile();
          toast(locale.value.toastAccountCreated);
          Get.offAllNamed(Routes.dashboard);
        } else {
          if (sellerChanged) await _updateSellerProfile();
          toast(locale.value.toastProfileUpdatedSuccessfully);
        }
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      toast(e.toString());
    } finally {
      if (!_isDisposed) isUpdating.value = false;
    }
  }

  void onEditProfileImage() {}

  String _generateRandomRefashionId() {
    const uuid = Uuid();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = uuid.v4().replaceAll('-', '').substring(0, 6).toUpperCase();
    return 'REF-$timestamp-$randomPart';
  }

  Future<void> _refreshToken() async {
    try {
      final email = HiveUtils.get(HiveKeys.userEmail);
      final password = HiveUtils.get(HiveKeys.userPassword);

      if (email != null && password != null) {
        final customerResponse = await _authApiService.login(email: email.toString(), password: password.toString());
        if (customerResponse?['token'] != null) {
          await HiveUtils.set(HiveKeys.authToken, customerResponse['token']);
        }

        final sellerResponse = await _authApiService.sellerLogin(email: email.toString(), password: password.toString());
        if (sellerResponse?['token'] != null) {
          await HiveUtils.set(HiveKeys.sellerToken, sellerResponse['token']);
        }
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
    }
  }

  Future<void> _syncSellerProfile() async {
    try {
      final email = emailController.text.trim();
      final body = {
        "registration_type": "business",
        "email": "$email.refashion",
        "phone": phoneController.text.trim(),
        "company_name": companyNameController.text.trim(),
        "name": storeNameController.text.trim(),
        "vat_number": vatNumberController.text.trim(),
        "tax_office": taxOfficeController.text.trim(),
        "address_line": addressLineController.text.trim(),
        "postal_code": postalCodeController.text.trim(),
        "city": cityController.text.trim(),
        "country_code": selectedCountryCode.value.toLowerCase(),
        "member": {"name": "${firstNameController.text.trim()} ${lastNameController.text.trim()}", "email": "$email.refashion"},
      };
      await _profileApiService.registerSeller(body);
    } catch (e) {
      debugPrint('Error syncing seller profile: $e');
    }
  }

  Future<void> _updateSellerProfile() async {
    try {
      final body = {
        "name": storeNameController.text.trim(),
        "vat_number": vatNumberController.text.trim(),
        "tax_office": taxOfficeController.text.trim(),
        "address_line": addressLineController.text.trim(),
        "postal_code": postalCodeController.text.trim(),
        "city": cityController.text.trim(),
        "country_code": selectedCountryCode.value.toLowerCase(),
      };

      final response = await _profileApiService.updateSellerInfo(body);
      if (_isDisposed) return;

      if (response.seller != null) {
        _initialValues['store_name'] = response.seller!.name ?? '';
        _initialValues['vat_number'] = response.seller!.vatNumber ?? '';
        _initialValues['tax_office'] = response.seller!.taxOffice ?? '';
        _initialValues['address_line'] = response.seller!.addressLine ?? '';
        _initialValues['postal_code'] = response.seller!.postalCode ?? '';
        _initialValues['city'] = response.seller!.city ?? '';
        _initialValues['country_code'] = response.seller!.countryCode ?? '';
        _checkChanges();
      }
    } catch (e) {
      debugPrint('Error updating seller profile: $e');
      toast(e.toString());
    }
  }

  Future<void> fetchRegions() async {
    isRegionsLoading.value = true;
    try {
      final regionData = await _addressService.fetchRegions();
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

          final List<DropdownItem<String>> items = [];
          fetchedCodes.forEach((name, code) {
            items.add(DropdownItem(value: code, label: '${code.toFlagEmoji()}  $name'));
          });
          countryDropdownItems.assignAll(items);

          _updateCountryNameFromCode();
        }
      }
    } catch (e) {
      debugPrint('Error fetching regions: $e');
    } finally {
      isRegionsLoading.value = false;
    }
  }

  void _updateCountryNameFromCode() {
    if (selectedCountryCode.value.isNotEmpty && countryCodeMap.isNotEmpty) {
      final code = selectedCountryCode.value.toUpperCase();
      for (var entry in countryCodeMap.entries) {
        if (entry.value.toUpperCase() == code) {
          selectedCountryName.value = entry.key;
          return;
        }
      }
    }
  }

  void onLogout() => _apiService.logout(forceLogout: true);

  @override
  void onClose() {
    _isDisposed = true;
    for (var controller in _controllers.values) {
      controller.removeListener(_checkChanges);
      controller.dispose();
    }
    super.onClose();
  }
}
