import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/buying/models/order_list_model.dart'
    as model;
import 'package:refashion/app/modules/buying/services/buying_service.dart';
import 'package:refashion/app/modules/selling/models/order_item_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class BuyingController extends GetxController {
  final BuyingService _buyingService = BuyingService();
  final RxString title = 'Purchased'.obs;
  final RxList<OrderItemModel> items = <OrderItemModel>[].obs;
  final RxList<OrderItemModel> filteredItems = <OrderItemModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedSort = 'Anytime'.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      title.value = args['title'] ?? 'Purchased';
    }
    fetchOrderList();
  }

  Future<void> fetchOrderList() async {
    try {
      isLoading.value = true;
      final orderList = await _buyingService.fetchOrders();
      if (orderList != null && orderList.orders != null) {
        final List<OrderItemModel> mappedItems = [];
        for (var order in orderList.orders!) {
          if (order.items != null && order.items!.isNotEmpty) {
            for (var item in order.items!) {
              mappedItems.add(_mapToOrderItemModel(order, item));
            }
          }
        }

        // Filter based on activity type from current title
        final String currentTitle = title.value.toLowerCase();
        final List<OrderItemModel> filteredByActivity = mappedItems.where((
          item,
        ) {
          if (currentTitle.contains('received')) {
            return item.status == OrderStatus.received;
          } else if (currentTitle.contains('returned')) {
            return item.status == OrderStatus.returned;
          } else {
            // Default to Purchased: includes placed, shipped, and cancelled
            return item.status == OrderStatus.purchased ||
                item.status == OrderStatus.shipped ||
                item.status == OrderStatus.cancelled;
          }
        }).toList();

        items.assignAll(filteredByActivity);
        filteredItems.assignAll(filteredByActivity);
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  OrderItemModel _mapToOrderItemModel(model.Order order, model.Item item) {
    final l = locale.value;

    // Determine OrderStatus
    OrderStatus status = OrderStatus.purchased;
    String statusText = l.orderPlaced;
    String dateText = '';

    if (order.createdAt != null) {
      dateText = DateFormat('EEE, d MMM').format(order.createdAt!);
    }

    if (order.status == 'canceled') {
      status = OrderStatus.cancelled;
      statusText = l.cancelledText;
    } else if (order.fulfillmentStatus == 'shipped') {
      status = OrderStatus.shipped;
      statusText = l.inTransit;
      dateText = l.shippedOn(dateText);
    } else if (order.fulfillmentStatus == 'delivered' ||
        order.status == 'completed') {
      status = OrderStatus.received;
      statusText = l.received;
      dateText = 'Delivered on $dateText';
    } else if (order.status == 'returned') {
      status = OrderStatus.returned;
      statusText = l.returned;
      dateText = l.onDate(dateText);
    } else {
      statusText = l.orderPlaced;
      dateText = 'Placed on $dateText';
    }

    return OrderItemModel(
      title: item.productTitle ?? item.title ?? 'N/A',
      description: item.productDescription ?? item.subtitle ?? '',
      image: item.thumbnail ?? '',
      statusText: statusText,
      dateText: dateText,
      status: status,
      trackStatus: order.fulfillmentStatus == 'shipped'
          ? 'Arriving soon'
          : null,
      orderId: order.id,
    );
  }

  void onItemTap(OrderItemModel item) {
    Get.toNamed(Routes.orderDetails, arguments: item);
  }

  void onSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredItems.assignAll(items);
    } else {
      filteredItems.assignAll(
        items
            .where(
              (item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void updateSort(String sort) {
    selectedSort.value = sort;
  }

  void onSortTap() {
    Get.bottomSheet(_buildSortBottomSheet(), isScrollControlled: true);
  }

  void onTrackTap() {
    Get.bottomSheet(_buildTrackBottomSheet(), isScrollControlled: true);
  }

  void onClearSort() {
    Get.back();
  }

  void onApplySort() {
    Get.back();
  }

  void onCloseBottomSheet() {
    Get.back();
  }

  void onBackTap() {
    Get.back();
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
