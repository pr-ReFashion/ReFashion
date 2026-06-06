import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';
import '../models/seller_info_model.dart';
import '../shimmer/product_seller_shimmer.dart';

class ProductSellerInfoCard extends GetView<ProductDetailController> {
  const ProductSellerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seller = controller.sellerInfo.value;
      final product = controller.product.value;

      if (controller.isSellerInfoLoading.value) {
        return const ProductSellerShimmer();
      }

      if (seller == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller info card
          _buildSellerCard(seller),
          SizedBox(height: 12.h),
          // Divider
          const Divider(
            color: ColorHelper.borderColor,
            height: 1,
            thickness: 1,
          ),
          SizedBox(height: 12.h),
          // Posted + Report Listing row
          _buildPostedAndReportRow(product?.createdAt),
        ],
      );
    });
  }

  Widget _buildSellerCard(SellerInfo seller) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Seller photo or placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: seller.photo != null && seller.photo!.isNotEmpty
                    ? CachedImageView(
                        imagePath: seller.photo!,
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 48.w,
                        height: 48.h,
                        color: ColorHelper.borderColor,
                        child: Icon(
                          Icons.image_outlined,
                          color: ColorHelper.subHeadingColor,
                          size: 24.sp,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              // Seller name and rating details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      seller.name ?? '',
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingStars(
                          rating: controller.averageRating,
                          size: 14.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          locale.value.reviews(controller.reviewsList.length),
                          style: TextStyleHelper.dmRegular400().copyWith(
                            color: ColorHelper.subHeadingColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron right
              Icon(
                Icons.chevron_right,
                color: ColorHelper.subHeadingColor,
                size: 24.sp,
              ),
            ],
          ),
          if (controller.isReviewsLoading.value) ...[
            SizedBox(height: 12.h),
            Divider(
              color: ColorHelper.borderColor.withValues(alpha: 0.5),
              height: 1,
            ),
            SizedBox(height: 12.h),
            const ProductSellerReviewsShimmer(),
          ] else if (controller.reviewsList.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(
              color: ColorHelper.borderColor.withValues(alpha: 0.5),
              height: 1,
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.reviewsList.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: ColorHelper.borderColor.withValues(alpha: 0.5),
                  height: 1,
                ),
              ),
              itemBuilder: (context, index) {
                final review = controller.reviewsList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingStars(
                          rating: (review.rating ?? 0).toDouble(),
                          size: 12.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${review.customer?.fullName ?? ''} | ${review.createdAt?.timeAgo() ?? ''}',
                            style: TextStyleHelper.dmRegular400().copyWith(
                              color: ColorHelper.subHeadingColor,
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (review.customerNote != null &&
                        review.customerNote!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        review.customerNote!,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          color: ColorHelper.subHeadingColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostedAndReportRow(DateTime? createdAt) {
    final timeAgoText = createdAt != null ? createdAt.timeAgo() : '';

    if (timeAgoText.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text(
        locale.value.postedText(timeAgoText),
        style: TextStyleHelper.dmRegular400().copyWith(
          color: ColorHelper.subHeadingColor,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    final filledStars = rating.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < filledStars) {
          return Icon(Icons.star, color: ColorHelper.black, size: size);
        } else {
          return Icon(
            Icons.star_border,
            color: ColorHelper.black.withValues(alpha: 0.2),
            size: size,
          );
        }
      }),
    );
  }
}
