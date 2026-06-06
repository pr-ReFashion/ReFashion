import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import '../../categories/model/category_list_model.dart';
import '../../categories/service/categories_service.dart';
import 'package:refashion/app/services/wishlist_controller.dart';
import '../../product_detail/models/product_list_model.dart';
import '../../product_detail/service/product_service.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final TextEditingController searchController = TextEditingController();

  RxInt selectedTab = 1.obs; // 0: Men, 1: Women, 2: Kids

  // Products
  final RxBool isLoadingProducts = false.obs;
  final RxBool errorProducts = false.obs;
  final RxBool errorCategories = false.obs;
  final RxList<Product> newItems = <Product>[].obs;
  final RxList<Product> trendingItems = <Product>[].obs;

  RxSet<String> get wishlistedIds => WishlistController.to.wishlistedIds;

  // Home Banner
  final RxInt currentBannerIndex = 0.obs;
  final RxBool isLoadingBanners = false.obs;
  final List<Color> bannerPlaceholders = [ColorHelper.inputDecorationBorder, ColorHelper.buttonColor, ColorHelper.error, ColorHelper.secondPrimary];

  final ScrollController bannerScrollController = ScrollController();

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
    if (bannerPlaceholders.isNotEmpty && bannerPlaceholders.length > 6) {
      scrollToBannerIndex(index, bannerPlaceholders.length);
    }
  }

  double _edgeSpacingForCount(int count) {
    if (count >= 4) return 18.w;
    if (count == 3) return 16.w;
    if (count == 2) return 12.w;
    return 16.w;
  }

  void scrollToBannerIndex(int index, int totalCount) {
    if (!bannerScrollController.hasClients) return;

    double edge = _edgeSpacingForCount(totalCount);
    double prefixWidth = 0;

    if (index > 0) {
      prefixWidth = index * 16.w;
      prefixWidth += (edge - 4.w);
    }

    double activeLeftMargin = (index == 0) ? edge : 4.w;
    double activeItemWidth = 20.w;
    double activeCenter = prefixWidth + activeLeftMargin + (activeItemWidth / 2);

    double viewportWidth = (totalCount > 6 ? 6 : totalCount) * 24.w;
    double targetOffset = activeCenter - (viewportWidth / 2);

    double maxScroll = bannerScrollController.positions.first.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScroll);

    bannerScrollController.animateTo(targetOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  // Categories
  final CategoriesService _categoriesService = CategoriesService();
  final RxBool isLoadingCategories = false.obs;
  final RxList<ProductCategory> productCategories = <ProductCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoadingProducts.value = true;
      final response = await _productService.fetchProducts(limit: 25, offset: 0);
      if (response.products != null) {
        final all = response.products!;

        // 1. New Items: Take top 10 most recent
        newItems.assignAll(all.take(10).toList());

        // 2. Trending Items: Take the rest and shuffle
        if (all.length > 10) {
          final rest = all.skip(10).toList();
          rest.shuffle();
          trendingItems.assignAll(rest);
        } else {
          trendingItems.clear();
        }
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      if (newItems.isEmpty && trendingItems.isEmpty) {
        errorProducts.value = true;
      }
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> toggleWishlist(Product product) async {
    if (product.id == null) return;
    await WishlistController.to.toggleWishlist(product.id!);
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final response = await _categoriesService.fetchCategories(page: 1, limit: 10);

      if (response.productCategories != null) {
        //  productCategories.assignAll(response.productCategories!);
        final List<ProductCategory> sortedCategories = response.productCategories!;
        sortedCategories.sort((a, b) {
          final int rankA = a.rank ?? 999;
          final int rankB = b.rank ?? 999;
          return rankA.compareTo(rankB);
        });
        productCategories.assignAll(sortedCategories);
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      if (productCategories.isEmpty) {
        errorCategories.value = true;
      }
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void onCategoryTap(ProductCategory category) {
    Get.toNamed(Routes.categoryProducts, arguments: {'title': category.name ?? locale.value.categoriesText, 'category_id': category.id, 'type': 'category'});
  }

  // Navigation
  void goToSearch() {
    Get.toNamed(Routes.searchView);
  }

  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onMenuTap() {
    Get.toNamed(Routes.categories);
  }

  void goToProductDetail(Product product) {
    Get.toNamed(Routes.productDetail, arguments: product);
  }

  void onViewAllNewItems() {
    Get.toNamed(Routes.categoryProducts, arguments: {'title': locale.value.newItemsText, 'type': 'new_items'});
  }

  void onViewAllTrendingItems() {
    Get.toNamed(Routes.categoryProducts, arguments: {'title': locale.value.trendingItemsText, 'type': 'trending'});
  }

  void goToNews() {
    Get.toNamed(Routes.newsArea);
  }

  void goToNewsDetail(NewsModel news) {
    Get.toNamed(Routes.newsDetail, arguments: news);
  }

  // News
  final List<NewsModel> newsList = [
    NewsModel(title: 'Cinematic Nostalgia Collection', tag: 'Fashion', time: '12 min ago', image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=400&auto=format&fit=crop'),
    NewsModel(title: 'All about Dras, the hamlet i...', tag: 'Travel', time: '12 min ago', image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=400&auto=format&fit=crop'),
    NewsModel(title: 'All about Dras, the hamlet i...', tag: 'Travel', time: '12 min ago', image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=400&auto=format&fit=crop'),
    NewsModel(title: 'All about Dras, the hamlet i...', tag: 'Travel', time: '12 min ago', image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=400&auto=format&fit=crop'),
  ];

  Future<void> onRefresh() async {
    errorProducts.value = false;
    errorCategories.value = false;
    await Future.wait([fetchCategories(), fetchProducts(), WishlistController.to.fetchWishlist(isRefresh: true)]);
  }
}

class NewsModel {
  final String title;
  final String? description;
  final String? date;
  final String tag;
  final String time;
  final String image;

  NewsModel({required this.title, this.description, this.date, required this.tag, required this.time, required this.image});
}
