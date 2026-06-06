import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:refashion/app/modules/profile/controllers/region_controller.dart';
import 'package:refashion/app/modules/order_details/models/order_detail_model.dart'
    as model;
import 'package:refashion/app/modules/order_details/shimmer/order_details_shimmer.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/constant/common_button.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.orderDetails),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const OrderDetailsShimmer();
        }

        final detail = controller.orderDetail.value;
        if (detail == null) {
          return EmptyWidget(
            title: locale.value.errorNotFound,
            description: locale.value.orderDetailsNotFoundDesc,
            icon: ImageHelper.noDataFound,
            btnText: locale.value.goBack,
            onTap: () => Get.back(),
          );
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),
                    _buildProductInfo(detail),
                    SizedBox(height: 24.h),
                    // _buildTimeline(detail),
                    // SizedBox(height: 12.h),
                    // _buildActionButtons(),
                    // SizedBox(height: 24.h),
                    _buildMyActivity(detail),
                    SizedBox(height: 24.h),
                    _buildTotalItemPrice(detail),
                    SizedBox(height: 24.h),
                    _buildUpdatesSentTo(detail),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
            _buildFixedBottomButton(detail),
          ],
        );
      }),
    );
  }

  Widget _buildFixedBottomButton(model.Order detail) {
    final orderStatus = detail.status;
    final fulfillmentStatus = detail.fulfillmentStatus;

    // Check if any shipping method has a return id
    final bool hasReturnId =
        detail.shippingMethods?.any(
          (method) => method.detail?.returnId != null,
        ) ??
        false;

    // Show "Return Order" if order is completed or delivered, it's not already returned, and user is not the seller
    bool canReturn =
        (orderStatus == 'completed' || fulfillmentStatus == 'delivered') &&
        !hasReturnId;

    if (!canReturn) return const SizedBox.shrink();

    return CommonBtn(
      text: locale.value.returnOrder,
      onTap: controller.onReturnTap,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      isLoading: controller.isLoading.value,
    );
  }

  Widget _buildProductInfo(model.Order detail) {
    final item = detail.items?.first;
    if (item == null) return const SizedBox.shrink();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedImageView(
            imagePath: item.thumbnail ?? '',
            height: 100.sp,
            width: 100.sp,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          item.productTitle ?? item.title ?? '',
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 16.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            item.productDescription ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /* Widget _buildTimeline(OrderDetailModel detail) {
    // Map existing OrderStepModel to new TimelineStepModel for the reusable widget
    final List<TimelineStepModel> steps = detail.timeline.map((step) {
      TimelineStatus status;
      if (step.isCurrent) {
        status = TimelineStatus.active;
      } else if (step.isCompleted) {
        status = TimelineStatus.completed;
      } else {
        status = TimelineStatus.upcoming;
      }

      return TimelineStepModel(
        title: step.title,
        subtitle: (step.date.isNotEmpty)
            ? (step.title.toLowerCase().contains('order placed')
                  ? 'on ${step.date}'
                  : 'by ${step.date}')
            : '',
        status: status,
      );
    }).toList();

    return OrderTimelineWidget(steps: steps);
  }

  Widget _buildActionButtons() {
    final detail = controller.orderDetail.value;
    if (detail == null) return const SizedBox.shrink();

    final status = detail.item.status;

    // Hide all buttons if the order is cancelled, returned, or received
    if (status == OrderStatus.cancelled ||
        status == OrderStatus.returned ||
        status == OrderStatus.received) {
      return const SizedBox.shrink();
    }

    // Determine visibility based on status
    bool showCancel =
        status == OrderStatus.purchased || status == OrderStatus.sold;
    bool showTrack =
        status == OrderStatus.purchased ||
        status == OrderStatus.sold ||
        status == OrderStatus.shipped;

    if (!showCancel && !showTrack) return const SizedBox.shrink();

    return Row(
      children: [
        if (showCancel)
          Expanded(
            child: CommonBtn(
              text: locale.value.cancelText,
              onTap: controller.onCancelTap,
              color: ColorHelper.white,
              textColor: ColorHelper.subHeadingColor,
              // height: 36.h,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: const BorderSide(color: ColorHelper.borderColor),
              ),
            ),
          ),
        if (showCancel && showTrack) SizedBox(width: 12.w),
        if (showTrack)
          Expanded(
            child: CommonBtn(
              text: locale.value.track,
              onTap: controller.onTrackTap,
              color: ColorHelper.white,
              textColor: ColorHelper.subHeadingColor,
              // height: 36.h,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: const BorderSide(color: ColorHelper.borderColor),
              ),
            ),
          ),
      ],
    );
  } */

  Widget _buildMyActivity(model.Order detail) {
    if (detail.shippingAddress == null && detail.billingAddress == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          locale.value.myActivity,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildAddressSection(
          locale.value.shippingAddress,
          detail.shippingAddress,
          detail.regionId,
        ),
        if (detail.billingAddress != null) ...[
          SizedBox(height: 16.h),
          _buildAddressSection(
            locale.value.billingAddress,
            detail.billingAddress,
            detail.regionId,
          ),
        ],
      ],
    );
  }

  Widget _buildAddressSection(
    String title,
    model.IngAddress? address,
    String? regionId,
  ) {
    if (address == null) return const SizedBox.shrink();

    final fullName = '${address.firstName ?? ''} ${address.lastName ?? ''}'
        .trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.subHeadingColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName.isNotEmpty ? fullName : '',
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                [
                  if (address.address1 != null && address.address1!.isNotEmpty)
                    address.address1,
                  if (address.address2 != null && address.address2!.isNotEmpty)
                    address.address2,
                  if (address.postalCode != null &&
                      address.postalCode!.isNotEmpty) ...[
                    if (address.city != null && address.city!.isNotEmpty) ...[
                      "${address.postalCode} ${address.city}",
                    ] else ...[
                      address.postalCode,
                    ],
                  ],

                  if (address.province != null && address.province!.isNotEmpty)
                    address.province,

                  if (address.countryCode != null &&
                      address.countryCode!.isNotEmpty)
                    _getCountryName(address.countryCode),
                  if (regionId != null && regionId.isNotEmpty)
                    _getRegionName(regionId),
                ].whereType<String>().join(', '),
                style: TextStyleHelper.dmRegular400().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.subHeadingColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalItemPrice(model.Order detail) {
    final priceEuro = detail.total?.toString() ?? '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          locale.value.totalItemPrice,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: controller.onPriceDetailTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      priceEuro.toPrice(),
                      style: TextStyleHelper.urSemiBold600().copyWith(
                        fontSize: 14.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorHelper.iconColor,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: ColorHelper.lightGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      CachedImageView(
                        imagePath: ImageHelper.icWallet,
                        size: 18.sp,
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
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatesSentTo(model.Order detail) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.updatesSentTo,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactRow(
                CupertinoIcons.phone,
                detail.shippingAddress?.phone ?? 'N/A',
              ),
              SizedBox(height: 8.h),
              _buildContactRow(Icons.email_outlined, detail.email ?? 'N/A'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: ColorHelper.iconColor),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 14.sp,
            color: ColorHelper.hintColor,
          ),
        ),
      ],
    );
  }

  String? _getCountryName(String? countryCode) {
    if (countryCode == null || countryCode.isEmpty) return null;
    try {
      if (Get.isRegistered<RegionController>()) {
        final regions = Get.find<RegionController>().availableRegions;
        for (var region in regions) {
          if (region.countries != null) {
            final country = region.countries!.firstWhereOrNull(
              (c) => c.iso2?.toLowerCase() == countryCode.toLowerCase(),
            );
            if (country != null) {
              return country.displayName ?? country.name;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting country name: $e');
    }
    return countryCode.toUpperCase();
  }

  String? _getRegionName(String? regionId) {
    if (regionId == null || regionId.isEmpty) return null;
    try {
      if (Get.isRegistered<RegionController>()) {
        final regions = Get.find<RegionController>().availableRegions;
        final region = regions.firstWhereOrNull((r) => r.id == regionId);
        return region?.name;
      }
    } catch (e) {
      debugPrint('Error getting region name: $e');
    }
    return null;
  }
}
