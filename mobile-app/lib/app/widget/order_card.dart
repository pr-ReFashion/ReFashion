import 'package:flutter/material.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/modules/selling/models/order_item_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class OrderCard extends StatelessWidget {
  final OrderItemModel item;
  final VoidCallback? onTrackTap;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.item, this.onTrackTap, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusHeader(),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedImageView(
                          imagePath: item.image,
                          height: 60.r,
                          width: 60.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyleHelper.urMedium500().copyWith(
                                fontSize: 16.sp,
                                height: 1.4,
                                color: ColorHelper.headingColor,
                              ),
                            ),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.dmRegular400().copyWith(
                                fontSize: 12.sp,
                                height: 1.2,
                                color: ColorHelper.subHeadingColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: ColorHelper.iconColor,
                        size: 18.sp,
                      ),
                    ],
                  ),
                  /* if (item.status == OrderStatus.purchased ||
                      item.status == OrderStatus.sold ||
                      item.status == OrderStatus.shipped) ...[
                    SizedBox(height: 12.h),
                    CommonBtn(
                      text: locale.value.track,
                      onTap: onTrackTap,
                      // height: 36.h,
                      width: double.infinity,
                      color: ColorHelper.white,
                      textColor: ColorHelper.subHeadingColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: const BorderSide(color: ColorHelper.borderColor),
                      ),
                    ),
                  ], */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: item.status == OrderStatus.cancelled
                ? ColorHelper.lightGrey
                : ColorHelper.primaryLightColor,
            shape: BoxShape.circle,
          ),
          child: item.status == OrderStatus.cancelled
              ? Icon(Icons.close, color: ColorHelper.iconColor, size: 18.sp)
              : CachedImageView(
                  imagePath: _getStatusIcon(),
                  size: 18.sp,
                  color: ColorHelper.primary,
                ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.statusText,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: item.status == OrderStatus.cancelled
                      ? ColorHelper.subHeadingColor
                      : ColorHelper.primary,
                ),
              ),
              Text(
                item.dateText,
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

  String _getStatusIcon() {
    switch (item.status) {
      case OrderStatus.purchased:
        return ImageHelper.icSwap;
      case OrderStatus.received:
        return ImageHelper.icSwap;
      case OrderStatus.returned:
        return ImageHelper.icSwap;
      case OrderStatus.shipped:
        return ImageHelper.icSwap;
      case OrderStatus.sold:
        return ImageHelper.icSwap;
      case OrderStatus.cancelled:
        return ImageHelper.icCancelled;
    }
  }
}
