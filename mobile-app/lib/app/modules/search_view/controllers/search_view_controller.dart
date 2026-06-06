import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import '../../product_detail/models/product_list_model.dart';
import '../../product_detail/service/product_service.dart';
import '../../../utills/hive/hive_keys.dart';
import '../../../utills/hive/hive_utils.dart';

class SearchViewController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxInt selectedTab = 0.obs; // 0 for Items, 1 for Users
  final ProductService _productService = ProductService();

  bool isFromCategory = false;
  final RxList<Product> searchedProducts = <Product>[].obs;
  final RxBool isLoadingResults = false.obs;
  final RxString searchText = ''.obs;

  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> userRecentSearches = <String>[].obs;

  final RxList<String> filteredItems = <String>[].obs;
  final RxList<SearchUserModel> filteredUsers = <SearchUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is Map) {
      isFromCategory = args['isFromCategory'] ?? false;
    }
    _loadRecentSearches();
    searchController.addListener(_onSearchChanged);
  }

  void _loadRecentSearches() {
    final storedItems = HiveUtils.get(HiveKeys.recentSearchesItems);
    if (storedItems != null && storedItems is List) {
      recentSearches.assignAll(storedItems.map((e) => e.toString()).toList());
    }

    final storedUsers = HiveUtils.get(HiveKeys.recentSearchesUsers);
    if (storedUsers != null && storedUsers is List) {
      userRecentSearches.assignAll(storedUsers.map((e) => e.toString()).toList());
    }
  }

  void _onSearchChanged() {
    String query = searchController.text;
    searchText.value = query;
    if (query.isEmpty) {
      filteredItems.clear();
      filteredUsers.clear();
      searchedProducts.clear();
    } else {
      // Always fetch products for both Home and Category modes
      if (query.length >= 3) {
        _searchProducts(query);
      }

      // Clear filtered users and items as we removed static suggestions
      filteredItems.clear();
      filteredUsers.clear();
    }
  }

  Future<void> _searchProducts(String query) async {
    try {
      isLoadingResults.value = true;
      final response = await _productService.fetchProducts(q: query, limit: 10);
      if (response.products != null) {
        searchedProducts.assignAll(response.products!);
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
    } finally {
      isLoadingResults.value = false;
    }
  }

  void _saveRecentSearch(String query) {
    if (query.isEmpty) return;

    final RxList<String> targetList = selectedTab.value == 0 ? recentSearches : userRecentSearches;

    // Remove if already exists to move it to the top
    targetList.remove(query);

    // Insert at the beginning
    targetList.insert(0, query);

    // Limit to 10 entries
    if (targetList.length > 10) {
      targetList.removeLast();
    }

    // Persist to Hive
    _persistRecentSearches();
  }

  void _persistRecentSearches() {
    HiveUtils.set(HiveKeys.recentSearchesItems, recentSearches.toList());
    HiveUtils.set(HiveKeys.recentSearchesUsers, userRecentSearches.toList());
  }

  void onBackTap() {
    Get.back();
  }

  void onCancelTap() {
    searchController.clear();
    Get.back();
  }

  void onTabChanged(int index) {
    selectedTab.value = index;
    searchController.clear();
  }

  void removeRecentSearch(int index) {
    if (selectedTab.value == 0) {
      recentSearches.removeAt(index);
    } else {
      userRecentSearches.removeAt(index);
    }
    _persistRecentSearches();
  }

  void onUserTap(SearchUserModel user) {
    // Navigate to user activity/profile page
    Get.toNamed(Routes.myActivity, arguments: user);
  }

  void onSuggestionTap(String suggestion) {
    if (suggestion.isNotEmpty) {
      _saveRecentSearch(suggestion);
      if (isFromCategory) {
        Get.back(result: suggestion);
      } else {
        // If not from category, maybe navigate to results or detail?
        // For now, if it's a tapped suggestion, navigate to CategoryProducts as result page
        Get.toNamed(
          Routes.categoryProducts,
          arguments: {
            'title': locale.value.search,
            'q': suggestion,
            'type': 'search', // Explicitly marking as search type
          },
        );
      }
    }
  }

  void onProductTap(Product product) {
    if (product.title != null) {
      _saveRecentSearch(product.title!);
    }
    if (isFromCategory) {
      Get.back(result: product.title);
    } else {
      Get.toNamed(Routes.productDetail, arguments: product);
    }
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      _saveRecentSearch(value);
    }
    if (isFromCategory) {
      if (value.isNotEmpty) {
        Get.back(result: value);
      }
    } else {
      // User: "without any search api call on done"
      Get.back();
    }
  }

  void onRecentSearchTap(String query) {
    if (selectedTab.value == 1) {
      // Direct navigation for Users tab
      onUserTap(SearchUserModel(name: query, image: ''));
    } else {
      // Return search result for Items tab
      onSuggestionTap(query);
    }
  }

  void clearRecentSearches() {
    if (selectedTab.value == 0) {
      recentSearches.clear();
    } else {
      userRecentSearches.clear();
    }
    _persistRecentSearches();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class SearchUserModel {
  final String name;
  final String image;

  SearchUserModel({required this.name, required this.image});
}
