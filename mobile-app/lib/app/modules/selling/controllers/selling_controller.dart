import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/order_item_model.dart';
import '../models/vendor_order_model.dart';
import 'package:intl/intl.dart';

class SellingController extends GetxController {
  final RxString title = 'Sold'.obs;
  final RxList<OrderItemModel> items = <OrderItemModel>[].obs;
  final RxList<OrderItemModel> filteredItems = <OrderItemModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedSort = 'Anytime'.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  OrderStatus? selectedStatus;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      title.value = args['title'] ?? 'Orders';
      selectedStatus = args['status'];
    }
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(
        ApiConfig.vendorOrders,
        queryParameters: {'order': '-created_at'},
        isSeller: true,
      );
      if (response != null) {
        final vendorOrderResponse = VendorOrderResponse.fromJson(response);
        final List<OrderItemModel> mappedItems =
            (vendorOrderResponse.orders ?? [])
                .map((order) => _mapVendorOrderToOrderItem(order))
                .toList();

        items.assignAll(mappedItems);
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error fetching vendor orders: $e');
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  OrderItemModel _mapVendorOrderToOrderItem(VendorOrder order) {
    final l = locale.value;
    final firstItem = order.items?.firstOrNull;

    // Map status
    OrderStatus status = OrderStatus.sold;
    String statusText = l.confirmed;

    // Mapping logic based on agreed categories
    if (order.status == 'canceled' || order.status == 'returned') {
      status = OrderStatus.cancelled;
      statusText = order.status == 'canceled' ? l.cancelledText : l.returned;
    } else if (order.status == 'completed') {
      status = OrderStatus.sold;
      statusText = l.received;
    } else {
      // Logic based on fulfillment for pending/other orders
      final fStatus = order.fulfillmentStatus;
      if (fStatus == 'shipped' ||
          fStatus == 'fulfilled' ||
          fStatus == 'partially_shipped' ||
          fStatus == 'partially_delivered') {
        status = OrderStatus.shipped;
        statusText = l.shippedText;
      } else {
        // Default to Sold (Pending items awaiting fulfillment)
        status = OrderStatus.sold;
        statusText = l.confirmed;
      }
    }

    String dateText = '';
    if (order.createdAt != null) {
      dateText = DateFormat('EEE, d MMM').format(order.createdAt!);
    }

    return OrderItemModel(
      title: firstItem?.title ?? 'Product',
      description: firstItem?.variant?.title ?? '',
      image: firstItem?.thumbnail ?? '',
      statusText: statusText,
      dateText: dateText,
      status: status,
      orderId: order.id,
      trackStatus: order.fulfillmentStatus == 'fulfilled' ? 'In Transit' : null,
      originalOrder: order,
    );
  }

  void onItemTap(OrderItemModel item) {
    Get.toNamed(Routes.orderDetails, arguments: item);
  }

  void onSearch(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void updateSort(String sort) {
    selectedSort.value = sort;
  }

  void _applyFilters() {
    List<OrderItemModel> results = List.from(items);

    // Filter by initial status from arguments
    if (selectedStatus != null) {
      if (selectedStatus == OrderStatus.sold) {
        // Sold tab shows pending orders
        results = results
            .where((item) => item.status == OrderStatus.sold)
            .toList();
      } else if (selectedStatus == OrderStatus.shipped) {
        // Shipped tab shows orders that are already shipped
        results = results
            .where((item) => item.status == OrderStatus.shipped)
            .toList();
      } else if (selectedStatus == OrderStatus.received) {
        // Received tab shows completed orders
        results = results
            .where((item) => item.status == OrderStatus.received)
            .toList();
      } else {
        results = results
            .where((item) => item.status == selectedStatus)
            .toList();
      }
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      results = results
          .where(
            (item) =>
                item.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Filter by date
    final now = DateTime.now();
    if (selectedSort.value != 'Anytime') {
      DateTime cutoff;
      if (selectedSort.value.contains('30 Days')) {
        cutoff = now.subtract(const Duration(days: 30));
      } else if (selectedSort.value.contains('6 Months')) {
        cutoff = now.subtract(const Duration(days: 180));
      } else if (selectedSort.value.contains('Year')) {
        cutoff = now.subtract(const Duration(days: 365));
      } else {
        cutoff = DateTime(1900);
      }

      results = results.where((item) {
        final orderDate = item.originalOrder?.createdAt;
        return orderDate != null && orderDate.isAfter(cutoff);
      }).toList();
    }

    filteredItems.assignAll(results);
  }

  void onClearSort() {
    selectedSort.value = 'Anytime';
    _applyFilters();
    Get.back();
  }

  void onApplySort() {
    _applyFilters();
    Get.back();
  }

  void onCloseBottomSheet() {
    Get.back();
  }

  void onBackTap() {
    Get.back();
  }

  void onSortTap() {
    Get.bottomSheet(_buildSortBottomSheet(), isScrollControlled: true);
  }

  void onTrackTap() {
    Get.bottomSheet(_buildTrackBottomSheet(), isScrollControlled: true);
  }

  Widget _buildSortBottomSheet() {
    final l = locale.value;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 30.h),
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
                l.sortByText,
                style: TextStyleHelper.urMedium500().copyWith(fontSize: 20.sp),
              ),
              IconButton(
                onPressed: onCloseBottomSheet,
                padding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close,
                  color: ColorHelper.iconColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
          const Divider(
            color: ColorHelper.borderColor,
            height: 1,
          ).paddingOnly(right: 6.w),
          SizedBox(height: 10.h),
          _buildSortOption(l.anytime),
          _buildSortOption(l.last30Days),
          _buildSortOption(l.last6Months),
          _buildSortOption(l.lastYear),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CommonBtn(
                  text: l.clear,
                  onTap: onClearSort,
                  color: ColorHelper.white,
                  textColor: ColorHelper.subHeadingColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(color: ColorHelper.borderColor),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CommonBtn(text: l.apply, onTap: onApplySort),
              ),
            ],
          ).paddingOnly(right: 6.w),
        ],
      ),
    );
  }

  Widget _buildSortOption(String label) {
    return Obx(
      () => InkWell(
        onTap: () => updateSort(label),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(right: 6.w),
          child: Row(
            children: [
              Container(
                height: 20.r,
                width: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedSort.value == label
                        ? ColorHelper.primary
                        : ColorHelper.iconColor,
                    width: 1.5,
                  ),
                ),
                child: selectedSort.value == label
                    ? Center(
                        child: Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: const BoxDecoration(
                            color: ColorHelper.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackBottomSheet() {
    final l = locale.value;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 30.h),
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
                l.track,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 20.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              IconButton(
                onPressed: onCloseBottomSheet,
                padding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close,
                  color: ColorHelper.iconColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
          const Divider(
            color: ColorHelper.borderColor,
            height: 1,
          ).paddingOnly(right: 6.w),
          SizedBox(height: 8.h),
          Text(
            l.status,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 16.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTrackItem(
            title: 'Arriving',
            subtitle: 'by 11 Dec - 13 Dec',
            isCompleted: false,
            isFirst: true,
          ),
          _buildTrackItem(
            title: 'Shipped',
            subtitle: 'by Thu - 9 Dec',
            isCompleted: false,
            isLineCompleted: true,
          ),
          _buildTrackItem(
            title: 'Order Placed',
            subtitle: 'on Fri, 5 Dec',
            isCompleted: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
    bool isLineCompleted = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? ColorHelper.primary
                      : ColorHelper.subHeadingColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: ColorHelper.white,
                    size: 16.sp,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: isLineCompleted
                        ? ColorHelper.primary
                        : ColorHelper.subHeadingColor.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyleHelper.urBold700().copyWith(
                          fontSize: 16.sp,
                          color: isCompleted
                              ? ColorHelper.primary
                              : ColorHelper.headingColor,
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      TextSpan(
                        text: subtitle,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
