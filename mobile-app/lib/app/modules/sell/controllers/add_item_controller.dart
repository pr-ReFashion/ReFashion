import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/modules/address/controllers/address_controller.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:refashion/app/modules/categories/model/category_list_model.dart' as cat;
import 'package:refashion/app/modules/categories/model/collection_list_model.dart' as col;
import 'package:refashion/app/modules/categories/service/categories_service.dart';
import 'package:refashion/app/modules/sell/model/product_tag_list_model.dart';
import 'package:refashion/app/modules/sell/model/product_type_list.dart';
import 'package:refashion/app/modules/sell/service/sell_service.dart';
import 'package:refashion/app/modules/sell/views/variant_inventory_view.dart';

import 'package:refashion/app/modules/sell/model/category_model.dart';
import 'package:refashion/app/modules/sell/model/section_model.dart';
import 'package:refashion/app/modules/sell/model/color_model.dart';
import 'package:refashion/app/modules/sell/model/product_option_model.dart';
import 'package:refashion/app/modules/sell/model/product_variant_model.dart';
import 'package:refashion/app/modules/sell/model/sales_channels_model.dart';

class AddItemController extends GetxController {
  final SellService _sellService = SellService();
  final CategoriesService _categoriesService = CategoriesService();

  bool get isNextEnabled => selectedSubcategory.value.isNotEmpty && selectedBrand.value.isNotEmpty;

  // New Section Model and List
  // Using a getter to dynamically return the state of sections
  // Move sections to a stable list initialized once or lazily
  late final List<SectionModel> sections = [
    SectionModel(
      title: locale.value.titleAndSubtitleSection,
      subtitle: locale.value.titleAndSubtitleSectionDesc,
      icon: ImageHelper.icProduct,
      isCompleted: isProductDetailsCompleted,
      onTap: onDetailsTap,
    ),
    SectionModel(
      title: locale.value.descriptionSectionTitle,
      subtitle: locale.value.descriptionSectionSubtitle,
      icon: ImageHelper.icFile,
      isCompleted: isDescriptionCompletedRx,
      onTap: onDescriptionTap,
    ),
    SectionModel(title: locale.value.photos, subtitle: locale.value.uploadPhotosDescription, icon: ImageHelper.icPhotos, isCompleted: isPhotosCompleted, onTap: onPhotosTap),
    SectionModel(title: locale.value.variantsTitle, subtitle: locale.value.variantsSubtitle, icon: ImageHelper.icTag, isCompleted: isVariantsCompletedRx, onTap: onVariantsTap),
    SectionModel(title: locale.value.organizeTitle, subtitle: locale.value.organizeSubtitle, icon: ImageHelper.icDocsFill, isCompleted: isOrganizeCompletedRx, onTap: onOrganizeTap),
    SectionModel(title: locale.value.variantInventoryTitle, subtitle: locale.value.variantInventorySubtitle, icon: ImageHelper.icBag, isCompleted: isInventoryCompletedRx, onTap: onInventoryTap),
  ];

  // Stable RxBools for sections
  final isProductDetailsCompleted = false.obs;
  final isPhotosCompleted = false.obs;
  final isDescriptionCompletedRx = false.obs;
  final isOrganizeCompletedRx = false.obs;
  final isVariantsCompletedRx = false.obs;
  final isInventoryCompletedRx = false.obs;
  final isPublishing = false.obs;

  SalesChannelsModel? salesChannelsModel;
  final selectedSalesChannelId = RxnString();

  void updateSectionStatus() {
    isProductDetailsCompleted.value = titleController.text.trim().isNotEmpty;
    isPhotosCompleted.value = selectedPhotos.isNotEmpty;
    isDescriptionCompletedRx.value = descriptionController.text.trim().isNotEmpty;

    // Organize completion: Check if any key field is selected
    isOrganizeCompletedRx.value = selectedTagIds.isNotEmpty || selectedTypeId.value != null || selectedCategoryId.value != null || selectedCollectionId.value != null;

    final selected = generatedVariants.where((v) => v.isSelected.value);
    isInventoryCompletedRx.value =
        selected.isNotEmpty &&
        selected.every((v) {
          final price = double.tryParse(v.priceController.text) ?? 0;
          return v.priceController.text.isNotEmpty && price > 0;
        });

    if (!isProductWithVariants.value) {
      isVariantsCompletedRx.value = false;
    } else {
      isVariantsCompletedRx.value = productOptions.any((opt) => opt.titleController.text.isNotEmpty && opt.values.isNotEmpty);
    }
  }

  bool get isInventoryCompleted {
    final selected = generatedVariants.where((v) => v.isSelected.value);
    if (selected.isEmpty) return false;
    return selected.every((v) {
      final price = double.tryParse(v.priceController.text) ?? 0;
      return v.priceController.text.isNotEmpty && price > 0;
    });
  }

  void onInventoryTap() {
    generateVariants();
    Get.to(() => const VariantInventoryView());
  }

  void onVariantsTap() {
    Get.toNamed(Routes.productVariants);
  }

  bool get isAddPhotosNextEnabled => selectedPhotos.isNotEmpty;

  int get completedSectionsCount => sections.where((s) => s.isCompleted.value).length;

  bool get isAllSectionsCompleted => isProductDetailsCompleted.value && isInventoryCompletedRx.value && isPhotosCompleted.value;

  final isFromReview = false.obs;
  final isLocationLoading = false.obs;
  final List<String> genders = ['Women', 'Men', 'Children'];
  final selectedGender = 0.obs;

  final categories = <CategoryModel>[
    CategoryModel(title: 'Bags', subcategories: ['All Bags', 'Everyday Bags', 'Travel & Work Bags', 'Mini & Ocassion Bags']),
    CategoryModel(title: 'Clothes', subcategories: ['T-Shirts', 'Dresses', 'Pants']),
    CategoryModel(title: 'Shoes', subcategories: ['Sneakers', 'Boots', 'Sandals']),
    CategoryModel(title: 'Accesories', subcategories: ['Jewelry', 'Watches', 'Hats']),
  ].obs;

  final selectedCategory = ''.obs;
  final selectedSubcategory = ''.obs;
  final selectedBrand = ''.obs;

  // New Organize State
  final isDiscountable = true.obs;
  final isOrganizeLoading = false.obs;

  final productTypesList = <ProductType>[].obs;
  final productTagsList = <ProductTag>[].obs;
  final productCategoriesList = <cat.ProductCategory>[].obs;
  final productCollectionsList = <col.Collection>[].obs;

  final selectedTypeId = RxnString();
  final selectedCollectionId = RxnString();
  final selectedCategoryId = RxnString();
  final selectedTagIds = <String>[].obs;
  final brands = <String>[
    'Abercrombie & Fitch',
    'Adidas',
    'Aeire',
    'Aeropostale',
    'Aldo',
    'Balenciaga',
    'Banana Republic',
    'Birkenstock',
    'Bottega Veneta',
    'Calvin Klein',
    'Champion',
    'Chanel',
    'Coach',
  ];

  final filteredBrands = <String>[].obs;
  final searchBrandController = TextEditingController();
  final searchController = TextEditingController();
  final isSearchEmpty = true.obs;

  // General Section Fields
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final handleController = TextEditingController();
  final descriptionController = TextEditingController();
  final isProductWithVariants = false.obs;
  final productOptions = <ProductOption>[].obs;

  void addProductOption() {
    productOptions.add(ProductOption());
  }

  void removeProductOption(int index) {
    productOptions.removeAt(index);
  }

  void addValueToOption(int index, String value) {
    if (value.trim().isNotEmpty) {
      productOptions[index].values.add(value.trim());
      productOptions[index].valueInputController.clear();
      generateVariants();
    }
  }

  void removeValueFromOption(int index, int valueIndex) {
    productOptions[index].values.removeAt(valueIndex);
    generateVariants();
  }

  final generatedVariants = <ProductVariant>[ProductVariant(combination: {})].obs;

  void generateVariants() {
    if (isProductWithVariants.value == false) {
      if (generatedVariants.length != 1 || generatedVariants.first.combination.isNotEmpty) {
        final v = ProductVariant(combination: {});
        v.isSelected.listen((_) => updateSectionStatus());
        v.priceController.addListener(updateSectionStatus);
        generatedVariants.assignAll([v]);
      }
      updateSectionStatus();
      return;
    }

    if (productOptions.isEmpty || !productOptions.any((opt) => opt.values.isNotEmpty)) {
      generatedVariants.clear();
      updateSectionStatus();
      return;
    }

    List<Map<String, String>> combinations = [{}];

    for (var option in productOptions) {
      String title = option.titleController.text.trim();
      if (title.isEmpty || option.values.isEmpty) continue;

      List<Map<String, String>> newCombinations = [];
      for (var existing in combinations) {
        for (var value in option.values) {
          var updated = Map<String, String>.from(existing);
          updated[title] = value;
          newCombinations.add(updated);
        }
      }
      combinations = newCombinations;
    }

    // Ensure combinations are unique to avoid duplicate keys
    final Set<String> seen = {};
    final List<Map<String, String>> uniqueCombinations = [];
    for (var c in combinations) {
      final key = c.entries.map((e) => "${e.key}:${e.value}").join("|");
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueCombinations.add(c);
      }
    }

    if (uniqueCombinations.isEmpty || (uniqueCombinations.length == 1 && uniqueCombinations.first.isEmpty)) {
      generatedVariants.clear();
    } else {
      final oldVariants = List<ProductVariant>.from(generatedVariants);
      final newVariants = uniqueCombinations.map((c) {
        try {
          return oldVariants.firstWhere((v) => _mapsEqual(v.combination, c));
        } catch (_) {
          final v = ProductVariant(combination: c);
          v.isSelected.listen((_) => updateSectionStatus());
          v.priceController.addListener(updateSectionStatus);
          return v;
        }
      }).toList();
      generatedVariants.assignAll(newVariants);
    }
    updateSectionStatus();
  }

  bool _mapsEqual(Map<String, String> m1, Map<String, String> m2) {
    if (m1.length != m2.length) return false;
    for (var key in m1.keys) {
      if (!m2.containsKey(key) || m1[key] != m2[key]) return false;
    }
    return true;
  }

  void onReorderVariants(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ProductVariant item = generatedVariants.removeAt(oldIndex);
    generatedVariants.insert(newIndex, item);
  }

  final selectedCondition = ''.obs;
  final selectedColor = ''.obs;
  final selectedSize = ''.obs;
  final materialController = TextEditingController();
  final material = ''.obs;
  final isMaterialEmpty = true.obs;

  final description = ''.obs;
  final isDescriptionEmpty = true.obs;

  final euroPriceController = TextEditingController();
  final rftValue = '0.00'.obs;
  final isPriceEmpty = true.obs;

  // Optional Info State
  final isVintage = false.obs;
  final placeOfPurchaseController = TextEditingController();
  final placeOfPurchase = ''.obs;
  final yearOfPurchaseController = TextEditingController();
  final yearOfPurchase = ''.obs;
  final purchasePriceController = TextEditingController();
  final purchasePrice = ''.obs;
  final receiptPath = RxnString();
  final hasCertificate = false.obs;
  final hasDustBag = false.obs;
  final hasOriginalBox = false.obs;
  final isOptionalInfoCompleted = false.obs;
  final isOptionalDetailsValid = false.obs;

  void checkOptionalDetailsValidation() {
    bool isValid =
        isVintage.value &&
        placeOfPurchaseController.text.isNotEmpty &&
        yearOfPurchaseController.text.isNotEmpty &&
        purchasePriceController.text.isNotEmpty &&
        receiptPath.value != null &&
        (hasCertificate.value || hasDustBag.value || hasOriginalBox.value);

    isOptionalDetailsValid.value = isValid;
    isOptionalInfoCompleted.value = isValid;
  }

  final selectedPhotos = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  final isConditionExpanded = false.obs;
  final isColorExpanded = false.obs;
  final isSizeExpanded = false.obs;

  RxList<AddressModel> get dummyAddresses => Get.find<AddressController>().addresses;
  final selectedAddress = Rxn<AddressModel>();

  bool get isOrganizeEnabled => true; // Make it always enabled as fields are optional

  final conditions = ['New with tags', 'Like new', 'Used-excellent', 'Used-good'];

  final colors = [
    ColorModel(name: 'Yellow', color: const Color(0xFFFFD700)),
    ColorModel(name: 'Red', color: const Color(0xFFFF0000)),
    ColorModel(name: 'Green', color: const Color(0xFF008000)),
    ColorModel(name: 'Violet', color: const Color(0xFFEE82EE)),
    ColorModel(name: 'Orange', color: const Color(0xFFFFA500)),
    ColorModel(name: 'Blue Violet', color: const Color(0xFF8A2BE2)),
    ColorModel(name: 'Yellow Green', color: const Color(0xFF9ACD32)),
    ColorModel(name: 'Red Violet', color: const Color(0xFFC71585)),
  ];

  final sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  bool get isProductDetailsEnabled => titleController.text.trim().isNotEmpty;

  bool get isVariantsCompleted {
    if (!isProductWithVariants.value) return true;
    return productOptions.any((opt) => opt.values.isNotEmpty);
  }

  @override
  void onInit() {
    super.onInit();
    filteredBrands.addAll(brands);
    isSearchEmpty.value = searchBrandController.text.isEmpty;
    isMaterialEmpty.value = materialController.text.isEmpty;

    // Sync search controller when brand is selected
    ever(selectedBrand, (String val) {
      searchController.text = val;
    });

    ever(selectedPhotos, (_) => updateSectionStatus());
    ever(isProductWithVariants, (_) {
      generateVariants();
      updateSectionStatus();
    });
    ever(selectedCondition, (_) => updateSectionStatus());
    ever(selectedColor, (_) => updateSectionStatus());
    ever(selectedSize, (_) => updateSectionStatus());

    ever(selectedBrand, (_) => updateSectionStatus());
    ever(selectedTypeId, (_) => updateSectionStatus());
    ever(selectedCategoryId, (_) => updateSectionStatus());
    ever(selectedCollectionId, (_) => updateSectionStatus());
    ever(selectedTagIds, (_) => updateSectionStatus());

    fetchOrganizeData();
    fetchSalesChannels();
    generateVariants();

    searchBrandController.addListener(() {
      filterBrands(searchBrandController.text.trim());
    });

    // Attach listeners to initial variants
    for (var v in generatedVariants) {
      v.isSelected.listen((_) => updateSectionStatus());
      v.priceController.addListener(updateSectionStatus);
    }
    updateSectionStatus();

    materialController.addListener(() {
      material.value = materialController.text;
      isMaterialEmpty.value = materialController.text.trim().isEmpty;
    });

    titleController.addListener(() {
      updateSectionStatus();
      update(['details_button']);
    });

    isDescriptionEmpty.value = descriptionController.text.trim().isEmpty;
    descriptionController.addListener(() {
      description.value = descriptionController.text;
      isDescriptionEmpty.value = descriptionController.text.trim().isEmpty;
    });

    euroPriceController.addListener(() {
      calculateRFT(euroPriceController.text);
      isPriceEmpty.value = euroPriceController.text.trim().isEmpty;
      updateSectionStatus();
    });

    descriptionController.addListener(() {
      isDescriptionEmpty.value = descriptionController.text.trim().isEmpty;
      updateSectionStatus();
    });

    placeOfPurchaseController.addListener(() {
      placeOfPurchase.value = placeOfPurchaseController.text;
      checkOptionalDetailsValidation();
    });
    yearOfPurchaseController.addListener(() {
      yearOfPurchase.value = yearOfPurchaseController.text;
      checkOptionalDetailsValidation();
    });
    purchasePriceController.addListener(() {
      purchasePrice.value = purchasePriceController.text;
      checkOptionalDetailsValidation();
    });

    // Listeners for switches and checkboxes
    ever(isVintage, (_) => checkOptionalDetailsValidation());
    ever(hasCertificate, (_) => checkOptionalDetailsValidation());
    ever(hasDustBag, (_) => checkOptionalDetailsValidation());
    ever(hasOriginalBox, (_) => checkOptionalDetailsValidation());

    checkOptionalDetailsValidation();
    updateSectionStatus();
  }

  void onDetailsSaveTap() {
    if (isFromReview.value) {
      isFromReview.value = false;
      Get.back();
    } else {
      Get.offNamed(Routes.addPhotos);
    }
  }

  void onVintageChanged(bool val) {
    isVintage.value = val;
  }

  void onPackagingToggle(RxBool obsValue) {
    obsValue.value = !obsValue.value;
  }

  void onColorSelect(ColorModel val) {
    selectColor(val.name);
  }

  void onMaterialChanged(String val) {
    isMaterialEmpty.value = val.trim().isEmpty;
  }

  void toggleCondition() {
    isConditionExpanded.value = !isConditionExpanded.value;
    isColorExpanded.value = false;
    isSizeExpanded.value = false;
  }

  void toggleColor() {
    isColorExpanded.value = !isColorExpanded.value;
    isConditionExpanded.value = false;
    isSizeExpanded.value = false;
  }

  void toggleSize() {
    isSizeExpanded.value = !isSizeExpanded.value;
    isConditionExpanded.value = false;
    isColorExpanded.value = false;
  }

  void selectCondition(String val) {
    selectedCondition.value = val;
    isConditionExpanded.value = false;
  }

  void selectColor(String val) {
    selectedColor.value = val;
    isColorExpanded.value = false;
  }

  void selectSize(String val) {
    selectedSize.value = val;
    isSizeExpanded.value = false;
  }

  void onSearchBrandChanged(String value) {
    isSearchEmpty.value = value.isEmpty;
  }

  void toggleCategory(int index) {
    for (int i = 0; i < categories.length; i++) {
      if (i == index) {
        categories[i].isExpanded.value = !categories[i].isExpanded.value;
      } else {
        categories[i].isExpanded.value = false;
      }
    }
  }

  void selectSubcategory(String category, String subcategory) {
    selectedCategory.value = category;
    selectedSubcategory.value = subcategory;
    update(['details_button']);
  }

  void onGenderTap(int index) {
    selectedGender.value = index;
  }

  void filterBrands(String query) {
    if (query.isEmpty) {
      filteredBrands.assignAll(brands);
    } else {
      filteredBrands.assignAll(brands.where((brand) => brand.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void selectBrand(String value) {
    selectedBrand.value = value;
    searchController.text = value;
    searchBrandController.clear();
    update(['details_button']);
    Get.back();
  }

  void goToSelectBrand() {
    Get.toNamed(Routes.selectBrand);
  }

  void onBackTap() {
    Get.back();
  }

  void onCancelSearchTap() {
    searchBrandController.clear();
    hideKeyboard(Get.context!);
  }

  void onCantFindBrandTap() {
    // Handle link tap
  }

  void onNextTap() {
    Get.toNamed(Routes.listingAnItem);
  }

  void onAddPhotosNextTap() {
    // if (isFromReview.value) {
    //   isFromReview.value = false;
    Get.back();
    // } else {
    //   Get.offNamed(Routes.description);
    // }
  }

  Future<void> onPublishTap() async {
    if (!isAllSectionsCompleted) return;

    try {
      isPublishing.value = true;

      // 1. Ensure sales channel is available
      if (salesChannelsModel == null || (salesChannelsModel?.salesChannels?.isEmpty ?? true)) {
        await fetchSalesChannels();
      }

      final List<Map<String, dynamic>> salesChannelsData = [];
      if (salesChannelsModel?.salesChannels?.isNotEmpty ?? false) {
        final channel = salesChannelsModel!.salesChannels!.firstWhere((sc) => sc.id == selectedSalesChannelId.value, orElse: () => salesChannelsModel!.salesChannels!.first);
        salesChannelsData.add({"id": channel.id, "name": channel.name});
      }

      // 2. Construct Product Data
      final List<Map<String, dynamic>> productOptionsData = productOptions
          .where((opt) => opt.titleController.text.isNotEmpty && opt.values.isNotEmpty)
          .map<Map<String, dynamic>>((opt) => {"title": opt.titleController.text.trim(), "values": opt.values.toList()})
          .toList();

      // If no variants, use the title from the UI as the default option value
      if (productOptionsData.isEmpty) {
        final variantTitle = generatedVariants.isNotEmpty ? generatedVariants.first.titleController.text.trim() : "Default variant";

        productOptionsData.addAll(<Map<String, dynamic>>[
          {
            "title": "Default variant",
            "values": [variantTitle.isNotEmpty ? variantTitle : "Default variant"],
          },
        ]);
      }

      final List<Map<String, dynamic>> variantsData = generatedVariants.where((v) => v.isSelected.value).toList().asMap().entries.map<Map<String, dynamic>>((entry) {
        final int index = entry.key;
        final v = entry.value;
        final Map<String, String> variantOptions = {};
        if (v.combination.isEmpty) {
          final variantTitle = v.titleController.text.trim();
          variantOptions["Default variant"] = variantTitle.isNotEmpty ? variantTitle : "Default variant";
        } else {
          v.combination.forEach((key, value) {
            variantOptions[key] = value;
          });
        }

        return {
          "title": v.titleController.text,
          "options": variantOptions,
          "variant_rank": index,
          "prices": [
            {"currency_code": "eur", "amount": double.tryParse(v.priceController.text) ?? 0},
          ],
          "manage_inventory": true,
          "allow_backorder": false,
        };
      }).toList();

      // 2. Upload Images
      List<Map<String, dynamic>> uploadedImages = [];
      if (selectedPhotos.isNotEmpty) {
        final uploadResponse = await _sellService.uploadImages(selectedPhotos.map((path) => File(path)).toList());
        if (uploadResponse != null && uploadResponse['files'] != null) {
          uploadedImages = List<Map<String, dynamic>>.from(uploadResponse['files']);
        }
      }

      final Map<String, dynamic> productRequest = {
        "title": titleController.text.trim(),
        "subtitle": subtitleController.text.trim(),
        "handle": handleController.text.trim(),
        "description": descriptionController.text.trim(),
        "discountable": isDiscountable.value,
        if (selectedCollectionId.value != null) "collection_id": selectedCollectionId.value,
        if (selectedTypeId.value != null) "type_id": selectedTypeId.value,
        "categories": selectedCategoryId.value != null
            ? <Map<String, dynamic>>[
                {"id": selectedCategoryId.value},
              ]
            : <Map<String, dynamic>>[],
        "tags": selectedTagIds.map((id) => {"id": id}).toList(),
        "sales_channels": salesChannelsData,
        "origin_country": "",
        "material": materialController.text.trim(),
        "mid_code": "",
        "hs_code": "",
        "options": productOptionsData,
        "variants": variantsData,
        "status": "proposed",
        "images": uploadedImages,
      };

      log(productRequest.toString());
      // 3. Call API
      final response = await _sellService.createProduct(productRequest);

      // // 4. Handle Success
      if (response != null && response['product'] != null) {
        final String productId = response['product']['id'];

        // Call Background Stock Update (Non-blocking)
        _sellService.syncProductStock(productId);

        toast(locale.value.toastProductCreated);
        Get.offNamedUntil(Routes.dashboard, (route) => false, arguments: 2); // Go back to Sell tab in Dashboard
      }
    } catch (e) {
      toast(e.toString());
      log(e.toString());
    } finally {
      isPublishing.value = false;
    }
  }

  // _updateProductStock removed as it's now in SellService for background persistence

  void onFinalPublishTap() {
    _showSuccessBottomSheet();
  }

  void _showSuccessBottomSheet() {
    Get.bottomSheet(
      PopScope(
        canPop: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w.w, 16.h, 16.w, 30.h),
          color: ColorHelper.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: onViewListingTap,
                    icon: Icon(Icons.close, size: 24.sp, color: ColorHelper.subHeadingColor),
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    constraints: const BoxConstraints(),
                  ),
                ),
                SizedBox(height: 32.h),
                CachedImageView(imagePath: ImageHelper.icSuccess, size: 140.sp, fit: BoxFit.contain),
                SizedBox(height: 10.h),
                Text(
                  locale.value.itemSubmitted,
                  style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.headingColor),
                ),
                SizedBox(height: 10.h),
                Text(
                  locale.value.itemSubmittedDesc,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.subHeadingColor),
                ),
                SizedBox(height: 32.h),
                // Item Summary Card
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: selectedPhotos.isNotEmpty
                          ? selectedPhotos[0].startsWith('http')
                                ? CachedImageView(imagePath: selectedPhotos[0], width: 100.w, height: 100.w, fit: BoxFit.cover)
                                : Image.file(File(selectedPhotos[0]), width: 100.w, height: 100.w, fit: BoxFit.cover)
                          : Container(
                              width: 100.w,
                              height: 100.w,
                              color: ColorHelper.lightGrey.withValues(alpha: 0.5),
                              padding: EdgeInsets.all(25.r),
                              child: CachedImageView(imagePath: ImageHelper.icNoImage, width: 50.w, height: 50.w),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedBrand.value,
                            style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.headingColor),
                          ),
                          Text(
                            selectedSubcategory.value,
                            style: TextStyleHelper.dmRegular400().copyWith(fontSize: 12.sp, color: ColorHelper.subHeadingColor),
                          ),
                          SizedBox(height: 8.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${euroPriceController.text.toPrice()} ',
                                  style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp, color: ColorHelper.headingColor),
                                ),
                                TextSpan(
                                  text: ' | ',
                                  style: TextStyleHelper.urRegular400().copyWith(fontSize: 16.sp, color: ColorHelper.borderColor),
                                ),
                                TextSpan(
                                  text: ' ${rftValue.value} RFT',
                                  style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp, color: ColorHelper.primary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            locale.value.shippingNotIncludedDesc,
                            style: TextStyleHelper.dmRegular400().copyWith(fontSize: 12.sp, color: ColorHelper.subHeadingColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Impact Banner
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  color: ColorHelper.successLight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('❤️', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8.w),
                          Text(
                            locale.value.youAreMakingAnImpact.toUpperCase(),
                            style: TextStyleHelper.urMedium500().copyWith(fontSize: 18.sp, color: ColorHelper.success),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        locale.value.impactDescription,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.urRegular400().copyWith(fontSize: 14.sp, color: ColorHelper.subHeadingColor, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                CommonBtn(onTap: onViewListingTap, text: locale.value.viewYourListing, width: double.infinity),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }

  void onViewListingTap() {
    Get.offAllNamed(Routes.dashboard, arguments: 2);
  }

  void onReviewDetailsEditTap() => onDetailsTap(fromReview: true);

  void onReviewPhotosEditTap() => onPhotosTap(fromReview: true);

  void onReviewDescriptionEditTap() => onDescriptionTap(fromReview: true);

  void onReviewAddressEditTap() => onAddressTap(fromReview: true);

  void onReviewPriceEditTap() => onPriceTap(fromReview: true);

  void onReviewOptionalInfoEditTap() => onOptionalInfoTap(fromReview: true);

  void onToggleVintageTap() {
    onVintageChanged(!isVintage.value);
  }

  void onToggleCertificateTap() => onPackagingToggle(hasCertificate);

  void onToggleDustBagTap() => onPackagingToggle(hasDustBag);

  void onToggleOriginalBoxTap() => onPackagingToggle(hasOriginalBox);

  void onOrganizeTap() {
    Get.toNamed(Routes.organize);
  }

  void onDetailsTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.productDetails);
  }

  void onPhotosTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.addPhotos);
  }

  void onShowTipsTap(Widget tipsDialog) {
    Get.dialog(tipsDialog, barrierDismissible: true);
  }

  void onShowImagePickerTap(Widget pickerSheet) {
    Get.bottomSheet(pickerSheet, backgroundColor: Colors.transparent);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedPhotos.add(image.path);
        if (Get.isBottomSheetOpen ?? false) Get.back();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onReorderPhotos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    // Clamp newIndex to ensure it doesn't exceed the actual list length
    // because the UI might have placeholders that increase the ReorderableListView itemCount.
    if (newIndex >= selectedPhotos.length) {
      newIndex = selectedPhotos.length - 1;
    }

    final String item = selectedPhotos.removeAt(oldIndex);
    selectedPhotos.insert(newIndex, item);
  }

  void onRemovePhotoTap(int index) {
    selectedPhotos.removeAt(index);
  }

  void onCameraTap() {
    pickImage(ImageSource.camera);
  }

  void onGalleryTap() {
    pickImage(ImageSource.gallery);
  }

  void onDescriptionTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.description);
  }

  void onDescriptionNextTap() {
    // if (isFromReview.value) {
    //   isFromReview.value = false;
    Get.back();
    // } else {
    //   Get.offNamed(Routes.productAddress);
    // }
  }

  void onAddressTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.productAddress);
  }

  void onAddressNextTap() {
    if (isFromReview.value) {
      isFromReview.value = false;
      Get.back();
    } else {
      Get.offNamed(Routes.productPrice);
    }
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

      // Industry standard: Use last known for speed, or fetch fresh if needed
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];

        // Create a temporary model to pass to the address form
        final tempAddress = AddressModel(
          firstName: '',
          lastName: '',
          phone: '',
          address1: place.street ?? '',
          city: place.locality ?? '',
          postalCode: place.postalCode ?? '',
          countryCode: place.country ?? '',
        );

        // Navigate to the form to let the user review and save the address properly
        final addressController = Get.find<AddressController>();
        addressController.onEditAddressTap(tempAddress, isNewAddress: true);
      }
      isLocationLoading.value = false;
    } catch (e) {
      isLocationLoading.value = false;
      debugPrint('Location Error: $e');
      toast("Could not get current location. Please try again.");
    }
  }

  void onAddProductAddressTap() {
    final addressController = Get.find<AddressController>();
    addressController.onAddAddressTap();
  }

  void onSelectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void onEditAddressTap(AddressModel address) {
    Get.toNamed(Routes.addressForm, arguments: address);
  }

  void onPriceTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.productPrice);
  }

  void onPriceNextTap() {
    if (isFromReview.value) {
      isFromReview.value = false;
      Get.back();
    } else {
      Get.offNamed(Routes.addItemOptionalDetails);
    }
  }

  void calculateRFT(String euro) {
    if (euro.isEmpty) {
      rftValue.value = '0.00';
      return;
    }
    try {
      double price = double.parse(euro);
      // Assuming 1 Euro = 1.2 RFT for example, or whatever rate
      rftValue.value = (price * 1.2).toStringAsFixed(2);
    } catch (e) {
      rftValue.value = '0.00';
    }
  }

  void onOptionalInfoTap({bool fromReview = false}) {
    isFromReview.value = fromReview;
    Get.toNamed(Routes.addItemOptionalDetails);
  }

  Future<void> pickReceipt() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg']);

      if (result != null) {
        receiptPath.value = result.files.single.path;
        checkOptionalDetailsValidation();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onOptionalDetailsSaveTap() {
    if (isFromReview.value) {
      isFromReview.value = false;
      Get.back();
    } else {
      if (isAllSectionsCompleted) {
        Get.offNamed(Routes.reviewAndSubmit);
      } else {
        Get.back();
      }
    }
  }

  Future<void> fetchOrganizeData() async {
    try {
      isOrganizeLoading.value = true;

      // Fetch data in parallel
      final results = await Future.wait([_sellService.fetchProductTypes(), _sellService.fetchProductTags(), _categoriesService.fetchCategories(), _categoriesService.fetchCollections()]);

      productTypesList.assignAll((results[0] as ProductTypeListModel).productTypes ?? []);
      productTagsList.assignAll((results[1] as ProductTagListModel).productTags ?? []);
      productCategoriesList.assignAll((results[2] as cat.CategoryListModel).productCategories ?? []);
      productCollectionsList.assignAll((results[3] as col.CollectionListModel).collections ?? []);
    } catch (e) {
      debugPrint("Error fetching organize data: $e");
    } finally {
      isOrganizeLoading.value = false;
    }
  }

  Future<void> fetchSalesChannels() async {
    try {
      salesChannelsModel = await _sellService.fetchSalesChannels();
      if (salesChannelsModel?.salesChannels?.isNotEmpty ?? false) {
        selectedSalesChannelId.value = salesChannelsModel!.salesChannels!.first.id;
      }
    } catch (e) {
      debugPrint("Error fetching sales channels: $e");
    }
  }

  void reset() {
    titleController.clear();
    subtitleController.clear();
    handleController.clear();
    descriptionController.clear();
    isProductWithVariants.value = false;
    productOptions.clear();
    generatedVariants.clear();
    selectedPhotos.clear();
    selectedCondition.value = '';
    selectedColor.value = '';
    selectedSize.value = '';
    materialController.clear();
    material.value = '';
    description.value = '';
    euroPriceController.clear();
    rftValue.value = '0.00';
    isVintage.value = false;
    placeOfPurchaseController.clear();
    yearOfPurchaseController.clear();
    purchasePriceController.clear();
    receiptPath.value = null;
    hasCertificate.value = false;
    hasDustBag.value = false;
    hasOriginalBox.value = false;
    selectedAddress.value = null;
    selectedCategory.value = '';
    selectedSubcategory.value = '';
    selectedBrand.value = '';
    isDiscountable.value = true;
    selectedTypeId.value = null;
    selectedCollectionId.value = null;
    selectedCategoryId.value = null;
    selectedTagIds.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    subtitleController.dispose();
    handleController.dispose();
    descriptionController.dispose();
    materialController.dispose();
    euroPriceController.dispose();
    placeOfPurchaseController.dispose();
    yearOfPurchaseController.dispose();
    purchasePriceController.dispose();
    searchBrandController.dispose();
    searchController.dispose();
    for (var variant in generatedVariants) {
      variant.dispose();
    }
    super.onClose();
  }
}
