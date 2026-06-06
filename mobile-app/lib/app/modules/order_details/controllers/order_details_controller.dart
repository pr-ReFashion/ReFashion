import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/order_details/models/order_detail_model.dart'
    as model;
import 'package:refashion/app/modules/order_details/service/order_details_service.dart';
import 'package:refashion/app/modules/order_details/views/cancel_order_view.dart';
import 'package:refashion/app/modules/selling/models/order_item_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/modules/order_details/models/return_reasom_model.dart';
import 'package:refashion/app/modules/order_details/shimmer/return_reason_shimmer.dart';
import 'package:refashion/app/widget/dotted_line.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/common_button.dart';

class OrderDetailsController extends GetxController {
  final OrderDetailsService _service = OrderDetailsService();
  final Rxn<model.Order> orderDetail = Rxn<model.Order>();
  final RxBool isLoading = false.obs;
  final RxBool isReasonsLoading = false.obs;
  final RxList<ReturnReason> returnReasons = <ReturnReason>[].obs;
  final Rxn<ReturnReason> selectedReason = Rxn<ReturnReason>();

  String? orderId;
  bool isSellerOrder = false;

  final RxBool isCancellationSent = false.obs;
  final RxInt selectedRefundMode = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is OrderItemModel) {
      orderId = args.orderId;
      isSellerOrder = args.originalOrder != null;
    } else if (args is Map<String, dynamic>) {
      // Support Map arguments if coming from some other place
      orderId = args['id'];
      isSellerOrder = args['isSeller'] ?? false;
    } else if (args is String) {
      orderId = args;
    }

    if (orderId != null) {
      fetchOrderDetail();
    }
  }

  Future<void> fetchOrderDetail() async {
    if (orderId == null) return;

    try {
      isLoading.value = true;
      final response = isSellerOrder
          ? await _service.fetchVendorOrderDetail(orderId!)
          : await _service.fetchOrderDetail(orderId!);
      if (response != null && response.order != null) {
        orderDetail.value = response.order;
      }
    } catch (e) {
      debugPrint('Error fetching order detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onCancelTap() {
    isCancellationSent.value = false;
    Get.to(() => const CancelOrderView());
  }

  void onConfirmCancellation() {
    isCancellationSent.value = true;
  }

  Future<void> onReturnTap() async {
    selectedReason.value = null; // Clear previous selection
    fetchReturnReasons();
    Get.bottomSheet(_buildReturnBottomSheet(), isScrollControlled: true);
  }

  Future<void> fetchReturnReasons() async {
    try {
      isReasonsLoading.value = true;
      final response = await _service.fetchReturnReasons();
      if (response != null && response.returnReasons != null) {
        returnReasons.assignAll(response.returnReasons!);
      }
    } catch (e) {
      debugPrint('Error fetching return reasons: $e');
    } finally {
      isReasonsLoading.value = false;
    }
  }

  void onSelectReason(ReturnReason reason) {
    selectedReason.value = reason;
  }

  Future<void> onReturnConfirm() async {
    if (orderId == null || selectedReason.value == null) return;

    final order = orderDetail.value;
    if (order == null || order.items == null || order.items!.isEmpty) return;

    try {
      isLoading.value = true;
      Get.back(); // close sheet

      final Map<String, dynamic> data = {
        "order_id": orderId,
        "items": order.items!
            .map(
              (item) => {
                "id": item.id,
                "quantity": item.quantity ?? 1,
                "reason_id": selectedReason.value!.id,
              },
            )
            .toList(),
        "return_shipping": {
          "option_id": (order.shippingMethods?.isNotEmpty ?? false)
              ? order.shippingMethods!.first.shippingOptionId
              : null,
          "price": order.total,
        },
      };

      final success = await _service.createReturn(data);
      if (success) {
        toast(locale.value.toastReturnRequested);
        fetchOrderDetail();
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildReturnBottomSheet() {
    final l = locale.value;
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.returnOrder,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 20.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: ColorHelper.iconColor,
                    size: 22.sp,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(
            color: ColorHelper.borderColor,
            height: 1,
          ).paddingSymmetric(horizontal: 16.w),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              l.selectReason,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            if (isReasonsLoading.value && returnReasons.isEmpty) {
              return const ReturnReasonShimmer().paddingSymmetric(
                horizontal: 16.w,
              );
            }
            if (returnReasons.isEmpty) {
              return SizedBox(
                height: 120.h,
                child: Center(
                  child: Text(
                    l.noReasonsAvailable,
                    style: TextStyleHelper.urRegular400(),
                  ),
                ).paddingSymmetric(vertical: 20.h),
              );
            }
            return Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: returnReasons.length,
                itemBuilder: (context, index) {
                  final reason = returnReasons[index];
                  return _buildReasonOption(reason);
                },
              ),
            );
          }),
          Obx(
            () => returnReasons.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ).copyWith(bottom: 14.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonBtn(
                            text: l.cancelText,
                            onTap: () => Get.back(),
                            color: ColorHelper.white,
                            textColor: ColorHelper.subHeadingColor,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: const BorderSide(
                                color: ColorHelper.borderColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(
                            () => CommonBtn(
                              text: l.returnOrder,
                              onTap: selectedReason.value != null
                                  ? onReturnConfirm
                                  : null,
                              enabled: selectedReason.value != null,
                              disabledColor: ColorHelper.lightGrey,
                              textColor: selectedReason.value != null
                                  ? ColorHelper.white
                                  : ColorHelper.black,
                              isLoading: isLoading.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonOption(ReturnReason reason) {
    return Obx(
      () => InkWell(
        onTap: () => onSelectReason(reason),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Container(
                height: 20.r,
                width: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedReason.value?.id == reason.id
                        ? ColorHelper.primary
                        : ColorHelper.iconColor,
                    width: 1.5,
                  ),
                ),
                child: selectedReason.value?.id == reason.id
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
              Expanded(
                child: Text(
                  reason.label ?? reason.value ?? 'N/A',
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTrackTap() {
    Get.bottomSheet(_buildTrackBottomSheet(), isScrollControlled: true);
  }

  void onCloseBottomSheet() {
    Get.back();
  }

  void onPriceDetailTap() {
    final detail = orderDetail.value;
    if (detail != null) {
      Get.bottomSheet(
        _buildPaymentInfoBottomSheet(detail),
        isScrollControlled: true,
      );
    }
  }

  Widget _buildPaymentInfoBottomSheet(model.Order detail) {
    final l = locale.value;

    // Medusa usually returns values in minor units (e.g., cents),
    // but the mapper transformed some to double.
    // We'll normalize to string for the UI.
    final itemTotal = detail.itemSubtotal?.toString() ?? '0';
    final tax = detail.originalTaxTotal?.toString() ?? '0';
    final discount = detail.discountTotal?.toString() ?? '0';
    final shipping = detail.shippingTotal?.toString() ?? '0';
    final total = detail.total?.toString() ?? '0';

    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.paymentInformation,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 20.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: ColorHelper.iconColor,
                    size: 22.sp,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(
            color: ColorHelper.borderColor,
            height: 1,
          ).paddingSymmetric(horizontal: 16.w),
          SizedBox(height: 10.h),
          _buildPriceRow(l.itemTotal, itemTotal),
          SizedBox(height: 10.h),
          _buildPriceRow(l.discount, '-$discount'),
          SizedBox(height: 10.h),
          _buildPriceRow(l.tax, tax),
          SizedBox(height: 10.h),
          _buildPriceRow(l.shippingText, shipping),
          SizedBox(height: 10.h),
          _buildPriceRow(l.totalAmount, total, isBold: true),
          SizedBox(height: 8.h),
          const DottedLine().paddingSymmetric(horizontal: 16.w),
          SizedBox(height: 8.h),
          _buildPriceRow(l.totalPaid, total, isPrimary: true, isBold: true),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
            ).copyWith(bottom: 30.h),
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: ColorHelper.lightGrey,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icWallet,
                  size: 16.sp,
                  color: ColorHelper.iconColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  detail.paymentStatus?.toUpperCase() ?? 'N/A',
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
    );
  }

  Widget _buildPriceRow(
    String label,
    String euro, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 16.sp,
              color: isPrimary ? ColorHelper.primary : ColorHelper.headingColor,
              fontWeight: isBold || isPrimary
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
          Text(
            euro.toPrice(),
            style: TextStyleHelper.urRegular400().copyWith(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
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
            isLineCompleted: true,
          ),
          _buildTrackItem(
            title: 'Shipped',
            subtitle: 'by Thu - 9 Dec',
            isCompleted: true,
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

  void onChangeAddressTap() {
    // Handle change address
  }
}
