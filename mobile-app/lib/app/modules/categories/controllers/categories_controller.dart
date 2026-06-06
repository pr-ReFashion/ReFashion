import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import '../model/category_list_model.dart';
import '../service/categories_service.dart';
import '../model/collection_list_model.dart';

class CategoriesController extends GetxController {
  final CategoriesService _categoriesService = CategoriesService();

  final RxInt selectedGenderIndex = 1.obs; // Default to Women
  final RxInt selectedMainCategoryIndex = 0.obs; // Default to first category

  final TextEditingController searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingCollections = false.obs;
  final RxBool isLoadingMore = false.obs;

  final RxList<ProductCategory> productCategories = <ProductCategory>[].obs;
  final RxList<Collection> collections = <Collection>[].obs;

  ScrollController sidebarScrollController = ScrollController();
  ScrollController collectionScrollController = ScrollController();

  // Category Pagination
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;

  // Collection Pagination
  final RxBool isLoadingMoreCollections = false.obs;
  int currentCollectionPage = 1;
  final int collectionLimit = 10;
  bool hasMoreCollections = true;

  String? currentCategoryName;
  String? currentListType;

  @override
  void onInit() {
    super.onInit();

    sidebarScrollController = ScrollController();
    collectionScrollController = ScrollController();

    fetchCategories(isRefresh: true);

    sidebarScrollController.addListener(_sidebarListener);
    collectionScrollController.addListener(_collectionListener);

    // Initialize filter states from arguments if available
    final dynamic args = Get.arguments;
    if (args is Map && args.containsKey('selectedFilters')) {
      final Map<String, Set<String>> passedFilters =
          args['selectedFilters'] as Map<String, Set<String>>;
      for (var tab in filterTabs) {
        selectedFilters[tab] = (passedFilters[tab] ?? <String>{}).toSet().obs;
      }
      if (args.containsKey('priceRange')) {
        priceRange.value = args['priceRange'] as RangeValues;
      }
    } else {
      for (var tab in filterTabs) {
        selectedFilters[tab] = <String>{}.obs;
      }
    }
  }

  // Filter Page State
  final RxInt selectedFilterTabIndex = 0.obs;

  final List<String> filterTabs = [
    'Material',
    'Collection Title',
    'Category',
    'Price',
  ];

  final RxMap<String, List<String>> filterOptions = <String, List<String>>{
    'Material': [
      'Cotton',
      'Polyster',
      'Leather',
      'Denim',
      'Wool',
      'Silk',
      'Linen',
      'Synthetic',
      'Mixed fabric',
    ],
    'Collection Title': [],
    'Category': [],
  }.obs;

  final RxMap<String, RxSet<String>> selectedFilters =
      <String, RxSet<String>>{}.obs;

  void onFilterTabTap(int index) {
    selectedFilterTabIndex.value = index;
  }

  void toggleFilterSelection(String category, String option) {
    if (selectedFilters[category]!.contains(option)) {
      selectedFilters[category]!.remove(option);
    } else {
      selectedFilters[category]!.add(option);
    }
  }

  void clearAllFilters() {
    for (var tab in filterTabs) {
      selectedFilters[tab]!.clear();
    }
    priceRange.value = const RangeValues(0, 10000);

    // Maintain the base context if we arrived from a specific category/collection
    final dynamic args = Get.arguments;
    if (args is Map) {
      final String? baseTitle = args['title'];
      final String? baseType = args['type'];

      if (baseTitle != null && baseTitle.isNotEmpty) {
        if (baseType == 'category') {
          // Ignore general segments like 'New Items'
          if (baseTitle != locale.value.newItemsText &&
              baseTitle != locale.value.trendingItemsText &&
              locale.value.categoriesText != baseTitle) {
            selectedFilters['Category']?.add(baseTitle);
          }
        } else if (baseType == 'collection') {
          selectedFilters['Collection Title']?.add(baseTitle);
        }
      }
    }
  }

  void applyFilters() {
    Get.back(
      result: {
        'selectedFilters': selectedFilters.map(
          (key, value) => MapEntry(key, value.toSet()),
        ),
        'priceRange': priceRange.value,
      },
    );
  }

  void onCloseTap() {
    Get.back();
  }

  // Price Filter State
  final RxBool isRFTEnabled = false.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 10000).obs;

  void toggleRFT(bool value) {
    isRFTEnabled.value = value;
  }

  void onPriceRangeChange(RangeValues values) {
    priceRange.value = RangeValues(
      values.start.roundToDouble(),
      values.end.roundToDouble(),
    );
  }

  void goToFilter() {
    Get.toNamed(Routes.filter, arguments: Get.arguments);
  }

  void onGenderTabTap(int index) {
    selectedGenderIndex.value = index;
  }

  void onMainCategoryTap(int index) {
    selectedMainCategoryIndex.value = index;
  }

  void goToCategoryProducts({
    String? categoryName,
    String? categoryId,
    String? collectionId,
    String? collectionTitle,
  }) {
    Get.toNamed(
      Routes.categoryProducts,
      arguments: {
        'title': collectionTitle ?? categoryName ?? locale.value.categoriesText,
        'category_id': categoryId,
        'collection_id': collectionId,
        'type': collectionId != null ? 'collection' : 'category',
      },
    );
  }

  void onSearchTap() {
    Get.toNamed(Routes.searchView);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void _sidebarListener() {
    if (!sidebarScrollController.hasClients) return;
    if (sidebarScrollController.position.pixels ==
            sidebarScrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData) {
      loadMoreCategories();
    }
  }

  void _collectionListener() {
    if (!collectionScrollController.hasClients) return;
    if (collectionScrollController.position.pixels >=
            collectionScrollController.position.maxScrollExtent - 200 &&
        !isLoadingMoreCollections.value &&
        hasMoreCollections) {
      loadMoreCollections();
    }
  }

  Future<void> fetchCollections({bool isRefresh = false}) async {
    try {
      if (isRefresh || collections.isEmpty) {
        currentCollectionPage = 1;
        hasMoreCollections = true;
        isLoadingCollections.value = true;
      }

      final response = await _categoriesService.fetchCollections(
        page: currentCollectionPage,
        limit: collectionLimit,
      );

      if (response.collections != null) {
        if (isRefresh) {
          collections.assignAll(response.collections!);
        } else {
          collections.addAll(response.collections!);
        }

        // Update filter options
        filterOptions['Collection Title'] = collections
            .map((e) => e.title ?? '')
            .where((element) => element.isNotEmpty)
            .toList();

        if (response.collections!.length < collectionLimit) {
          hasMoreCollections = false;
        } else {
          currentCollectionPage++;
        }
      }
    } catch (e) {
      debugPrint('Error fetching collections: $e');
    } finally {
      isLoadingCollections.value = false;
    }
  }

  Future<void> loadMoreCollections() async {
    if (isLoadingMoreCollections.value || !hasMoreCollections) return;

    try {
      isLoadingMoreCollections.value = true;
      await fetchCollections();
    } finally {
      isLoadingMoreCollections.value = false;
    }
  }

  Future<void> fetchCategories({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        hasMoreData = true;
      }

      if (!isRefresh || productCategories.isEmpty) {
        isLoading.value = true;
      }

      final response = await _categoriesService.fetchCategories(
        page: currentPage,
        limit: limit,
      );

      if (isRefresh) {
        await fetchCollections(isRefresh: true);
      }

      if (response.productCategories != null) {
        if (isRefresh) {
          productCategories.assignAll(response.productCategories!);
        } else {
          productCategories.addAll(response.productCategories!);
        }

        // Update filter options
        filterOptions['Category'] = productCategories
            .map((e) => e.name ?? '')
            .where((element) => element.isNotEmpty)
            .toList();

        if (response.productCategories!.length < limit) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreCategories() async {
    try {
      isLoadingMore.value = true;
      final response = await _categoriesService.fetchCategories(
        page: currentPage,
        limit: limit,
      );

      if (response.productCategories != null &&
          response.productCategories!.isNotEmpty) {
        productCategories.addAll(response.productCategories!);

        // Update filter options
        filterOptions['Category'] = productCategories
            .map((e) => e.name ?? '')
            .where((element) => element.isNotEmpty)
            .toList();

        if (response.productCategories!.length < limit) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      debugPrint('Error loading more categories: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    sidebarScrollController.removeListener(_sidebarListener);
    collectionScrollController.removeListener(_collectionListener);
    super.onClose();
  }
}
