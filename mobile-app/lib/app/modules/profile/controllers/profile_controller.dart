import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/modules/selling/models/order_item_model.dart';
import 'package:refashion/app/modules/sell/service/sell_service.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/modules/selling/models/vendor_order_model.dart';
import 'follow_controller.dart';

class ProfileController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final SellService _sellService = SellService();

  final userName = ''.obs;
  final firstName = ''.obs;
  final lastName = ''.obs;
  final userId = ''.obs;
  final profileImage = ''.obs;
  final bio = ''.obs;
  final followersCount = 0.obs;
  final followingCount = 0.obs;
  final isLoading = false.obs;
  final isProductLoading = false.obs;
  final isMoreProductLoading = false.obs;
  final soldCount = 0.obs;
  final shippedCount = 0.obs;
  final cancelledCount = 0.obs;

  final ScrollController scrollController = ScrollController();

  int productLimit = 10;
  int currentProductPage = 1;
  int totalCount = 0;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchCustomerInfo();
    fetchMyProducts();
    fetchActivityCounts();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isMoreProductLoading.value &&
        !isProductLoading.value) {
      if (myProducts.length < totalCount) {
        currentProductPage++;
        fetchMyProducts(isLoadMore: true);
      }
    }
  }

  Future<void> fetchCustomerInfo() async {
    try {
      isLoading.value = true;
      final response = await _profileApiService.getCustomerInfo();
      if (response.customer != null) {
        final customer = response.customer!;
        final metadata = customer.metadata;

        userName.value = metadata?.username ?? '';
        firstName.value = customer.firstName ?? '';
        lastName.value = customer.lastName ?? '';
        userId.value = metadata?.refashionId ?? '';
        bio.value = metadata?.bio ?? '';
      }
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('404') || errorStr.contains('not found')) {
        _apiService.logout(forceLogout: true);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreProductLoading.value = true;
    } else {
      isProductLoading.value = true;
      currentProductPage = 1;
    }

    try {
      int offset = (currentProductPage - 1) * productLimit;
      final response = await _sellService.fetchVendorProducts(
        limit: productLimit,
        offset: offset,
      );
      if (response.products != null) {
        if (isLoadMore) {
          myProducts.addAll(response.products!);
        } else {
          myProducts.assignAll(response.products!);
        }
        totalCount = response.count ?? 0;
      }
    } catch (e) {
      debugPrint('Error fetching vendor products: $e');
    } finally {
      isProductLoading.value = false;
      isMoreProductLoading.value = false;
    }
  }

  Future<void> fetchActivityCounts() async {
    try {
      final response = await _apiService.get(
        ApiConfig.vendorOrders,
        queryParameters: {'order': '-created_at'},
        isSeller: true,
      );
      if (response != null) {
        final vendorOrderResponse = VendorOrderResponse.fromJson(response);
        int soldItems = 0;
        int shippedItems = 0;
        int cancelledItems = 0;

        final List<VendorOrder> vendorOrders = vendorOrderResponse.orders ?? [];
        for (final VendorOrder order in vendorOrders) {
          final status = order.status;
          final fStatus = order.fulfillmentStatus;

          if (status == 'canceled' || status == 'returned') {
            cancelledItems += (order.items?.length ?? 0);
            continue;
          }

          if (fStatus == 'shipped' ||
              fStatus == 'fulfilled' ||
              fStatus == 'partially_shipped' ||
              fStatus == 'partially_delivered') {
            shippedItems += (order.items?.length ?? 0);
          } else {
            soldItems += (order.items?.length ?? 0);
          }
        }
        soldCount.value = soldItems;
        shippedCount.value = shippedItems;
        cancelledCount.value = cancelledItems;
      }
    } catch (e) {
      debugPrint('Error fetching activity counts: $e');
    }
  }

  final selectedTab = 0.obs; // 0 for Buying, 1 for Selling

  final myProducts = <Product>[].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onProductTap(Product product) {
    Get.toNamed(Routes.productDetail, arguments: product);
  }

  void onChatTap() {
    Get.toNamed(Routes.supportChat);
  }

  void onSettingTap() {
    Get.toNamed(Routes.profileSettings);
  }

  void onFollowersTap() {
    Get.toNamed(Routes.followers, arguments: FollowType.followers);
  }

  void onFollowingTap() {
    Get.toNamed(Routes.following, arguments: FollowType.following);
  }

  void onSoldTap() {
    Get.toNamed(
      Routes.selling,
      arguments: {'title': locale.value.soldText, 'status': OrderStatus.sold},
    );
  }

  void onShippedTap() {
    Get.toNamed(
      Routes.selling,
      arguments: {
        'title': locale.value.shippedText,
        'status': OrderStatus.shipped,
      },
    );
  }

  void onCancelledTap() {
    Get.toNamed(
      Routes.selling,
      arguments: {
        'title': locale.value.cancelledText,
        'status': OrderStatus.cancelled,
      },
    );
  }

  void onPurchasedTap() {
    Get.toNamed(
      Routes.buying,
      arguments: {
        'title': locale.value.purchased,
        'status': OrderStatus.purchased,
      },
    );
  }

  void onReceivedTap() {
    Get.toNamed(
      Routes.buying,
      arguments: {
        'title': locale.value.received,
        'status': OrderStatus.received,
      },
    );
  }

  void onReturnedTap() {
    Get.toNamed(
      Routes.buying,
      arguments: {
        'title': locale.value.returned,
        'status': OrderStatus.returned,
      },
    );
  }

  Future<void> onRefresh() async {
    await Future.wait([
      fetchCustomerInfo(),
      fetchMyProducts(),
      fetchActivityCounts(),
    ]);
  }
}
