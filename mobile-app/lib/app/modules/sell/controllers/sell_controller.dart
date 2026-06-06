import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/modules/sell/service/sell_service.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';
import 'package:refashion/app/modules/profile/service/profile_api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'add_item_controller.dart';

class SellController extends GetxController {
  final ProfileApiService _profileApiService = ProfileApiService();
  final SellService _sellService = SellService();

  final List<Product> products = <Product>[].obs;
  final isLoading = true.obs;
  final isMoreLoading = false.obs;
  final isDeleting = false.obs;
  final storeStatus = "".obs;

  final ScrollController scrollController = ScrollController();

  int limit = 10;
  int currentProductPage = 1;
  int totalCount = 0;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
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
        !isMoreLoading.value &&
        !isLoading.value) {
      if (products.length < totalCount) {
        currentProductPage++;
        fetchProducts(isLoadMore: true, showLoader: false);
      }
    }
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchSellerInfo(showLoader: false),
        fetchProducts(showLoader: false),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSellerInfo({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;
      final response = await _profileApiService.getSellerInfo();
      if (response.seller != null) {
        storeStatus.value = response.seller!.storeStatus ?? "";
      }
    } catch (e) {
      debugPrint('Error fetching seller info: $e');
      storeStatus.value = "ERROR";
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> fetchProducts({
    bool isLoadMore = false,
    bool showLoader = true,
  }) async {
    if (isLoadMore) {
      if (products.length >= totalCount) return;
      isMoreLoading.value = true;
    } else {
      if (showLoader) isLoading.value = true;
      currentProductPage = 1;
    }

    int offset = (currentProductPage - 1) * limit;
    log("current product page :$currentProductPage");
    log("offset: $offset");

    try {
      final response = await _sellService.fetchVendorProducts(
        limit: limit,
        offset: offset,
      );

      if (isLoadMore) {
        products.addAll(response.products ?? []);
      } else {
        products.assignAll(response.products ?? []);
      }

      totalCount = response.count ?? 0;
    } catch (e) {
      debugPrint('Error fetching vendor products: $e');
    } finally {
      if (showLoader) isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void addNewItem() {
    if (Get.isRegistered<AddItemController>()) {
      Get.find<AddItemController>().reset();
    }
    Get.toNamed(Routes.listingAnItem);
  }

  void onCancelDelete() {
    Get.back();
  }

  Future<void> onConfirmDelete(Product item, int index) async {
    // 1. Close bottom sheet immediately
    Get.back();

    try {
      if (item.id == null) return;
      isDeleting.value = true;

      final response = await _sellService.deleteProduct(item.id!);
      if (response != null) {
        products.removeAt(index);
        toast(locale.value.toastProductDeleted);
      }
    } catch (e) {
      debugPrint('Error deleting product: $e');
      toast(e.toString());
    } finally {
      isDeleting.value = false;
    }
  }

  void showDeleteConfirmation(Product item, int index) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedImageView(
                      imagePath: item.thumbnail ?? "",
                      height: 60.h,
                      width: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.value.deleteItem,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          locale.value.areYouSureToDeleteItem,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CommonBtn(
                    onTap: onCancelDelete,
                    color: ColorHelper.transparent,
                    text: locale.value.cancelText,
                    textColor: ColorHelper.subHeadingColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(color: ColorHelper.borderColor),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    onTap: () => onConfirmDelete(item, index),
                    text: locale.value.confirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> onRefresh() async {
    await _loadInitialData();
  }
}
