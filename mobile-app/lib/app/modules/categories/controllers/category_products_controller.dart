import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/custom_check_box.dart';
import 'package:refashion/app/services/wishlist_controller.dart';
import '../../product_detail/models/product_list_model.dart';
import '../../product_detail/service/product_service.dart';
import 'package:refashion/app/utills/price_formatter.dart';

class AppliedFilter {
  final String type;
  final String value;

  AppliedFilter({required this.type, required this.value});
}

class CategoryProductsController extends GetxController {
  final ProductService _productService = ProductService();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingMoreProducts = false.obs;
  final RxInt totalProductCount = 0.obs;

  int currentProductPage = 1;
  final int productLimit = 10;
  bool hasMoreProducts = true;
  final RxString searchQuery = ''.obs;

  RxSet<String> get wishlistedIds => WishlistController.to.wishlistedIds;

  String? title;
  String? categoryId;
  String? collectionId;
  String? type;

  ScrollController productScrollController = ScrollController();

  final RxInt selectedSortIndex = 0.obs;
  final RxInt selectedConditionIndex = 5.obs; // Default to 'Any'

  // Filter persistence
  final RxMap<String, Set<String>> selectedFilters = <String, Set<String>>{
    'Material': {},
    'Collection Title': {},
    'Category': {},
  }.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 10000).obs;
  final RxInt appliedFilterCount = 0.obs;

  List<AppliedFilter> get activeFilters {
    final List<AppliedFilter> list = [];
    selectedFilters.forEach((key, values) {
      for (var value in values) {
        list.add(AppliedFilter(type: key, value: value));
      }
    });

    if (priceRange.value.start != 0 || priceRange.value.end != 10000) {
      list.add(
        AppliedFilter(
          type: 'Price',
          value:
              '${priceRange.value.start.toPrice(decimalDigits: 0)} - ${priceRange.value.end.toPrice(decimalDigits: 0)}',
        ),
      );
    }
    return list;
  }

  String get displayTitle {
    final categories = selectedFilters['Category'] ?? <String>{};
    final collections = selectedFilters['Collection Title'] ?? <String>{};

    // Case 1: Multiple filters selected across any tab
    // If more than one filter is active, show "Filtered Results"
    if (appliedFilterCount.value > 1) {
      return locale.value.filteredResultsText;
    }

    // Case 2: Only 1 specific Collection is active
    if (collections.length == 1) {
      return collections.first;
    }

    // Case 3: Only 1 specific Category is active
    if (categories.length == 1) {
      return categories.first;
    }

    // Case 4: Default Fallback to original entrance title
    return title ?? locale.value.categoriesText;
  }

  void removeFilter(AppliedFilter filter) {
    if (filter.type == 'Price') {
      priceRange.value = const RangeValues(0, 10000);
    } else {
      final set = selectedFilters[filter.type];
      if (set != null) {
        set.remove(filter.value);
        selectedFilters[filter.type] = Set.from(set);
      }
    }
    updateFilterCount();
    // Re-fetch products starting from the first page, choosing the right method/endpoint automatically
    fetchProducts(isRefresh: true);
  }

  Future<void> applyCurrentFilters({bool isRefresh = false}) async {
    if (isRefresh && isLoadingProducts.value) return;
    if (!isRefresh &&
        (isLoadingMoreProducts.value || isLoadingProducts.value)) {
      return;
    }

    try {
      if (isRefresh) {
        currentProductPage = 1;
        hasMoreProducts = true;
        isLoadingProducts.value = true;
      } else {
        isLoadingMoreProducts.value = true;
      }

      int offset = (currentProductPage - 1) * productLimit;

      final String? material = selectedFilters['Material']!.isNotEmpty
          ? selectedFilters['Material']!.map((e) => e.toLowerCase()).join(',')
          : null;
      final String? collection = selectedFilters['Collection Title']!.isNotEmpty
          ? selectedFilters['Collection Title']!
                .map((e) => e.toLowerCase())
                .join(',')
          : null;
      final String? categoryName = selectedFilters['Category']!.isNotEmpty
          ? selectedFilters['Category']!.map((e) => e.toLowerCase()).join(',')
          : null;

      final results = await _productService.fetchFilteredProducts(
        material: material,
        collection: collection,
        categoryName: categoryName,
        minPrice: priceRange.value.start,
        maxPrice: priceRange.value.end,
        limit: productLimit,
        offset: offset,
      );

      if (results.products != null) {
        final fetchedProducts = results.products!;
        if (isRefresh) {
          products.assignAll(fetchedProducts);
        } else {
          products.addAll(fetchedProducts);
        }

        final int apiCount = results.count ?? 0;
        final int currentLoadedCount = products.length;
        totalProductCount.value = apiCount > currentLoadedCount
            ? apiCount
            : currentLoadedCount;

        if (fetchedProducts.length < productLimit) {
          hasMoreProducts = false;
        } else {
          currentProductPage++;
        }
      }
    } catch (e) {
      debugPrint('Error applying filters: $e');
    } finally {
      isLoadingProducts.value = false;
      isLoadingMoreProducts.value = false;
    }
  }

  void updateFilterCount() {
    int count = 0;
    selectedFilters.forEach((key, value) {
      count += value.length;
    });
    if (priceRange.value.start != 0 || priceRange.value.end != 10000) {
      count += 1;
    }
    appliedFilterCount.value = count;
  }

  final List<String> sortOptions = [
    'Most Recent',
    'Lowest Price',
    'Highest Price',
  ];

  final List<String> conditionOptions = [
    'Fair',
    'Good',
    'Very Good',
    'Never Worn',
    'Never Worn with Tag',
    'Any',
  ];

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is Map) {
      title = args['title'];
      categoryId = args['category_id'];
      collectionId = args['collection_id'];
      type = args['type'];
      if (args['q'] != null) {
        searchQuery.value = args['q'];
      }
    } else if (args is String) {
      title = args;
      type = 'category';
    }

    // Pre-populate active filters if arriving from a category or collection
    if (type == 'category' && title != null && title!.isNotEmpty) {
      // Don't auto-add categories like 'New Items' or 'Trending Items' that act as dynamic segments
      if (title != locale.value.newItemsText &&
          title != locale.value.trendingItemsText &&
          title != locale.value.categoriesText) {
        selectedFilters['Category'] = {title!};
      }
    } else if (type == 'collection' && title != null && title!.isNotEmpty) {
      selectedFilters['Collection Title'] = {title!};
    }
    updateFilterCount();

    productScrollController.addListener(_productListener);
    if (products.isEmpty) {
      fetchProducts(isRefresh: true);
    } else {
      isLoadingProducts.value = false;
    }
  }

  void _productListener() {
    if (!productScrollController.hasClients) return;
    if (productScrollController.position.pixels >=
            productScrollController.position.maxScrollExtent - 200 &&
        !isLoadingMoreProducts.value &&
        !isLoadingProducts.value &&
        hasMoreProducts) {
      loadMoreProducts();
    }
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh && isLoadingProducts.value) return;
    if (!isRefresh &&
        (isLoadingMoreProducts.value || isLoadingProducts.value)) {
      return;
    }

    // If filters are applied, use the filter-specific fetch method
    if (appliedFilterCount.value > 0) {
      return applyCurrentFilters(isRefresh: isRefresh);
    }

    try {
      if (isRefresh) {
        currentProductPage = 1;
        hasMoreProducts = true;
        isLoadingProducts.value = true;
      }

      int currentLimit = productLimit;
      int offset = (currentProductPage - 1) * productLimit;

      // New Items logic: only top 10
      if (type == 'new_items') {
        currentLimit = 10;
        offset = 0;
      }
      // Trending logic: start from index 10
      else if (type == 'trending') {
        offset = offset + 10;
      }

      final response = await _productService.fetchProducts(
        limit: currentLimit,
        offset: offset,
        categoryIds: categoryId != null ? [categoryId!] : null,
        collectionId: collectionId,
        q: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      if (response.products != null) {
        final fetchedProducts = response.products!;

        if (type == 'new_items') {
          totalProductCount.value = fetchedProducts.length;
          products.assignAll(fetchedProducts);
          hasMoreProducts = false;
        } else if (type == 'trending') {
          totalProductCount.value = (response.count ?? 0) > 10
              ? (response.count! - 10)
              : 0;
          if (isRefresh) {
            products.assignAll(fetchedProducts);
          } else {
            products.addAll(fetchedProducts);
          }
          if (fetchedProducts.length < productLimit) {
            hasMoreProducts = false;
          } else {
            currentProductPage++;
          }
        } else {
          if (isRefresh) {
            products.assignAll(fetchedProducts);
          } else {
            products.addAll(fetchedProducts);
          }

          final int apiCount = response.count ?? 0;
          final int currentLoadedCount = products.length;
          totalProductCount.value = apiCount > currentLoadedCount
              ? apiCount
              : currentLoadedCount;

          if (fetchedProducts.length < productLimit) {
            hasMoreProducts = false;
          } else {
            currentProductPage++;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> toggleWishlist(Product product) async {
    if (product.id == null) return;
    await WishlistController.to.toggleWishlist(product.id!);
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMoreProducts.value || !hasMoreProducts) return;

    try {
      await fetchProducts();
    } finally {
      isLoadingMoreProducts.value = false;
    }
  }

  Future<void> onRefreshProducts() async {
    await Future.wait([
      fetchProducts(isRefresh: true),
      WishlistController.to.fetchWishlist(isRefresh: true),
    ]);
  }

  Future<void> onSearchTap() async {
    final result = await Get.toNamed(
      Routes.searchView,
      arguments: {'isFromCategory': true},
    );
    if (result is String) {
      searchQuery.value = result;
      fetchProducts(isRefresh: true);
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    onRefreshProducts();
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onSortByTap() {
    Get.bottomSheet(
      _CommonSheetWrapper(
        title: locale.value.sortByText,
        child: Column(
          children: sortOptions.asMap().entries.map((entry) {
            return Obx(
              () => _SortOptionItem(
                title: entry.value,
                isSelected: selectedSortIndex.value == entry.key,
                onTap: () => onSortOptionTap(entry.key),
              ),
            );
          }).toList(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void onConditionTap() {
    Get.bottomSheet(
      _CommonSheetWrapper(
        title: locale.value.conditionText,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: conditionOptions.asMap().entries.map((entry) {
            return Obx(
              () => _ConditionOptionItem(
                title: entry.value,
                isSelected: selectedConditionIndex.value == entry.key,
                onTap: () => onConditionOptionTap(entry.key),
              ),
            );
          }).toList(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void onSortOptionTap(int index) {
    selectedSortIndex.value = index;
    Get.back();
  }

  void onConditionOptionTap(int index) {
    selectedConditionIndex.value = index;
    Get.back();
  }

  void onFilterTap() async {
    final dynamic rawArgs = Get.arguments;
    Map<String, dynamic> args = {};
    if (rawArgs is Map) {
      args = Map.from(rawArgs);
    } else if (rawArgs is String) {
      args['title'] = rawArgs;
    }

    // Add filter state to arguments
    args['selectedFilters'] = Map<String, Set<String>>.from(selectedFilters);
    args['priceRange'] = priceRange.value;

    final result = await Get.toNamed(Routes.filter, arguments: args);

    if (result is Map) {
      if (result.containsKey('selectedFilters')) {
        selectedFilters.assignAll(
          result['selectedFilters'] as Map<String, Set<String>>,
        );
      }
      if (result.containsKey('priceRange')) {
        priceRange.value = result['priceRange'] as RangeValues;
      }
      updateFilterCount();
      // Fetch products after a short delay for smooth transition OR immediately
      applyCurrentFilters(isRefresh: true);
    }
  }

  void onSaveSearchTap() {
    // Save search logic
  }

  void onProductFavoriteTap(int index) {
    if (index >= 0 && index < products.length) {
      toggleWishlist(products[index]);
    }
  }

  void onProductTap(int index) {
    if (index >= 0 && index < products.length) {
      Get.toNamed(Routes.productDetail, arguments: products[index]);
    }
  }

  @override
  void onClose() {
    productScrollController.removeListener(_productListener);
    super.onClose();
  }
}

class _CommonSheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _CommonSheetWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 20.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  size: 22.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1, color: ColorHelper.borderColor),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

class _SortOptionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorHelper.primaryLightColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
      ),
    );
  }
}

class _ConditionOptionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionOptionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          children: [
            CustomCheckbox(
              value: isSelected,
              size: 18.sp,
              onChanged: (_) => onTap(),
              activeColor: ColorHelper.primary,
              borderColor: ColorHelper.iconColor,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
